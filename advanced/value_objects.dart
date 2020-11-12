import 'dart:ui';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartz/dartz.dart';
import 'package:kt_dart/collection.dart';

import 'package:inspecciones/domain/cuestionario/pregunta.dart';
import 'package:inspecciones/domain/core/failures.dart';
import 'package:inspecciones/domain/core/value_objects.dart';
import 'package:inspecciones/domain/core/value_transformers.dart';
import 'package:inspecciones/domain/core/value_validators.dart';

class NoteBody extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  static const maxLength = 1000;

  factory NoteBody(String input) {
    assert(input != null);
    return NoteBody._(
      validateMaxStringLength(input, maxLength).flatMap(validateStringNotEmpty),
    );
  }

  const NoteBody._(this.value);
}

class NoteColor extends ValueObject<Color> {
  static const List<Color> predefinedColors = [
    Color(0xfffafafa), // canvas
    Color(0xfffa8072), // salmon
    Color(0xfffedc56), // mustard
    Color(0xffd0f0c0), // tea
    Color(0xfffca3b7), // flamingo
    Color(0xff997950), // tortilla
    Color(0xfffffdd0), // cream
  ];

  @override
  final Either<ValueFailure<Color>, Color> value;

  factory NoteColor(Color input) {
    assert(input != null);
    return NoteColor._(
      right(makeColorOpaque(input)),
    );
  }

  const NoteColor._(this.value);
}

class List3<T> extends ValueObject<KtList<T>> {
  @override
  final Either<ValueFailure<KtList<T>>, KtList<T>> value;

  static const maxLength = 3;

  factory List3(KtList<T> input) {
    assert(input != null);
    return List3._(
      validateMaxListLength(input, maxLength),
    );
  }

  const List3._(this.value);

  int get length {
    return value.getOrElse(() => emptyList()).size;
  }

  bool get isFull {
    return length == maxLength;
  }
}

class TextoPregunta extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  static const maxLength = 100;

  factory TextoPregunta(String input) {
    assert(input != null);
    return TextoPregunta._(
      validateMaxStringLength(input, maxLength).flatMap(validateStringNotEmpty),
    );
  }

  const TextoPregunta._(this.value);
}

class ListaDePreguntas extends ValueObject<KtList<Pregunta>> {
  @override
  final Either<ValueFailure<KtList<Pregunta>>, KtList<Pregunta>> value;

  factory ListaDePreguntas(KtList<Pregunta> input) {
    assert(input != null);
    return ListaDePreguntas._(Right(input));
  }

  const ListaDePreguntas._(this.value);

  int get length {
    return value.getOrElse(() => emptyList()).size;
  }
}
