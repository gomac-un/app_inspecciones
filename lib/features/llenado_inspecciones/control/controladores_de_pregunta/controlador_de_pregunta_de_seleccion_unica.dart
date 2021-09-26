import 'package:reactive_forms/reactive_forms.dart';

import '../../domain/bloques/preguntas/opcion_de_respuesta.dart';
import '../../domain/bloques/preguntas/pregunta_de_seleccion_unica.dart';
import '../controlador_de_pregunta.dart';
import '../visitors/controlador_de_pregunta_visitor.dart';

class ControladorDePreguntaDeSeleccionUnica
    extends ControladorDePregunta<PreguntaDeSeleccionUnica> {
  @override
  late final FormControl<OpcionDeRespuesta?> respuestaEspecificaControl =
      fb.control(pregunta.respuesta?.opcionSeleccionada, [Validators.required]);

  ControladorDePreguntaDeSeleccionUnica(PreguntaDeSeleccionUnica pregunta)
      : super(pregunta);

  @override
  int? get criticidadRespuesta => respuestaEspecificaControl.value?.criticidad;

  @override
  void accept(ControladorDePreguntaVisitor visitor) =>
      visitor.visitSeleccionUnica(this);
}
