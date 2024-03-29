import 'package:dartz/dartz.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:rxdart/rxdart.dart';

import '../../control/visitors/controlador_de_pregunta_visitor.dart';
import '../../domain/bloques/preguntas/opcion_de_respuesta.dart';
import '../../domain/bloques/preguntas/pregunta_de_seleccion_multiple.dart';
import '../controlador_de_pregunta.dart';
import '../controlador_llenado_inspeccion.dart';

class ControladorDePreguntaDeSeleccionMultiple
    extends ControladorDePregunta<PreguntaDeSeleccionMultiple, FormArray> {
  late final List<ControladorDeSubPreguntaDeSeleccionMultiple>
      controladoresPreguntas = pregunta.respuestas
          .map((p) =>
              ControladorDeSubPreguntaDeSeleccionMultiple(p, controlInspeccion))
          .toList();

  @override
  late final FormArray respuestaEspecificaControl = fb.array(
      controladoresPreguntas.map((c) => c.control).toList(),
      [MultipleValidator().validate]);

  ControladorDePreguntaDeSeleccionMultiple(PreguntaDeSeleccionMultiple pregunta,
      ControladorLlenadoInspeccion controlInspeccion)
      : super(pregunta, controlInspeccion);

  @override
  late final ValueStream<bool> requiereCriticidadDelInspector =
      BehaviorSubject.seeded(false);

  @override
  late final ValueStream<int> criticidadRespuesta = Rx.combineLatest<
      Tuple2<ControladorDeSubPreguntaDeSeleccionMultiple, bool>, int>(
    controladoresPreguntas.map(
      (c) => Rx.combineLatest2<bool, int,
          Tuple2<ControladorDeSubPreguntaDeSeleccionMultiple, bool>>(
        c.respuestaEspecificaControl.toValueStreamNN(),
        c.criticidadCalculada,
        (seleccionada, criticidad) => Tuple2(c, seleccionada && criticidad > 0),
      ),
    ),
    (l) {
      final opcionesSeleccionadas =
          l.where((t) => t.value2).map((e) => e.value1.pregunta.opcion);
      return _calcularCriticidad(opcionesSeleccionadas);
    },
  ).toVSwithInitial(criticidadRespuestaSync);

  int get criticidadRespuestaSync {
    final opcionesSeleccionadas = controladoresPreguntas
        // la opcion esta seleccionada y no esta reparada
        .where((c) =>
            c.respuestaEspecificaControl.value! &&
            c.criticidadCalculada.value > 0)
        .map((c) => c.pregunta.opcion);
    return _calcularCriticidad(opcionesSeleccionadas);
  }

  int _calcularCriticidad(Iterable<OpcionDeRespuesta> opcionesSeleccionadas) {
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

class ControladorDeSubPreguntaDeSeleccionMultiple extends ControladorDePregunta<
    SubPreguntaDeSeleccionMultiple, FormControl<bool>> {
  @override
  late final FormControl<bool> respuestaEspecificaControl =
      fb.control(pregunta.respuesta?.estaSeleccionada ?? false);

  ControladorDeSubPreguntaDeSeleccionMultiple(
      SubPreguntaDeSeleccionMultiple pregunta,
      ControladorLlenadoInspeccion controlInspeccion)
      : super(pregunta, controlInspeccion);

  @override
  late final ValueStream<bool> requiereCriticidadDelInspector =
      BehaviorSubject.seeded(pregunta.opcion.requiereCriticidadDelInspector);

  @override
  late final ValueStream<int?> criticidadRespuesta = respuestaEspecificaControl
      .valueChanges
      .map((estaSeleccionada) => estaSeleccionada! ? 1 : 0)
      .toVSwithInitial(criticidadRespuestaSync);

  int get criticidadRespuestaSync =>
      pregunta.opcion.criticidad * (estaSeleccionadaSync ? 1 : 0);

  bool get estaSeleccionadaSync => respuestaEspecificaControl.value!;

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
