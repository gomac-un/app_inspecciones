part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class LoggingIn extends AuthEvent {
  final UserLogin user;

  LoggingIn(this.user);
  @override
  List<Object> get props => [user];
}

class LoggingOut extends AuthEvent {}
