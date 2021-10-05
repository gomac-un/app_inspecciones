import 'package:freezed_annotation/freezed_annotation.dart';

part 'credenciales.freezed.dart';
part 'credenciales.g.dart';

@freezed
class Credenciales with _$Credenciales {
  factory Credenciales({
    required String username,
    required String password,
  }) = _Credenciales;

  const Credenciales._();

  factory Credenciales.fromJson(Map<String, dynamic> json) =>
      _$CredencialesFromJson(json);
}
