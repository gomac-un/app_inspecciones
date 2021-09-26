import '../pregunta.dart';
import 'opcion_de_respuesta.dart';

class PreguntaDeSeleccion<T extends Respuesta> extends Pregunta<T> {
  final List<OpcionDeRespuesta> opcionesDeRespuesta;

  PreguntaDeSeleccion(
    this.opcionesDeRespuesta, {
    required String titulo,
    required String descripcion,
    required int criticidad,
    required String posicion,
    required bool calificable,
    T? respuesta,
  }) : super(
          titulo: titulo,
          descripcion: descripcion,
          criticidad: criticidad,
          posicion: posicion,
          respuesta: respuesta,
          calificable: calificable,
        );
}
