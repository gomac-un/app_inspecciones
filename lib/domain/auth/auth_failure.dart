import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_failure.freezed.dart';

@freezed
class AuthFailure with _$AuthFailure {
  const factory AuthFailure.noHayInternet() = _NoHayInternet;
  const factory AuthFailure.noHayConexionAlServidor() =
      _NoHayConexionAlServidor;
  const factory AuthFailure.usuarioOPasswordInvalidos() =
      _UsuarioOPasswordInvalidos;
  const factory AuthFailure.unexpectedError(Object exception) =
      _UnexpectedError;
  const factory AuthFailure.databaseError(Object exception) = _DatabaseError;
}
