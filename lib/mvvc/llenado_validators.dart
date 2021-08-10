//Custom Validators
import 'dart:io';

import 'package:reactive_forms/reactive_forms.dart';

/// Marca como requerido el textField de 'nuevoTipoDeInspeccion',
/// en caso de que se haya seleccionado 'Otra' como tipo de inspeccion.
Map<String, dynamic> reparacion(AbstractControl<dynamic> control) {
  final form = control as FormGroup;

  final reparado = form.control('reparado') as FormControl<bool>;
  final observacion =
      form.control('observacionReparacion') as FormControl<String>;
  final fotosReparacion = form.control('fotosReparacion') as FormArray<File>;

  final error = {ValidationMessage.required: true};

  if (reparado.value) {
    if (observacion.value.trim().isEmpty) {
      observacion.setErrors(error);
    }
    if (fotosReparacion.value.isEmpty) {
      fotosReparacion.setErrors(error);
    }
  } else {
    observacion.removeError(ValidationMessage.required);
    fotosReparacion.removeError(ValidationMessage.required);
  }
  return null;
}
