import 'dart:io';

import 'package:inspecciones/domain/core/enums.dart';
import 'package:inspecciones/infrastructure/moor_database_llenado.dart';
import 'package:meta/meta.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:moor/moor.dart';

import 'bloque_field_bloc.dart';

class RespuestaFieldBloc extends ListFieldBloc {
  BloqueConPreguntaRespondida bloque;

  final SingleFieldBloc respuestas;
  final TextFieldBloc observacion;
  final BooleanFieldBloc novedad;
  final BooleanFieldBloc reparado;
  final TextFieldBloc observacionReparacion;
  final ListFieldBloc<InputFieldBloc<File, Object>> fotosBase;
  final ListFieldBloc<InputFieldBloc<File, Object>> fotosReparacion;

  RespuestaFieldBloc._({
    @required this.bloque,
    @required this.respuestas,
    @required this.novedad,
    @required this.reparado,
    @required this.observacion,
    @required this.observacionReparacion,
    @required this.fotosBase,
    @required this.fotosReparacion,
    String name,
  }) : super(name: name) {
    addFieldBloc(respuestas);
    addFieldBloc(observacion);
    addFieldBloc(reparado);
    addFieldBloc(observacionReparacion);
    addFieldBloc(fotosBase);
    addFieldBloc(fotosReparacion);

    /*reparado.onValueChanges(
      onData: (previous, current) async* {
        if (current.isInitial) return;
        if (current.value) {
          addFieldBloc(observacionReparacion);
        } else {
          removeFieldBlocAt(state.fieldBlocs.length - 1);
        }
      },
    );*/
  }

  factory RespuestaFieldBloc(BloqueConPreguntaRespondida bloque) {
    SingleFieldBloc resbloc;
    //inicializacion del bloc de respuestas segun el tipo de pregunta
    switch (bloque.pregunta.tipo) {
      case TipoDePregunta.unicaRespuesta:
        {
          resbloc =
              SelectFieldBloc<OpcionDeRespuesta, BloqueConPreguntaRespondida>(
            name: 'respuesta',
            items: bloque.pregunta.opcionesDeRespuesta,
            //para poner el valor inicial de la lista, se busca el objeto que tenga el mismo texto en la respuesta, si no hay respuesta devuelve null
            initialValue: bloque.pregunta.opcionesDeRespuesta.firstWhere(
                (e) =>
                    e.texto == bloque.respuesta.respuestas.value?.first?.texto,
                orElse: () => null),
          );
        }
        break;
      case TipoDePregunta.multipleRespuesta:
        {
          resbloc = MultiSelectFieldBloc<OpcionDeRespuesta,
              BloqueConPreguntaRespondida>(
            name: 'respuesta',
            items: bloque.pregunta.opcionesDeRespuesta,
            //para poner el valor inicial de la lista, se buscan los objetos que esten en las respuestas
            initialValue: bloque.pregunta.opcionesDeRespuesta
                .where((opc) =>
                    (bloque.respuesta.respuestas.value?.any((res) =>
                        opc.texto ==
                        res.texto)) ?? // si no hay respuesta, devuelve false
                    false)
                .toList(),
          );
        }
        break;
      //TODO: Otros casos
      default:
        {}
        break;
    }
    //cuando al bloc se le notifica un cambio de valor, este actualiza el valor de la respuesta en el objeto original, por lo tanto el objeto original (bloque) solo puede setear el valor al principio
    return RespuestaFieldBloc._(
      bloque: bloque,
      respuestas: resbloc
        ..updateExtraData(bloque) //quitar?
        ..onValueChanges(
          onData: (previous, current) async* {
            bloque.respuesta = bloque.respuesta.copyWith(
                respuestas: Value([
              if (current.value is List) ...current.value,
              if (!(current.value is List)) current.value
            ]));
          },
        ),
      reparado: BooleanFieldBloc(
          name: 'reparado', initialValue: bloque.respuesta.reparado.value)
        ..onValueChanges(
          onData: (previous, current) async* {
            bloque.respuesta =
                bloque.respuesta.copyWith(reparado: Value(current.value));
          },
        ),
      novedad: BooleanFieldBloc(
          name: 'novedad', initialValue: bloque.respuesta.novedad.value)
        ..onValueChanges(
          onData: (previous, current) async* {
            bloque.respuesta =
                bloque.respuesta.copyWith(novedad: Value(current.value));
          },
        ),
      observacion: TextFieldBloc(
          name: 'observacion', initialValue: bloque.respuesta.observacion.value)
        ..onValueChanges(
          onData: (previous, current) async* {
            bloque.respuesta =
                bloque.respuesta.copyWith(observacion: Value(current.value));
          },
        ),
      observacionReparacion: TextFieldBloc(
          name: 'observacionReparacion',
          initialValue: bloque.respuesta.observacionReparacion.value)
        ..onValueChanges(
          onData: (previous, current) async* {
            bloque.respuesta = bloque.respuesta
                .copyWith(observacionReparacion: Value(current.value));
          },
        ),
      fotosBase: ListFieldBloc(
        name: 'fotosBase',
        fieldBlocs: bloque.respuesta.fotosBase.value
            ?.map(
              (e) => InputFieldBloc(
                name: "foto",
                initialValue: File(e),
                toJson: (file) => file.path,
              ),
            )
            ?.toList(),
      ),
      fotosReparacion: ListFieldBloc(
        name: 'fotosReparacion',
        fieldBlocs: bloque.respuesta.fotosReparacion.value
            ?.map(
              (e) => InputFieldBloc(
                name: "foto",
                initialValue: File(e),
                toJson: (file) => file.path,
              ),
            )
            ?.toList(),
      ),
    );
  }
}
