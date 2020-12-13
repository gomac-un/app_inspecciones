import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:inspecciones/domain/core/enums.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/injection.dart';
import 'package:inspecciones/mvvc/llenado_controls.dart';
import 'package:kt_dart/collection.dart';
import 'package:kt_dart/kt.dart';
import 'package:reactive_forms/reactive_forms.dart';

part 'llenado_datos_test.dart';

//TODO: agregar todas las validaciones necesarias

class LlenadoFormViewModel {
  final _db = getIt<Database>();

  final ValueNotifier<bool> cargada = ValueNotifier(false);

  final String _vehiculo;
  final int _cuestionarioId;

  final form = FormGroup({});

  //FormArray bloques = bloquesDeEjemplo;
  FormArray bloques = FormArray([]);

  //List bloquesMutables;

  LlenadoFormViewModel(this._vehiculo, this._cuestionarioId) {
    /*form.addAll({
      'bloques': bloques,
    });*/
    cargarDatos();
  }

  Future cargarDatos() async {
    /*final Inspeccion inspeccion =
        await _db.getInspeccion(_vehiculo, _cuestionarioId);*/

    final bloquesBD = await _db.cargarCuestionario(_cuestionarioId, _vehiculo);

    //ordenamiento y creacion de los controles dependiendo del tipo de elemento
    bloques = FormArray((bloquesBD
          ..sort((a, b) => a.nOrden.compareTo(b.bloque.nOrden)))
        .map<AbstractControl>((e) {
      if (e is BloqueConTitulo) return TituloFormGroup(e.titulo);
      if (e is BloqueConPreguntaSimple)
        return RespuestaSeleccionSimpleFormGroup(e.pregunta, e.respuesta);
      if (e is BloqueConCuadricula)
        return RespuestaCuadriculaFormArray(
            e.cuadricula, e.preguntasRespondidas);
      throw Exception("Tipo de bloque no reconocido");
    }).toList());

    form.addAll({
      'bloques': bloques,
    });
    cargada.value = true;
  }

  Future guardarBorrador() async {
    print(form.value);
    final respuestas =
        bloques.controls.expand<RespuestaConOpcionesDeRespuesta>((e) {
      if (e is TituloFormGroup) return [];
      if (e is RespuestaSeleccionSimpleFormGroup) return [e.toDB()];
      if (e is RespuestaCuadriculaFormArray) return e.toDB();
      throw Exception("Tipo de control no reconocido");
    }).toList();

    await _db.guardarInspeccion(respuestas, _cuestionarioId, _vehiculo, true);
    print("guardada");
  }

  void finalizar() {
    //TODO: implementar
    print(form.value);
    throw NotImplementedException();
  }
}
