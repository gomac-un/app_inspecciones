import 'bloque.dart';
import 'inspeccion.dart';

class CuestionarioInspeccionado {
  final Cuestionario cuestionario;
  final List<Bloque> bloques;
  final Inspeccion inspeccion;

  CuestionarioInspeccionado(
    this.cuestionario,
    this.inspeccion,
    this.bloques,
  );
}

class Cuestionario {
  final int id;
  final String tipoDeInspeccion;

  Cuestionario({required this.id, required this.tipoDeInspeccion});
}
