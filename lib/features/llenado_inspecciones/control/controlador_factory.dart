import '../domain/bloques/bloques.dart';
import 'controlador_de_pregunta.dart';
import 'controladores_de_pregunta/controladores_de_pregunta.dart';

class ControladorFactory {
  ControladorDePregunta crearControlador(Pregunta pregunta) {
    if (pregunta is PreguntaNumerica) {
      return ControladorDePreguntaNumerica(pregunta);
    }
    if (pregunta is PreguntaDeSeleccionUnica) {
      return ControladorDePreguntaDeSeleccionUnica(pregunta);
    }
    if (pregunta is CuadriculaDeSeleccionUnica) {
      return ControladorDeCuadriculaDeSeleccionUnica(pregunta);
    }
    if (pregunta is CuadriculaDeSeleccionMultiple) {
      return ControladorDeCuadriculaDeSeleccionMultiple(pregunta);
    }
    if (pregunta is PreguntaDeSeleccionMultiple) {
      return ControladorDePreguntaDeSeleccionMultiple(pregunta);
    }
    throw UnimplementedError(
        "La pregunta de tipo ${pregunta.runtimeType} no tiene asociado un controlador en el factory, por favor asignele uno");
  }
}
