part of 'auth_bloc.dart';

// Definición de eventos que maneja el login.
@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.startingApp() = StartingApp;
  const factory AuthEvent.loggingIn({required UserLogin usuario}) = LoggingIn;
  const factory AuthEvent.loggingOut() = LoggingOut;
}
