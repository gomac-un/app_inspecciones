import 'dart:io';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:inspecciones/domain/core/enums.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';

import 'package:meta/meta.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import 'bloque_field_bloc.dart';

class PreguntaFieldBloc extends BloqueFieldBloc {
  final Database _db;

  final ListFieldBloc<InputFieldBloc<File, Object>> imagenes;

  final SelectFieldBloc<int, dynamic> criticidad;
  final SelectFieldBloc<Sistema, dynamic> sistema;
  final SelectFieldBloc<SubSistema, dynamic> subsistema;
  final SelectFieldBloc<String, dynamic> posicion;
  final SelectFieldBloc<TipoDePregunta, dynamic> tiposDePregunta;

  final TextFieldBloc valorMedio;
  final TextFieldBloc limiteInferior;
  final TextFieldBloc limiteSuperior;

  /*final sistema = SelectFieldBloc(
      name: 'sistema', items: ['carroceria', 'direccion', 'motor']);*/

  /*final tiposDePregunta = SelectFieldBloc<String, dynamic>(
    name: 'tipoDePregunta',
    validators: [FieldBlocValidators.required],
    items: [
      'unicaRespuesta',
      'multipleRespuesta',
      'binaria',
      'fecha',
      'rangoNumerico',
    ],
  );*/
  final ListFieldBloc<OpcionDeRespuestaFieldBloc> respuestas;

  PreguntaFieldBloc._(
    this._db, {
    this.imagenes,
    TextFieldBloc titulo,
    TextFieldBloc descripcion,
    @required this.criticidad,
    @required this.respuestas,
    this.sistema,
    this.subsistema,
    this.posicion,
    this.tiposDePregunta,
    @required this.valorMedio,
    this.limiteInferior,
    this.limiteSuperior,
    String name,
  }) : super(titulo: titulo, descripcion: descripcion, name: name, fieldBlocs: [
          imagenes,
          criticidad,
          respuestas,
          sistema,
          subsistema,
          posicion,
          tiposDePregunta,
          valorMedio,
          limiteInferior,
          limiteSuperior,
        ]) {
    sistema.onValueChanges(
      onData: (previous, current) async* {
        final subsistemas = await _db.getSubSistemas(sistema.value);
        subsistema..updateItems(subsistemas);
      },
    );
    //TODO: make this work
    tiposDePregunta.onValueChanges(
      onData: (previous, current) async* {
        state.formBloc.removeFieldBlocs(
          fieldBlocs: [
            valorMedio,
          ],
        );

        if (current.value == TipoDePregunta.rangoNumerico) {
          state.formBloc.addFieldBlocs(fieldBlocs: [
            valorMedio,
          ]);
        }
      },
    );
  }
  factory PreguntaFieldBloc(Database db, List<Sistema> sistemas) {
    return PreguntaFieldBloc._(
      db,
      imagenes: ListFieldBloc(name: 'imagenes'),
      name: 'pregunta',
      titulo: TextFieldBloc(name: 'titulo'),
      descripcion: TextFieldBloc(name: 'descripcion'),
      criticidad: CriticidadFieldBloc(),
      respuestas: ListFieldBloc(name: 'respuestas'),
      sistema:
          SelectFieldBloc<Sistema, dynamic>(name: 'sistema', items: sistemas),
      subsistema: SelectFieldBloc<SubSistema, dynamic>(name: 'subsistema'),
      posicion: SelectFieldBloc(
          name: 'posicion',
          items: ['no aplica', 'frente', 'abajo', 'atras'],
          initialValue: 'no aplica'),
      tiposDePregunta: SelectFieldBloc<TipoDePregunta, dynamic>(
        name: 'tipoDePregunta',
        validators: [FieldBlocValidators.required],
        items: TipoDePregunta.values,
        toJson: (e) => EnumToString.convertToString(e),
      ),
      valorMedio: TextFieldBloc(name: 'valorMedio'),
      limiteInferior: TextFieldBloc(name: 'limiteInferior'),
      limiteSuperior: TextFieldBloc(name: 'limiteSuperior'),
    );
  }
}

class OpcionDeRespuestaFieldBloc extends GroupFieldBloc {
  final TextFieldBloc texto;
  final SelectFieldBloc<int, dynamic> criticidad;

  OpcionDeRespuestaFieldBloc({
    @required this.texto,
    @required this.criticidad,
    String name,
  }) : super([
          texto,
          criticidad,
        ], name: name);
}

class CriticidadFieldBloc extends SelectFieldBloc<int, dynamic> {
  CriticidadFieldBloc() : super(name: "criticidad", items: [0, 1, 2, 3, 4]);
}
