part of 'auth_bloc.dart';

// Definición de eventos que maneja el login.
@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.started() = Started;
  const factory AuthEvent.loggingIn(
      {required Credenciales credenciales,
      @Default(false) bool offline}) = LoggingIn;
  const factory AuthEvent.loggingOut() = LoggingOut;
}
