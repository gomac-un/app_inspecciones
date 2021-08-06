// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'api_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserLogin _$UserLoginFromJson(Map<String, dynamic> json) {
  return _UserLogin.fromJson(json);
}

/// @nodoc
class _$UserLoginTearOff {
  const _$UserLoginTearOff();

  _UserLogin call(
      {required String username,
      required String password,
      required bool esAdmin}) {
    return _UserLogin(
      username: username,
      password: password,
      esAdmin: esAdmin,
    );
  }

  UserLogin fromJson(Map<String, Object> json) {
    return UserLogin.fromJson(json);
  }
}

/// @nodoc
const $UserLogin = _$UserLoginTearOff();

/// @nodoc
mixin _$UserLogin {
  String get username => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  bool get esAdmin => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserLoginCopyWith<UserLogin> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserLoginCopyWith<$Res> {
  factory $UserLoginCopyWith(UserLogin value, $Res Function(UserLogin) then) =
      _$UserLoginCopyWithImpl<$Res>;
  $Res call({String username, String password, bool esAdmin});
}

/// @nodoc
class _$UserLoginCopyWithImpl<$Res> implements $UserLoginCopyWith<$Res> {
  _$UserLoginCopyWithImpl(this._value, this._then);

  final UserLogin _value;
  // ignore: unused_field
  final $Res Function(UserLogin) _then;

  @override
  $Res call({
    Object? username = freezed,
    Object? password = freezed,
    Object? esAdmin = freezed,
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
      esAdmin: esAdmin == freezed
          ? _value.esAdmin
          : esAdmin // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$UserLoginCopyWith<$Res> implements $UserLoginCopyWith<$Res> {
  factory _$UserLoginCopyWith(
          _UserLogin value, $Res Function(_UserLogin) then) =
      __$UserLoginCopyWithImpl<$Res>;
  @override
  $Res call({String username, String password, bool esAdmin});
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
    Object? username = freezed,
    Object? password = freezed,
    Object? esAdmin = freezed,
  }) {
    return _then(_UserLogin(
      username: username == freezed
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
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
class _$_UserLogin extends _UserLogin {
  _$_UserLogin(
      {required this.username, required this.password, required this.esAdmin})
      : super._();

  factory _$_UserLogin.fromJson(Map<String, dynamic> json) =>
      _$_$_UserLoginFromJson(json);

  @override
  final String username;
  @override
  final String password;
  @override
  final bool esAdmin;

  @override
  String toString() {
    return 'UserLogin(username: $username, password: $password, esAdmin: $esAdmin)';
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
            (identical(other.esAdmin, esAdmin) ||
                const DeepCollectionEquality().equals(other.esAdmin, esAdmin)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(username) ^
      const DeepCollectionEquality().hash(password) ^
      const DeepCollectionEquality().hash(esAdmin);

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
  factory _UserLogin(
      {required String username,
      required String password,
      required bool esAdmin}) = _$_UserLogin;
  _UserLogin._() : super._();

  factory _UserLogin.fromJson(Map<String, dynamic> json) =
      _$_UserLogin.fromJson;

  @override
  String get username => throw _privateConstructorUsedError;
  @override
  String get password => throw _privateConstructorUsedError;
  @override
  bool get esAdmin => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$UserLoginCopyWith<_UserLogin> get copyWith =>
      throw _privateConstructorUsedError;
}
