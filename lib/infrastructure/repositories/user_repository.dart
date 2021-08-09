import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:injectable/injectable.dart';
import 'package:inspecciones/application/auth/usuario.dart';
import 'package:inspecciones/core/error/exceptions.dart';
import 'package:inspecciones/domain/auth/auth_failure.dart';
import 'package:inspecciones/infrastructure/datasources/local_preferences_datasource.dart';
import 'package:inspecciones/infrastructure/datasources/remote_datasource.dart';
import 'package:inspecciones/infrastructure/repositories/api_model.dart';
import 'package:meta/meta.dart';

/// Maneja la información del usuario y sirve de puente entre [AuthBloc] y [InspeccionesRemoteDataSource]
@injectable
class UserRepository {
  final InspeccionesRemoteDataSource _api;
  final LocalPreferencesDataSource _localPreferences;

  UserRepository(this._api, this._localPreferences);

  /// Proceso de autenticación del usuario, en el login
  Future<Either<AuthFailure, Usuario>> authenticateUser(
      {required UserLogin userLogin}) async {
    /// Usado para la autenticación en Django
    final String token;

    /// True si puede crear cuestionarios
    final bool esAdmin;
    final hayInternet = await _hayInternet();

    if (!hayInternet) {
      return const Left(AuthFailure.noHayInternet());
    }

    try {
      token = await _getToken(userLogin);
    } on TimeoutException {
      return const Left(AuthFailure.noHayConexionAlServidor());
    } on CredencialesException {
      return const Left(AuthFailure.usuarioOPasswordInvalidos());
    } catch (e) {
      return const Left(AuthFailure.serverError());
    }

    try {
      esAdmin = await _getPermisos(userLogin, token);
    } on TimeoutException {
      return const Left(AuthFailure.noHayConexionAlServidor());
    } on CredencialesException {
      return const Left(AuthFailure.usuarioOPasswordInvalidos());
    } catch (e) {
      return const Left(AuthFailure.serverError());
    }

    /// Se crea el usuario localmente con los datos obtenidos de la Api
    final user = Usuario(
        documento: userLogin.username,
        password: userLogin.password,
        esAdmin: esAdmin,
        token: token);
    return Right(user);
  }

  /// Devuelve el token usado en autenticación de Django para hacer
  Future<String> _getToken(UserLogin userLogin) async {
    final res = await _api.getToken(userLogin.toJson());
    return res['token'] as String;
  }

  /// Devuelve bool que indica si puede o no crear cuestionarios.
  /// Se usa [token] para poder enviar en el header de la petición
  Future<bool> _getPermisos(UserLogin userLogin, String token) async {
    final res = await _api.getPermisos(userLogin.toJson(), token);
    return res['esAdmin'] as bool;
  }

  /// Write token with the user to the local database.
  Future<void> saveLocalUser({required Usuario user}) async {
    await _localPreferences.saveUser(user);
  }

  /// Elimina user guardado localmente cuando se presiona cerrar sesión, el usuario deberá iniciar sesión la próxima vez que abra la app
  Future<void> deleteLocalUser() => _localPreferences.deleteUser();

  /// Devuelve usuario si hay uno guardado (No se debe iniciar sesión), en caso contrario null (Aparece login_screen).
  Option<Usuario> getLocalUser() => optionOf(_localPreferences.getUser());

  /// Consulta si en [localPreferences] se ha guardado el appId (Código unico de instalación),
  /// en caso de que no se hace petición a la app para obtenerlo
  Future getAppId() async {
    if (_localPreferences.getAppId() != null) {
      return _localPreferences.getAppId();
    }

    final res = await _api.postRecurso(
      '/registro-app/',
      {},
    );
    final appId = res['id'] as int;
    _localPreferences.saveAppId(appId);
    return appId;
  }

  Future<bool> _hayInternet() async =>
      InternetConnectionChecker().hasConnection;

  Option<DateTime> getUltimaSincronizacion() =>
      optionOf(_localPreferences.getUltimaSincronizacion());

  Future<bool> saveUltimaSincronizacion() =>
      _localPreferences.saveUltimaSincronizacion();
}
