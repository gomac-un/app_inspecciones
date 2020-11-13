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
class LlenarCuestionarioFormBloc extends FormBloc<String, String> {
  /*public static <T> void setTopItem(List<T> t, int position){
    t.add(0, t.remove(position));
};*/

  //final IInspeccionesRepository _inspeccionesRepository;
  final Database _db;
  final Borrador borrador;

  //helpful list for render
  final Map<int, RespuestaFieldBloc> blocsRespuestas = {};

  //blocs

  final vehiculo = TextFieldBloc(name: 'vehiculo');

  final tiposDeInspeccion =
      SelectFieldBloc<CuestionarioDeModelo, List<BloqueConPreguntaRespondida>>(
    name: 'tipoDeInspeccion',
    //validators: [FieldBlocValidators.required],
  );

  final respuestas = ListFieldBloc<RespuestaFieldBloc>(name: 'respuestas');

  LlenarCuestionarioFormBloc(this._db, [this.borrador]) {
    addFieldBlocs(fieldBlocs: [
      vehiculo,
      tiposDeInspeccion,
      respuestas,
    ]);
    /*
    distinct(
      (previous, current) =>
          previous.toJson().toString() == current.toString().toString(),
    ).listen((state) {
      // TODO: Autoguardado automático.
      //print(state.toJson());
    });*/

    //machete para cargar un borrador
    Future.delayed(const Duration(microseconds: 0), () {
      vehiculo.updateValue(borrador?.activo?.identificador);
      tiposDeInspeccion.updateValue(borrador?.cuestionarioDeModelo);
    });

    vehiculo.onValueChanges(
      onData: (previous, current) async* {
        final inspecciones = await _db.cuestionariosParaVehiculo(current.value);

        tiposDeInspeccion..updateItems(inspecciones);
      },
    );

    tiposDeInspeccion.onValueChanges(
      onData: (previous, current) async* {
        //limpieza
        blocsRespuestas.clear();
        respuestas.removeFieldBlocsWhere((_) => true);

        final bloques = await _db.cargarInspeccion(
          current.value,
          vehiculo.value,
        );

        //hack para iterar en la ui
        tiposDeInspeccion.updateExtraData(bloques);

        bloques?.asMap()?.forEach((i, bloque) {
          if (bloque.pregunta != null) {
            blocsRespuestas[i] = RespuestaFieldBloc(bloque);
            respuestas.addFieldBloc(blocsRespuestas[i]);
          }
        });
      },
    );

    /*
    vehiculo.updateValue(borrador.activo.identificador);
    tiposDeInspeccion.updateValue(borrador.cuestionarioDeModelo);*/
  }

  @override
  void onSubmitting() async {
    try {
      state;
      await guardarBorrador();
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

  Future guardarBorrador() async {
    final appDir = await getApplicationDocumentsDirectory();
    final subDir = "inspecciones";
    final idform =
        blocsRespuestas.entries.first.value.bloque.bloque.cuestionarioId;

    //actualizar las fotos
    await Future.forEach(blocsRespuestas.values, (e) async {
      final bloc = e as RespuestaFieldBloc;
      final fotosBases =
          procesarFotos(bloc.fotosBase, appDir.path, subDir, idform.toString());
      final fotosBaseProcesadas = await Future.wait(fotosBases);
      final fotosReparacion = procesarFotos(
          bloc.fotosReparacion, appDir.path, subDir, idform.toString());
      final fotosReparacionProcesadas = await Future.wait(fotosReparacion);
      bloc.bloque.respuesta = bloc.bloque.respuesta.copyWith(
        fotosBase: Value(
          fotosBaseProcesadas.toList(),
        ),
        fotosReparacion: Value(
          fotosReparacionProcesadas.toList(),
        ),
      );
    });
    await _db.guardarInspeccion(
        blocsRespuestas.entries.map((e) => e.value.bloque.respuesta).toList(),
        tiposDeInspeccion.value.cuestionarioId,
        vehiculo.value);
  }

  Iterable<Future<String>> procesarFotos(
      ListFieldBloc<InputFieldBloc<File, Object>> blocImagenes,
      String appDir,
      String subDir,
      String idform) {
    return blocImagenes.state.fieldBlocs.map((imagebloc) async {
      var image = imagebloc.state.value;
      if (path.isWithin(appDir, image.path)) {
        // la imagen ya esta en la carpeta de datos
        return imagebloc.state.value.path;
      } else {
        //mover la foto a la carpeta de datos
        final fileName = path.basename(image.path);
        final newPath =
            path.join(appDir, 'fotos', subDir, idform.toString(), fileName);
        await File(newPath).create(recursive: true);
        final savedImage = await image.copy(newPath);
        return savedImage.path;
      }
    });
  }

  void finalizarInspeccion() {
    print("TODO: implementar");
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
