//Custom Validators
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/injection.dart';
import 'package:inspecciones/mvvc/creacion_cuestionarios/creacion_form_controller.dart';
import 'package:inspecciones/mvvc/planeacion_grupos_controls.dart';
import 'package:reactive_forms/reactive_forms.dart';

Future<Map<String, dynamic>> inspeccionesExistentes(
  AbstractControl<dynamic> control,
) async {
  final form = control as CrearGrupoControl;
  final fechaInicio = form.control('fechaInicio') as FormControl<DateTime>;
  final fechaFin = form.control('fechaFin') as FormControl<DateTime>;
  final tipoDeInspeccion =
      form.control('cantidad') as FormControl<TiposDeInspeccione>;

  final nuevaControl =
      form.control('nuevoTipoDeInspeccion') as FormControl<String>;
  if (tipoDeInspeccion.value.tipo == 'Otra') {
    final nuevaInspeccion = nuevaControl.value.toLowerCase();
    final inspeccionesExistentes =
        await getIt<Database>().planeacionDao.getInspeccionesConGrupo();
    if (inspeccionesExistentes.isNotEmpty) {
      final y = inspeccionesExistentes.firstWhere(
          (cu) => cu.toLowerCase() == nuevaInspeccion,
          orElse: () => null);
      if (y != null) {
        nuevaControl.setErrors({
          'yaExiste': true /*cuestionariosExistentes.first.modelo*/
        });
        nuevaControl.markAsTouched();
      } else {
        nuevaControl.removeError('yaExiste');
      }
    } else {
      nuevaControl.removeError('yaExiste');
    }
  }

  return null;
}

Map<String, dynamic> nuevoTipoDeInspeccion(AbstractControl<dynamic> control) {
  final form = control as CrearGrupoControl;
  final tipoDeInspeccion =
      form.control('tipoDeInspeccion') as FormControl<TiposDeInspeccione>;

  final nuevoTipoDeinspeccion =
      form.control('nuevoTipoDeInspeccion') as FormControl<String>;

  final error = {ValidationMessage.required: true};

  if (tipoDeInspeccion.value.tipo == 'Otra' &&
      nuevoTipoDeinspeccion.value.trim().isEmpty) {
    nuevoTipoDeinspeccion.setErrors(error);
    //nuevoTipoDeinspeccion.markAsTouched();
  } else {
    nuevoTipoDeinspeccion.removeError(ValidationMessage.required);
  }
  return null;
}
