import 'dart:io';

import 'package:inspecciones/domain/core/i_inspecciones_repository.dart';
import 'package:inspecciones/domain/clasesbasicas/idYnombre.dart';
import 'package:inspecciones/domain/cuestionario/pregunta.dart';
import 'package:inspecciones/domain/cuestionario/respuesta.dart';
import 'package:meta/meta.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import 'pregunta_field_bloc.dart';
import 'bloque_field_bloc.dart';

class RespuestaPreguntaFieldBloc extends GroupFieldBloc {
  Pregunta pregunta;

  final SelectFieldBloc<Respuesta, Pregunta> respuestas;
  final BooleanFieldBloc reparado;
  final TextFieldBloc observacion;
  final TextFieldBloc observacionReparacion;

  RespuestaPreguntaFieldBloc._({
    @required this.pregunta,
    @required this.respuestas,
    @required this.reparado,
    @required this.observacion,
    @required this.observacionReparacion,
    String name,
  }) : super([respuestas, reparado, observacion, observacionReparacion],
            name: name);

  factory RespuestaPreguntaFieldBloc(Pregunta pregunta) {
    return RespuestaPreguntaFieldBloc._(
      pregunta: pregunta,
      respuestas: SelectFieldBloc(
          name: 'respuesta', items: pregunta.opcionesDeRespuesta)
        ..updateExtraData(pregunta),
      reparado: BooleanFieldBloc(name: 'reparado'),
      observacion: TextFieldBloc(name: 'observacion'),
      observacionReparacion: TextFieldBloc(name: 'observacionReparacion'),
    );
  }
}
