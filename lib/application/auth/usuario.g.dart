// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$Online _$$OnlineFromJson(Map<String, dynamic> json) => _$Online(
      documento: json['documento'] as String,
      password: json['password'] as String,
      token: json['token'] as String,
      esAdmin: json['esAdmin'] as bool,
    );

Map<String, dynamic> _$$OnlineToJson(_$Online instance) => <String, dynamic>{
      'documento': instance.documento,
      'password': instance.password,
      'token': instance.token,
      'esAdmin': instance.esAdmin,
    };

_$Offline _$$OfflineFromJson(Map<String, dynamic> json) => _$Offline(
      documento: json['documento'] as String,
      password: json['password'] as String,
      esAdmin: json['esAdmin'] as bool? ?? false,
    );

Map<String, dynamic> _$$OfflineToJson(_$Offline instance) => <String, dynamic>{
      'documento': instance.documento,
      'password': instance.password,
      'esAdmin': instance.esAdmin,
    };
