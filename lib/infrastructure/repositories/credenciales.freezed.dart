// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'credenciales.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Credenciales _$CredencialesFromJson(Map<String, dynamic> json) {
  return _Credenciales.fromJson(json);
}

/// @nodoc
class _$CredencialesTearOff {
  const _$CredencialesTearOff();

  _Credenciales call({required String username, required String password}) {
    return _Credenciales(
      username: username,
      password: password,
    );
  }

  Credenciales fromJson(Map<String, Object> json) {
    return Credenciales.fromJson(json);
  }
}

/// @nodoc
const $Credenciales = _$CredencialesTearOff();

/// @nodoc
mixin _$Credenciales {
  String get username => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CredencialesCopyWith<Credenciales> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CredencialesCopyWith<$Res> {
  factory $CredencialesCopyWith(
          Credenciales value, $Res Function(Credenciales) then) =
      _$CredencialesCopyWithImpl<$Res>;
  $Res call({String username, String password});
}

/// @nodoc
class _$CredencialesCopyWithImpl<$Res> implements $CredencialesCopyWith<$Res> {
  _$CredencialesCopyWithImpl(this._value, this._then);

  final Credenciales _value;
  // ignore: unused_field
  final $Res Function(Credenciales) _then;

  @override
  $Res call({
    Object? username = freezed,
    Object? password = freezed,
  }) {
    return _then(_value.copyWith(
      username: username == freezed
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      password: password == freezed
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$CredencialesCopyWith<$Res>
    implements $CredencialesCopyWith<$Res> {
  factory _$CredencialesCopyWith(
          _Credenciales value, $Res Function(_Credenciales) then) =
      __$CredencialesCopyWithImpl<$Res>;
  @override
  $Res call({String username, String password});
}

/// @nodoc
class __$CredencialesCopyWithImpl<$Res> extends _$CredencialesCopyWithImpl<$Res>
    implements _$CredencialesCopyWith<$Res> {
  __$CredencialesCopyWithImpl(
      _Credenciales _value, $Res Function(_Credenciales) _then)
      : super(_value, (v) => _then(v as _Credenciales));

  @override
  _Credenciales get _value => super._value as _Credenciales;

  @override
  $Res call({
    Object? username = freezed,
    Object? password = freezed,
  }) {
    return _then(_Credenciales(
      username: username == freezed
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      password: password == freezed
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Credenciales extends _Credenciales {
  _$_Credenciales({required this.username, required this.password}) : super._();

  factory _$_Credenciales.fromJson(Map<String, dynamic> json) =>
      _$$_CredencialesFromJson(json);

  @override
  final String username;
  @override
  final String password;

  @override
  String toString() {
    return 'Credenciales(username: $username, password: $password)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Credenciales &&
            (identical(other.username, username) ||
                const DeepCollectionEquality()
                    .equals(other.username, username)) &&
            (identical(other.password, password) ||
                const DeepCollectionEquality()
                    .equals(other.password, password)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(username) ^
      const DeepCollectionEquality().hash(password);

  @JsonKey(ignore: true)
  @override
  _$CredencialesCopyWith<_Credenciales> get copyWith =>
      __$CredencialesCopyWithImpl<_Credenciales>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CredencialesToJson(this);
  }
}

abstract class _Credenciales extends Credenciales {
  factory _Credenciales({required String username, required String password}) =
      _$_Credenciales;
  _Credenciales._() : super._();

  factory _Credenciales.fromJson(Map<String, dynamic> json) =
      _$_Credenciales.fromJson;

  @override
  String get username => throw _privateConstructorUsedError;
  @override
  String get password => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$CredencialesCopyWith<_Credenciales> get copyWith =>
      throw _privateConstructorUsedError;
}
