import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

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
      final bool hasToken = await userRepository.hasToken();

      if (hasToken) {
        yield Authenticated();
      } else {
        yield Unauthenticated();
      }
    }

    if (event is LoggingIn) {
      yield Loading();

      await userRepository.persistToken(user: event.user);
      yield Authenticated();
    }

    if (event is LoggingOut) {
      yield Loading();

      await userRepository.deleteToken(id: 0);

      yield Unauthenticated();
    }
  }
}
