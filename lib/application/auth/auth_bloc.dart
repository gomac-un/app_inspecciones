import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:inspecciones/application/auth/usuario.dart';
import 'package:inspecciones/domain/auth/auth_failure.dart';
import 'package:inspecciones/infrastructure/datasources/remote_datasource.dart';
import 'package:inspecciones/infrastructure/repositories/credenciales.dart';
import 'package:inspecciones/infrastructure/repositories/user_repository.dart';
import 'package:inspecciones/injection.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

part 'auth_bloc.freezed.dart';

// Modulo @injectable para manejar el estado de la aplicación al momento del ingreso del usuario
//
// Se usa  BLoC (https://bloclibrary.dev/#/).
// El método [mapEventToState] escucha tres eventos definidos en auth_event.

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._userRepository)
      : super(const AuthState.unauthenticated(loading: true, failure: None())) {
    add(const AuthEvent.started());
  }

  // Información del ususario
  final UserRepository _userRepository;

  // Stream que escucha los cambios en el login.
  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    yield* event.when(
      //TODO: pulir los errores
      // Cuando se inicia la app y el [usuario] esté guardado, se llama [registrarApi]
      //y, finalmente se actualiza el estado a autenticado
      started: () async* {
        final usuario = _userRepository.getLocalUser();
        final lastSync = _userRepository.getUltimaSincronizacion();

        yield usuario.fold(
          () =>
              const AuthState.unauthenticated(loading: false, failure: None()),
          (usuario) {
            registrarAPI(usuario);
            return AuthState.authenticated(
              loading: false,
              failure: const None(),
              usuario: usuario,
              sincronizado: lastSync,
            );
          },
        );
      },

      /// Actualiza el estado del login a autenticado cuando [usuario] inicia sesión.
      /// si [appId] no existe, lanza error para que se conecte a internet.
      loggingIn: (credenciales, offline) async* {
        yield state.copyWith(loading: true);

        final autentication = await _userRepository.authenticateUser(
            credenciales: credenciales, offline: offline);

        yield autentication.fold(
          (failure) => state.copyWith(loading: false, failure: Some(failure)),
          (usuario) {
            registrarAPI(usuario);

            /// Obtiene la ultima sincronización, esto para saber que pantalla se muestra primero: sincronización o borradores.
            final lastSync = _userRepository.getUltimaSincronizacion();

            /// Guarda los datos del usuario, para que no tenga que iniciar sesión la próxima vez
            _userRepository.saveLocalUser(user: usuario);
            return AuthState.authenticated(
              loading: false,
              failure: const None(),
              usuario: usuario,
              sincronizado: lastSync,
            );
          },
        );
      },

      /// Actualiza el estado del login a inautenticado cuando el usuario cierra sesión
      loggingOut: () async* {
        yield state.copyWith(loading: true);

        /// Se borra la info del usuario, lo que hace que deba iniciar sesión la próxima vez
        await _userRepository.deleteLocalUser();
        yield const AuthState.unauthenticated(loading: false, failure: None());
      },
    );
  }

  Future<Either<AuthFailure, int>> getOrRegisterAppId() =>
      _userRepository.getOrRegisterAppId();
}
