// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'api_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
UserLogin _$UserLoginFromJson(Map<String, dynamic> json) {
  return _UserLogin.fromJson(json);
}

/// @nodoc
class _$UserLoginTearOff {
  const _$UserLoginTearOff();

// ignore: unused_element
  _UserLogin call({String documento, String password}) {
    return _UserLogin(
      documento: documento,
      password: password,
    );
  }

// ignore: unused_element
  UserLogin fromJson(Map<String, Object> json) {
    return UserLogin.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $UserLogin = _$UserLoginTearOff();

/// @nodoc
mixin _$UserLogin {
  String get documento;
  String get password;

  Map<String, dynamic> toJson();
  $UserLoginCopyWith<UserLogin> get copyWith;
}

/// @nodoc
abstract class $UserLoginCopyWith<$Res> {
  factory $UserLoginCopyWith(UserLogin value, $Res Function(UserLogin) then) =
      _$UserLoginCopyWithImpl<$Res>;
  $Res call({String documento, String password});
}

/// @nodoc
class _$UserLoginCopyWithImpl<$Res> implements $UserLoginCopyWith<$Res> {
  _$UserLoginCopyWithImpl(this._value, this._then);

  final UserLogin _value;
  // ignore: unused_field
  final $Res Function(UserLogin) _then;

  @override
  $Res call({
    Object documento = freezed,
    Object password = freezed,
  }) {
    return _then(_value.copyWith(
      documento: documento == freezed ? _value.documento : documento as String,
      password: password == freezed ? _value.password : password as String,
    ));
  }
}

/// @nodoc
abstract class _$UserLoginCopyWith<$Res> implements $UserLoginCopyWith<$Res> {
  factory _$UserLoginCopyWith(
          _UserLogin value, $Res Function(_UserLogin) then) =
      __$UserLoginCopyWithImpl<$Res>;
  @override
  $Res call({String documento, String password});
}

/// @nodoc
class __$UserLoginCopyWithImpl<$Res> extends _$UserLoginCopyWithImpl<$Res>
    implements _$UserLoginCopyWith<$Res> {
  __$UserLoginCopyWithImpl(_UserLogin _value, $Res Function(_UserLogin) _then)
      : super(_value, (v) => _then(v as _UserLogin));

  @override
  _UserLogin get _value => super._value as _UserLogin;

  @override
  $Res call({
    Object documento = freezed,
    Object password = freezed,
  }) {
    return _then(_UserLogin(
      documento: documento == freezed ? _value.documento : documento as String,
      password: password == freezed ? _value.password : password as String,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_UserLogin extends _UserLogin {
  _$_UserLogin({this.documento, this.password}) : super._();

  factory _$_UserLogin.fromJson(Map<String, dynamic> json) =>
      _$_$_UserLoginFromJson(json);

  @override
  final String documento;
  @override
  final String password;

  @override
  String toString() {
    return 'UserLogin(documento: $documento, password: $password)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _UserLogin &&
            (identical(other.documento, documento) ||
                const DeepCollectionEquality()
                    .equals(other.documento, documento)) &&
            (identical(other.password, password) ||
                const DeepCollectionEquality()
                    .equals(other.password, password)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(documento) ^
      const DeepCollectionEquality().hash(password);

  @override
  _$UserLoginCopyWith<_UserLogin> get copyWith =>
      __$UserLoginCopyWithImpl<_UserLogin>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_UserLoginToJson(this);
  }
}

abstract class _UserLogin extends UserLogin {
  _UserLogin._() : super._();
  factory _UserLogin({String documento, String password}) = _$_UserLogin;

  factory _UserLogin.fromJson(Map<String, dynamic> json) =
      _$_UserLogin.fromJson;

  @override
  String get documento;
  @override
  String get password;
  @override
  _$UserLoginCopyWith<_UserLogin> get copyWith;
}
