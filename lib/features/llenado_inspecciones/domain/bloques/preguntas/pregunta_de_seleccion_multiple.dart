import '../pregunta.dart';
import 'opcion_de_respuesta.dart';
import 'pregunta_de_seleccion.dart';

class PreguntaDeSeleccionMultiple
    extends PreguntaDeSeleccion<RespuestaDeSeleccionMultiple> {
  final List<SubPreguntaDeSeleccionMultiple> respuestas;

  PreguntaDeSeleccionMultiple(
    List<OpcionDeRespuesta> opcionesDeRespuesta,
    this.respuestas, {
    required String titulo,
    required String descripcion,
    required int criticidad,
    required String posicion,
    required bool calificable,
    RespuestaDeSeleccionMultiple? respuesta,
  }) : super(
          opcionesDeRespuesta,
          respuesta: respuesta,
          titulo: titulo,
          descripcion: descripcion,
          criticidad: criticidad,
          posicion: posicion,
          calificable: calificable,
        );
}

class SubPreguntaDeSeleccionMultiple
    extends Pregunta<SubRespuestaDeSeleccionMultiple> {
  final OpcionDeRespuesta opcion;
  SubPreguntaDeSeleccionMultiple(
    this.opcion, {
    required String titulo,
    required String descripcion,
    required int criticidad,
    required String posicion,
    required bool calificable,
    SubRespuestaDeSeleccionMultiple? respuesta,
  }) : super(
          respuesta: respuesta,
          titulo: titulo,
          descripcion: descripcion,
          criticidad: criticidad,
          posicion: posicion,
          calificable: calificable,
        );
}
