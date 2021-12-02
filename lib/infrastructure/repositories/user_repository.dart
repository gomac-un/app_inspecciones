import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/core/entities/usuario.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/domain/auth/auth_failure.dart';
import 'package:inspecciones/features/login/credenciales.dart';
import 'package:inspecciones/infrastructure/core/network_info.dart';
import 'package:inspecciones/infrastructure/core/typedefs.dart';
import 'package:inspecciones/infrastructure/datasources/auth_remote_datasource.dart';
import 'package:inspecciones/infrastructure/datasources/local_preferences_datasource.dart';
import 'package:inspecciones/infrastructure/datasources/providers.dart';
import 'package:inspecciones/infrastructure/network_info/shared.dart';
import 'package:inspecciones/infrastructure/utils/transformador_excepciones_api.dart';
import 'package:inspecciones/utils/future_either_x.dart';

import 'app_repository.dart';
import 'providers.dart';

class UserRepository {
  final Reader _read;
  AuthRemoteDataSource get _api => _read(authRemoteDataSourceProvider);
  LocalPreferencesDataSource get _localPreferences =>
      _read(localPreferencesDataSourceProvider);
  NetworkInfo get _networkInfo => _read(networkInfoProvider);
  AppRepository get _appRepository => _read(appRepositoryProvider);

  UserRepository(this._read);

  /// si [offline] no es false, consulta en la api si el usuario y la contraseña
  /// coinciden, obtiene y registra el token de la api.
  Future<Either<AuthFailure, Usuario>> authenticateUser(
      {required Credenciales credenciales, bool offline = false}) async {
    if (offline) {
      return Right(Usuario.offline(
        username: credenciales.username,
      ));
    }
    final hayInternet = await _hayInternet();
    if (!hayInternet) {
      return const Left(AuthFailure.noHayInternet());
    }

    return _validarUsuario(credenciales)
        .leftMap(apiFailureToAuthFailure)
        // se registra el token aqui porque inmediatamente despues hay que realizar
        // [_getPermisos] que necesita ese token
        .nestedEvaluatedMap((token) => _appRepository.guardarToken(token))
        .flatMap((_) => _esAdmin().leftMap(apiFailureToAuthFailure))
        .nestedMap((esAdmin) => _buildUsuarioOnline(credenciales, esAdmin));
  }

  /// Consulta en la api si el usuario y la contraseña coincide, de ser asi
  /// retorna el token para usar la api
  Future<Either<ApiFailure, String>> _validarUsuario(
          Credenciales credenciales) =>
      _appRepository.getTokenFromApi(credenciales);

  Future<Either<ApiFailure, bool>> _esAdmin() =>
      apiExceptionToApiFailure(() async {
        final resMap = await _api.getPerfil(null);
        return resMap['rol'] == 'administrador';
      });

  Usuario _buildUsuarioOnline(Credenciales credenciales, bool esAdmin) =>
      Usuario.online(username: credenciales.username, esAdmin: esAdmin);

  Future<void> saveLocalUser({required Usuario user}) async {
    await _localPreferences.saveUser(user);
  }

  /// Elimina user guardado localmente cuando se presiona cerrar sesión,
  /// el usuario deberá iniciar sesión la próxima vez que abra la app
  Future<void> deleteLocalUser() {
    _read(appRepositoryProvider)
        .guardarToken(null); // esto puede que sea tarea de otra clase
    return _localPreferences.deleteUser();
  }

  /// Devuelve usuario si hay uno guardado (No se debe iniciar sesión),
  /// en caso contrario null (Aparece login_screen).
  Option<Usuario> getLocalUser() => optionOf(_localPreferences.getUser());

  Future<Either<ApiFailure, String>> registrarUsuario(
          {required JsonMap formulario}) =>
      apiExceptionToApiFailure(() =>
          _api.registrarUsuario(formulario).then((res) => res['username']));

  Future<Either<ApiFailure, Perfil>> getPerfil(int id) =>
      apiExceptionToApiFailure(
          () => _api.getPerfil(id).then((res) => Perfil.fromJson(res)));

  Future<bool> _hayInternet() => _networkInfo.isConnected;
}

AuthFailure apiFailureToAuthFailure(ApiFailure apiFailure) => apiFailure.map(
      errorDeConexion: (_) => const AuthFailure.noHayConexionAlServidor(),
      errorInesperadoDelServidor: (e) => AuthFailure.unexpectedError(e),
      errorDecodificandoLaRespuesta: (e) => AuthFailure.unexpectedError(e),
      errorDeCredenciales: (_) => const AuthFailure.usuarioOPasswordInvalidos(),
      errorDePermisos: (e) => AuthFailure.unexpectedError(e),
      errorDeComunicacionConLaApi: (e) => AuthFailure.unexpectedError(e),
      errorDeProgramacion: (e) => AuthFailure.unexpectedError(e),
    );

class Perfil {
  final bool estaActivo;
  final DateTime fechaRegistro;
  final String username;
  final String nombre;
  final String email;
  final String foto;
  final String celular;
  final String organizacion;
  final String rol;

  Perfil(this.estaActivo, this.fechaRegistro, this.username, this.nombre,
      this.email, this.foto, this.celular, this.organizacion, this.rol);

  factory Perfil.fromJson(Map<String, dynamic> json) => Perfil(
        json['esta_activo'],
        DateTime.parse(json['fecha_registro']),
        json['username'],
        json['nombre'],
        json['email'],
        json['foto'],
        json['celular'],
        json['organizacion'],
        json['rol'],
      );
}
