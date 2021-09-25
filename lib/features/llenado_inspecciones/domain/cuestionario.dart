import 'bloque.dart';
import 'inspeccion.dart';

class CuestionarioInspeccionado {
  final int id;
  final String tipoDeInspeccion;
  final List<Bloque> bloques;
  final Inspeccion inspeccion;

  CuestionarioInspeccionado(
    this.inspeccion,
    this.bloques, {
    required this.id,
    required this.tipoDeInspeccion,
  });
}
