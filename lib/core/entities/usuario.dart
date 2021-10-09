import 'package:freezed_annotation/freezed_annotation.dart';

part 'usuario.freezed.dart';
part 'usuario.g.dart';

@freezed
class Usuario with _$Usuario {
  const factory Usuario.online({
    /// Nombre de usuario
    required String documento,
    required String password,

    /// True si puede crear cuestionarios.
    required bool esAdmin,
  }) = UsuarioOnline;

  const factory Usuario.offline({
    /// Nombre de usuario
    required String documento,
    required String password,

    /// True si puede crear cuestionarios.
    @Default(false) bool esAdmin,
  }) = UsuarioOffline;

  /// Convierte un usuario en formato Json [json] a un objeto de tipo [Usuario]
  factory Usuario.fromJson(Map<String, dynamic> json) =>
      _$UsuarioFromJson(json);
}
