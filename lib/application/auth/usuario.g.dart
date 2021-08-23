// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UsuarioOnline _$$UsuarioOnlineFromJson(Map<String, dynamic> json) =>
    _$UsuarioOnline(
      documento: json['documento'] as String,
      password: json['password'] as String,
      token: json['token'] as String,
      esAdmin: json['esAdmin'] as bool,
    );

Map<String, dynamic> _$$UsuarioOnlineToJson(_$UsuarioOnline instance) =>
    <String, dynamic>{
      'documento': instance.documento,
      'password': instance.password,
      'token': instance.token,
      'esAdmin': instance.esAdmin,
    };

_$UsuarioOffline _$$UsuarioOfflineFromJson(Map<String, dynamic> json) =>
    _$UsuarioOffline(
      documento: json['documento'] as String,
      password: json['password'] as String,
      esAdmin: json['esAdmin'] as bool? ?? false,
    );

Map<String, dynamic> _$$UsuarioOfflineToJson(_$UsuarioOffline instance) =>
    <String, dynamic>{
      'documento': instance.documento,
      'password': instance.password,
      'esAdmin': instance.esAdmin,
    };
