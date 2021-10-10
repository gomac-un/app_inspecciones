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

import 'app_repository.dart';

class UserRepository {
  AuthRemoteDataSource get _api => _read(authRemoteDataSourceProvider);
  final LocalPreferencesDataSource _localPreferences;
  final NetworkInfo _networkInfo;
  final AppRepository _appRepository;
  final Reader _read;

  UserRepository(
    this._read,
    this._localPreferences,
    this._networkInfo,
    this._appRepository,
  );

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

    return getUsuario(credenciales).leftMap(apiFailureToAuthFailure).flatMap(
        (usuario) => _appRepository
            .getOrRegisterAppId()
            .leftMap(apiFailureToAuthFailure)
            .then((r) => r.fold((l) => Left(l), (_) => Right(usuario))));
  }

  /// verifica que el usuario y la contraseña coincidan y además recibe y guarda
  /// el token de autenticacion de la api
  Future<Either<ApiFailure, Usuario>> getUsuario(Credenciales credenciales) =>
      _appRepository.registrarToken(credenciales).flatMap(
            (token) => apiExceptionToApiFailure(() async => Usuario.online(
                  documento: credenciales.username,
                  password: credenciales.password,
                  esAdmin: await _getPermisos(credenciales.username),
                )),
          );

  /// Devuelve bool que indica si puede o no crear cuestionarios.
  /// Se usa [token] para poder enviar en el header de la petición
  Future<bool> _getPermisos(String username) async {
    final resMap = await _api.getPermisos(username);
    return resMap['esAdmin'] as bool;
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

  Future<bool> _hayInternet() => _networkInfo.isConnected;
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
