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
    required int id,
    required String titulo,
    required String descripcion,
    required int nOrden,
    required int criticidad,
    required String posicion,
    required bool calificable,
    T? respuesta,
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

typedef CuadriculaDeSeleccionMultiple = Cuadricula<
    RespuestaDeCuadriculaDeSeleccionMultiple, PreguntaDeSeleccionMultiple>;

typedef CuadriculaDeSeleccionUnica = Cuadricula<
    RespuestaDeCuadriculaDeSeleccionUnica, PreguntaDeSeleccionUnica>;
