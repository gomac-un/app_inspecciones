import '../model/bloques/bloques.dart';

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
    //TODO: implement
    throw UnimplementedError();
  }
}
