import 'dart:convert';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import 'package:inspecciones/application/crear_cuestionario_form/pregunta_field_bloc.dart';
import 'package:inspecciones/infrastructure/moor_database_llenado.dart';

import 'bloque_field_bloc.dart';

class CrearCuestionarioFormBloc extends FormBloc<String, String> {
  //TODO: reordenado de las preguntas
  /*public static <T> void setTopItem(List<T> t, int position){
    t.add(0, t.remove(position));
};*/

  final Database _db;

  List<Sistema> sistemas;

  final nuevoTipoDeinspeccion = TextFieldBloc(name: 'nuevoTipoDeInspeccion');

  final tiposDeInspeccion = SelectFieldBloc<String, dynamic>(
    name: 'tipoDeInspeccion',
    //validators: [FieldBlocValidators.required],
  );

  final clasesDeModelos = MultiSelectFieldBloc<String, dynamic>(
    name: 'modelos',
  );

  final SelectFieldBloc<Contratista, dynamic> contratista =
      SelectFieldBloc<Contratista, dynamic>(
    name: 'contratista',
    //validators: [FieldBlocValidators.required],
  );

  final periodicidad = TextFieldBloc(
    name: 'periodicidad',
    /*validators: [
      (String n) =>
          double.parse(n, (e) => null) != null ? null : "debe ser numerico"
    ],*/
  );

  final bloques = ListFieldBloc<BloqueFieldBloc>(name: 'bloques');

  CrearCuestionarioFormBloc(this._db) : super(isLoading: true) {
    /*
    distinct(
      (previous, current) =>
          previous.toJson().toString() == current.toString().toString(),
    ).listen((state) {
      // TODO: Autoguardado automático.
      //print(state.toJson());
    });*/

    tiposDeInspeccion.onValueChanges(
      onData: (previous, current) async* {
        removeFieldBlocs(
          fieldBlocs: [
            nuevoTipoDeinspeccion,
          ],
        );

        if (current.value == 'otra') {
          addFieldBlocs(fieldBlocs: [
            nuevoTipoDeinspeccion,
          ]);
        }
      },
    );

    clasesDeModelos.addAsyncValidators(
      [_cuestionariosExistentes],
    );
  }

  Future<String> _cuestionariosExistentes(List<String> modelos) async {
    final cuestionariosExistentes =
        await _db.getCuestionarios(tiposDeInspeccion.value, modelos);
    if (cuestionariosExistentes.length > 0) {
      return "Ya hay un cuestionario para esta inspeccion y \n el modelo " +
          cuestionariosExistentes.first.modelo;
    }
    return null;
  }

  @override
  void onLoading() async {
    final res = await Future.wait([
      _db.getTiposDeInspecciones(),
      _db.getModelos(),
      _db.getContratistas(),
      _db.getSistemas(),
    ]);
    // datos para el formulario

    List<String> inspecciones = res[0] as List<String>;
    List<String> modelos = res[1] as List<String>;
    List<Contratista> contratistas = res[2] as List<Contratista>;

    // datos para las preguntas
    this.sistemas = res[3] as List<Sistema>;

    tiposDeInspeccion..updateItems(inspecciones..add("otra"));
    clasesDeModelos..updateItems(modelos);
    contratista..updateItems(contratistas);

    addFieldBlocs(fieldBlocs: [
      tiposDeInspeccion,
      clasesDeModelos,
      contratista,
      periodicidad,
      bloques
    ]);
    emitLoaded();
  }

  void addTitulo() {
    bloques.addFieldBloc(BloqueFieldBloc(
      name: 'titulo',
      titulo: TextFieldBloc(name: 'titulo'),
      descripcion: TextFieldBloc(name: 'descripcion'),
    ));
  }

  void addPregunta() {
    bloques.addFieldBloc(PreguntaFieldBloc(
      _db,
      sistemas,
    ));
  }

  //TODO: implement
  void moverPreguntaDeA(int indexDe, int indexA) {
    bloques.removeFieldBlocAt(indexDe);
  }

  void removeBloque(int index) {
    bloques.removeFieldBlocAt(index);
  }

  void addRespuestaToPregunta(int preguntaIndex) {
    (bloques.value[preguntaIndex] as PreguntaFieldBloc)
        .respuestas
        .addFieldBloc(OpcionDeRespuestaFieldBloc(
          name: "respuesta",
          texto: TextFieldBloc(name: "texto"),
          criticidad: CriticidadFieldBloc(),
        ));
  }

  /*void removeRespuestaFromPregunta(
      {@required int preguntaIndex, @required int respuestaIndex}) {
    preguntas.value[preguntaIndex].respuestas.removeFieldBlocAt(respuestaIndex);
  }*/

  @override
  void onSubmitting() async {
    try {
      await _db.crearCuestionario(state.toJson());

      /*print(JsonEncoder.withIndent('    ').convert(
        state.toJson(),
      ));*/
      emitSuccess(
          canSubmitAgain: false,
          successResponse: JsonEncoder.withIndent('    ').convert(
            state.toJson(),
          ) /*+
            "state.tostring(): \n" +
            state.toString(),*/
          );
    } catch (e) {
      emitFailure();
      print(e);
    }
  }

  @override
  Future<void> close() {
    nuevoTipoDeinspeccion.close();
    return super.close();
  }
}
