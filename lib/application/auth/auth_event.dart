part of 'auth_bloc.dart';

@freezed
abstract class AuthEvent with _$AuthEvent {
  const factory AuthEvent.startingApp() = StartingApp;
  const factory AuthEvent.loggingIn({Usuario usuario}) = LoggingIn;
  const factory AuthEvent.loggingOut() = LoggingOut;
}
