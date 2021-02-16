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
  _UserLogin call({String username, String password, bool esdAdmin}) {
    return _UserLogin(
      username: username,
      password: password,
      esdAdmin: esdAdmin,
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
  String get username;
  String get password;
  bool get esdAdmin;

  Map<String, dynamic> toJson();
  @JsonKey(ignore: true)
  $UserLoginCopyWith<UserLogin> get copyWith;
}

/// @nodoc
abstract class $UserLoginCopyWith<$Res> {
  factory $UserLoginCopyWith(UserLogin value, $Res Function(UserLogin) then) =
      _$UserLoginCopyWithImpl<$Res>;
  $Res call({String username, String password, bool esdAdmin});
}

/// @nodoc
class _$UserLoginCopyWithImpl<$Res> implements $UserLoginCopyWith<$Res> {
  _$UserLoginCopyWithImpl(this._value, this._then);

  final UserLogin _value;
  // ignore: unused_field
  final $Res Function(UserLogin) _then;

  @override
  $Res call({
    Object username = freezed,
    Object password = freezed,
    Object esdAdmin = freezed,
  }) {
    return _then(_value.copyWith(
      username: username == freezed ? _value.username : username as String,
      password: password == freezed ? _value.password : password as String,
      esdAdmin: esdAdmin == freezed ? _value.esdAdmin : esdAdmin as bool,
    ));
  }
}

/// @nodoc
abstract class _$UserLoginCopyWith<$Res> implements $UserLoginCopyWith<$Res> {
  factory _$UserLoginCopyWith(
          _UserLogin value, $Res Function(_UserLogin) then) =
      __$UserLoginCopyWithImpl<$Res>;
  @override
  $Res call({String username, String password, bool esdAdmin});
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
    Object username = freezed,
    Object password = freezed,
    Object esdAdmin = freezed,
  }) {
    return _then(_UserLogin(
      username: username == freezed ? _value.username : username as String,
      password: password == freezed ? _value.password : password as String,
      esdAdmin: esdAdmin == freezed ? _value.esdAdmin : esdAdmin as bool,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_UserLogin extends _UserLogin {
  _$_UserLogin({this.username, this.password, this.esdAdmin}) : super._();

  factory _$_UserLogin.fromJson(Map<String, dynamic> json) =>
      _$_$_UserLoginFromJson(json);

  @override
  final String username;
  @override
  final String password;
  @override
  final bool esdAdmin;

  @override
  String toString() {
    return 'UserLogin(username: $username, password: $password, esdAdmin: $esdAdmin)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _UserLogin &&
            (identical(other.username, username) ||
                const DeepCollectionEquality()
                    .equals(other.username, username)) &&
            (identical(other.password, password) ||
                const DeepCollectionEquality()
                    .equals(other.password, password)) &&
            (identical(other.esdAdmin, esdAdmin) ||
                const DeepCollectionEquality()
                    .equals(other.esdAdmin, esdAdmin)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(username) ^
      const DeepCollectionEquality().hash(password) ^
      const DeepCollectionEquality().hash(esdAdmin);

  @JsonKey(ignore: true)
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
  factory _UserLogin({String username, String password, bool esdAdmin}) =
      _$_UserLogin;

  factory _UserLogin.fromJson(Map<String, dynamic> json) =
      _$_UserLogin.fromJson;

  @override
  String get username;
  @override
  String get password;
  @override
  bool get esdAdmin;
  @override
  @JsonKey(ignore: true)
  _$UserLoginCopyWith<_UserLogin> get copyWith;
}
