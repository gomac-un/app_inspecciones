import 'package:reactive_forms/reactive_forms.dart';

import '../../control/visitors/controlador_de_pregunta_visitor.dart';
import '../../domain/bloques/preguntas/pregunta_de_seleccion_multiple.dart';
import '../controlador_de_pregunta.dart';

class ControladorDePreguntaDeSeleccionMultiple
    extends ControladorDePregunta<PreguntaDeSeleccionMultiple> {
  late final List<ControladorDeSubPreguntaDeSeleccionMultiple>
      controladoresPreguntas = pregunta.respuestas
          .map((p) => ControladorDeSubPreguntaDeSeleccionMultiple(p))
          .toList();

  @override
  late final FormArray respuestaEspecificaControl = fb.array(
      controladoresPreguntas.map((c) => c.control).toList(),
      [MultipleValidator().validate]);

  ControladorDePreguntaDeSeleccionMultiple(PreguntaDeSeleccionMultiple pregunta)
      : super(pregunta);

  @override
  int get criticidadRespuesta {
    final opcionesSeleccionadas = controladoresPreguntas
        // la opcion esta seleccionada y no esta reparada
        .where((c) =>
            c.respuestaEspecificaControl.value! && c.criticidadCalculada > 0)
        .map((c) => c.pregunta.opcion);

    if (opcionesSeleccionadas.any((r) => r.criticidad == 4) ||
        opcionesSeleccionadas.where((r) => r.criticidad >= 3).length >= 2) {
      return 4;
    } else if (opcionesSeleccionadas.any((r) => r.criticidad == 3) ||
        opcionesSeleccionadas.where((r) => r.criticidad >= 2).length >= 2) {
      return 3;
    } else if (opcionesSeleccionadas.any((r) => r.criticidad == 2) ||
        opcionesSeleccionadas.where((r) => r.criticidad >= 1).length >= 2) {
      return 2;
    } else if (opcionesSeleccionadas.any((r) => r.criticidad == 1)) {
      return 1;
    } else if (opcionesSeleccionadas.every((r) => r.criticidad == 0)) {
      return 0;
    } else {
      return 4; // nunca deberia llegar hasta aca
    }
  }

  @override
  R accept<R>(ControladorDePreguntaVisitor<R> visitor) =>
      visitor.visitSeleccionMultiple(this);
}

class ControladorDeSubPreguntaDeSeleccionMultiple
    extends ControladorDePregunta<SubPreguntaDeSeleccionMultiple> {
  @override
  late final FormControl<bool> respuestaEspecificaControl =
      fb.control(pregunta.respuesta?.estaSeleccionada ?? false);

  ControladorDeSubPreguntaDeSeleccionMultiple(
      SubPreguntaDeSeleccionMultiple pregunta)
      : super(pregunta);

  @override
  int get criticidadRespuesta =>
      pregunta.opcion.criticidad * (estaSeleccionada ? 1 : 0);

  bool get estaSeleccionada => respuestaEspecificaControl.value!;

  @override
  R accept<R>(ControladorDePreguntaVisitor<R> visitor) =>
      throw UnsupportedError("$runtimeType no recibe visitors");
}

class MultipleValidator extends Validator<dynamic> {
  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    final respuestas = control as FormArray;
    final contestadas = respuestas.controls
        .where((x) => (x as FormGroup).control('respuestaEspecifica').value);
    if (contestadas.isEmpty) {
      return <String, dynamic>{ValidationMessage.minLength: true};
    }
    return null;
  }
}
