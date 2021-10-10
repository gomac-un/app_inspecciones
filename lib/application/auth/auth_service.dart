import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/core/entities/usuario.dart';
import 'package:inspecciones/domain/auth/auth_failure.dart';
import 'package:inspecciones/features/login/credenciales.dart';
import 'package:inspecciones/infrastructure/repositories/app_repository.dart';
import 'package:inspecciones/infrastructure/repositories/providers.dart';
import 'package:inspecciones/infrastructure/repositories/user_repository.dart';
import 'package:inspecciones/infrastructure/utils/future_either_x.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'auth_service.freezed.dart';
part 'auth_state.dart';

/// Maneja el estado de autenticación en la app
final authProvider =
    StateNotifierProvider<AuthService, AuthState>((ref) => AuthService(
          ref.watch(userRepositoryProvider),
          ref.watch(appRepositoryProvider),
        ));

final authListenableProvider = ChangeNotifierProvider(
    (ref) => LoginInfo(ref.watch(authProvider.notifier)));

final userProvider =
    Provider<Usuario?>((ref) => ref.watch(authProvider).whenOrNull(
          authenticated: id,
        ));

class LoginInfo extends ChangeNotifier {
  final AuthService authService;
  late final VoidCallback remover;

  bool _loggedIn = false;

  LoginInfo(this.authService) {
    remover = authService.addListener((auth) {
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
    remover();
    super.dispose();
  }
}

class AuthService extends StateNotifier<AuthState> {
  final UserRepository _userRepository;
  final AppRepository _appRepository;

  AuthService(this._userRepository, this._appRepository)
      : super(const AuthState.loading()) {
    init();
  }

  Future init() async {
    //TODO: eliminar duplicacion de codigo con login
    // TODO: registrar de alguna manera el token en la api
    final usuario = _userRepository.getLocalUser();

    state = usuario.fold(
      () => const AuthState.unauthenticated(),
      (usuario) => AuthState.authenticated(usuario: usuario),
    );
  }

  Future login(
    Credenciales credenciales, {
    required bool offline,
    void Function(AuthFailure failure)? onFailure,
    VoidCallback? onSuccess,
  }) async {
    /// TODO: mover la logica de authenticateUser de el userRepository aqui o a un usecase
    final autentication = await _userRepository.authenticateUser(
        credenciales: credenciales, offline: offline);

    autentication.fold(
      (failure) => onFailure?.call(failure),
      (usuario) {
        /// Guarda los datos del usuario, para que no tenga que iniciar sesión la próxima vez
        _userRepository.saveLocalUser(user: usuario);

        // para distinguir a los usuarios con Sentry
        Sentry.configureScope(
          (scope) => scope.user = SentryUser(id: usuario.documento),
        );

        state = AuthState.authenticated(usuario: usuario);
        onSuccess?.call();
      },
    );
  }

  Future logout() async {
    /// Se borra la info del usuario, lo que hace que deba iniciar sesión la próxima vez
    await _userRepository.deleteLocalUser();

    Sentry.configureScope(
      (scope) =>
          scope.user = scope.user?.copyWith(extras: {'logged_out': true}),
    );
    state = const AuthState.unauthenticated();
  }

  /// Informacion usada por la vista para evitar login sin haber obtenido el AppId

  Future<Either<AuthFailure, int>> getOrRegisterAppId() =>
      _appRepository.getOrRegisterAppId().leftMap(apiFailureToAuthFailure);
}
