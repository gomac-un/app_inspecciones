//Custom Validators
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/injection.dart';
import 'package:inspecciones/mvvc/creacion_form_view_model.dart';
import 'package:reactive_forms/reactive_forms.dart';

//FIXME: no recalcula cuando cambia el tipo de inspeccion
/// Cuando se crea un cuestionario
/// Valida que no exista un [tipoDeInspeccion] aplicado a los mismos [modelos].
Future<Map<String, dynamic>> cuestionariosExistentes(
  AbstractControl<dynamic> control,
) async {
  final form = control as CreacionFormViewModel;

  /// Nuevo tipo elegido en el form.
  final tipoDeInspeccion =
      form.control('tipoDeInspeccion') as FormControl<String>;

  /// Modelos seleccionados en el form.
  final modelos = form.control('modelos') as FormControl<List<String>>;

  /// Se consulta si ya existe algun cuestionario aplicado a los mismos modelos.
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

/// Marca como requerido el textField de 'nuevoTipoDeInspeccion',
/// en caso de que se haya seleccionado 'Otra' como tipo de inspeccion.
Map<String, dynamic> nuevoTipoDeInspeccion(AbstractControl<dynamic> control) {
  final form = control as FormGroup;

  final tipoDeInspeccion = form.control('tipoDeInspeccion');
  final nuevoTipoDeinspeccion =
      form.control('nuevoTipoDeInspeccion') as FormControl<String>;

  final error = {ValidationMessage.required: true};

  if (tipoDeInspeccion.value == 'Otra' &&
      nuevoTipoDeinspeccion.value.trim().isEmpty) {
    nuevoTipoDeinspeccion.setErrors(error);
    //nuevoTipoDeinspeccion.markAsTouched();
  } else {
    nuevoTipoDeinspeccion.removeError(ValidationMessage.required);
  }
  return null;
}

/// Validación que verifica que el valor del textfield para 'minimo' sea menor que el valor introducido en el textfield 'maximo'.
/// En las preguntas numéricas
ValidatorFunction verificarRango(String controlMinimo, String controlMaximo) {
  return (AbstractControl<dynamic> control) {
    final form = control as FormGroup;

    final valorMinimo = form.control(controlMinimo);
    final valorMaximo = form.control(controlMaximo);
    if (double.parse(valorMinimo.value.toString()) >=
        double.parse(valorMaximo.value.toString())) {
      valorMaximo.setErrors({'verificarRango': true});
    } else {
      valorMaximo.removeError('verificarRango');
    }

    return null;
  };
}
