import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/core/entities/usuario.dart';
import 'package:inspecciones/domain/auth/auth_failure.dart';
import 'package:inspecciones/features/login/credenciales.dart';
import 'package:inspecciones/infrastructure/repositories/app_repository.dart';
import 'package:inspecciones/infrastructure/repositories/organizacion_repository.dart';
import 'package:inspecciones/infrastructure/repositories/providers.dart';
import 'package:inspecciones/infrastructure/repositories/user_repository.dart';
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
  Future<void> login(
    Credenciales credenciales, {
    required bool offline,
    void Function(AuthFailure failure)? onFailure,
    VoidCallback? onSuccess,
  }) async {
    final autentication = await _userRepository
        // automaticamente guarda y registra el token
        .authenticateUser(credenciales: credenciales, offline: offline);

    await autentication.fold(
      (failure) async => onFailure?.call(failure),
      (usuario) async {
        // Guarda los datos del usuario, para que no tenga que iniciar sesión la próxima vez
        await _userRepository.saveLocalUser(user: usuario);

        // descarga la información básica de la organizacion desde el server
        if (!offline) await _syncOrganizacion();

        // para distinguir a los usuarios con Sentry
        Sentry.configureScope(
          (scope) => scope.user = SentryUser(id: usuario.username),
        );

        // [AppRouter] escucha este evento y redirige al home
        state = AuthState.authenticated(usuario: usuario);
        onSuccess?.call();
      },
    );
  }

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

  Future<void> _syncOrganizacion() async {
    await _organizacionRepository.refreshListaDeActivos();
    await _organizacionRepository.sincronizarEtiquetasDeActivos();
    await _organizacionRepository.sincronizarEtiquetasDePreguntas();
  }
}
