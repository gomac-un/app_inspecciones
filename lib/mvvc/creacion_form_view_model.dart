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

  ValueNotifier<List<Sistema>> sistemas = ValueNotifier([]);

  ValueNotifier<List<String>> tiposDeInspeccion = ValueNotifier([]);
  final tipoDeInspeccion = FormControl<String>();

  final nuevoTipoDeinspeccion = FormControl<String>();

  ValueNotifier<List<String>> modelos = ValueNotifier([]);

  final modelosSeleccionados = FormControl<List<String>>(value: []);

  ValueNotifier<List<Contratista>> contratistas = ValueNotifier([]);
  final contratista = FormControl<Contratista>();

  final periodicidad = FormControl<double>();

  final bloques = FormArray([]);

  final form = FormGroup({});

  CreacionFormViewModel() {
    form.addAll({
      'tipoDeInspeccion': tipoDeInspeccion,
      'nuevoTipoDeInspeccion': nuevoTipoDeinspeccion,
      'modelos': modelosSeleccionados,
      'contratista': contratista,
      'periodicidad': periodicidad,
      'bloques': bloques,
    });
    //agregar un titulo inicial
    bloques.add(CreadorTituloFormGroup());
    cargarDatos();
  }

  Future cargarDatos() async {
    tiposDeInspeccion.value = await _db.getTiposDeInspecciones();
    tiposDeInspeccion.value.add("otro");

    modelos.value = await _db.getModelos();
    contratistas.value = await _db.getContratistas();
    sistemas.value = await _db.getSistemas();
  }

  /// Metodos para los bloques que funcionan sorprendentemente bien con los nulos y los casos extremos
  agregarPreguntaDespuesDe(AbstractControl e) {
    bloques.insert(bloques.controls.indexOf(e) + 1,
        CreadorPreguntaSeleccionSimpleFormGroup());
  }

  agregarTituloDespuesDe(AbstractControl e) {
    bloques.insert(bloques.controls.indexOf(e) + 1, CreadorTituloFormGroup());
  }

  agregarCuadriculaDespuesDe(AbstractControl e) {
    bloques.insert(
        bloques.controls.indexOf(e) + 1, CreadorPreguntaCuadriculaFormGroup());
  }

  borrarBloque(AbstractControl e) {
    //TODO hacerle dispose si se requiere
    try {
      bloques.remove(e);
    } on FormControlNotFoundException {
      print("que pendejo");
    }
  }

  Future guardarEnLocal({bool esBorrador}) async {
    //TODO: implementar
  }
  void enviar() {
    //TODO: implementar
    print(form.value);
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
