// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'usuario.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Usuario _$UsuarioFromJson(Map<String, dynamic> json) {
  return _Usuario.fromJson(json);
}

/// @nodoc
class _$UsuarioTearOff {
  const _$UsuarioTearOff();

  _Usuario call(
      {required String documento,
      required String password,
      required String token,
      required bool esAdmin}) {
    return _Usuario(
      documento: documento,
      password: password,
      token: token,
      esAdmin: esAdmin,
    );
  }

  Usuario fromJson(Map<String, Object> json) {
    return Usuario.fromJson(json);
  }
}

/// @nodoc
const $Usuario = _$UsuarioTearOff();

/// @nodoc
mixin _$Usuario {
  /// Nombre de usuario
  String get documento => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;

  /// Parte de la autenticación de Django para acceder a los servicios de la Api
  /// https://www.django-rest-framework.org/api-guide/authentication/#tokenauthentication
  String get token => throw _privateConstructorUsedError;

  /// True si puede crear cuestionarios.
  bool get esAdmin => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UsuarioCopyWith<Usuario> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UsuarioCopyWith<$Res> {
  factory $UsuarioCopyWith(Usuario value, $Res Function(Usuario) then) =
      _$UsuarioCopyWithImpl<$Res>;
  $Res call({String documento, String password, String token, bool esAdmin});
}

/// @nodoc
class _$UsuarioCopyWithImpl<$Res> implements $UsuarioCopyWith<$Res> {
  _$UsuarioCopyWithImpl(this._value, this._then);

  final Usuario _value;
  // ignore: unused_field
  final $Res Function(Usuario) _then;

  @override
  $Res call({
    Object? documento = freezed,
    Object? password = freezed,
    Object? token = freezed,
    Object? esAdmin = freezed,
  }) {
    return _then(_value.copyWith(
      documento: documento == freezed
          ? _value.documento
          : documento // ignore: cast_nullable_to_non_nullable
              as String,
      password: password == freezed
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      token: token == freezed
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      esAdmin: esAdmin == freezed
          ? _value.esAdmin
          : esAdmin // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$UsuarioCopyWith<$Res> implements $UsuarioCopyWith<$Res> {
  factory _$UsuarioCopyWith(_Usuario value, $Res Function(_Usuario) then) =
      __$UsuarioCopyWithImpl<$Res>;
  @override
  $Res call({String documento, String password, String token, bool esAdmin});
}

/// @nodoc
class __$UsuarioCopyWithImpl<$Res> extends _$UsuarioCopyWithImpl<$Res>
    implements _$UsuarioCopyWith<$Res> {
  __$UsuarioCopyWithImpl(_Usuario _value, $Res Function(_Usuario) _then)
      : super(_value, (v) => _then(v as _Usuario));

  @override
  _Usuario get _value => super._value as _Usuario;

  @override
  $Res call({
    Object? documento = freezed,
    Object? password = freezed,
    Object? token = freezed,
    Object? esAdmin = freezed,
  }) {
    return _then(_Usuario(
      documento: documento == freezed
          ? _value.documento
          : documento // ignore: cast_nullable_to_non_nullable
              as String,
      password: password == freezed
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      token: token == freezed
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      esAdmin: esAdmin == freezed
          ? _value.esAdmin
          : esAdmin // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Usuario implements _Usuario {
  _$_Usuario(
      {required this.documento,
      required this.password,
      required this.token,
      required this.esAdmin});

  factory _$_Usuario.fromJson(Map<String, dynamic> json) =>
      _$_$_UsuarioFromJson(json);

  @override

  /// Nombre de usuario
  final String documento;
  @override
  final String password;
  @override

  /// Parte de la autenticación de Django para acceder a los servicios de la Api
  /// https://www.django-rest-framework.org/api-guide/authentication/#tokenauthentication
  final String token;
  @override

  /// True si puede crear cuestionarios.
  final bool esAdmin;

  @override
  String toString() {
    return 'Usuario(documento: $documento, password: $password, token: $token, esAdmin: $esAdmin)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Usuario &&
            (identical(other.documento, documento) ||
                const DeepCollectionEquality()
                    .equals(other.documento, documento)) &&
            (identical(other.password, password) ||
                const DeepCollectionEquality()
                    .equals(other.password, password)) &&
            (identical(other.token, token) ||
                const DeepCollectionEquality().equals(other.token, token)) &&
            (identical(other.esAdmin, esAdmin) ||
                const DeepCollectionEquality().equals(other.esAdmin, esAdmin)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(documento) ^
      const DeepCollectionEquality().hash(password) ^
      const DeepCollectionEquality().hash(token) ^
      const DeepCollectionEquality().hash(esAdmin);

  @JsonKey(ignore: true)
  @override
  _$UsuarioCopyWith<_Usuario> get copyWith =>
      __$UsuarioCopyWithImpl<_Usuario>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_UsuarioToJson(this);
  }
}

abstract class _Usuario implements Usuario {
  factory _Usuario(
      {required String documento,
      required String password,
      required String token,
      required bool esAdmin}) = _$_Usuario;

  factory _Usuario.fromJson(Map<String, dynamic> json) = _$_Usuario.fromJson;

  @override

  /// Nombre de usuario
  String get documento => throw _privateConstructorUsedError;
  @override
  String get password => throw _privateConstructorUsedError;
  @override

  /// Parte de la autenticación de Django para acceder a los servicios de la Api
  /// https://www.django-rest-framework.org/api-guide/authentication/#tokenauthentication
  String get token => throw _privateConstructorUsedError;
  @override

  /// True si puede crear cuestionarios.
  bool get esAdmin => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$UsuarioCopyWith<_Usuario> get copyWith =>
      throw _privateConstructorUsedError;
}
