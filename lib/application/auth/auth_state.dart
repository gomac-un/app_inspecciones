part of 'auth_bloc.dart';

// Definición de estados que maneja el login.
@freezed
class AuthState with _$AuthState {
  /// [sincronizado] DateTime usado para saber si ha sincronizado alguna vez la app o no,.
  const factory AuthState.authenticated(
      {required bool loading,
      required Option<AuthFailure> failure,
      required Usuario usuario,
      required Option<DateTime> sincronizado}) = Authenticated;

  const factory AuthState.unauthenticated({
    required bool loading,
    required Option<AuthFailure> failure,
  }) = Unauthenticated;
}
