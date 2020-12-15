import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:inspecciones/infrastructure/repositories/api_model.dart';
import 'package:inspecciones/infrastructure/repositories/user_repository.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({@required this.userRepository})
      : assert(UserRepository != null),
        super(Uninitialized());

  final UserRepository userRepository;

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AppStarted) {
      final user = await userRepository.getLocalUser();

      if (user != null) {
        yield Authenticated(user);
      } else {
        yield Unauthenticated();
      }
    }

    if (event is LoggingIn) {
      yield Loading();
      final validUser = userRepository.authenticateUser(userLogin: event.user);
      await userRepository.saveLocalUser(user: event.user);
      yield Authenticated(validUser);
    }

    if (event is LoggingOut) {
      yield Loading();
      await userRepository.deleteToken(id: 0);
      yield Unauthenticated();
    }
  }
}
