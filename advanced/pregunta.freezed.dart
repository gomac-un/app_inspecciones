// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'pregunta.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

class _$PreguntaTearOff {
  const _$PreguntaTearOff();

// ignore: unused_element
  _Pregunta call(
      {@required UniqueId id,
      @required TextoPregunta texto,
      @required bool done}) {
    return _Pregunta(
      id: id,
      texto: texto,
      done: done,
    );
  }
}

// ignore: unused_element
const $Pregunta = _$PreguntaTearOff();

mixin _$Pregunta {
  UniqueId get id;
  TextoPregunta get texto;
  bool get done;

  $PreguntaCopyWith<Pregunta> get copyWith;
}

abstract class $PreguntaCopyWith<$Res> {
  factory $PreguntaCopyWith(Pregunta value, $Res Function(Pregunta) then) =
      _$PreguntaCopyWithImpl<$Res>;
  $Res call({UniqueId id, TextoPregunta texto, bool done});
}

class _$PreguntaCopyWithImpl<$Res> implements $PreguntaCopyWith<$Res> {
  _$PreguntaCopyWithImpl(this._value, this._then);

  final Pregunta _value;
  // ignore: unused_field
  final $Res Function(Pregunta) _then;

  @override
  $Res call({
    Object id = freezed,
    Object texto = freezed,
    Object done = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed ? _value.id : id as UniqueId,
      texto: texto == freezed ? _value.texto : texto as TextoPregunta,
      done: done == freezed ? _value.done : done as bool,
    ));
  }
}

abstract class _$PreguntaCopyWith<$Res> implements $PreguntaCopyWith<$Res> {
  factory _$PreguntaCopyWith(_Pregunta value, $Res Function(_Pregunta) then) =
      __$PreguntaCopyWithImpl<$Res>;
  @override
  $Res call({UniqueId id, TextoPregunta texto, bool done});
}

class __$PreguntaCopyWithImpl<$Res> extends _$PreguntaCopyWithImpl<$Res>
    implements _$PreguntaCopyWith<$Res> {
  __$PreguntaCopyWithImpl(_Pregunta _value, $Res Function(_Pregunta) _then)
      : super(_value, (v) => _then(v as _Pregunta));

  @override
  _Pregunta get _value => super._value as _Pregunta;

  @override
  $Res call({
    Object id = freezed,
    Object texto = freezed,
    Object done = freezed,
  }) {
    return _then(_Pregunta(
      id: id == freezed ? _value.id : id as UniqueId,
      texto: texto == freezed ? _value.texto : texto as TextoPregunta,
      done: done == freezed ? _value.done : done as bool,
    ));
  }
}

class _$_Pregunta with DiagnosticableTreeMixin implements _Pregunta {
  const _$_Pregunta(
      {@required this.id, @required this.texto, @required this.done})
      : assert(id != null),
        assert(texto != null),
        assert(done != null);

  @override
  final UniqueId id;
  @override
  final TextoPregunta texto;
  @override
  final bool done;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Pregunta(id: $id, texto: $texto, done: $done)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Pregunta'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('texto', texto))
      ..add(DiagnosticsProperty('done', done));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Pregunta &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.texto, texto) ||
                const DeepCollectionEquality().equals(other.texto, texto)) &&
            (identical(other.done, done) ||
                const DeepCollectionEquality().equals(other.done, done)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(texto) ^
      const DeepCollectionEquality().hash(done);

  @override
  _$PreguntaCopyWith<_Pregunta> get copyWith =>
      __$PreguntaCopyWithImpl<_Pregunta>(this, _$identity);
}

abstract class _Pregunta implements Pregunta {
  const factory _Pregunta(
      {@required UniqueId id,
      @required TextoPregunta texto,
      @required bool done}) = _$_Pregunta;

  @override
  UniqueId get id;
  @override
  TextoPregunta get texto;
  @override
  bool get done;
  @override
  _$PreguntaCopyWith<_Pregunta> get copyWith;
}
