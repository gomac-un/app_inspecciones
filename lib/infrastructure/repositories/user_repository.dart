import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/core/entities/usuario.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/domain/auth/auth_failure.dart';
import 'package:inspecciones/features/login/credenciales.dart';
import 'package:inspecciones/infrastructure/core/network_info.dart';
import 'package:inspecciones/infrastructure/datasources/auth_remote_datasource.dart';
import 'package:inspecciones/infrastructure/datasources/local_preferences_datasource.dart';
import 'package:inspecciones/infrastructure/datasources/providers.dart';
import 'package:inspecciones/infrastructure/utils/future_either_x.dart';
import 'package:inspecciones/infrastructure/utils/transformador_excepciones_api.dart';

class UserRepository {
  AuthRemoteDataSource get _api => _read(authRemoteDataSourceProvider);
  final LocalPreferencesDataSource _localPreferences;
  final NetworkInfo _networkInfo;
  final Reader _read;

  UserRepository(this._read, this._localPreferences, this._networkInfo);

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

    return getOrRegisterAppId()
        .flatMap(
            (_) => apiExceptionToApiFailure(() => _getUsuario(credenciales)))
        .leftMap(apiFailureToAuthFailure);
  }

  /// Devuelve el token usado en autenticación de Django para hacer
  Future<String> _getToken(Credenciales credenciales) async {
    final resMap = await _api.getToken(credenciales.toJson());
    return resMap['token'] as String;
  }

  /// Devuelve bool que indica si puede o no crear cuestionarios.
  /// Se usa [token] para poder enviar en el header de la petición
  Future<bool> _getPermisos(String username, String token) async {
    final resMap = await _api.getPermisos(username, token);
    return resMap['esAdmin'] as bool;
  }

  Future<Usuario> _getUsuario(Credenciales credenciales) async {
    final token = await _getToken(credenciales);
    _read(tokenProvider.notifier).state =
        token; // esto puede que sea tarea de otra clase
    final esAdmin = await _getPermisos(credenciales.username, token);
    return Usuario.online(
        documento: credenciales.username,
        password: credenciales.password,
        esAdmin: esAdmin,
        token: token);
  }

  Future<void> saveLocalUser({required Usuario user}) async {
    await _localPreferences.saveUser(user);
  }

  /// Elimina user guardado localmente cuando se presiona cerrar sesión,
  /// el usuario deberá iniciar sesión la próxima vez que abra la app
  Future<void> deleteLocalUser() {
    _read(tokenProvider.notifier).state =
        null; // esto puede que sea tarea de otra clase
    return _localPreferences.deleteUser();
  }

  /// Devuelve usuario si hay uno guardado (No se debe iniciar sesión),
  /// en caso contrario null (Aparece login_screen).
  Option<Usuario> getLocalUser() => optionOf(_localPreferences.getUser());

  /// genera el código unico que identifica cada instalación de la app
  /// en caso de que no exista uno ya
  /// Consulta si en [localPreferences] se ha guardado el appId (Código unico de instalación),
  /// en caso de que no se hace petición a gomac para obtenerlo
  Future<Either<ApiFailure, int>> getOrRegisterAppId() async {
    final cachedAppId = _localPreferences.getAppId();
    if (cachedAppId != null) {
      return Right(cachedAppId);
    }
    return apiExceptionToApiFailure(_api.registrarApp).map(
      (appIdMap) {
        final appId = appIdMap['id'] as int;
        _localPreferences.saveAppId(appId);
        return Right(appId);
      },
    );
  }

  Future<bool> _hayInternet() => _networkInfo.isConnected;

  DateTime? getUltimaSincronizacion() =>
      _localPreferences.getUltimaSincronizacion();

  Future<bool> saveUltimaSincronizacion(DateTime momento) =>
      _localPreferences.saveUltimaSincronizacion(momento);
}

AuthFailure apiFailureToAuthFailure(apiFailure) => apiFailure.map(
      errorDeConexion: (_) => const AuthFailure.noHayConexionAlServidor(),
      errorInesperadoDelServidor: (e) => AuthFailure.unexpectedError(e),
      errorDecodificandoLaRespuesta: (e) => AuthFailure.unexpectedError(e),
      errorDeCredenciales: (_) => const AuthFailure.usuarioOPasswordInvalidos(),
      errorDePermisos: (e) => AuthFailure.unexpectedError(e),
      errorDeComunicacionConLaApi: (e) => AuthFailure.unexpectedError(e),
      errorDeProgramacion: (e) => AuthFailure.unexpectedError(e),
    );
