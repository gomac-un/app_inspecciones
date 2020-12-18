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
    yield* event.when(
      //TODO: pulir los errores
      startingApp: () async* {
        final usuario = userRepository.getLocalUser();

        yield usuario.fold(
          () => const AuthState.unauthenticated(),
          (u) => AuthState.authenticated(usuario: u),
        );
      },
      loggingIn: (usuario) async* {
        await userRepository.saveLocalUser(user: usuario);
        yield AuthState.authenticated(usuario: usuario);
      },
      loggingOut: () async* {
        yield const AuthState.loading();
        await userRepository.deleteLocalUser();
        yield const AuthState.unauthenticated();
      },
    );
  }
}
