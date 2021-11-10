import 'package:inspecciones/core/entities/app_image.dart';

import '../../etiqueta.dart';
import '../pregunta.dart';
import 'opcion_de_respuesta.dart';
import 'pregunta_de_seleccion.dart';

class PreguntaDeSeleccionMultiple
    extends PreguntaDeSeleccion<RespuestaDeSeleccionMultiple> {
  final List<SubPreguntaDeSeleccionMultiple>
      respuestas; // aqui se traen las respuestas en el cargado

  PreguntaDeSeleccionMultiple(
    List<OpcionDeRespuesta> opcionesDeRespuesta,
    this.respuestas, {
    required String id,
    required String titulo,
    required String descripcion,
    required List<AppImage> fotosGuia,
    required int criticidad,
    required List<Etiqueta> etiquetas,
    required bool calificable,
    RespuestaDeSeleccionMultiple?
        respuesta, // aqui se depositan las respuestas para el guardado
  }) : super(
          opcionesDeRespuesta,
          id: id,
          respuesta: respuesta,
          titulo: titulo,
          descripcion: descripcion,
          fotosGuia: fotosGuia,
          criticidad: criticidad,
          etiquetas: etiquetas,
          calificable: calificable,
        );
}

class SubPreguntaDeSeleccionMultiple
    extends Pregunta<SubRespuestaDeSeleccionMultiple> {
  final OpcionDeRespuesta opcion;
  SubPreguntaDeSeleccionMultiple(
    this.opcion, {
    required String id,
    required String titulo,
    required String descripcion,
    required List<AppImage> fotosGuia,
    required int criticidad,
    required List<Etiqueta> etiquetas,
    required bool calificable,
    SubRespuestaDeSeleccionMultiple? respuesta,
  }) : super(
          id: id,
          respuesta: respuesta,
          titulo: titulo,
          descripcion: descripcion,
          fotosGuia: fotosGuia,
          criticidad: criticidad,
          etiquetas: etiquetas,
          calificable: calificable,
        );
}
