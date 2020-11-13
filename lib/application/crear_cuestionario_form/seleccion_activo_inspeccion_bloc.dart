import 'dart:convert';
import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:inspecciones/application/crear_cuestionario_form/respuesta_field_bloc.dart';
import 'package:inspecciones/domain/core/enums.dart';
import 'package:inspecciones/domain/core/i_inspecciones_repository.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:inspecciones/domain/clasesbasicas/idYnombre.dart';
import 'package:inspecciones/infrastructure/moor_database_llenado.dart';
import 'package:moor/moor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import 'bloque_field_bloc.dart';
import 'crear_cuestionario_app.dart';

@injectable
class SeleccionActivoInspeccionBloc extends FormBloc<String, String> {
  //final IInspeccionesRepository _inspeccionesRepository;
  final Database _db;

  //blocs
  final vehiculo = TextFieldBloc(name: 'vehiculo');

  final tiposDeInspeccion =
      SelectFieldBloc<CuestionarioDeModelo, List<BloqueConPreguntaRespondida>>(
    name: 'tipoDeInspeccion',
    //validators: [FieldBlocValidators.required],
  );

  SeleccionActivoInspeccionBloc(this._db) {
    addFieldBlocs(fieldBlocs: [
      vehiculo,
      tiposDeInspeccion,
    ]);
    /*
    distinct(
      (previous, current) =>
          previous.toJson().toString() == current.toString().toString(),
    ).listen((state) {
      // TODO: Autoguardado automático.
      //print(state.toJson());
    });*/

    vehiculo.onValueChanges(
      onData: (previous, current) async* {
        final inspecciones = await _db.cuestionariosParaVehiculo(current.value);
        tiposDeInspeccion..updateItems(inspecciones);
      },
    );
  }

  @override
  void onSubmitting() async {
    try {
      emitSuccess(
        canSubmitAgain: true,
        /*successResponse: JsonEncoder.withIndent('    ').convert(
            state.toJson(),
          )*/
      );
    } catch (e) {
      emitFailure(failureResponse: e.toString());
    }
  }
}
