import '../bloque.dart';
import '../respuesta.dart';

abstract class Pregunta extends Bloque {
  late final Respuesta respuesta;
  late final int criticidad;
}
