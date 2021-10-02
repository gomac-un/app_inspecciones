import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/core/entities/usuario.dart';
import 'package:inspecciones/domain/auth/auth_failure.dart';
import 'package:inspecciones/infrastructure/repositories/credenciales.dart';
import 'package:inspecciones/infrastructure/repositories/providers.dart';
import 'package:inspecciones/infrastructure/repositories/user_repository.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'auth_service.freezed.dart';
part 'auth_state.dart';

/// Maneja el estado de autenticación en la app
final authProvider = StateNotifierProvider<AuthService, AuthState>(
    (ref) => AuthService(ref.watch(userRepositoryProvider)));

final userProvider = Provider<Usuario>((ref) => ref.watch(authProvider).when(
      authenticated: (usuario, _) => usuario,
      unauthenticated: () => throw Exception("Usuario no inicializado"),
      loading: () => throw Exception("Usuario no inicializado"),
    ));

class AuthService extends StateNotifier<AuthState> {
  final UserRepository _userRepository;

  AuthService(this._userRepository) : super(const AuthState.loading()) {
    init();
  }

  Future init() async {
    //TODO: eliminar duplicacion de codigo con login
    // TODO: registrar de alguna manera el token en la api
    final usuario = _userRepository.getLocalUser();
    final lastSync = _userRepository.getUltimaSincronizacion();

    state = usuario.fold(
      () => const AuthState.unauthenticated(),
      (usuario) => AuthState.authenticated(
        usuario: usuario,
        sincronizado: lastSync,
      ),
    );
  }

  Future login(
    Credenciales credenciales, {
    required bool offline,
    void Function(AuthFailure failure)? onFailure,
    VoidCallback? onSuccess,
  }) async {
    /// TODO: mover la logica de authenticateUser de el userRepository a
    /// este bloc o a un usecase
    final autentication = await _userRepository.authenticateUser(
        credenciales: credenciales, offline: offline);

    autentication.fold(
      (failure) => onFailure?.call(failure),
      (usuario) {
        /// Obtiene la ultima sincronización, esto para saber que pantalla se
        /// muestra primero: sincronización o borradores.
        final lastSync = _userRepository.getUltimaSincronizacion();

        /// Guarda los datos del usuario, para que no tenga que iniciar sesión la próxima vez
        _userRepository.saveLocalUser(user: usuario);

        // para distinguir a los usuarios con Sentry
        /*Sentry.configureScope(
          (scope) => scope.user = SentryUser(id: usuario.documento),
        );*/

        state = AuthState.authenticated(
          usuario: usuario,
          sincronizado: lastSync,
        );
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
      _userRepository.getOrRegisterAppId();
}
