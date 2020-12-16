import 'package:inspecciones/infrastructure/moor_database.dart';

import 'package:injectable/injectable.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

@injectable
class SeleccionActivoInspeccionBloc extends FormBloc<String, String> {
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
    ]);

    vehiculo.onValueChanges(
      onData: (previous, current) async* {
        if (current.value != "") {
          addFieldBloc(fieldBloc: tiposDeInspeccion);
        }
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
