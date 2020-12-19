
import 'package:json_annotation/json_annotation.dart';
import 'package:moor/moor.dart' as moor;
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


