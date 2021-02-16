// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserLogin _$_$_UserLoginFromJson(Map<String, dynamic> json) {
  return _$_UserLogin(
    username: json['username'] as String,
    password: json['password'] as String,
    esdAdmin: json['esdAdmin'] as bool,
  );
}

Map<String, dynamic> _$_$_UserLoginToJson(_$_UserLogin instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'esdAdmin': instance.esdAdmin,
    };
