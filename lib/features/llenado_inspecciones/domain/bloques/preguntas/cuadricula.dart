import '../pregunta.dart';
import 'opcion_de_respuesta.dart';
import 'pregunta_de_seleccion.dart';
import 'preguntas.dart';

class Cuadricula<A extends Respuesta, T extends RespuestaDeCuadricula<A>,
    P extends PreguntaDeSeleccion<A>> extends PreguntaDeSeleccion<T> {
  final List<P> preguntas;

  Cuadricula(
    this.preguntas,
    List<OpcionDeRespuesta> opcionesDeRespuesta, {
    required String titulo,
    required String descripcion,
    required int criticidad,
    required String posicion,
    required bool calificable,
    T? respuesta,
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

typedef CuadriculaDeSeleccionMultiple = Cuadricula<RespuestaDeSeleccionMultiple,
    RespuestaDeCuadriculaDeSeleccionMultiple, PreguntaDeSeleccionMultiple>;

typedef CuadriculaDeSeleccionUnica = Cuadricula<RespuestaDeSeleccionUnica,
    RespuestaDeCuadriculaDeSeleccionUnica, PreguntaDeSeleccionUnica>;
