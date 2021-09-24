import 'package:reactive_forms/reactive_forms.dart';

import '../../model/bloques/preguntas/pregunta_numerica.dart';

import '../controlador_de_pregunta.dart';

class ControladorDePreguntaNumerica extends ControladorDePregunta {
  final FormControl<int?> respuestaNumericaControl;

  ControladorDePreguntaNumerica(PreguntaNumerica pregunta)
      : respuestaNumericaControl = fb.control(pregunta.respuestaNumerica) {
    this.pregunta = pregunta;
    control.addAll({"respuesta": respuestaNumericaControl});
  }

  @override
  void guardar() {
    //TODO: implement
    throw UnimplementedError();
  }
}
