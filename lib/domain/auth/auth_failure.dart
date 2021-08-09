import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_failure.freezed.dart';

@freezed
class AuthFailure with _$AuthFailure {
  const factory AuthFailure.noHayInternet() = NoHayInternet;
  const factory AuthFailure.noHayConexionAlServidor() = NoHayConexionAlServidor;
  const factory AuthFailure.usuarioOPasswordInvalidos() =
      UsuarioOPasswordInvalidos;
  const factory AuthFailure.serverError() = ServerError;
}
