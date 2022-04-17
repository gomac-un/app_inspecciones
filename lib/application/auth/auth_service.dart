import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/core/entities/usuario.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/domain/auth/auth_failure.dart';
import 'package:inspecciones/features/login/credenciales.dart';
import 'package:inspecciones/infrastructure/datasources/auth_remote_datasource.dart';
import 'package:inspecciones/infrastructure/datasources/connectivity.dart';
import 'package:inspecciones/infrastructure/datasources/providers.dart';
import 'package:inspecciones/infrastructure/repositories/app_repository.dart';
import 'package:inspecciones/infrastructure/repositories/organizacion_repository.dart';
import 'package:inspecciones/infrastructure/repositories/providers.dart';
import 'package:inspecciones/infrastructure/repositories/user_repository.dart';
import 'package:inspecciones/utils/future_either_x.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'auth_service.freezed.dart';
part 'auth_state.dart';

/// Maneja el estado de autenticación en la app
final StateNotifierProvider<AuthService, AuthState> authProvider =
    StateNotifierProvider<AuthService, AuthState>(
        (ref) => AuthService(ref.read));

final authListenableProvider = ChangeNotifierProvider(
    (ref) => LoginInfo(ref.watch(authProvider.notifier)));

final userProvider =
    Provider<Usuario?>((ref) => ref.watch(authProvider).whenOrNull(
          authenticated: id,
        ));

class LoginInfo extends ChangeNotifier {
  final AuthService authService;
  late final VoidCallback remove;

  bool _loggedIn = false;

  LoginInfo(this.authService) {
    remove = authService.addListener((auth) {
      auth.map(
        authenticated: (_) => _loggedIn = true,
        unauthenticated: (_) => _loggedIn = false,
        loading: (_) => _loggedIn = false,
      );
      notifyListeners();
    });
  }

  bool get loggedIn => _loggedIn;

  @override
  void dispose() {
    remove();
    super.dispose();
  }
}

class AuthService extends StateNotifier<AuthState> {
  final Reader _read;
  UserRepository get _userRepository => _read(userRepositoryProvider);
  AppRepository get _appRepository => _read(appRepositoryProvider);
  AuthRemoteDataSource get _api => _read(authRemoteDataSourceProvider);

  OrganizacionRepository get _organizacionRepository =>
      _read(organizacionRepositoryProvider);

  AuthService(this._read) : super(const AuthState.loading()) {
    //TODO: eliminar duplicacion de codigo con login
    final usuario = _userRepository.getLocalUser();

    state = usuario.fold(
      () => const AuthState.unauthenticated(),
      (usuario) {
        //_appRepository.registrarToken();
        return AuthState.authenticated(usuario: usuario);
      },
    );
  }

  /// autentica y guarda el usuario y el token en local,
  ///como es escuchado por [AppRouter] redirige al home luego de autenticar
  /// TODO: establecer bien las responsabilidades de login_control, auth_service y los repositories
  Future<Either<AuthFailure, Unit>> login(Credenciales credenciales) {
    return authenticateUser(credenciales).flatMap(
      (usuario) async {
        // Guarda los datos del usuario, para que no tenga que iniciar sesión la próxima vez
        await _userRepository.saveLocalUser(user: usuario);

        // para distinguir a los usuarios con Sentry
        Sentry.configureScope(
          (scope) => scope.user = SentryUser(id: usuario.username),
        );

        // [AppRouter] escucha este evento y redirige al home
        state = AuthState.authenticated(usuario: usuario);

        // descarga la información básica de la organizacion desde el server
        await _organizacionRepository.syncOrganizacion();

        return const Right(unit);
      },
    );
  }

  Future<Either<AuthFailure, Unit>> loginOffline(
    Credenciales credenciales, {
    required String organizacion,
  }) {
    return authenticateUserOffline(credenciales, organizacion: organizacion)
        .flatMap(
      (usuario) async {
        await _userRepository.saveLocalUser(user: usuario);
        Sentry.configureScope(
          (scope) => scope.user = SentryUser(id: usuario.username),
        );
        state = AuthState.authenticated(usuario: usuario);
        return const Right(unit);
      },
    );
  }

  Future<Either<AuthFailure, Usuario>> authenticateUserOffline(
      Credenciales credenciales,
      {required String organizacion}) async {
    return Right(Usuario.offline(
      username: credenciales.username,
      organizacion: organizacion,
      esAdmin: false,
    ));
  }

  /// si [offline] no es false, consulta en la api si el usuario y la contraseña
  /// coinciden, obtiene y registra el token de la api.
  Future<Either<AuthFailure, Usuario>> authenticateUser(
      Credenciales credenciales) async {
    final hayInternet = await _read(connectivityProvider.future);
    if (!hayInternet) {
      return const Left(AuthFailure.noHayInternet());
    }

    return _validarUsuario(credenciales)
        .leftMap(apiFailureToAuthFailure)
        // se registra el token aqui porque inmediatamente despues hay que realizar
        // [getMiPerfil] que necesita ese token
        .nestedEvaluatedMap((token) => _appRepository.guardarToken(token))
        .flatMap((_) =>
            _userRepository.getMiPerfil().leftMap(apiFailureToAuthFailure))
        .nestedMap((perfil) => _buildUsuarioOnline(perfil));
  }

  /// Consulta en la api si el usuario y la contraseña coincide, de ser asi
  /// retorna el token para usar la api
  Future<Either<ApiFailure, String>> _validarUsuario(
          Credenciales credenciales) =>
      _appRepository.getTokenFromApi(credenciales);

  Usuario _buildUsuarioOnline(Perfil perfil) => Usuario.online(
      username: perfil.username,
      organizacion: perfil.organizacion,
      esAdmin: perfil.rol == "administrador");

  Future<void> logout() async {
    /// Se borra la info del usuario, lo que hace que deba iniciar sesión la próxima vez
    await _userRepository.deleteLocalUser();

    Sentry.configureScope(
      (scope) =>
          scope.user = scope.user?.copyWith(extras: {'logged_out': true}),
    );
    state = const AuthState.unauthenticated();
    await _appRepository.guardarToken(null);
  }

  AuthFailure apiFailureToAuthFailure(ApiFailure apiFailure) => apiFailure.map(
        errorDeConexion: (_) => const AuthFailure.noHayConexionAlServidor(),
        errorInesperadoDelServidor: (e) => AuthFailure.unexpectedError(e),
        errorDecodificandoLaRespuesta: (e) => AuthFailure.unexpectedError(e),
        errorDeCredenciales: (_) =>
            const AuthFailure.usuarioOPasswordInvalidos(),
        errorDePermisos: (e) => AuthFailure.unexpectedError(e),
        errorDeComunicacionConLaApi: (e) => AuthFailure.unexpectedError(e),
        errorDeProgramacion: (e) => AuthFailure.unexpectedError(e),
        errorDatabase: (e) => AuthFailure.databaseError(e),
      );
}
