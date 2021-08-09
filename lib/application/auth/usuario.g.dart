// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Usuario _$$_UsuarioFromJson(Map<String, dynamic> json) => _$_Usuario(
      documento: json['documento'] as String,
      password: json['password'] as String,
      token: json['token'] as String,
      esAdmin: json['esAdmin'] as bool,
    );

Map<String, dynamic> _$$_UsuarioToJson(_$_Usuario instance) =>
    <String, dynamic>{
      'documento': instance.documento,
      'password': instance.password,
      'token': instance.token,
      'esAdmin': instance.esAdmin,
    };
