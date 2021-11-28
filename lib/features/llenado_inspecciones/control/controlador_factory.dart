import '../domain/bloques/bloques.dart';
import 'controlador_de_pregunta.dart';
import 'controlador_llenado_inspeccion.dart';
import 'controladores_de_pregunta/controladores_de_pregunta.dart';

class ControladorFactory {
  ControladorDePregunta crearControlador(
      Pregunta pregunta, ControladorLlenadoInspeccion controlInspeccion) {
    if (pregunta is PreguntaNumerica) {
      return ControladorDePreguntaNumerica(pregunta, controlInspeccion);
    }
    if (pregunta is PreguntaDeSeleccionUnica) {
      return ControladorDePreguntaDeSeleccionUnica(pregunta, controlInspeccion);
    }
    if (pregunta is CuadriculaDeSeleccionUnica) {
      return ControladorDeCuadriculaDeSeleccionUnica(
          pregunta, controlInspeccion);
    }
    if (pregunta is CuadriculaDeSeleccionMultiple) {
      return ControladorDeCuadriculaDeSeleccionMultiple(
          pregunta, controlInspeccion);
    }
    if (pregunta is PreguntaDeSeleccionMultiple) {
      return ControladorDePreguntaDeSeleccionMultiple(
          pregunta, controlInspeccion);
    }
    throw UnimplementedError(
        "La pregunta de tipo ${pregunta.runtimeType} no tiene asociado un controlador en el factory, por favor asignele uno");
  }
}
