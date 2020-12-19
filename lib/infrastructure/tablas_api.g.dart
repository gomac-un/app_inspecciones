// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tablas_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sistema _$SistemaFromJson(Map<String, dynamic> json) {
  return Sistema(
    id: json['id'] as int,
    nombre: json['nombre'] as String,
  );
}

Map<String, dynamic> _$SistemaToJson(Sistema instance) => <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
    };
