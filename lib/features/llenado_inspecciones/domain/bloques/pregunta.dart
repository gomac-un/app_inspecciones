import '../bloque.dart';
import '../respuesta.dart';

export '../respuesta.dart';

class Pregunta<T extends Respuesta> extends Bloque {
  final T? respuesta;
  final int criticidad;
  final String posicion;
  final bool calificable;

  Pregunta({
    required String titulo,
    required String descripcion,
    required this.criticidad,
    required this.posicion,
    required this.calificable,
    this.respuesta,
  }) : super(titulo: titulo, descripcion: descripcion);
}
