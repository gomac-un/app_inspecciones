import 'package:reactive_forms/reactive_forms.dart';

import '../../domain/bloques/preguntas/opcion_de_respuesta.dart';
import '../../domain/bloques/preguntas/pregunta_de_seleccion_unica.dart';
import '../../domain/metarespuesta.dart';
import '../controlador_de_pregunta.dart';
import '../visitors/controlador_de_pregunta_visitor.dart';

class ControladorDePreguntaDeSeleccionUnica extends ControladorDePregunta<
    PreguntaDeSeleccionUnica, FormControl<OpcionDeRespuesta?>> {
  @override
  late final respuestaEspecificaControl =
      fb.control(pregunta.respuesta?.opcionSeleccionada, [Validators.required]);

  ControladorDePreguntaDeSeleccionUnica(PreguntaDeSeleccionUnica pregunta)
      : super(pregunta);

  @override
  int? get criticidadRespuesta => respuestaEspecificaControl.value?.criticidad;

  @override
  MetaRespuesta guardarMetaRespuesta() =>
      respuestaEspecificaControl.value?.requiereCriticidadDelInspector ?? false
          ? super.guardarMetaRespuesta().copyWith(
              criticidadDelInspector: criticidadDelInspectorControl.value)
          : super.guardarMetaRespuesta();

  @override
  R accept<R>(ControladorDePreguntaVisitor<R> visitor) =>
      visitor.visitSeleccionUnica(this);
}
