import 'package:reactive_forms/reactive_forms.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/bloques/preguntas/opcion_de_respuesta.dart';
import '../../domain/bloques/preguntas/pregunta_de_seleccion_unica.dart';
import '../controlador_de_pregunta.dart';
import '../controlador_llenado_inspeccion.dart';
import '../visitors/controlador_de_pregunta_visitor.dart';

class ControladorDePreguntaDeSeleccionUnica extends ControladorDePregunta<
    PreguntaDeSeleccionUnica, FormControl<OpcionDeRespuesta?>> {
  @override
  late final respuestaEspecificaControl =
      fb.control(pregunta.respuesta?.opcionSeleccionada, [Validators.required]);

  ControladorDePreguntaDeSeleccionUnica(PreguntaDeSeleccionUnica pregunta,
      ControladorLlenadoInspeccion controlInspeccion)
      : super(pregunta, controlInspeccion);

  @override
  late final ValueStream<bool> requiereCriticidadDelInspector =
      respuestaEspecificaControl.valueChanges
          .map((o) => o?.requiereCriticidadDelInspector ?? false)
          .toVSwithInitial(requiereCriticidadDelInspectorSync);

  bool get requiereCriticidadDelInspectorSync =>
      respuestaEspecificaControl.value?.requiereCriticidadDelInspector ?? false;


  @override
  late final ValueStream<int?> criticidadRespuesta =
      respuestaEspecificaControl.valueChanges.map((o) {
    return o?.criticidad;
  }).toVSwithInitial(respuestaEspecificaControl.value?.criticidad);

  @override
  R accept<R>(ControladorDePreguntaVisitor<R> visitor) =>
      visitor.visitSeleccionUnica(this);
}
