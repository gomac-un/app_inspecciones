import 'package:flutter/foundation.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/bloques/preguntas/pregunta_numerica.dart';
import '../controlador_de_pregunta.dart';
import '../controlador_llenado_inspeccion.dart';
import '../visitors/controlador_de_pregunta_visitor.dart';

class ControladorDePreguntaNumerica
    extends ControladorDePregunta<PreguntaNumerica, FormControl<double?>> {
  @override
  late final respuestaEspecificaControl = fb.control(
      pregunta.respuesta?.respuestaNumerica,
      [DoubleValidator().validate, Validators.required]);

  ControladorDePreguntaNumerica(
      PreguntaNumerica pregunta, ControladorLlenadoInspeccion controlInspeccion)
      : super(pregunta, controlInspeccion);

  @override
  late final ValueStream<bool> requiereCriticidadDelInspector =
      BehaviorSubject.seeded(false);

  @override
  late final ValueStream<int?> criticidadRespuesta = respuestaEspecificaControl
      .valueChanges
      .map((value) => value == null ? null : _encontrarCriticidadDeValor(value))
      .toVSwithInitial(criticidadRespuestaSync);

  int? get criticidadRespuestaSync =>
      valor == null ? null : _encontrarCriticidadDeValor(valor!);

  int _encontrarCriticidadDeValor(double valor) =>
      pregunta.rangosDeCriticidad.singleWhere(
        (r) => valor >= r.inicio && valor <= r.fin,
        orElse: () {
          FlutterError.reportError(FlutterErrorDetails(
            exception: Exception('rangos incompletos'),
            library: 'inspecciones',
            context: ErrorDescription(
                'rangos de criticidad incompletos, usando criticidad 0 por defecto'),
          ));
          return RangoDeCriticidad(0, 0, 0);
        },
      ).criticidad;

  @override
  R accept<R>(ControladorDePreguntaVisitor<R> visitor) =>
      visitor.visitControladorDePreguntaNumerica(this);

  double? get valor => respuestaEspecificaControl.value;
}

class DoubleValidator extends Validator<dynamic> {
  static final RegExp _numberRegex = RegExp(r'^-?[0-9]+(\.?[0-9]+)?$');
  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) =>
      (control.value == null) ||
              !_numberRegex.hasMatch(control.value.toString())
          ? <String, dynamic>{ValidationMessage.number: true}
          : null;
}

class MyDoubleValueAccessor extends ControlValueAccessor<double?, String> {
  final int maxDigits;

  MyDoubleValueAccessor({
    this.maxDigits = 2,
  });

  @override
  String modelToViewValue(double? modelValue) {
    return modelValue == null
        ? ''
        : modelValue.toStringAsFixed(
            modelValue.truncateToDouble() == modelValue ? 0 : maxDigits);
  }

  @override
  double? viewToModelValue(String? viewValue) {
    return (viewValue == '' || viewValue == null)
        ? null
        : double.tryParse(viewValue);
  }
}
