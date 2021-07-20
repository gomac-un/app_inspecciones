import 'package:freezed_annotation/freezed_annotation.dart';

part 'usuario.freezed.dart';
part 'usuario.g.dart';

@freezed
abstract class Usuario with _$Usuario {
  factory Usuario({
    /// Nombre de usuario
    String documento,
    String password,

    /// Parte de la autenticación de Django para acceder a los servicios de la Api
    /// https://www.django-rest-framework.org/api-guide/authentication/#tokenauthentication
    String token,

    /// True si puede crear cuestionarios.
    bool esAdmin,
  }) = _Usuario;

  /// Convierte un usuario en formato Json [json] a un objeto de tipo [Usuario]
  factory Usuario.fromJson(Map<String, dynamic> json) =>
      _$UsuarioFromJson(json);
}
