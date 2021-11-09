import 'package:inspecciones/core/entities/app_image.dart';

import '../../etiqueta.dart';
import '../pregunta.dart';
import 'opcion_de_respuesta.dart';

class PreguntaDeSeleccion<T extends Respuesta> extends Pregunta<T> {
  final List<OpcionDeRespuesta> opcionesDeRespuesta;

  PreguntaDeSeleccion(
    this.opcionesDeRespuesta, {
    required String id,
    required String titulo,
    required String descripcion,
    required List<AppImage> fotosGuia,
    required int criticidad,
    required List<Etiqueta> etiquetas,
    required bool calificable,
    T? respuesta,
  }) : super(
          id: id,
          titulo: titulo,
          descripcion: descripcion,
          fotosGuia: fotosGuia,
          criticidad: criticidad,
          etiquetas: etiquetas,
          respuesta: respuesta,
          calificable: calificable,
        );
}
