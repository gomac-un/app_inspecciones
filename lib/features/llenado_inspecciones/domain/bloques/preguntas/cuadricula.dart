import 'package:inspecciones/core/entities/app_image.dart';

import '../../etiqueta.dart';
import '../pregunta.dart';
import 'opcion_de_respuesta.dart';
import 'pregunta_de_seleccion.dart';
import 'preguntas.dart';

class Cuadricula<T extends RespuestaDeCuadricula, P extends PreguntaDeSeleccion>
    extends PreguntaDeSeleccion<T> {
  final List<P> preguntas;

  Cuadricula(
    this.preguntas,
    List<OpcionDeRespuesta> opcionesDeRespuesta, {
    required String id,
    required String titulo,
    required String descripcion,
    required List<AppImage> fotosGuia,
    required int criticidad,
    required List<Etiqueta> etiquetas,
    required bool calificable,
    T? respuesta,
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

typedef CuadriculaDeSeleccionMultiple = Cuadricula<
    RespuestaDeCuadriculaDeSeleccionMultiple, PreguntaDeSeleccionMultiple>;

typedef CuadriculaDeSeleccionUnica = Cuadricula<
    RespuestaDeCuadriculaDeSeleccionUnica, PreguntaDeSeleccionUnica>;
