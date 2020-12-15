part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthState {}

class Authenticated extends AuthState {
  final Usuario usuario;

  Authenticated(this.usuario);
  List<Object> get props => [usuario];
}

class Unauthenticated extends AuthState {}

class Loading extends AuthState {}
