
import 'dart:convert';

import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moor/moor.dart' as moor;
import 'package:moor/moor.dart';
part 'tablas_api.g.dart';

@JsonSerializable()
class Sistema extends moor.Table{
  moor.IntColumn get id => integer()();
  moor.TextColumn get nombre => text()();
  Sistema({id, nombre});
  @override
  Set<moor.Column> get primaryKey => {id};
  factory Sistema.fromJson(Map<String,dynamic> json) => _$SistemaFromJson(json);
  Map<String, dynamic> toJson() => _$SistemaToJson(this);

}

class NombreConverter extends TypeConverter<Sistema, String> {
  const NombreConverter();
  @override
  Sistema mapToDart(String fromDb) {
    if (fromDb == null) {
      return null;
    }
    return Sistema.fromJson(json.decode(fromDb) as Map<String, dynamic>);
  }

  @override
  String mapToSql(Sistema value) {
    if (value == null) {
      return null;
    }

    return json.encode(value.toJson());
  }
}


