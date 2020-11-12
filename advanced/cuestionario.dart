import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';

import 'package:inspecciones/domain/core/entity.dart';
import 'package:inspecciones/domain/core/failures.dart';
import 'package:inspecciones/domain/core/value_objects.dart';
import 'package:inspecciones/domain/cuestionario/pregunta.dart';
import 'package:inspecciones/domain/cuestionario/value_objects.dart';

part 'cuestionario.freezed.dart';

@freezed
abstract class Cuestionario with _$Cuestionario implements IEntity {
  const factory Cuestionario({
    @required UniqueId id,
    @required NoteBody body,
    @required ListaDePreguntas preguntas,
  }) = _Cuestionario;

  factory Cuestionario.empty() => Cuestionario(
        id: UniqueId(),
        body: NoteBody(''),
        preguntas: ListaDePreguntas(emptyList()),
      );
}

extension CuestionarioX on Cuestionario {
  Option<ValueFailure<dynamic>> get failureOption {
    return body.failureOrUnit
        .andThen(preguntas.failureOrUnit)
        .andThen(
          preguntas
              .getOrCrash()
              .map((todoItem) => todoItem.failureOption)
              .filter((o) => o.isSome())
              .getOrElse(0, (_) => none())
              .fold(() => right(unit), (f) => left(f)),
        )
        .fold((f) => some(f), (_) => none());
  }
}
