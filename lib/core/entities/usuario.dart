import 'package:freezed_annotation/freezed_annotation.dart';

part 'usuario.freezed.dart';
part 'usuario.g.dart';

@freezed
class Usuario with _$Usuario {
  const factory Usuario.online({
    required String username,
    required String organizacion,
    required bool esAdmin,
  }) = UsuarioOnline;

  const factory Usuario.offline({
    required String username,
    required String organizacion,
    required bool esAdmin,
  }) = UsuarioOffline;

  /// Convierte un usuario en formato Json [json] a un objeto de tipo [Usuario]
  factory Usuario.fromJson(Map<String, dynamic> json) =>
      _$UsuarioFromJson(json);
}
