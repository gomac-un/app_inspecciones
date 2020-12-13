import 'package:flutter/foundation.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/injection.dart';
import 'package:inspecciones/mvvc/creacion_controls.dart';
import 'package:reactive_forms/reactive_forms.dart';

part 'creacion_datos_test.dart';

//TODO: agregar todas las validaciones necesarias
//TODO: implementar la edicion de cuestionarios

class CreacionFormViewModel {
  final _db = getIt<Database>();

  final sistemas = ValueNotifier<List<Sistema>>([]);
  final tiposDeInspeccion = ValueNotifier<List<String>>([]);
  final modelos = ValueNotifier<List<String>>([]);
  final contratistas = ValueNotifier<List<Contratista>>([]);

  final tipoDeInspeccion =
      FormControl<String>(validators: [Validators.required]);

  final nuevoTipoDeinspeccion =
      FormControl<String>(value: ""); //validado desde el form

  final modelosSeleccionados = FormControl<List<String>>(
      value: [], validators: [Validators.minLength(1)]);

  final contratista = FormControl<Contratista>();

  final periodicidad = FormControl<double>();

  final bloques = FormArray([]);

  FormGroup form; //no cambiar please

  CreacionFormViewModel() {
    form = FormGroup({
      'tipoDeInspeccion': tipoDeInspeccion,
      'nuevoTipoDeInspeccion': nuevoTipoDeinspeccion,
      'modelos': modelosSeleccionados,
      'contratista': contratista,
      'periodicidad': periodicidad,
      'bloques': bloques,
    }, validators: [
      _nuevoTipoDeInspeccion
    ], asyncValidators: [
      _cuestionariosExistentes
    ]);
    //agregar un titulo inicial
    bloques.add(CreadorTituloFormGroup());
    cargarDatos();
  }

  Future cargarDatos() async {
    tiposDeInspeccion.value = await _db.getTiposDeInspecciones();
    tiposDeInspeccion.value.add("otra");

    modelos.value = await _db.getModelos();
    contratistas.value = await _db.getContratistas();
    sistemas.value = await _db.getSistemas();
  }

  /// Metodo que funciona sorprendentemente bien con los nulos y los casos extremos
  agregarBloqueDespuesDe({AbstractControl bloque, AbstractControl despuesDe}) {
    bloques.insert(bloques.controls.indexOf(despuesDe) + 1, bloque);
  }

  borrarBloque(AbstractControl e) {
    //TODO hacerle dispose si se requiere
    try {
      bloques.remove(e);
    } on FormControlNotFoundException {
      print("que pendejo");
    }
  }

  enviar() async {
    print(form.controls);
    form.markAllAsTouched();
    await _db.crearCuestionario(form.controls);
  }

  /// Cierra todos los streams para evitar fugas de memoria, se suele llamar desde el provider
  dispose() {
    tiposDeInspeccion.dispose();
    modelos.dispose();
    contratistas.dispose();
    sistemas.dispose();
    form.dispose();
  }
}

//Custom Validators
Future<Map<String, dynamic>> _cuestionariosExistentes(
    AbstractControl<dynamic> control) async {
  final form = control as FormGroup;

  final tipoDeInspeccion = form.control('tipoDeInspeccion');
  final modelos = form.control('modelos');

  final cuestionariosExistentes = await getIt<Database>()
      .getCuestionarios(tipoDeInspeccion.value, modelos.value);
  if (cuestionariosExistentes.length > 0) {
    tipoDeInspeccion.setErrors({'yaExiste': true});
    tipoDeInspeccion.markAsTouched();
  } else {
    tipoDeInspeccion.removeError('yaExiste');
  }
  return null;
}

Map<String, dynamic> _nuevoTipoDeInspeccion(AbstractControl<dynamic> control) {
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
