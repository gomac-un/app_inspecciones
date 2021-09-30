part of 'auth_service.dart';

// Definición de estados que maneja el login.
@freezed
class AuthState with _$AuthState {
  /// [sincronizado] DateTime usado para saber si ha sincronizado alguna vez la app o no,.
  const factory AuthState.authenticated(
      {required Usuario usuario,
      required Option<DateTime> sincronizado}) = Authenticated;

  const factory AuthState.unauthenticated() = Unauthenticated;
  const factory AuthState.loading() = Loading;
}
