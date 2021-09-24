import 'package:reactive_forms/reactive_forms.dart';

import '../../model/bloques/preguntas/pregunta_de_seleccion_unica.dart';
import '../../model/bloques/preguntas/opcion_de_respuesta.dart';

import '../controlador_de_pregunta.dart';

class ControladorDePreguntaDeSeleccionUnica extends ControladorDePregunta {
  final FormControl<OpcionDeRespuesta> opcionSeleccionadaControl;

  ControladorDePreguntaDeSeleccionUnica(PreguntaDeSeleccionUnica pregunta)
      : opcionSeleccionadaControl = fb.control(pregunta.opcionSeleccionada) {
    this.pregunta = pregunta;
    control.addAll({"opcionSeleccionada": opcionSeleccionadaControl});
  }

  @override
  void guardar() {
    // TODO: implement guardar
    throw UnimplementedError();
  }
}
