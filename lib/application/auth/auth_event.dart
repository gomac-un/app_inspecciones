part of 'auth_bloc.dart';

// Definición de eventos que maneja el login.
@freezed
abstract class AuthEvent with _$AuthEvent {
  const factory AuthEvent.startingApp() = StartingApp;
  const factory AuthEvent.loggingIn({Usuario usuario}) = LoggingIn;
  const factory AuthEvent.loggingOut() = LoggingOut;
}
