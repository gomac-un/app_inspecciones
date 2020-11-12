import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:inspecciones/domain/core/entity.dart';
import 'package:inspecciones/domain/core/failures.dart';
import 'package:inspecciones/domain/core/value_objects.dart';
import 'package:inspecciones/domain/cuestionario/value_objects.dart';

part 'pregunta.freezed.dart';

@freezed
abstract class Pregunta with _$Pregunta implements IEntity {
  const factory Pregunta({
    @required UniqueId id,
    @required TextoPregunta texto,
    @required bool done,
  }) = _Pregunta;

  factory Pregunta.empty() => Pregunta(
        id: UniqueId(),
        texto: TextoPregunta(''),
        done: false,
      );
}

extension PreguntaX on Pregunta {
  Option<ValueFailure<dynamic>> get failureOption {
    return texto.failureOrUnit.fold((f) => some(f), (_) => none());
  }
}
