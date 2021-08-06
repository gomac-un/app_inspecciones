part of 'auth_bloc.dart';

// Definición de estados que maneja el login.
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = Initial;

  /// [sincronizado] DateTime usado para saber si ha sincronizado alguna vez la app o no,.
  const factory AuthState.authenticated(
      {required Usuario usuario,
      required DateTime sincronizado}) = Authenticated;
  const factory AuthState.unauthenticated() = Unauthenticated;
  const factory AuthState.loading() = Loading;
}
