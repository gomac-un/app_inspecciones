import 'package:freezed_annotation/freezed_annotation.dart';

part 'usuario.freezed.dart';
part 'usuario.g.dart';

@freezed
class Usuario with _$Usuario {
  const factory Usuario.online({
    /// Nombre de usuario
    required String documento,
    required String password,

    /// Parte de la autenticación de Django para acceder a los servicios de la Api
    /// https://www.django-rest-framework.org/api-guide/authentication/#tokenauthentication
    required String token,

    /// True si puede crear cuestionarios.
    required bool esAdmin,
  }) = Online;

  const factory Usuario.offline({
    /// Nombre de usuario
    required String documento,
    required String password,

    /// True si puede crear cuestionarios.
    @Default(false) bool esAdmin,
  }) = Offline;

  /// Convierte un usuario en formato Json [json] a un objeto de tipo [Usuario]
  factory Usuario.fromJson(Map<String, dynamic> json) =>
      _$UsuarioFromJson(json);
}
