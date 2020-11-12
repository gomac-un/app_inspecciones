// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'cuestionario.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

class _$CuestionarioTearOff {
  const _$CuestionarioTearOff();

// ignore: unused_element
  _Cuestionario call(
      {@required UniqueId id,
      @required NoteBody body,
      @required ListaDePreguntas preguntas}) {
    return _Cuestionario(
      id: id,
      body: body,
      preguntas: preguntas,
    );
  }
}

// ignore: unused_element
const $Cuestionario = _$CuestionarioTearOff();

mixin _$Cuestionario {
  UniqueId get id;
  NoteBody get body;
  ListaDePreguntas get preguntas;

  $CuestionarioCopyWith<Cuestionario> get copyWith;
}

abstract class $CuestionarioCopyWith<$Res> {
  factory $CuestionarioCopyWith(
          Cuestionario value, $Res Function(Cuestionario) then) =
      _$CuestionarioCopyWithImpl<$Res>;
  $Res call({UniqueId id, NoteBody body, ListaDePreguntas preguntas});
}

class _$CuestionarioCopyWithImpl<$Res> implements $CuestionarioCopyWith<$Res> {
  _$CuestionarioCopyWithImpl(this._value, this._then);

  final Cuestionario _value;
  // ignore: unused_field
  final $Res Function(Cuestionario) _then;

  @override
  $Res call({
    Object id = freezed,
    Object body = freezed,
    Object preguntas = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed ? _value.id : id as UniqueId,
      body: body == freezed ? _value.body : body as NoteBody,
      preguntas: preguntas == freezed
          ? _value.preguntas
          : preguntas as ListaDePreguntas,
    ));
  }
}

abstract class _$CuestionarioCopyWith<$Res>
    implements $CuestionarioCopyWith<$Res> {
  factory _$CuestionarioCopyWith(
          _Cuestionario value, $Res Function(_Cuestionario) then) =
      __$CuestionarioCopyWithImpl<$Res>;
  @override
  $Res call({UniqueId id, NoteBody body, ListaDePreguntas preguntas});
}

class __$CuestionarioCopyWithImpl<$Res> extends _$CuestionarioCopyWithImpl<$Res>
    implements _$CuestionarioCopyWith<$Res> {
  __$CuestionarioCopyWithImpl(
      _Cuestionario _value, $Res Function(_Cuestionario) _then)
      : super(_value, (v) => _then(v as _Cuestionario));

  @override
  _Cuestionario get _value => super._value as _Cuestionario;

  @override
  $Res call({
    Object id = freezed,
    Object body = freezed,
    Object preguntas = freezed,
  }) {
    return _then(_Cuestionario(
      id: id == freezed ? _value.id : id as UniqueId,
      body: body == freezed ? _value.body : body as NoteBody,
      preguntas: preguntas == freezed
          ? _value.preguntas
          : preguntas as ListaDePreguntas,
    ));
  }
}

class _$_Cuestionario with DiagnosticableTreeMixin implements _Cuestionario {
  const _$_Cuestionario(
      {@required this.id, @required this.body, @required this.preguntas})
      : assert(id != null),
        assert(body != null),
        assert(preguntas != null);

  @override
  final UniqueId id;
  @override
  final NoteBody body;
  @override
  final ListaDePreguntas preguntas;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Cuestionario(id: $id, body: $body, preguntas: $preguntas)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Cuestionario'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('body', body))
      ..add(DiagnosticsProperty('preguntas', preguntas));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Cuestionario &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.body, body) ||
                const DeepCollectionEquality().equals(other.body, body)) &&
            (identical(other.preguntas, preguntas) ||
                const DeepCollectionEquality()
                    .equals(other.preguntas, preguntas)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(body) ^
      const DeepCollectionEquality().hash(preguntas);

  @override
  _$CuestionarioCopyWith<_Cuestionario> get copyWith =>
      __$CuestionarioCopyWithImpl<_Cuestionario>(this, _$identity);
}

abstract class _Cuestionario implements Cuestionario {
  const factory _Cuestionario(
      {@required UniqueId id,
      @required NoteBody body,
      @required ListaDePreguntas preguntas}) = _$_Cuestionario;

  @override
  UniqueId get id;
  @override
  NoteBody get body;
  @override
  ListaDePreguntas get preguntas;
  @override
  _$CuestionarioCopyWith<_Cuestionario> get copyWith;
}
