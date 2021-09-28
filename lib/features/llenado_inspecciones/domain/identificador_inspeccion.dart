// main.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'identificador_inspeccion.freezed.dart';

@freezed
class IdentificadorDeInspeccion with _$IdentificadorDeInspeccion {
  factory IdentificadorDeInspeccion(
      {required String activo,
      required int cuestionarioId}) = _IdentificadorDeInspeccion;
}
