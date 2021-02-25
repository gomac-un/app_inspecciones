//Custom Validators
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/injection.dart';
import 'package:inspecciones/mvvc/creacion_form_view_model.dart';
import 'package:reactive_forms/reactive_forms.dart';

//FIXME: no recalcula cuando cambia el tipo de inspeccion
Future<Map<String, dynamic>> cuestionariosExistentes(
  AbstractControl<dynamic> control,
) async {
  final form = control as CreacionFormViewModel;

  final tipoDeInspeccion =
      form.control('tipoDeInspeccion') as FormControl<String>;

  final modelos = form.control('modelos') as FormControl<List<String>>;

  final cuestionariosExistentes = await getIt<Database>()
      .creacionDao
      .getCuestionarios(tipoDeInspeccion.value, modelos.value);

  if (cuestionariosExistentes.isNotEmpty) {
    final y = cuestionariosExistentes.firstWhere(
        (cu) => cu.id != form?.cuestionario?.id,
        orElse: () => null);
    if (y != null) {
      modelos.setErrors({
        'yaExiste': true /*cuestionariosExistentes.first.modelo*/
      });
      modelos.markAsTouched();
    } else {
      modelos.removeError('yaExiste');
    }
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
