// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'usuario.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Usuario _$UsuarioFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType'] as String?) {
    case 'online':
      return UsuarioOnline.fromJson(json);
    case 'offline':
      return UsuarioOffline.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'Usuario',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
class _$UsuarioTearOff {
  const _$UsuarioTearOff();

  UsuarioOnline online(
      {required String documento,
      required String password,
      required String token,
      required bool esAdmin}) {
    return UsuarioOnline(
      documento: documento,
      password: password,
      token: token,
      esAdmin: esAdmin,
    );
  }

  UsuarioOffline offline(
      {required String documento,
      required String password,
      bool esAdmin = false}) {
    return UsuarioOffline(
      documento: documento,
      password: password,
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

  /// True si puede crear cuestionarios.
  bool get esAdmin => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String documento, String password, String token, bool esAdmin)
        online,
    required TResult Function(String documento, String password, bool esAdmin)
        offline,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(
            String documento, String password, String token, bool esAdmin)?
        online,
    TResult Function(String documento, String password, bool esAdmin)? offline,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String documento, String password, String token, bool esAdmin)?
        online,
    TResult Function(String documento, String password, bool esAdmin)? offline,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UsuarioOnline value) online,
    required TResult Function(UsuarioOffline value) offline,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(UsuarioOnline value)? online,
    TResult Function(UsuarioOffline value)? offline,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UsuarioOnline value)? online,
    TResult Function(UsuarioOffline value)? offline,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UsuarioCopyWith<Usuario> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UsuarioCopyWith<$Res> {
  factory $UsuarioCopyWith(Usuario value, $Res Function(Usuario) then) =
      _$UsuarioCopyWithImpl<$Res>;
  $Res call({String documento, String password, bool esAdmin});
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
      esAdmin: esAdmin == freezed
          ? _value.esAdmin
          : esAdmin // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class $UsuarioOnlineCopyWith<$Res> implements $UsuarioCopyWith<$Res> {
  factory $UsuarioOnlineCopyWith(
          UsuarioOnline value, $Res Function(UsuarioOnline) then) =
      _$UsuarioOnlineCopyWithImpl<$Res>;
  @override
  $Res call({String documento, String password, String token, bool esAdmin});
}

/// @nodoc
class _$UsuarioOnlineCopyWithImpl<$Res> extends _$UsuarioCopyWithImpl<$Res>
    implements $UsuarioOnlineCopyWith<$Res> {
  _$UsuarioOnlineCopyWithImpl(
      UsuarioOnline _value, $Res Function(UsuarioOnline) _then)
      : super(_value, (v) => _then(v as UsuarioOnline));

  @override
  UsuarioOnline get _value => super._value as UsuarioOnline;

  @override
  $Res call({
    Object? documento = freezed,
    Object? password = freezed,
    Object? token = freezed,
    Object? esAdmin = freezed,
  }) {
    return _then(UsuarioOnline(
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
class _$UsuarioOnline implements UsuarioOnline {
  const _$UsuarioOnline(
      {required this.documento,
      required this.password,
      required this.token,
      required this.esAdmin});

  factory _$UsuarioOnline.fromJson(Map<String, dynamic> json) =>
      _$$UsuarioOnlineFromJson(json);

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
    return 'Usuario.online(documento: $documento, password: $password, token: $token, esAdmin: $esAdmin)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is UsuarioOnline &&
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
  $UsuarioOnlineCopyWith<UsuarioOnline> get copyWith =>
      _$UsuarioOnlineCopyWithImpl<UsuarioOnline>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String documento, String password, String token, bool esAdmin)
        online,
    required TResult Function(String documento, String password, bool esAdmin)
        offline,
  }) {
    return online(documento, password, token, esAdmin);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(
            String documento, String password, String token, bool esAdmin)?
        online,
    TResult Function(String documento, String password, bool esAdmin)? offline,
  }) {
    return online?.call(documento, password, token, esAdmin);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String documento, String password, String token, bool esAdmin)?
        online,
    TResult Function(String documento, String password, bool esAdmin)? offline,
    required TResult orElse(),
  }) {
    if (online != null) {
      return online(documento, password, token, esAdmin);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UsuarioOnline value) online,
    required TResult Function(UsuarioOffline value) offline,
  }) {
    return online(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(UsuarioOnline value)? online,
    TResult Function(UsuarioOffline value)? offline,
  }) {
    return online?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UsuarioOnline value)? online,
    TResult Function(UsuarioOffline value)? offline,
    required TResult orElse(),
  }) {
    if (online != null) {
      return online(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$UsuarioOnlineToJson(this)..['runtimeType'] = 'online';
  }
}

abstract class UsuarioOnline implements Usuario {
  const factory UsuarioOnline(
      {required String documento,
      required String password,
      required String token,
      required bool esAdmin}) = _$UsuarioOnline;

  factory UsuarioOnline.fromJson(Map<String, dynamic> json) =
      _$UsuarioOnline.fromJson;

  @override

  /// Nombre de usuario
  String get documento => throw _privateConstructorUsedError;
  @override
  String get password => throw _privateConstructorUsedError;

  /// Parte de la autenticación de Django para acceder a los servicios de la Api
  /// https://www.django-rest-framework.org/api-guide/authentication/#tokenauthentication
  String get token => throw _privateConstructorUsedError;
  @override

  /// True si puede crear cuestionarios.
  bool get esAdmin => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  $UsuarioOnlineCopyWith<UsuarioOnline> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UsuarioOfflineCopyWith<$Res> implements $UsuarioCopyWith<$Res> {
  factory $UsuarioOfflineCopyWith(
          UsuarioOffline value, $Res Function(UsuarioOffline) then) =
      _$UsuarioOfflineCopyWithImpl<$Res>;
  @override
  $Res call({String documento, String password, bool esAdmin});
}

/// @nodoc
class _$UsuarioOfflineCopyWithImpl<$Res> extends _$UsuarioCopyWithImpl<$Res>
    implements $UsuarioOfflineCopyWith<$Res> {
  _$UsuarioOfflineCopyWithImpl(
      UsuarioOffline _value, $Res Function(UsuarioOffline) _then)
      : super(_value, (v) => _then(v as UsuarioOffline));

  @override
  UsuarioOffline get _value => super._value as UsuarioOffline;

  @override
  $Res call({
    Object? documento = freezed,
    Object? password = freezed,
    Object? esAdmin = freezed,
  }) {
    return _then(UsuarioOffline(
      documento: documento == freezed
          ? _value.documento
          : documento // ignore: cast_nullable_to_non_nullable
              as String,
      password: password == freezed
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
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
class _$UsuarioOffline implements UsuarioOffline {
  const _$UsuarioOffline(
      {required this.documento, required this.password, this.esAdmin = false});

  factory _$UsuarioOffline.fromJson(Map<String, dynamic> json) =>
      _$$UsuarioOfflineFromJson(json);

  @override

  /// Nombre de usuario
  final String documento;
  @override
  final String password;
  @JsonKey(defaultValue: false)
  @override

  /// True si puede crear cuestionarios.
  final bool esAdmin;

  @override
  String toString() {
    return 'Usuario.offline(documento: $documento, password: $password, esAdmin: $esAdmin)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is UsuarioOffline &&
            (identical(other.documento, documento) ||
                const DeepCollectionEquality()
                    .equals(other.documento, documento)) &&
            (identical(other.password, password) ||
                const DeepCollectionEquality()
                    .equals(other.password, password)) &&
            (identical(other.esAdmin, esAdmin) ||
                const DeepCollectionEquality().equals(other.esAdmin, esAdmin)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(documento) ^
      const DeepCollectionEquality().hash(password) ^
      const DeepCollectionEquality().hash(esAdmin);

  @JsonKey(ignore: true)
  @override
  $UsuarioOfflineCopyWith<UsuarioOffline> get copyWith =>
      _$UsuarioOfflineCopyWithImpl<UsuarioOffline>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String documento, String password, String token, bool esAdmin)
        online,
    required TResult Function(String documento, String password, bool esAdmin)
        offline,
  }) {
    return offline(documento, password, esAdmin);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(
            String documento, String password, String token, bool esAdmin)?
        online,
    TResult Function(String documento, String password, bool esAdmin)? offline,
  }) {
    return offline?.call(documento, password, esAdmin);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String documento, String password, String token, bool esAdmin)?
        online,
    TResult Function(String documento, String password, bool esAdmin)? offline,
    required TResult orElse(),
  }) {
    if (offline != null) {
      return offline(documento, password, esAdmin);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UsuarioOnline value) online,
    required TResult Function(UsuarioOffline value) offline,
  }) {
    return offline(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(UsuarioOnline value)? online,
    TResult Function(UsuarioOffline value)? offline,
  }) {
    return offline?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UsuarioOnline value)? online,
    TResult Function(UsuarioOffline value)? offline,
    required TResult orElse(),
  }) {
    if (offline != null) {
      return offline(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$UsuarioOfflineToJson(this)..['runtimeType'] = 'offline';
  }
}

abstract class UsuarioOffline implements Usuario {
  const factory UsuarioOffline(
      {required String documento,
      required String password,
      bool esAdmin}) = _$UsuarioOffline;

  factory UsuarioOffline.fromJson(Map<String, dynamic> json) =
      _$UsuarioOffline.fromJson;

  @override

  /// Nombre de usuario
  String get documento => throw _privateConstructorUsedError;
  @override
  String get password => throw _privateConstructorUsedError;
  @override

  /// True si puede crear cuestionarios.
  bool get esAdmin => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  $UsuarioOfflineCopyWith<UsuarioOffline> get copyWith =>
      throw _privateConstructorUsedError;
}
