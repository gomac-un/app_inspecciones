//Custom Validators
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/injection.dart';
import 'package:reactive_forms/reactive_forms.dart';

Future<Map<String, dynamic>> cuestionariosExistentes(
    AbstractControl<dynamic> control) async {
  final form = control as FormGroup;

  final tipoDeInspeccion = form.control('tipoDeInspeccion');
  final modelos = form.control('modelos');

  final cuestionariosExistentes = await getIt<Database>()
      .getCuestionarios(tipoDeInspeccion.value, modelos.value);

  if (cuestionariosExistentes.length > 0) {
    modelos.setErrors({'yaExiste': cuestionariosExistentes.first.modelo});
    modelos.markAsTouched();
  } else {
    modelos.removeError('yaExiste');
  }
  return null;
}

Map<String, dynamic> nuevoTipoDeInspeccion(AbstractControl<dynamic> control) {
  final form = control as FormGroup;

  final tipoDeInspeccion = form.control('tipoDeInspeccion');
  final nuevoTipoDeinspeccion =
      form.control('nuevoTipoDeInspeccion') as FormControl<String>;

  final error = {ValidationMessage.required: true};

  if (tipoDeInspeccion.value == 'otra' &&
      nuevoTipoDeinspeccion.value.trim().isEmpty) {
    nuevoTipoDeinspeccion.setErrors(error);
    //nuevoTipoDeinspeccion.markAsTouched();
  } else {
    nuevoTipoDeinspeccion.removeError(ValidationMessage.required);
  }
  return null;
}
