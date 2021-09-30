import '../bloque.dart';
import '../respuesta.dart';

export '../respuesta.dart';

class Pregunta<T extends Respuesta> extends Bloque {
  final int id;

  /// Es mutable para asignarla o reasignarla facilmente a la hora de guardar,
  /// aunque se debe pensar como hacer para que podamos ser inmutables, tal vez
  /// usando un copywith
  T? respuesta;
  final int criticidad;
  final String posicion;
  final bool calificable;

  Pregunta({
    required this.id,
    required String titulo,
    required String descripcion,
    required this.criticidad,
    required this.posicion,
    required this.calificable,
    this.respuesta,
  }) : super(titulo: titulo, descripcion: descripcion);
}
