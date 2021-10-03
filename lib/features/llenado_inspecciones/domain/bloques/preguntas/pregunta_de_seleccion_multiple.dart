import '../pregunta.dart';
import 'opcion_de_respuesta.dart';
import 'pregunta_de_seleccion.dart';

class PreguntaDeSeleccionMultiple
    extends PreguntaDeSeleccion<RespuestaDeSeleccionMultiple> {
  final List<SubPreguntaDeSeleccionMultiple> respuestas;

  PreguntaDeSeleccionMultiple(
    List<OpcionDeRespuesta> opcionesDeRespuesta,
    this.respuestas, {
    required int id,
    required String titulo,
    required String descripcion,
    required int nOrden,
    required int criticidad,
    required String posicion,
    required bool calificable,
    RespuestaDeSeleccionMultiple? respuesta,
  }) : super(
          opcionesDeRespuesta,
          id: id,
          respuesta: respuesta,
          titulo: titulo,
          descripcion: descripcion,
          criticidad: criticidad,
          posicion: posicion,
          calificable: calificable,
          nOrden: nOrden,
        );
}

class SubPreguntaDeSeleccionMultiple
    extends Pregunta<SubRespuestaDeSeleccionMultiple> {
  final OpcionDeRespuesta opcion;
  SubPreguntaDeSeleccionMultiple(
    this.opcion, {
    required int id,
    required String titulo,
    required String descripcion,
    required int nOrden,
    required int criticidad,
    required String posicion,
    required bool calificable,
    SubRespuestaDeSeleccionMultiple? respuesta,
  }) : super(
          id: id,
          respuesta: respuesta,
          titulo: titulo,
          descripcion: descripcion,
          criticidad: criticidad,
          posicion: posicion,
          calificable: calificable,
          nOrden: nOrden,
        );
}
