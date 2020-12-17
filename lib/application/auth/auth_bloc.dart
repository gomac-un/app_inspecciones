import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:inspecciones/application/auth/usuario.dart';
import 'package:inspecciones/infrastructure/repositories/api_model.dart';
import 'package:inspecciones/infrastructure/repositories/user_repository.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

part 'auth_bloc.freezed.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({@required this.userRepository})
      : assert(UserRepository != null),
        super(const AuthState.initial());

  final UserRepository userRepository;

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    yield* event.map(
      //TODO: pulir los errores
      startingApp: (e) async* {
        final usuario = userRepository.getLocalUser();

        if (usuario != null) {
          yield AuthState.authenticated(usuario: usuario);
        } else {
          yield const AuthState.unauthenticated();
        }
      },
      loggingIn: (e) async* {
        yield const AuthState.loading();
        try {
          final validUser =
              await userRepository.authenticateUser(userLogin: e.login);
          await userRepository.saveLocalUser(user: validUser);
          yield AuthState.authenticated(usuario: validUser);
        } catch (e) {
          yield const AuthState.unauthenticated();
        }
      },
      loggingOut: (e) async* {
        yield const AuthState.loading();
        await userRepository.deleteLocalUser();
        yield const AuthState.unauthenticated();
      },
    );
  }
}
