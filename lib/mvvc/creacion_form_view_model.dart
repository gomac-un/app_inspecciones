import 'package:flutter/foundation.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/injection.dart';
import 'package:inspecciones/mvvc/creacion_controls.dart';
import 'package:inspecciones/mvvc/creacion_validators.dart';
import 'package:reactive_forms/reactive_forms.dart';

//TODO: implementar la edicion de cuestionarios
//TODO: este viewmodel podria extender de FormGroup
class CreacionFormViewModel extends FormGroup {
  final _db = getIt<Database>();

  final sistemas = ValueNotifier<List<Sistema>>([]);
  final tiposDeInspeccion = ValueNotifier<List<String>>([]);
  final modelos = ValueNotifier<List<String>>([]);
  final contratistas = ValueNotifier<List<Contratista>>([]);

  Copiable bloqueCopiado;

  CreacionFormViewModel()
      : super(
          {
            'tipoDeInspeccion':
                FormControl<String>(validators: [Validators.required]),
            'nuevoTipoDeInspeccion': FormControl<String>(value: ""),
            'modelos': FormControl<List<String>>(
                value: [], validators: [Validators.minLength(1)]),
            'contratista':
                FormControl<Contratista>(validators: [Validators.required]),
            'periodicidad': FormControl<double>(
                value: 0, validators: [Validators.required]),
            'bloques': FormArray(
                [CreadorTituloFormGroup()]), //agrega un titulo inicial
          },
          validators: [nuevoTipoDeInspeccion],
          asyncValidators: [cuestionariosExistentes],
        );

  Future cargarDatos() async {
    tiposDeInspeccion.value = await _db.creacionDao.getTiposDeInspecciones();
    tiposDeInspeccion.value.add("otra");

    modelos.value = await _db.creacionDao.getModelos();
    modelos.value.add("todos");

    contratistas.value = await _db.creacionDao.getContratistas();
    sistemas.value = await _db.creacionDao.getSistemas();
  }

  /// Metodo que funciona sorprendentemente bien con los nulos y los casos extremos
  void agregarBloqueDespuesDe(
      {AbstractControl bloque, AbstractControl despuesDe}) {
    final bloques = control("bloques") as FormArray;
    bloques.insert(bloques.controls.indexOf(despuesDe) + 1, bloque);
  }

  void borrarBloque(AbstractControl e) {
    //TODO hacerle dispose si se requiere
    try {
      (control("bloques") as FormArray).remove(e);
      // ignore: empty_catches
    } on FormControlNotFoundException {}
  }

  Future enviar() async {
    markAllAsTouched();
    await _db.creacionDao.crearCuestionario(controls);
  }

  /// Cierra todos los streams para evitar fugas de memoria, se suele llamar desde el provider
  @override
  void dispose() {
    tiposDeInspeccion.dispose();
    modelos.dispose();
    contratistas.dispose();
    sistemas.dispose();
    super.dispose();
  }
}
