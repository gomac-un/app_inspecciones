import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:inspecciones/core/entities/usuario.dart';
import 'package:inspecciones/core/error/exceptions.dart';
import 'package:inspecciones/domain/auth/auth_failure.dart';
import 'package:inspecciones/infrastructure/core/network_info.dart';
import 'package:inspecciones/infrastructure/datasources/local_preferences_datasource.dart';
import 'package:inspecciones/infrastructure/datasources/remote_datasource.dart';
import 'package:inspecciones/infrastructure/repositories/credenciales.dart';

class UserRepository {
  final AuthRemoteDatasource _api;
  final LocalPreferencesDataSource _localPreferences;
  final NetworkInfo _networkInfo;

  UserRepository(this._api, this._localPreferences, this._networkInfo);

  Future<Either<AuthFailure, Usuario>> authenticateUser(
      {required Credenciales credenciales, bool offline = false}) async {
    if (offline) {
      return Right(Usuario.offline(
        documento: credenciales.username,
        password: credenciales.password,
      ));
    }
    final hayInternet = await _hayInternet();
    if (!hayInternet) {
      return const Left(AuthFailure.noHayInternet());
    }

    /// Usado para la autenticación en Django
    final String token;

    /// True si puede crear cuestionarios
    final bool esAdmin;
    try {
      /// genera el código unico que identifica cada instalación de la app
      /// en caso de que no exista uno ya
      await getOrRegisterAppId();

      token = await _getToken(credenciales);
      esAdmin = await _getPermisos(credenciales, token);
    } on TimeoutException {
      return const Left(AuthFailure.noHayConexionAlServidor());
    } on CredencialesException {
      return const Left(AuthFailure.usuarioOPasswordInvalidos());
    } catch (e) {
      return Left(AuthFailure.unexpectedError(e));
    }

    /// Se crea el usuario localmente con los datos obtenidos de la Api
    final user = Usuario.online(
        documento: credenciales.username,
        password: credenciales.password,
        esAdmin: esAdmin,
        token: token);
    return Right(user);
  }

  /// Devuelve el token usado en autenticación de Django para hacer
  Future<String> _getToken(Credenciales credenciales) async {
    final res = await _api.getToken(credenciales.toJson());
    return res['token'] as String;
  }

  /// Devuelve bool que indica si puede o no crear cuestionarios.
  /// Se usa [token] para poder enviar en el header de la petición
  Future<bool> _getPermisos(Credenciales credenciales, String token) async {
    final res = await _api.getPermisos(credenciales.toJson(), token);
    return res['esAdmin'] as bool;
  }

  /// Write token with the user to the local database.
  Future<void> saveLocalUser({required Usuario user}) async {
    await _localPreferences.saveUser(user);
  }

  /// Elimina user guardado localmente cuando se presiona cerrar sesión,
  /// el usuario deberá iniciar sesión la próxima vez que abra la app
  Future<void> deleteLocalUser() => _localPreferences.deleteUser();

  /// Devuelve usuario si hay uno guardado (No se debe iniciar sesión),
  /// en caso contrario null (Aparece login_screen).
  Option<Usuario> getLocalUser() => optionOf(_localPreferences.getUser());

  /// Consulta si en [localPreferences] se ha guardado el appId (Código unico de instalación),
  /// en caso de que no se hace petición a gomac para obtenerlo
  Future<Either<AuthFailure, int>> getOrRegisterAppId() async {
    final cachedAppId = _localPreferences.getAppId();
    if (cachedAppId != null) {
      return Future.value(Right(cachedAppId));
    }
    try {
      final res = await _api.registrarApp();
      final appId = res['id'] as int;
      _localPreferences.saveAppId(appId);
      return Right(appId);
    } catch (e) {
      // TODO: manejar los errores especificos
      return Left(AuthFailure.unexpectedError(e));
    }
  }

  Future<bool> _hayInternet() => _networkInfo.isConnected;

  Option<DateTime> getUltimaSincronizacion() =>
      optionOf(_localPreferences.getUltimaSincronizacion());

  Future<bool> saveUltimaSincronizacion() =>
      _localPreferences.saveUltimaSincronizacion();
}
