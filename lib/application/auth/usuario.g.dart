// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Usuario _$_$_UsuarioFromJson(Map<String, dynamic> json) {
  return _$_Usuario(
    documento: json['documento'] as String,
    password: json['password'] as String,
    token: json['token'] as String,
    esAdmin: json['esAdmin'] as bool,
  );
}

Map<String, dynamic> _$_$_UsuarioToJson(_$_Usuario instance) =>
    <String, dynamic>{
      'documento': instance.documento,
      'password': instance.password,
      'token': instance.token,
      'esAdmin': instance.esAdmin,
    };
