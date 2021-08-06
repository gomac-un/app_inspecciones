// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RespuestaConOpcionesDeRespuesta2 _$RespuestaConOpcionesDeRespuesta2FromJson(
    Map<String, dynamic> json) {
  return RespuestaConOpcionesDeRespuesta2(
    json['respuesta'],
    json['opcionesDeRespuesta'] as List<dynamic>,
  );
}

Map<String, dynamic> _$RespuestaConOpcionesDeRespuesta2ToJson(
        RespuestaConOpcionesDeRespuesta2 instance) =>
    <String, dynamic>{
      'respuesta': instance.respuesta,
      'opcionesDeRespuesta': instance.opcionesDeRespuesta,
    };

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Activo extends DataClass implements Insertable<Activo> {
  final int id;
  final String modelo;
  Activo({required this.id, required this.modelo});
  factory Activo.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Activo(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      modelo: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}modelo'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['modelo'] = Variable<String>(modelo);
    return map;
  }

  ActivosCompanion toCompanion(bool nullToAbsent) {
    return ActivosCompanion(
      id: Value(id),
      modelo: Value(modelo),
    );
  }

  factory Activo.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Activo(
      id: serializer.fromJson<int>(json['id']),
      modelo: serializer.fromJson<String>(json['modelo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'modelo': serializer.toJson<String>(modelo),
    };
  }

  Activo copyWith({int? id, String? modelo}) => Activo(
        id: id ?? this.id,
        modelo: modelo ?? this.modelo,
      );
  @override
  String toString() {
    return (StringBuffer('Activo(')
          ..write('id: $id, ')
          ..write('modelo: $modelo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode, modelo.hashCode));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Activo && other.id == this.id && other.modelo == this.modelo);
}

class ActivosCompanion extends UpdateCompanion<Activo> {
  final Value<int> id;
  final Value<String> modelo;
  const ActivosCompanion({
    this.id = const Value.absent(),
    this.modelo = const Value.absent(),
  });
  ActivosCompanion.insert({
    this.id = const Value.absent(),
    required String modelo,
  }) : modelo = Value(modelo);
  static Insertable<Activo> custom({
    Expression<int>? id,
    Expression<String>? modelo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (modelo != null) 'modelo': modelo,
    });
  }

  ActivosCompanion copyWith({Value<int>? id, Value<String>? modelo}) {
    return ActivosCompanion(
      id: id ?? this.id,
      modelo: modelo ?? this.modelo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (modelo.present) {
      map['modelo'] = Variable<String>(modelo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivosCompanion(')
          ..write('id: $id, ')
          ..write('modelo: $modelo')
          ..write(')'))
        .toString();
  }
}

class $ActivosTable extends Activos with TableInfo<$ActivosTable, Activo> {
  final GeneratedDatabase _db;
  final String? _alias;
  $ActivosTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _modeloMeta = const VerificationMeta('modelo');
  late final GeneratedColumn<String?> modelo = GeneratedColumn<String?>(
      'modelo', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, modelo];
  @override
  String get aliasedName => _alias ?? 'activos';
  @override
  String get actualTableName => 'activos';
  @override
  VerificationContext validateIntegrity(Insertable<Activo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('modelo')) {
      context.handle(_modeloMeta,
          modelo.isAcceptableOrUnknown(data['modelo']!, _modeloMeta));
    } else if (isInserting) {
      context.missing(_modeloMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Activo map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Activo.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ActivosTable createAlias(String alias) {
    return $ActivosTable(_db, alias);
  }
}

class CuestionarioDeModelo extends DataClass
    implements Insertable<CuestionarioDeModelo> {
  final int id;

  ///El modelo especial "Todos" aplica para todos los vehiculos.
  final String modelo;
  final int periodicidad;
  final int cuestionarioId;
  final int? contratistaId;
  CuestionarioDeModelo(
      {required this.id,
      required this.modelo,
      required this.periodicidad,
      required this.cuestionarioId,
      this.contratistaId});
  factory CuestionarioDeModelo.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return CuestionarioDeModelo(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      modelo: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}modelo'])!,
      periodicidad: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}periodicidad'])!,
      cuestionarioId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cuestionario_id'])!,
      contratistaId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}contratista_id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['modelo'] = Variable<String>(modelo);
    map['periodicidad'] = Variable<int>(periodicidad);
    map['cuestionario_id'] = Variable<int>(cuestionarioId);
    if (!nullToAbsent || contratistaId != null) {
      map['contratista_id'] = Variable<int?>(contratistaId);
    }
    return map;
  }

  CuestionarioDeModelosCompanion toCompanion(bool nullToAbsent) {
    return CuestionarioDeModelosCompanion(
      id: Value(id),
      modelo: Value(modelo),
      periodicidad: Value(periodicidad),
      cuestionarioId: Value(cuestionarioId),
      contratistaId: contratistaId == null && nullToAbsent
          ? const Value.absent()
          : Value(contratistaId),
    );
  }

  factory CuestionarioDeModelo.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return CuestionarioDeModelo(
      id: serializer.fromJson<int>(json['id']),
      modelo: serializer.fromJson<String>(json['modelo']),
      periodicidad: serializer.fromJson<int>(json['periodicidad']),
      cuestionarioId: serializer.fromJson<int>(json['cuestionario']),
      contratistaId: serializer.fromJson<int?>(json['contratista']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'modelo': serializer.toJson<String>(modelo),
      'periodicidad': serializer.toJson<int>(periodicidad),
      'cuestionario': serializer.toJson<int>(cuestionarioId),
      'contratista': serializer.toJson<int?>(contratistaId),
    };
  }

  CuestionarioDeModelo copyWith(
          {int? id,
          String? modelo,
          int? periodicidad,
          int? cuestionarioId,
          int? contratistaId}) =>
      CuestionarioDeModelo(
        id: id ?? this.id,
        modelo: modelo ?? this.modelo,
        periodicidad: periodicidad ?? this.periodicidad,
        cuestionarioId: cuestionarioId ?? this.cuestionarioId,
        contratistaId: contratistaId ?? this.contratistaId,
      );
  @override
  String toString() {
    return (StringBuffer('CuestionarioDeModelo(')
          ..write('id: $id, ')
          ..write('modelo: $modelo, ')
          ..write('periodicidad: $periodicidad, ')
          ..write('cuestionarioId: $cuestionarioId, ')
          ..write('contratistaId: $contratistaId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          modelo.hashCode,
          $mrjc(periodicidad.hashCode,
              $mrjc(cuestionarioId.hashCode, contratistaId.hashCode)))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CuestionarioDeModelo &&
          other.id == this.id &&
          other.modelo == this.modelo &&
          other.periodicidad == this.periodicidad &&
          other.cuestionarioId == this.cuestionarioId &&
          other.contratistaId == this.contratistaId);
}

class CuestionarioDeModelosCompanion
    extends UpdateCompanion<CuestionarioDeModelo> {
  final Value<int> id;
  final Value<String> modelo;
  final Value<int> periodicidad;
  final Value<int> cuestionarioId;
  final Value<int?> contratistaId;
  const CuestionarioDeModelosCompanion({
    this.id = const Value.absent(),
    this.modelo = const Value.absent(),
    this.periodicidad = const Value.absent(),
    this.cuestionarioId = const Value.absent(),
    this.contratistaId = const Value.absent(),
  });
  CuestionarioDeModelosCompanion.insert({
    this.id = const Value.absent(),
    required String modelo,
    required int periodicidad,
    required int cuestionarioId,
    this.contratistaId = const Value.absent(),
  })  : modelo = Value(modelo),
        periodicidad = Value(periodicidad),
        cuestionarioId = Value(cuestionarioId);
  static Insertable<CuestionarioDeModelo> custom({
    Expression<int>? id,
    Expression<String>? modelo,
    Expression<int>? periodicidad,
    Expression<int>? cuestionarioId,
    Expression<int?>? contratistaId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (modelo != null) 'modelo': modelo,
      if (periodicidad != null) 'periodicidad': periodicidad,
      if (cuestionarioId != null) 'cuestionario_id': cuestionarioId,
      if (contratistaId != null) 'contratista_id': contratistaId,
    });
  }

  CuestionarioDeModelosCompanion copyWith(
      {Value<int>? id,
      Value<String>? modelo,
      Value<int>? periodicidad,
      Value<int>? cuestionarioId,
      Value<int?>? contratistaId}) {
    return CuestionarioDeModelosCompanion(
      id: id ?? this.id,
      modelo: modelo ?? this.modelo,
      periodicidad: periodicidad ?? this.periodicidad,
      cuestionarioId: cuestionarioId ?? this.cuestionarioId,
      contratistaId: contratistaId ?? this.contratistaId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (modelo.present) {
      map['modelo'] = Variable<String>(modelo.value);
    }
    if (periodicidad.present) {
      map['periodicidad'] = Variable<int>(periodicidad.value);
    }
    if (cuestionarioId.present) {
      map['cuestionario_id'] = Variable<int>(cuestionarioId.value);
    }
    if (contratistaId.present) {
      map['contratista_id'] = Variable<int?>(contratistaId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CuestionarioDeModelosCompanion(')
          ..write('id: $id, ')
          ..write('modelo: $modelo, ')
          ..write('periodicidad: $periodicidad, ')
          ..write('cuestionarioId: $cuestionarioId, ')
          ..write('contratistaId: $contratistaId')
          ..write(')'))
        .toString();
  }
}

class $CuestionarioDeModelosTable extends CuestionarioDeModelos
    with TableInfo<$CuestionarioDeModelosTable, CuestionarioDeModelo> {
  final GeneratedDatabase _db;
  final String? _alias;
  $CuestionarioDeModelosTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _modeloMeta = const VerificationMeta('modelo');
  late final GeneratedColumn<String?> modelo = GeneratedColumn<String?>(
      'modelo', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _periodicidadMeta =
      const VerificationMeta('periodicidad');
  late final GeneratedColumn<int?> periodicidad = GeneratedColumn<int?>(
      'periodicidad', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _cuestionarioIdMeta =
      const VerificationMeta('cuestionarioId');
  late final GeneratedColumn<int?> cuestionarioId = GeneratedColumn<int?>(
      'cuestionario_id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES cuestionarios(id) ON DELETE CASCADE');
  final VerificationMeta _contratistaIdMeta =
      const VerificationMeta('contratistaId');
  late final GeneratedColumn<int?> contratistaId = GeneratedColumn<int?>(
      'contratista_id', aliasedName, true,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      $customConstraints: 'REFERENCES contratistas(id) ON DELETE SET NULL');
  @override
  List<GeneratedColumn> get $columns =>
      [id, modelo, periodicidad, cuestionarioId, contratistaId];
  @override
  String get aliasedName => _alias ?? 'cuestionario_de_modelos';
  @override
  String get actualTableName => 'cuestionario_de_modelos';
  @override
  VerificationContext validateIntegrity(
      Insertable<CuestionarioDeModelo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('modelo')) {
      context.handle(_modeloMeta,
          modelo.isAcceptableOrUnknown(data['modelo']!, _modeloMeta));
    } else if (isInserting) {
      context.missing(_modeloMeta);
    }
    if (data.containsKey('periodicidad')) {
      context.handle(
          _periodicidadMeta,
          periodicidad.isAcceptableOrUnknown(
              data['periodicidad']!, _periodicidadMeta));
    } else if (isInserting) {
      context.missing(_periodicidadMeta);
    }
    if (data.containsKey('cuestionario_id')) {
      context.handle(
          _cuestionarioIdMeta,
          cuestionarioId.isAcceptableOrUnknown(
              data['cuestionario_id']!, _cuestionarioIdMeta));
    } else if (isInserting) {
      context.missing(_cuestionarioIdMeta);
    }
    if (data.containsKey('contratista_id')) {
      context.handle(
          _contratistaIdMeta,
          contratistaId.isAcceptableOrUnknown(
              data['contratista_id']!, _contratistaIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CuestionarioDeModelo map(Map<String, dynamic> data, {String? tablePrefix}) {
    return CuestionarioDeModelo.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $CuestionarioDeModelosTable createAlias(String alias) {
    return $CuestionarioDeModelosTable(_db, alias);
  }
}

class Cuestionario extends DataClass implements Insertable<Cuestionario> {
  final int id;
  final String tipoDeInspeccion;
  final EstadoDeCuestionario estado;

  /// Campo usado solo en la app para identificar los cuestionarios nuevos que deben ser enviados al server.
  final bool esLocal;
  Cuestionario(
      {required this.id,
      required this.tipoDeInspeccion,
      required this.estado,
      required this.esLocal});
  factory Cuestionario.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Cuestionario(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      tipoDeInspeccion: const StringType().mapFromDatabaseResponse(
          data['${effectivePrefix}tipo_de_inspeccion'])!,
      estado: $CuestionariosTable.$converter0.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}estado']))!,
      esLocal: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}es_local'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tipo_de_inspeccion'] = Variable<String>(tipoDeInspeccion);
    {
      final converter = $CuestionariosTable.$converter0;
      map['estado'] = Variable<int>(converter.mapToSql(estado)!);
    }
    map['es_local'] = Variable<bool>(esLocal);
    return map;
  }

  CuestionariosCompanion toCompanion(bool nullToAbsent) {
    return CuestionariosCompanion(
      id: Value(id),
      tipoDeInspeccion: Value(tipoDeInspeccion),
      estado: Value(estado),
      esLocal: Value(esLocal),
    );
  }

  factory Cuestionario.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Cuestionario(
      id: serializer.fromJson<int>(json['id']),
      tipoDeInspeccion: serializer.fromJson<String>(json['tipoDeInspeccion']),
      estado: serializer.fromJson<EstadoDeCuestionario>(json['estado']),
      esLocal: serializer.fromJson<bool>(json['esLocal']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tipoDeInspeccion': serializer.toJson<String>(tipoDeInspeccion),
      'estado': serializer.toJson<EstadoDeCuestionario>(estado),
      'esLocal': serializer.toJson<bool>(esLocal),
    };
  }

  Cuestionario copyWith(
          {int? id,
          String? tipoDeInspeccion,
          EstadoDeCuestionario? estado,
          bool? esLocal}) =>
      Cuestionario(
        id: id ?? this.id,
        tipoDeInspeccion: tipoDeInspeccion ?? this.tipoDeInspeccion,
        estado: estado ?? this.estado,
        esLocal: esLocal ?? this.esLocal,
      );
  @override
  String toString() {
    return (StringBuffer('Cuestionario(')
          ..write('id: $id, ')
          ..write('tipoDeInspeccion: $tipoDeInspeccion, ')
          ..write('estado: $estado, ')
          ..write('esLocal: $esLocal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(tipoDeInspeccion.hashCode,
          $mrjc(estado.hashCode, esLocal.hashCode))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cuestionario &&
          other.id == this.id &&
          other.tipoDeInspeccion == this.tipoDeInspeccion &&
          other.estado == this.estado &&
          other.esLocal == this.esLocal);
}

class CuestionariosCompanion extends UpdateCompanion<Cuestionario> {
  final Value<int> id;
  final Value<String> tipoDeInspeccion;
  final Value<EstadoDeCuestionario> estado;
  final Value<bool> esLocal;
  const CuestionariosCompanion({
    this.id = const Value.absent(),
    this.tipoDeInspeccion = const Value.absent(),
    this.estado = const Value.absent(),
    this.esLocal = const Value.absent(),
  });
  CuestionariosCompanion.insert({
    this.id = const Value.absent(),
    required String tipoDeInspeccion,
    required EstadoDeCuestionario estado,
    this.esLocal = const Value.absent(),
  })  : tipoDeInspeccion = Value(tipoDeInspeccion),
        estado = Value(estado);
  static Insertable<Cuestionario> custom({
    Expression<int>? id,
    Expression<String>? tipoDeInspeccion,
    Expression<EstadoDeCuestionario>? estado,
    Expression<bool>? esLocal,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tipoDeInspeccion != null) 'tipo_de_inspeccion': tipoDeInspeccion,
      if (estado != null) 'estado': estado,
      if (esLocal != null) 'es_local': esLocal,
    });
  }

  CuestionariosCompanion copyWith(
      {Value<int>? id,
      Value<String>? tipoDeInspeccion,
      Value<EstadoDeCuestionario>? estado,
      Value<bool>? esLocal}) {
    return CuestionariosCompanion(
      id: id ?? this.id,
      tipoDeInspeccion: tipoDeInspeccion ?? this.tipoDeInspeccion,
      estado: estado ?? this.estado,
      esLocal: esLocal ?? this.esLocal,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tipoDeInspeccion.present) {
      map['tipo_de_inspeccion'] = Variable<String>(tipoDeInspeccion.value);
    }
    if (estado.present) {
      final converter = $CuestionariosTable.$converter0;
      map['estado'] = Variable<int>(converter.mapToSql(estado.value)!);
    }
    if (esLocal.present) {
      map['es_local'] = Variable<bool>(esLocal.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CuestionariosCompanion(')
          ..write('id: $id, ')
          ..write('tipoDeInspeccion: $tipoDeInspeccion, ')
          ..write('estado: $estado, ')
          ..write('esLocal: $esLocal')
          ..write(')'))
        .toString();
  }
}

class $CuestionariosTable extends Cuestionarios
    with TableInfo<$CuestionariosTable, Cuestionario> {
  final GeneratedDatabase _db;
  final String? _alias;
  $CuestionariosTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _tipoDeInspeccionMeta =
      const VerificationMeta('tipoDeInspeccion');
  late final GeneratedColumn<String?> tipoDeInspeccion =
      GeneratedColumn<String?>('tipo_de_inspeccion', aliasedName, false,
          typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _estadoMeta = const VerificationMeta('estado');
  late final GeneratedColumnWithTypeConverter<EstadoDeCuestionario, int?>
      estado = GeneratedColumn<int?>('estado', aliasedName, false,
              typeName: 'INTEGER', requiredDuringInsert: true)
          .withConverter<EstadoDeCuestionario>($CuestionariosTable.$converter0);
  final VerificationMeta _esLocalMeta = const VerificationMeta('esLocal');
  late final GeneratedColumn<bool?> esLocal = GeneratedColumn<bool?>(
      'es_local', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (es_local IN (0, 1))',
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [id, tipoDeInspeccion, estado, esLocal];
  @override
  String get aliasedName => _alias ?? 'cuestionarios';
  @override
  String get actualTableName => 'cuestionarios';
  @override
  VerificationContext validateIntegrity(Insertable<Cuestionario> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tipo_de_inspeccion')) {
      context.handle(
          _tipoDeInspeccionMeta,
          tipoDeInspeccion.isAcceptableOrUnknown(
              data['tipo_de_inspeccion']!, _tipoDeInspeccionMeta));
    } else if (isInserting) {
      context.missing(_tipoDeInspeccionMeta);
    }
    context.handle(_estadoMeta, const VerificationResult.success());
    if (data.containsKey('es_local')) {
      context.handle(_esLocalMeta,
          esLocal.isAcceptableOrUnknown(data['es_local']!, _esLocalMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Cuestionario map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Cuestionario.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $CuestionariosTable createAlias(String alias) {
    return $CuestionariosTable(_db, alias);
  }

  static TypeConverter<EstadoDeCuestionario, int> $converter0 =
      const EnumIndexConverter<EstadoDeCuestionario>(
          EstadoDeCuestionario.values);
}

class Bloque extends DataClass implements Insertable<Bloque> {
  final int id;

  /// Indica la posición en el cuestionario iniciando desde 0
  final int nOrden;
  final int cuestionarioId;
  Bloque(
      {required this.id, required this.nOrden, required this.cuestionarioId});
  factory Bloque.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Bloque(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      nOrden: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}n_orden'])!,
      cuestionarioId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cuestionario_id'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['n_orden'] = Variable<int>(nOrden);
    map['cuestionario_id'] = Variable<int>(cuestionarioId);
    return map;
  }

  BloquesCompanion toCompanion(bool nullToAbsent) {
    return BloquesCompanion(
      id: Value(id),
      nOrden: Value(nOrden),
      cuestionarioId: Value(cuestionarioId),
    );
  }

  factory Bloque.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Bloque(
      id: serializer.fromJson<int>(json['id']),
      nOrden: serializer.fromJson<int>(json['nOrden']),
      cuestionarioId: serializer.fromJson<int>(json['cuestionario']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nOrden': serializer.toJson<int>(nOrden),
      'cuestionario': serializer.toJson<int>(cuestionarioId),
    };
  }

  Bloque copyWith({int? id, int? nOrden, int? cuestionarioId}) => Bloque(
        id: id ?? this.id,
        nOrden: nOrden ?? this.nOrden,
        cuestionarioId: cuestionarioId ?? this.cuestionarioId,
      );
  @override
  String toString() {
    return (StringBuffer('Bloque(')
          ..write('id: $id, ')
          ..write('nOrden: $nOrden, ')
          ..write('cuestionarioId: $cuestionarioId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf(
      $mrjc(id.hashCode, $mrjc(nOrden.hashCode, cuestionarioId.hashCode)));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bloque &&
          other.id == this.id &&
          other.nOrden == this.nOrden &&
          other.cuestionarioId == this.cuestionarioId);
}

class BloquesCompanion extends UpdateCompanion<Bloque> {
  final Value<int> id;
  final Value<int> nOrden;
  final Value<int> cuestionarioId;
  const BloquesCompanion({
    this.id = const Value.absent(),
    this.nOrden = const Value.absent(),
    this.cuestionarioId = const Value.absent(),
  });
  BloquesCompanion.insert({
    this.id = const Value.absent(),
    required int nOrden,
    required int cuestionarioId,
  })  : nOrden = Value(nOrden),
        cuestionarioId = Value(cuestionarioId);
  static Insertable<Bloque> custom({
    Expression<int>? id,
    Expression<int>? nOrden,
    Expression<int>? cuestionarioId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nOrden != null) 'n_orden': nOrden,
      if (cuestionarioId != null) 'cuestionario_id': cuestionarioId,
    });
  }

  BloquesCompanion copyWith(
      {Value<int>? id, Value<int>? nOrden, Value<int>? cuestionarioId}) {
    return BloquesCompanion(
      id: id ?? this.id,
      nOrden: nOrden ?? this.nOrden,
      cuestionarioId: cuestionarioId ?? this.cuestionarioId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nOrden.present) {
      map['n_orden'] = Variable<int>(nOrden.value);
    }
    if (cuestionarioId.present) {
      map['cuestionario_id'] = Variable<int>(cuestionarioId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BloquesCompanion(')
          ..write('id: $id, ')
          ..write('nOrden: $nOrden, ')
          ..write('cuestionarioId: $cuestionarioId')
          ..write(')'))
        .toString();
  }
}

class $BloquesTable extends Bloques with TableInfo<$BloquesTable, Bloque> {
  final GeneratedDatabase _db;
  final String? _alias;
  $BloquesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _nOrdenMeta = const VerificationMeta('nOrden');
  late final GeneratedColumn<int?> nOrden = GeneratedColumn<int?>(
      'n_orden', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _cuestionarioIdMeta =
      const VerificationMeta('cuestionarioId');
  late final GeneratedColumn<int?> cuestionarioId = GeneratedColumn<int?>(
      'cuestionario_id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES cuestionarios(id) ON DELETE CASCADE');
  @override
  List<GeneratedColumn> get $columns => [id, nOrden, cuestionarioId];
  @override
  String get aliasedName => _alias ?? 'bloques';
  @override
  String get actualTableName => 'bloques';
  @override
  VerificationContext validateIntegrity(Insertable<Bloque> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('n_orden')) {
      context.handle(_nOrdenMeta,
          nOrden.isAcceptableOrUnknown(data['n_orden']!, _nOrdenMeta));
    } else if (isInserting) {
      context.missing(_nOrdenMeta);
    }
    if (data.containsKey('cuestionario_id')) {
      context.handle(
          _cuestionarioIdMeta,
          cuestionarioId.isAcceptableOrUnknown(
              data['cuestionario_id']!, _cuestionarioIdMeta));
    } else if (isInserting) {
      context.missing(_cuestionarioIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Bloque map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Bloque.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $BloquesTable createAlias(String alias) {
    return $BloquesTable(_db, alias);
  }
}

class Titulo extends DataClass implements Insertable<Titulo> {
  final int id;
  final String titulo;
  final String descripcion;

  /// Este campo no es usado actualmente para los titulos
  final KtList<String> fotos;
  final int bloqueId;
  Titulo(
      {required this.id,
      required this.titulo,
      required this.descripcion,
      required this.fotos,
      required this.bloqueId});
  factory Titulo.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Titulo(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      titulo: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}titulo'])!,
      descripcion: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}descripcion'])!,
      fotos: $TitulosTable.$converter0.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}fotos']))!,
      bloqueId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}bloque_id'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['titulo'] = Variable<String>(titulo);
    map['descripcion'] = Variable<String>(descripcion);
    {
      final converter = $TitulosTable.$converter0;
      map['fotos'] = Variable<String>(converter.mapToSql(fotos)!);
    }
    map['bloque_id'] = Variable<int>(bloqueId);
    return map;
  }

  TitulosCompanion toCompanion(bool nullToAbsent) {
    return TitulosCompanion(
      id: Value(id),
      titulo: Value(titulo),
      descripcion: Value(descripcion),
      fotos: Value(fotos),
      bloqueId: Value(bloqueId),
    );
  }

  factory Titulo.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Titulo(
      id: serializer.fromJson<int>(json['id']),
      titulo: serializer.fromJson<String>(json['titulo']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      fotos: serializer.fromJson<KtList<String>>(json['fotos']),
      bloqueId: serializer.fromJson<int>(json['bloque']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'titulo': serializer.toJson<String>(titulo),
      'descripcion': serializer.toJson<String>(descripcion),
      'fotos': serializer.toJson<KtList<String>>(fotos),
      'bloque': serializer.toJson<int>(bloqueId),
    };
  }

  Titulo copyWith(
          {int? id,
          String? titulo,
          String? descripcion,
          KtList<String>? fotos,
          int? bloqueId}) =>
      Titulo(
        id: id ?? this.id,
        titulo: titulo ?? this.titulo,
        descripcion: descripcion ?? this.descripcion,
        fotos: fotos ?? this.fotos,
        bloqueId: bloqueId ?? this.bloqueId,
      );
  @override
  String toString() {
    return (StringBuffer('Titulo(')
          ..write('id: $id, ')
          ..write('titulo: $titulo, ')
          ..write('descripcion: $descripcion, ')
          ..write('fotos: $fotos, ')
          ..write('bloqueId: $bloqueId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          titulo.hashCode,
          $mrjc(descripcion.hashCode,
              $mrjc(fotos.hashCode, bloqueId.hashCode)))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Titulo &&
          other.id == this.id &&
          other.titulo == this.titulo &&
          other.descripcion == this.descripcion &&
          other.fotos == this.fotos &&
          other.bloqueId == this.bloqueId);
}

class TitulosCompanion extends UpdateCompanion<Titulo> {
  final Value<int> id;
  final Value<String> titulo;
  final Value<String> descripcion;
  final Value<KtList<String>> fotos;
  final Value<int> bloqueId;
  const TitulosCompanion({
    this.id = const Value.absent(),
    this.titulo = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.fotos = const Value.absent(),
    this.bloqueId = const Value.absent(),
  });
  TitulosCompanion.insert({
    this.id = const Value.absent(),
    required String titulo,
    required String descripcion,
    this.fotos = const Value.absent(),
    required int bloqueId,
  })  : titulo = Value(titulo),
        descripcion = Value(descripcion),
        bloqueId = Value(bloqueId);
  static Insertable<Titulo> custom({
    Expression<int>? id,
    Expression<String>? titulo,
    Expression<String>? descripcion,
    Expression<KtList<String>>? fotos,
    Expression<int>? bloqueId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (titulo != null) 'titulo': titulo,
      if (descripcion != null) 'descripcion': descripcion,
      if (fotos != null) 'fotos': fotos,
      if (bloqueId != null) 'bloque_id': bloqueId,
    });
  }

  TitulosCompanion copyWith(
      {Value<int>? id,
      Value<String>? titulo,
      Value<String>? descripcion,
      Value<KtList<String>>? fotos,
      Value<int>? bloqueId}) {
    return TitulosCompanion(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      fotos: fotos ?? this.fotos,
      bloqueId: bloqueId ?? this.bloqueId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (titulo.present) {
      map['titulo'] = Variable<String>(titulo.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (fotos.present) {
      final converter = $TitulosTable.$converter0;
      map['fotos'] = Variable<String>(converter.mapToSql(fotos.value)!);
    }
    if (bloqueId.present) {
      map['bloque_id'] = Variable<int>(bloqueId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TitulosCompanion(')
          ..write('id: $id, ')
          ..write('titulo: $titulo, ')
          ..write('descripcion: $descripcion, ')
          ..write('fotos: $fotos, ')
          ..write('bloqueId: $bloqueId')
          ..write(')'))
        .toString();
  }
}

class $TitulosTable extends Titulos with TableInfo<$TitulosTable, Titulo> {
  final GeneratedDatabase _db;
  final String? _alias;
  $TitulosTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _tituloMeta = const VerificationMeta('titulo');
  late final GeneratedColumn<String?> titulo = GeneratedColumn<String?>(
      'titulo', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      typeName: 'TEXT',
      requiredDuringInsert: true);
  final VerificationMeta _descripcionMeta =
      const VerificationMeta('descripcion');
  late final GeneratedColumn<String?> descripcion = GeneratedColumn<String?>(
      'descripcion', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(
          minTextLength: 0, maxTextLength: 1500),
      typeName: 'TEXT',
      requiredDuringInsert: true);
  final VerificationMeta _fotosMeta = const VerificationMeta('fotos');
  late final GeneratedColumnWithTypeConverter<KtList<String>, String?> fotos =
      GeneratedColumn<String?>('fotos', aliasedName, false,
              typeName: 'TEXT',
              requiredDuringInsert: false,
              defaultValue: const Constant("[]"))
          .withConverter<KtList<String>>($TitulosTable.$converter0);
  final VerificationMeta _bloqueIdMeta = const VerificationMeta('bloqueId');
  late final GeneratedColumn<int?> bloqueId = GeneratedColumn<int?>(
      'bloque_id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES bloques(id) ON DELETE CASCADE');
  @override
  List<GeneratedColumn> get $columns =>
      [id, titulo, descripcion, fotos, bloqueId];
  @override
  String get aliasedName => _alias ?? 'titulos';
  @override
  String get actualTableName => 'titulos';
  @override
  VerificationContext validateIntegrity(Insertable<Titulo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('titulo')) {
      context.handle(_tituloMeta,
          titulo.isAcceptableOrUnknown(data['titulo']!, _tituloMeta));
    } else if (isInserting) {
      context.missing(_tituloMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
          _descripcionMeta,
          descripcion.isAcceptableOrUnknown(
              data['descripcion']!, _descripcionMeta));
    } else if (isInserting) {
      context.missing(_descripcionMeta);
    }
    context.handle(_fotosMeta, const VerificationResult.success());
    if (data.containsKey('bloque_id')) {
      context.handle(_bloqueIdMeta,
          bloqueId.isAcceptableOrUnknown(data['bloque_id']!, _bloqueIdMeta));
    } else if (isInserting) {
      context.missing(_bloqueIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Titulo map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Titulo.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $TitulosTable createAlias(String alias) {
    return $TitulosTable(_db, alias);
  }

  static TypeConverter<KtList<String>, String> $converter0 =
      const ListInColumnConverter();
}

class CuadriculaDePreguntas extends DataClass
    implements Insertable<CuadriculaDePreguntas> {
  final int id;
  final String titulo;
  final String descripcion;
  final int bloqueId;
  CuadriculaDePreguntas(
      {required this.id,
      required this.titulo,
      required this.descripcion,
      required this.bloqueId});
  factory CuadriculaDePreguntas.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return CuadriculaDePreguntas(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      titulo: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}titulo'])!,
      descripcion: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}descripcion'])!,
      bloqueId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}bloque_id'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['titulo'] = Variable<String>(titulo);
    map['descripcion'] = Variable<String>(descripcion);
    map['bloque_id'] = Variable<int>(bloqueId);
    return map;
  }

  CuadriculasDePreguntasCompanion toCompanion(bool nullToAbsent) {
    return CuadriculasDePreguntasCompanion(
      id: Value(id),
      titulo: Value(titulo),
      descripcion: Value(descripcion),
      bloqueId: Value(bloqueId),
    );
  }

  factory CuadriculaDePreguntas.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return CuadriculaDePreguntas(
      id: serializer.fromJson<int>(json['id']),
      titulo: serializer.fromJson<String>(json['titulo']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      bloqueId: serializer.fromJson<int>(json['bloque']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'titulo': serializer.toJson<String>(titulo),
      'descripcion': serializer.toJson<String>(descripcion),
      'bloque': serializer.toJson<int>(bloqueId),
    };
  }

  CuadriculaDePreguntas copyWith(
          {int? id, String? titulo, String? descripcion, int? bloqueId}) =>
      CuadriculaDePreguntas(
        id: id ?? this.id,
        titulo: titulo ?? this.titulo,
        descripcion: descripcion ?? this.descripcion,
        bloqueId: bloqueId ?? this.bloqueId,
      );
  @override
  String toString() {
    return (StringBuffer('CuadriculaDePreguntas(')
          ..write('id: $id, ')
          ..write('titulo: $titulo, ')
          ..write('descripcion: $descripcion, ')
          ..write('bloqueId: $bloqueId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(titulo.hashCode, $mrjc(descripcion.hashCode, bloqueId.hashCode))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CuadriculaDePreguntas &&
          other.id == this.id &&
          other.titulo == this.titulo &&
          other.descripcion == this.descripcion &&
          other.bloqueId == this.bloqueId);
}

class CuadriculasDePreguntasCompanion
    extends UpdateCompanion<CuadriculaDePreguntas> {
  final Value<int> id;
  final Value<String> titulo;
  final Value<String> descripcion;
  final Value<int> bloqueId;
  const CuadriculasDePreguntasCompanion({
    this.id = const Value.absent(),
    this.titulo = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.bloqueId = const Value.absent(),
  });
  CuadriculasDePreguntasCompanion.insert({
    this.id = const Value.absent(),
    required String titulo,
    required String descripcion,
    required int bloqueId,
  })  : titulo = Value(titulo),
        descripcion = Value(descripcion),
        bloqueId = Value(bloqueId);
  static Insertable<CuadriculaDePreguntas> custom({
    Expression<int>? id,
    Expression<String>? titulo,
    Expression<String>? descripcion,
    Expression<int>? bloqueId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (titulo != null) 'titulo': titulo,
      if (descripcion != null) 'descripcion': descripcion,
      if (bloqueId != null) 'bloque_id': bloqueId,
    });
  }

  CuadriculasDePreguntasCompanion copyWith(
      {Value<int>? id,
      Value<String>? titulo,
      Value<String>? descripcion,
      Value<int>? bloqueId}) {
    return CuadriculasDePreguntasCompanion(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      bloqueId: bloqueId ?? this.bloqueId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (titulo.present) {
      map['titulo'] = Variable<String>(titulo.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (bloqueId.present) {
      map['bloque_id'] = Variable<int>(bloqueId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CuadriculasDePreguntasCompanion(')
          ..write('id: $id, ')
          ..write('titulo: $titulo, ')
          ..write('descripcion: $descripcion, ')
          ..write('bloqueId: $bloqueId')
          ..write(')'))
        .toString();
  }
}

class $CuadriculasDePreguntasTable extends CuadriculasDePreguntas
    with TableInfo<$CuadriculasDePreguntasTable, CuadriculaDePreguntas> {
  final GeneratedDatabase _db;
  final String? _alias;
  $CuadriculasDePreguntasTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _tituloMeta = const VerificationMeta('titulo');
  late final GeneratedColumn<String?> titulo = GeneratedColumn<String?>(
      'titulo', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 100),
      typeName: 'TEXT',
      requiredDuringInsert: true);
  final VerificationMeta _descripcionMeta =
      const VerificationMeta('descripcion');
  late final GeneratedColumn<String?> descripcion = GeneratedColumn<String?>(
      'descripcion', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(
          minTextLength: 0, maxTextLength: 1500),
      typeName: 'TEXT',
      requiredDuringInsert: true);
  final VerificationMeta _bloqueIdMeta = const VerificationMeta('bloqueId');
  late final GeneratedColumn<int?> bloqueId = GeneratedColumn<int?>(
      'bloque_id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      $customConstraints: 'UNIQUE REFERENCES bloques(id) ON DELETE CASCADE');
  @override
  List<GeneratedColumn> get $columns => [id, titulo, descripcion, bloqueId];
  @override
  String get aliasedName => _alias ?? 'cuadriculas_de_preguntas';
  @override
  String get actualTableName => 'cuadriculas_de_preguntas';
  @override
  VerificationContext validateIntegrity(
      Insertable<CuadriculaDePreguntas> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('titulo')) {
      context.handle(_tituloMeta,
          titulo.isAcceptableOrUnknown(data['titulo']!, _tituloMeta));
    } else if (isInserting) {
      context.missing(_tituloMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
          _descripcionMeta,
          descripcion.isAcceptableOrUnknown(
              data['descripcion']!, _descripcionMeta));
    } else if (isInserting) {
      context.missing(_descripcionMeta);
    }
    if (data.containsKey('bloque_id')) {
      context.handle(_bloqueIdMeta,
          bloqueId.isAcceptableOrUnknown(data['bloque_id']!, _bloqueIdMeta));
    } else if (isInserting) {
      context.missing(_bloqueIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CuadriculaDePreguntas map(Map<String, dynamic> data, {String? tablePrefix}) {
    return CuadriculaDePreguntas.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $CuadriculasDePreguntasTable createAlias(String alias) {
    return $CuadriculasDePreguntasTable(_db, alias);
  }
}

class Pregunta extends DataClass implements Insertable<Pregunta> {
  final int id;
  final String titulo;
  final String descripcion;
  final int criticidad;

  /// Atributo usado para información al inspector. Indica a que posición del vehiculo hace referencia la pregunta.
  final String? eje;
  final String? posicionZ;
  final String? lado;
  final KtList<String> fotosGuia;

  /// Campo usado paraa preguntas que activan otras dependiendo de laa respuesta.
  final bool esCondicional;
  final int? sistemaId;
  final int bloqueId;
  final int? subSistemaId;
  final TipoDePregunta tipo;
  Pregunta(
      {required this.id,
      required this.titulo,
      required this.descripcion,
      required this.criticidad,
      this.eje,
      this.posicionZ,
      this.lado,
      required this.fotosGuia,
      required this.esCondicional,
      this.sistemaId,
      required this.bloqueId,
      this.subSistemaId,
      required this.tipo});
  factory Pregunta.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Pregunta(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      titulo: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}titulo'])!,
      descripcion: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}descripcion'])!,
      criticidad: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}criticidad'])!,
      eje: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}eje']),
      posicionZ: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}posicion_z']),
      lado: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}lado']),
      fotosGuia: $PreguntasTable.$converter0.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}fotos_guia']))!,
      esCondicional: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}es_condicional'])!,
      sistemaId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}sistema_id']),
      bloqueId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}bloque_id'])!,
      subSistemaId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}sub_sistema_id']),
      tipo: $PreguntasTable.$converter1.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}tipo']))!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['titulo'] = Variable<String>(titulo);
    map['descripcion'] = Variable<String>(descripcion);
    map['criticidad'] = Variable<int>(criticidad);
    if (!nullToAbsent || eje != null) {
      map['eje'] = Variable<String?>(eje);
    }
    if (!nullToAbsent || posicionZ != null) {
      map['posicion_z'] = Variable<String?>(posicionZ);
    }
    if (!nullToAbsent || lado != null) {
      map['lado'] = Variable<String?>(lado);
    }
    {
      final converter = $PreguntasTable.$converter0;
      map['fotos_guia'] = Variable<String>(converter.mapToSql(fotosGuia)!);
    }
    map['es_condicional'] = Variable<bool>(esCondicional);
    if (!nullToAbsent || sistemaId != null) {
      map['sistema_id'] = Variable<int?>(sistemaId);
    }
    map['bloque_id'] = Variable<int>(bloqueId);
    if (!nullToAbsent || subSistemaId != null) {
      map['sub_sistema_id'] = Variable<int?>(subSistemaId);
    }
    {
      final converter = $PreguntasTable.$converter1;
      map['tipo'] = Variable<int>(converter.mapToSql(tipo)!);
    }
    return map;
  }

  PreguntasCompanion toCompanion(bool nullToAbsent) {
    return PreguntasCompanion(
      id: Value(id),
      titulo: Value(titulo),
      descripcion: Value(descripcion),
      criticidad: Value(criticidad),
      eje: eje == null && nullToAbsent ? const Value.absent() : Value(eje),
      posicionZ: posicionZ == null && nullToAbsent
          ? const Value.absent()
          : Value(posicionZ),
      lado: lado == null && nullToAbsent ? const Value.absent() : Value(lado),
      fotosGuia: Value(fotosGuia),
      esCondicional: Value(esCondicional),
      sistemaId: sistemaId == null && nullToAbsent
          ? const Value.absent()
          : Value(sistemaId),
      bloqueId: Value(bloqueId),
      subSistemaId: subSistemaId == null && nullToAbsent
          ? const Value.absent()
          : Value(subSistemaId),
      tipo: Value(tipo),
    );
  }

  factory Pregunta.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Pregunta(
      id: serializer.fromJson<int>(json['id']),
      titulo: serializer.fromJson<String>(json['titulo']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      criticidad: serializer.fromJson<int>(json['criticidad']),
      eje: serializer.fromJson<String?>(json['eje']),
      posicionZ: serializer.fromJson<String?>(json['posicionZ']),
      lado: serializer.fromJson<String?>(json['lado']),
      fotosGuia: serializer.fromJson<KtList<String>>(json['fotosGuia']),
      esCondicional: serializer.fromJson<bool>(json['esCondicional']),
      sistemaId: serializer.fromJson<int?>(json['sistema']),
      bloqueId: serializer.fromJson<int>(json['bloque']),
      subSistemaId: serializer.fromJson<int?>(json['subSistema']),
      tipo: serializer.fromJson<TipoDePregunta>(json['tipo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'titulo': serializer.toJson<String>(titulo),
      'descripcion': serializer.toJson<String>(descripcion),
      'criticidad': serializer.toJson<int>(criticidad),
      'eje': serializer.toJson<String?>(eje),
      'posicionZ': serializer.toJson<String?>(posicionZ),
      'lado': serializer.toJson<String?>(lado),
      'fotosGuia': serializer.toJson<KtList<String>>(fotosGuia),
      'esCondicional': serializer.toJson<bool>(esCondicional),
      'sistema': serializer.toJson<int?>(sistemaId),
      'bloque': serializer.toJson<int>(bloqueId),
      'subSistema': serializer.toJson<int?>(subSistemaId),
      'tipo': serializer.toJson<TipoDePregunta>(tipo),
    };
  }

  Pregunta copyWith(
          {int? id,
          String? titulo,
          String? descripcion,
          int? criticidad,
          String? eje,
          String? posicionZ,
          String? lado,
          KtList<String>? fotosGuia,
          bool? esCondicional,
          int? sistemaId,
          int? bloqueId,
          int? subSistemaId,
          TipoDePregunta? tipo}) =>
      Pregunta(
        id: id ?? this.id,
        titulo: titulo ?? this.titulo,
        descripcion: descripcion ?? this.descripcion,
        criticidad: criticidad ?? this.criticidad,
        eje: eje ?? this.eje,
        posicionZ: posicionZ ?? this.posicionZ,
        lado: lado ?? this.lado,
        fotosGuia: fotosGuia ?? this.fotosGuia,
        esCondicional: esCondicional ?? this.esCondicional,
        sistemaId: sistemaId ?? this.sistemaId,
        bloqueId: bloqueId ?? this.bloqueId,
        subSistemaId: subSistemaId ?? this.subSistemaId,
        tipo: tipo ?? this.tipo,
      );
  @override
  String toString() {
    return (StringBuffer('Pregunta(')
          ..write('id: $id, ')
          ..write('titulo: $titulo, ')
          ..write('descripcion: $descripcion, ')
          ..write('criticidad: $criticidad, ')
          ..write('eje: $eje, ')
          ..write('posicionZ: $posicionZ, ')
          ..write('lado: $lado, ')
          ..write('fotosGuia: $fotosGuia, ')
          ..write('esCondicional: $esCondicional, ')
          ..write('sistemaId: $sistemaId, ')
          ..write('bloqueId: $bloqueId, ')
          ..write('subSistemaId: $subSistemaId, ')
          ..write('tipo: $tipo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          titulo.hashCode,
          $mrjc(
              descripcion.hashCode,
              $mrjc(
                  criticidad.hashCode,
                  $mrjc(
                      eje.hashCode,
                      $mrjc(
                          posicionZ.hashCode,
                          $mrjc(
                              lado.hashCode,
                              $mrjc(
                                  fotosGuia.hashCode,
                                  $mrjc(
                                      esCondicional.hashCode,
                                      $mrjc(
                                          sistemaId.hashCode,
                                          $mrjc(
                                              bloqueId.hashCode,
                                              $mrjc(subSistemaId.hashCode,
                                                  tipo.hashCode)))))))))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Pregunta &&
          other.id == this.id &&
          other.titulo == this.titulo &&
          other.descripcion == this.descripcion &&
          other.criticidad == this.criticidad &&
          other.eje == this.eje &&
          other.posicionZ == this.posicionZ &&
          other.lado == this.lado &&
          other.fotosGuia == this.fotosGuia &&
          other.esCondicional == this.esCondicional &&
          other.sistemaId == this.sistemaId &&
          other.bloqueId == this.bloqueId &&
          other.subSistemaId == this.subSistemaId &&
          other.tipo == this.tipo);
}

class PreguntasCompanion extends UpdateCompanion<Pregunta> {
  final Value<int> id;
  final Value<String> titulo;
  final Value<String> descripcion;
  final Value<int> criticidad;
  final Value<String?> eje;
  final Value<String?> posicionZ;
  final Value<String?> lado;
  final Value<KtList<String>> fotosGuia;
  final Value<bool> esCondicional;
  final Value<int?> sistemaId;
  final Value<int> bloqueId;
  final Value<int?> subSistemaId;
  final Value<TipoDePregunta> tipo;
  const PreguntasCompanion({
    this.id = const Value.absent(),
    this.titulo = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.criticidad = const Value.absent(),
    this.eje = const Value.absent(),
    this.posicionZ = const Value.absent(),
    this.lado = const Value.absent(),
    this.fotosGuia = const Value.absent(),
    this.esCondicional = const Value.absent(),
    this.sistemaId = const Value.absent(),
    this.bloqueId = const Value.absent(),
    this.subSistemaId = const Value.absent(),
    this.tipo = const Value.absent(),
  });
  PreguntasCompanion.insert({
    this.id = const Value.absent(),
    required String titulo,
    required String descripcion,
    required int criticidad,
    this.eje = const Value.absent(),
    this.posicionZ = const Value.absent(),
    this.lado = const Value.absent(),
    this.fotosGuia = const Value.absent(),
    this.esCondicional = const Value.absent(),
    this.sistemaId = const Value.absent(),
    required int bloqueId,
    this.subSistemaId = const Value.absent(),
    required TipoDePregunta tipo,
  })  : titulo = Value(titulo),
        descripcion = Value(descripcion),
        criticidad = Value(criticidad),
        bloqueId = Value(bloqueId),
        tipo = Value(tipo);
  static Insertable<Pregunta> custom({
    Expression<int>? id,
    Expression<String>? titulo,
    Expression<String>? descripcion,
    Expression<int>? criticidad,
    Expression<String?>? eje,
    Expression<String?>? posicionZ,
    Expression<String?>? lado,
    Expression<KtList<String>>? fotosGuia,
    Expression<bool>? esCondicional,
    Expression<int?>? sistemaId,
    Expression<int>? bloqueId,
    Expression<int?>? subSistemaId,
    Expression<TipoDePregunta>? tipo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (titulo != null) 'titulo': titulo,
      if (descripcion != null) 'descripcion': descripcion,
      if (criticidad != null) 'criticidad': criticidad,
      if (eje != null) 'eje': eje,
      if (posicionZ != null) 'posicion_z': posicionZ,
      if (lado != null) 'lado': lado,
      if (fotosGuia != null) 'fotos_guia': fotosGuia,
      if (esCondicional != null) 'es_condicional': esCondicional,
      if (sistemaId != null) 'sistema_id': sistemaId,
      if (bloqueId != null) 'bloque_id': bloqueId,
      if (subSistemaId != null) 'sub_sistema_id': subSistemaId,
      if (tipo != null) 'tipo': tipo,
    });
  }

  PreguntasCompanion copyWith(
      {Value<int>? id,
      Value<String>? titulo,
      Value<String>? descripcion,
      Value<int>? criticidad,
      Value<String?>? eje,
      Value<String?>? posicionZ,
      Value<String?>? lado,
      Value<KtList<String>>? fotosGuia,
      Value<bool>? esCondicional,
      Value<int?>? sistemaId,
      Value<int>? bloqueId,
      Value<int?>? subSistemaId,
      Value<TipoDePregunta>? tipo}) {
    return PreguntasCompanion(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      criticidad: criticidad ?? this.criticidad,
      eje: eje ?? this.eje,
      posicionZ: posicionZ ?? this.posicionZ,
      lado: lado ?? this.lado,
      fotosGuia: fotosGuia ?? this.fotosGuia,
      esCondicional: esCondicional ?? this.esCondicional,
      sistemaId: sistemaId ?? this.sistemaId,
      bloqueId: bloqueId ?? this.bloqueId,
      subSistemaId: subSistemaId ?? this.subSistemaId,
      tipo: tipo ?? this.tipo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (titulo.present) {
      map['titulo'] = Variable<String>(titulo.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (criticidad.present) {
      map['criticidad'] = Variable<int>(criticidad.value);
    }
    if (eje.present) {
      map['eje'] = Variable<String?>(eje.value);
    }
    if (posicionZ.present) {
      map['posicion_z'] = Variable<String?>(posicionZ.value);
    }
    if (lado.present) {
      map['lado'] = Variable<String?>(lado.value);
    }
    if (fotosGuia.present) {
      final converter = $PreguntasTable.$converter0;
      map['fotos_guia'] =
          Variable<String>(converter.mapToSql(fotosGuia.value)!);
    }
    if (esCondicional.present) {
      map['es_condicional'] = Variable<bool>(esCondicional.value);
    }
    if (sistemaId.present) {
      map['sistema_id'] = Variable<int?>(sistemaId.value);
    }
    if (bloqueId.present) {
      map['bloque_id'] = Variable<int>(bloqueId.value);
    }
    if (subSistemaId.present) {
      map['sub_sistema_id'] = Variable<int?>(subSistemaId.value);
    }
    if (tipo.present) {
      final converter = $PreguntasTable.$converter1;
      map['tipo'] = Variable<int>(converter.mapToSql(tipo.value)!);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreguntasCompanion(')
          ..write('id: $id, ')
          ..write('titulo: $titulo, ')
          ..write('descripcion: $descripcion, ')
          ..write('criticidad: $criticidad, ')
          ..write('eje: $eje, ')
          ..write('posicionZ: $posicionZ, ')
          ..write('lado: $lado, ')
          ..write('fotosGuia: $fotosGuia, ')
          ..write('esCondicional: $esCondicional, ')
          ..write('sistemaId: $sistemaId, ')
          ..write('bloqueId: $bloqueId, ')
          ..write('subSistemaId: $subSistemaId, ')
          ..write('tipo: $tipo')
          ..write(')'))
        .toString();
  }
}

class $PreguntasTable extends Preguntas
    with TableInfo<$PreguntasTable, Pregunta> {
  final GeneratedDatabase _db;
  final String? _alias;
  $PreguntasTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _tituloMeta = const VerificationMeta('titulo');
  late final GeneratedColumn<String?> titulo = GeneratedColumn<String?>(
      'titulo', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      typeName: 'TEXT',
      requiredDuringInsert: true);
  final VerificationMeta _descripcionMeta =
      const VerificationMeta('descripcion');
  late final GeneratedColumn<String?> descripcion = GeneratedColumn<String?>(
      'descripcion', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(
          minTextLength: 0, maxTextLength: 1500),
      typeName: 'TEXT',
      requiredDuringInsert: true);
  final VerificationMeta _criticidadMeta = const VerificationMeta('criticidad');
  late final GeneratedColumn<int?> criticidad = GeneratedColumn<int?>(
      'criticidad', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _ejeMeta = const VerificationMeta('eje');
  late final GeneratedColumn<String?> eje = GeneratedColumn<String?>(
      'eje', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 50),
      typeName: 'TEXT',
      requiredDuringInsert: false);
  final VerificationMeta _posicionZMeta = const VerificationMeta('posicionZ');
  late final GeneratedColumn<String?> posicionZ = GeneratedColumn<String?>(
      'posicion_z', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 50),
      typeName: 'TEXT',
      requiredDuringInsert: false);
  final VerificationMeta _ladoMeta = const VerificationMeta('lado');
  late final GeneratedColumn<String?> lado = GeneratedColumn<String?>(
      'lado', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 50),
      typeName: 'TEXT',
      requiredDuringInsert: false);
  final VerificationMeta _fotosGuiaMeta = const VerificationMeta('fotosGuia');
  late final GeneratedColumnWithTypeConverter<KtList<String>, String?>
      fotosGuia = GeneratedColumn<String?>('fotos_guia', aliasedName, false,
              typeName: 'TEXT',
              requiredDuringInsert: false,
              defaultValue: const Constant("[]"))
          .withConverter<KtList<String>>($PreguntasTable.$converter0);
  final VerificationMeta _esCondicionalMeta =
      const VerificationMeta('esCondicional');
  late final GeneratedColumn<bool?> esCondicional = GeneratedColumn<bool?>(
      'es_condicional', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (es_condicional IN (0, 1))',
      defaultValue: const Constant(false));
  final VerificationMeta _sistemaIdMeta = const VerificationMeta('sistemaId');
  late final GeneratedColumn<int?> sistemaId = GeneratedColumn<int?>(
      'sistema_id', aliasedName, true,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      $customConstraints: 'REFERENCES sistemas(id)');
  final VerificationMeta _bloqueIdMeta = const VerificationMeta('bloqueId');
  late final GeneratedColumn<int?> bloqueId = GeneratedColumn<int?>(
      'bloque_id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES bloques(id) ON DELETE CASCADE');
  final VerificationMeta _subSistemaIdMeta =
      const VerificationMeta('subSistemaId');
  late final GeneratedColumn<int?> subSistemaId = GeneratedColumn<int?>(
      'sub_sistema_id', aliasedName, true,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      $customConstraints: 'REFERENCES sub_sistemas(id)');
  final VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  late final GeneratedColumnWithTypeConverter<TipoDePregunta, int?> tipo =
      GeneratedColumn<int?>('tipo', aliasedName, false,
              typeName: 'INTEGER', requiredDuringInsert: true)
          .withConverter<TipoDePregunta>($PreguntasTable.$converter1);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        titulo,
        descripcion,
        criticidad,
        eje,
        posicionZ,
        lado,
        fotosGuia,
        esCondicional,
        sistemaId,
        bloqueId,
        subSistemaId,
        tipo
      ];
  @override
  String get aliasedName => _alias ?? 'preguntas';
  @override
  String get actualTableName => 'preguntas';
  @override
  VerificationContext validateIntegrity(Insertable<Pregunta> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('titulo')) {
      context.handle(_tituloMeta,
          titulo.isAcceptableOrUnknown(data['titulo']!, _tituloMeta));
    } else if (isInserting) {
      context.missing(_tituloMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
          _descripcionMeta,
          descripcion.isAcceptableOrUnknown(
              data['descripcion']!, _descripcionMeta));
    } else if (isInserting) {
      context.missing(_descripcionMeta);
    }
    if (data.containsKey('criticidad')) {
      context.handle(
          _criticidadMeta,
          criticidad.isAcceptableOrUnknown(
              data['criticidad']!, _criticidadMeta));
    } else if (isInserting) {
      context.missing(_criticidadMeta);
    }
    if (data.containsKey('eje')) {
      context.handle(
          _ejeMeta, eje.isAcceptableOrUnknown(data['eje']!, _ejeMeta));
    }
    if (data.containsKey('posicion_z')) {
      context.handle(_posicionZMeta,
          posicionZ.isAcceptableOrUnknown(data['posicion_z']!, _posicionZMeta));
    }
    if (data.containsKey('lado')) {
      context.handle(
          _ladoMeta, lado.isAcceptableOrUnknown(data['lado']!, _ladoMeta));
    }
    context.handle(_fotosGuiaMeta, const VerificationResult.success());
    if (data.containsKey('es_condicional')) {
      context.handle(
          _esCondicionalMeta,
          esCondicional.isAcceptableOrUnknown(
              data['es_condicional']!, _esCondicionalMeta));
    }
    if (data.containsKey('sistema_id')) {
      context.handle(_sistemaIdMeta,
          sistemaId.isAcceptableOrUnknown(data['sistema_id']!, _sistemaIdMeta));
    }
    if (data.containsKey('bloque_id')) {
      context.handle(_bloqueIdMeta,
          bloqueId.isAcceptableOrUnknown(data['bloque_id']!, _bloqueIdMeta));
    } else if (isInserting) {
      context.missing(_bloqueIdMeta);
    }
    if (data.containsKey('sub_sistema_id')) {
      context.handle(
          _subSistemaIdMeta,
          subSistemaId.isAcceptableOrUnknown(
              data['sub_sistema_id']!, _subSistemaIdMeta));
    }
    context.handle(_tipoMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Pregunta map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Pregunta.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $PreguntasTable createAlias(String alias) {
    return $PreguntasTable(_db, alias);
  }

  static TypeConverter<KtList<String>, String> $converter0 =
      const ListInColumnConverter();
  static TypeConverter<TipoDePregunta, int> $converter1 =
      const EnumIndexConverter<TipoDePregunta>(TipoDePregunta.values);
}

class OpcionDeRespuesta extends DataClass
    implements Insertable<OpcionDeRespuesta> {
  final int id;

  ///uno de estos 2 debe ser no nulo.
  final int? preguntaId;
  final int? cuadriculaId;

  /// Si el inspector puede asignar un nivel de gravedad a la respuesta
  final bool calificable;
  final String texto;
  final int criticidad;
  OpcionDeRespuesta(
      {required this.id,
      this.preguntaId,
      this.cuadriculaId,
      required this.calificable,
      required this.texto,
      required this.criticidad});
  factory OpcionDeRespuesta.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return OpcionDeRespuesta(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      preguntaId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}pregunta_id']),
      cuadriculaId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cuadricula_id']),
      calificable: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}calificable'])!,
      texto: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}texto'])!,
      criticidad: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}criticidad'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || preguntaId != null) {
      map['pregunta_id'] = Variable<int?>(preguntaId);
    }
    if (!nullToAbsent || cuadriculaId != null) {
      map['cuadricula_id'] = Variable<int?>(cuadriculaId);
    }
    map['calificable'] = Variable<bool>(calificable);
    map['texto'] = Variable<String>(texto);
    map['criticidad'] = Variable<int>(criticidad);
    return map;
  }

  OpcionesDeRespuestaCompanion toCompanion(bool nullToAbsent) {
    return OpcionesDeRespuestaCompanion(
      id: Value(id),
      preguntaId: preguntaId == null && nullToAbsent
          ? const Value.absent()
          : Value(preguntaId),
      cuadriculaId: cuadriculaId == null && nullToAbsent
          ? const Value.absent()
          : Value(cuadriculaId),
      calificable: Value(calificable),
      texto: Value(texto),
      criticidad: Value(criticidad),
    );
  }

  factory OpcionDeRespuesta.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return OpcionDeRespuesta(
      id: serializer.fromJson<int>(json['id']),
      preguntaId: serializer.fromJson<int?>(json['pregunta']),
      cuadriculaId: serializer.fromJson<int?>(json['cuadricula']),
      calificable: serializer.fromJson<bool>(json['calificable']),
      texto: serializer.fromJson<String>(json['texto']),
      criticidad: serializer.fromJson<int>(json['criticidad']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pregunta': serializer.toJson<int?>(preguntaId),
      'cuadricula': serializer.toJson<int?>(cuadriculaId),
      'calificable': serializer.toJson<bool>(calificable),
      'texto': serializer.toJson<String>(texto),
      'criticidad': serializer.toJson<int>(criticidad),
    };
  }

  OpcionDeRespuesta copyWith(
          {int? id,
          int? preguntaId,
          int? cuadriculaId,
          bool? calificable,
          String? texto,
          int? criticidad}) =>
      OpcionDeRespuesta(
        id: id ?? this.id,
        preguntaId: preguntaId ?? this.preguntaId,
        cuadriculaId: cuadriculaId ?? this.cuadriculaId,
        calificable: calificable ?? this.calificable,
        texto: texto ?? this.texto,
        criticidad: criticidad ?? this.criticidad,
      );
  @override
  String toString() {
    return (StringBuffer('OpcionDeRespuesta(')
          ..write('id: $id, ')
          ..write('preguntaId: $preguntaId, ')
          ..write('cuadriculaId: $cuadriculaId, ')
          ..write('calificable: $calificable, ')
          ..write('texto: $texto, ')
          ..write('criticidad: $criticidad')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          preguntaId.hashCode,
          $mrjc(
              cuadriculaId.hashCode,
              $mrjc(calificable.hashCode,
                  $mrjc(texto.hashCode, criticidad.hashCode))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OpcionDeRespuesta &&
          other.id == this.id &&
          other.preguntaId == this.preguntaId &&
          other.cuadriculaId == this.cuadriculaId &&
          other.calificable == this.calificable &&
          other.texto == this.texto &&
          other.criticidad == this.criticidad);
}

class OpcionesDeRespuestaCompanion extends UpdateCompanion<OpcionDeRespuesta> {
  final Value<int> id;
  final Value<int?> preguntaId;
  final Value<int?> cuadriculaId;
  final Value<bool> calificable;
  final Value<String> texto;
  final Value<int> criticidad;
  const OpcionesDeRespuestaCompanion({
    this.id = const Value.absent(),
    this.preguntaId = const Value.absent(),
    this.cuadriculaId = const Value.absent(),
    this.calificable = const Value.absent(),
    this.texto = const Value.absent(),
    this.criticidad = const Value.absent(),
  });
  OpcionesDeRespuestaCompanion.insert({
    this.id = const Value.absent(),
    this.preguntaId = const Value.absent(),
    this.cuadriculaId = const Value.absent(),
    this.calificable = const Value.absent(),
    required String texto,
    required int criticidad,
  })  : texto = Value(texto),
        criticidad = Value(criticidad);
  static Insertable<OpcionDeRespuesta> custom({
    Expression<int>? id,
    Expression<int?>? preguntaId,
    Expression<int?>? cuadriculaId,
    Expression<bool>? calificable,
    Expression<String>? texto,
    Expression<int>? criticidad,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (preguntaId != null) 'pregunta_id': preguntaId,
      if (cuadriculaId != null) 'cuadricula_id': cuadriculaId,
      if (calificable != null) 'calificable': calificable,
      if (texto != null) 'texto': texto,
      if (criticidad != null) 'criticidad': criticidad,
    });
  }

  OpcionesDeRespuestaCompanion copyWith(
      {Value<int>? id,
      Value<int?>? preguntaId,
      Value<int?>? cuadriculaId,
      Value<bool>? calificable,
      Value<String>? texto,
      Value<int>? criticidad}) {
    return OpcionesDeRespuestaCompanion(
      id: id ?? this.id,
      preguntaId: preguntaId ?? this.preguntaId,
      cuadriculaId: cuadriculaId ?? this.cuadriculaId,
      calificable: calificable ?? this.calificable,
      texto: texto ?? this.texto,
      criticidad: criticidad ?? this.criticidad,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (preguntaId.present) {
      map['pregunta_id'] = Variable<int?>(preguntaId.value);
    }
    if (cuadriculaId.present) {
      map['cuadricula_id'] = Variable<int?>(cuadriculaId.value);
    }
    if (calificable.present) {
      map['calificable'] = Variable<bool>(calificable.value);
    }
    if (texto.present) {
      map['texto'] = Variable<String>(texto.value);
    }
    if (criticidad.present) {
      map['criticidad'] = Variable<int>(criticidad.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OpcionesDeRespuestaCompanion(')
          ..write('id: $id, ')
          ..write('preguntaId: $preguntaId, ')
          ..write('cuadriculaId: $cuadriculaId, ')
          ..write('calificable: $calificable, ')
          ..write('texto: $texto, ')
          ..write('criticidad: $criticidad')
          ..write(')'))
        .toString();
  }
}

class $OpcionesDeRespuestaTable extends OpcionesDeRespuesta
    with TableInfo<$OpcionesDeRespuestaTable, OpcionDeRespuesta> {
  final GeneratedDatabase _db;
  final String? _alias;
  $OpcionesDeRespuestaTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _preguntaIdMeta = const VerificationMeta('preguntaId');
  late final GeneratedColumn<int?> preguntaId = GeneratedColumn<int?>(
      'pregunta_id', aliasedName, true,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      $customConstraints: 'REFERENCES preguntas(id) ON DELETE CASCADE');
  final VerificationMeta _cuadriculaIdMeta =
      const VerificationMeta('cuadriculaId');
  late final GeneratedColumn<int?> cuadriculaId = GeneratedColumn<int?>(
      'cuadricula_id', aliasedName, true,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      $customConstraints:
          'REFERENCES cuadriculas_de_preguntas(id) ON DELETE CASCADE');
  final VerificationMeta _calificableMeta =
      const VerificationMeta('calificable');
  late final GeneratedColumn<bool?> calificable = GeneratedColumn<bool?>(
      'calificable', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (calificable IN (0, 1))',
      defaultValue: const Constant(false));
  final VerificationMeta _textoMeta = const VerificationMeta('texto');
  late final GeneratedColumn<String?> texto = GeneratedColumn<String?>(
      'texto', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      typeName: 'TEXT',
      requiredDuringInsert: true);
  final VerificationMeta _criticidadMeta = const VerificationMeta('criticidad');
  late final GeneratedColumn<int?> criticidad = GeneratedColumn<int?>(
      'criticidad', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, preguntaId, cuadriculaId, calificable, texto, criticidad];
  @override
  String get aliasedName => _alias ?? 'opciones_de_respuesta';
  @override
  String get actualTableName => 'opciones_de_respuesta';
  @override
  VerificationContext validateIntegrity(Insertable<OpcionDeRespuesta> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pregunta_id')) {
      context.handle(
          _preguntaIdMeta,
          preguntaId.isAcceptableOrUnknown(
              data['pregunta_id']!, _preguntaIdMeta));
    }
    if (data.containsKey('cuadricula_id')) {
      context.handle(
          _cuadriculaIdMeta,
          cuadriculaId.isAcceptableOrUnknown(
              data['cuadricula_id']!, _cuadriculaIdMeta));
    }
    if (data.containsKey('calificable')) {
      context.handle(
          _calificableMeta,
          calificable.isAcceptableOrUnknown(
              data['calificable']!, _calificableMeta));
    }
    if (data.containsKey('texto')) {
      context.handle(
          _textoMeta, texto.isAcceptableOrUnknown(data['texto']!, _textoMeta));
    } else if (isInserting) {
      context.missing(_textoMeta);
    }
    if (data.containsKey('criticidad')) {
      context.handle(
          _criticidadMeta,
          criticidad.isAcceptableOrUnknown(
              data['criticidad']!, _criticidadMeta));
    } else if (isInserting) {
      context.missing(_criticidadMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OpcionDeRespuesta map(Map<String, dynamic> data, {String? tablePrefix}) {
    return OpcionDeRespuesta.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $OpcionesDeRespuestaTable createAlias(String alias) {
    return $OpcionesDeRespuestaTable(_db, alias);
  }
}

class Inspeccion extends DataClass implements Insertable<Inspeccion> {
  /// Este id tiene el formato: yymmddhhmm(activoId) ver [Database.generarId()]
  final int id;
  final EstadoDeInspeccion estado;
  final double criticidadTotal;
  final double criticidadReparacion;

  /// Cuando se inicia la inspeccion
  final DateTime? momentoInicio;

  /// Se actualiza cada que se presiona guardar en el llenado
  final DateTime? momentoBorradorGuardado;

  /// Se marca solo cuando se presiona finalizar y el estado de la inspeccion es reparacion
  final DateTime? momentoFinalizacion;

  /// Nulo hasta que se envia la inspección al server
  final DateTime? momentoEnvio;
  final int cuestionarioId;
  final int activoId;

  /// Esta columna es usada en la app para saber si es creada por el usuario o la descargó del servidor
  final bool esNueva;
  Inspeccion(
      {required this.id,
      required this.estado,
      required this.criticidadTotal,
      required this.criticidadReparacion,
      this.momentoInicio,
      this.momentoBorradorGuardado,
      this.momentoFinalizacion,
      this.momentoEnvio,
      required this.cuestionarioId,
      required this.activoId,
      required this.esNueva});
  factory Inspeccion.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Inspeccion(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      estado: $InspeccionesTable.$converter0.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}estado']))!,
      criticidadTotal: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}criticidad_total'])!,
      criticidadReparacion: const RealType().mapFromDatabaseResponse(
          data['${effectivePrefix}criticidad_reparacion'])!,
      momentoInicio: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}momento_inicio']),
      momentoBorradorGuardado: const DateTimeType().mapFromDatabaseResponse(
          data['${effectivePrefix}momento_borrador_guardado']),
      momentoFinalizacion: const DateTimeType().mapFromDatabaseResponse(
          data['${effectivePrefix}momento_finalizacion']),
      momentoEnvio: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}momento_envio']),
      cuestionarioId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cuestionario_id'])!,
      activoId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}activo_id'])!,
      esNueva: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}es_nueva'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      final converter = $InspeccionesTable.$converter0;
      map['estado'] = Variable<int>(converter.mapToSql(estado)!);
    }
    map['criticidad_total'] = Variable<double>(criticidadTotal);
    map['criticidad_reparacion'] = Variable<double>(criticidadReparacion);
    if (!nullToAbsent || momentoInicio != null) {
      map['momento_inicio'] = Variable<DateTime?>(momentoInicio);
    }
    if (!nullToAbsent || momentoBorradorGuardado != null) {
      map['momento_borrador_guardado'] =
          Variable<DateTime?>(momentoBorradorGuardado);
    }
    if (!nullToAbsent || momentoFinalizacion != null) {
      map['momento_finalizacion'] = Variable<DateTime?>(momentoFinalizacion);
    }
    if (!nullToAbsent || momentoEnvio != null) {
      map['momento_envio'] = Variable<DateTime?>(momentoEnvio);
    }
    map['cuestionario_id'] = Variable<int>(cuestionarioId);
    map['activo_id'] = Variable<int>(activoId);
    map['es_nueva'] = Variable<bool>(esNueva);
    return map;
  }

  InspeccionesCompanion toCompanion(bool nullToAbsent) {
    return InspeccionesCompanion(
      id: Value(id),
      estado: Value(estado),
      criticidadTotal: Value(criticidadTotal),
      criticidadReparacion: Value(criticidadReparacion),
      momentoInicio: momentoInicio == null && nullToAbsent
          ? const Value.absent()
          : Value(momentoInicio),
      momentoBorradorGuardado: momentoBorradorGuardado == null && nullToAbsent
          ? const Value.absent()
          : Value(momentoBorradorGuardado),
      momentoFinalizacion: momentoFinalizacion == null && nullToAbsent
          ? const Value.absent()
          : Value(momentoFinalizacion),
      momentoEnvio: momentoEnvio == null && nullToAbsent
          ? const Value.absent()
          : Value(momentoEnvio),
      cuestionarioId: Value(cuestionarioId),
      activoId: Value(activoId),
      esNueva: Value(esNueva),
    );
  }

  factory Inspeccion.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Inspeccion(
      id: serializer.fromJson<int>(json['id']),
      estado: serializer.fromJson<EstadoDeInspeccion>(json['estado']),
      criticidadTotal: serializer.fromJson<double>(json['criticidadTotal']),
      criticidadReparacion:
          serializer.fromJson<double>(json['criticidadReparacion']),
      momentoInicio: serializer.fromJson<DateTime?>(json['momentoInicio']),
      momentoBorradorGuardado:
          serializer.fromJson<DateTime?>(json['momentoBorradorGuardado']),
      momentoFinalizacion:
          serializer.fromJson<DateTime?>(json['momentoFinalizacion']),
      momentoEnvio: serializer.fromJson<DateTime?>(json['momentoEnvio']),
      cuestionarioId: serializer.fromJson<int>(json['cuestionario']),
      activoId: serializer.fromJson<int>(json['activo']),
      esNueva: serializer.fromJson<bool>(json['esNueva']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'estado': serializer.toJson<EstadoDeInspeccion>(estado),
      'criticidadTotal': serializer.toJson<double>(criticidadTotal),
      'criticidadReparacion': serializer.toJson<double>(criticidadReparacion),
      'momentoInicio': serializer.toJson<DateTime?>(momentoInicio),
      'momentoBorradorGuardado':
          serializer.toJson<DateTime?>(momentoBorradorGuardado),
      'momentoFinalizacion': serializer.toJson<DateTime?>(momentoFinalizacion),
      'momentoEnvio': serializer.toJson<DateTime?>(momentoEnvio),
      'cuestionario': serializer.toJson<int>(cuestionarioId),
      'activo': serializer.toJson<int>(activoId),
      'esNueva': serializer.toJson<bool>(esNueva),
    };
  }

  Inspeccion copyWith(
          {int? id,
          EstadoDeInspeccion? estado,
          double? criticidadTotal,
          double? criticidadReparacion,
          DateTime? momentoInicio,
          DateTime? momentoBorradorGuardado,
          DateTime? momentoFinalizacion,
          DateTime? momentoEnvio,
          int? cuestionarioId,
          int? activoId,
          bool? esNueva}) =>
      Inspeccion(
        id: id ?? this.id,
        estado: estado ?? this.estado,
        criticidadTotal: criticidadTotal ?? this.criticidadTotal,
        criticidadReparacion: criticidadReparacion ?? this.criticidadReparacion,
        momentoInicio: momentoInicio ?? this.momentoInicio,
        momentoBorradorGuardado:
            momentoBorradorGuardado ?? this.momentoBorradorGuardado,
        momentoFinalizacion: momentoFinalizacion ?? this.momentoFinalizacion,
        momentoEnvio: momentoEnvio ?? this.momentoEnvio,
        cuestionarioId: cuestionarioId ?? this.cuestionarioId,
        activoId: activoId ?? this.activoId,
        esNueva: esNueva ?? this.esNueva,
      );
  @override
  String toString() {
    return (StringBuffer('Inspeccion(')
          ..write('id: $id, ')
          ..write('estado: $estado, ')
          ..write('criticidadTotal: $criticidadTotal, ')
          ..write('criticidadReparacion: $criticidadReparacion, ')
          ..write('momentoInicio: $momentoInicio, ')
          ..write('momentoBorradorGuardado: $momentoBorradorGuardado, ')
          ..write('momentoFinalizacion: $momentoFinalizacion, ')
          ..write('momentoEnvio: $momentoEnvio, ')
          ..write('cuestionarioId: $cuestionarioId, ')
          ..write('activoId: $activoId, ')
          ..write('esNueva: $esNueva')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          estado.hashCode,
          $mrjc(
              criticidadTotal.hashCode,
              $mrjc(
                  criticidadReparacion.hashCode,
                  $mrjc(
                      momentoInicio.hashCode,
                      $mrjc(
                          momentoBorradorGuardado.hashCode,
                          $mrjc(
                              momentoFinalizacion.hashCode,
                              $mrjc(
                                  momentoEnvio.hashCode,
                                  $mrjc(
                                      cuestionarioId.hashCode,
                                      $mrjc(activoId.hashCode,
                                          esNueva.hashCode)))))))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Inspeccion &&
          other.id == this.id &&
          other.estado == this.estado &&
          other.criticidadTotal == this.criticidadTotal &&
          other.criticidadReparacion == this.criticidadReparacion &&
          other.momentoInicio == this.momentoInicio &&
          other.momentoBorradorGuardado == this.momentoBorradorGuardado &&
          other.momentoFinalizacion == this.momentoFinalizacion &&
          other.momentoEnvio == this.momentoEnvio &&
          other.cuestionarioId == this.cuestionarioId &&
          other.activoId == this.activoId &&
          other.esNueva == this.esNueva);
}

class InspeccionesCompanion extends UpdateCompanion<Inspeccion> {
  final Value<int> id;
  final Value<EstadoDeInspeccion> estado;
  final Value<double> criticidadTotal;
  final Value<double> criticidadReparacion;
  final Value<DateTime?> momentoInicio;
  final Value<DateTime?> momentoBorradorGuardado;
  final Value<DateTime?> momentoFinalizacion;
  final Value<DateTime?> momentoEnvio;
  final Value<int> cuestionarioId;
  final Value<int> activoId;
  final Value<bool> esNueva;
  const InspeccionesCompanion({
    this.id = const Value.absent(),
    this.estado = const Value.absent(),
    this.criticidadTotal = const Value.absent(),
    this.criticidadReparacion = const Value.absent(),
    this.momentoInicio = const Value.absent(),
    this.momentoBorradorGuardado = const Value.absent(),
    this.momentoFinalizacion = const Value.absent(),
    this.momentoEnvio = const Value.absent(),
    this.cuestionarioId = const Value.absent(),
    this.activoId = const Value.absent(),
    this.esNueva = const Value.absent(),
  });
  InspeccionesCompanion.insert({
    this.id = const Value.absent(),
    required EstadoDeInspeccion estado,
    required double criticidadTotal,
    required double criticidadReparacion,
    this.momentoInicio = const Value.absent(),
    this.momentoBorradorGuardado = const Value.absent(),
    this.momentoFinalizacion = const Value.absent(),
    this.momentoEnvio = const Value.absent(),
    required int cuestionarioId,
    required int activoId,
    this.esNueva = const Value.absent(),
  })  : estado = Value(estado),
        criticidadTotal = Value(criticidadTotal),
        criticidadReparacion = Value(criticidadReparacion),
        cuestionarioId = Value(cuestionarioId),
        activoId = Value(activoId);
  static Insertable<Inspeccion> custom({
    Expression<int>? id,
    Expression<EstadoDeInspeccion>? estado,
    Expression<double>? criticidadTotal,
    Expression<double>? criticidadReparacion,
    Expression<DateTime?>? momentoInicio,
    Expression<DateTime?>? momentoBorradorGuardado,
    Expression<DateTime?>? momentoFinalizacion,
    Expression<DateTime?>? momentoEnvio,
    Expression<int>? cuestionarioId,
    Expression<int>? activoId,
    Expression<bool>? esNueva,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (estado != null) 'estado': estado,
      if (criticidadTotal != null) 'criticidad_total': criticidadTotal,
      if (criticidadReparacion != null)
        'criticidad_reparacion': criticidadReparacion,
      if (momentoInicio != null) 'momento_inicio': momentoInicio,
      if (momentoBorradorGuardado != null)
        'momento_borrador_guardado': momentoBorradorGuardado,
      if (momentoFinalizacion != null)
        'momento_finalizacion': momentoFinalizacion,
      if (momentoEnvio != null) 'momento_envio': momentoEnvio,
      if (cuestionarioId != null) 'cuestionario_id': cuestionarioId,
      if (activoId != null) 'activo_id': activoId,
      if (esNueva != null) 'es_nueva': esNueva,
    });
  }

  InspeccionesCompanion copyWith(
      {Value<int>? id,
      Value<EstadoDeInspeccion>? estado,
      Value<double>? criticidadTotal,
      Value<double>? criticidadReparacion,
      Value<DateTime?>? momentoInicio,
      Value<DateTime?>? momentoBorradorGuardado,
      Value<DateTime?>? momentoFinalizacion,
      Value<DateTime?>? momentoEnvio,
      Value<int>? cuestionarioId,
      Value<int>? activoId,
      Value<bool>? esNueva}) {
    return InspeccionesCompanion(
      id: id ?? this.id,
      estado: estado ?? this.estado,
      criticidadTotal: criticidadTotal ?? this.criticidadTotal,
      criticidadReparacion: criticidadReparacion ?? this.criticidadReparacion,
      momentoInicio: momentoInicio ?? this.momentoInicio,
      momentoBorradorGuardado:
          momentoBorradorGuardado ?? this.momentoBorradorGuardado,
      momentoFinalizacion: momentoFinalizacion ?? this.momentoFinalizacion,
      momentoEnvio: momentoEnvio ?? this.momentoEnvio,
      cuestionarioId: cuestionarioId ?? this.cuestionarioId,
      activoId: activoId ?? this.activoId,
      esNueva: esNueva ?? this.esNueva,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (estado.present) {
      final converter = $InspeccionesTable.$converter0;
      map['estado'] = Variable<int>(converter.mapToSql(estado.value)!);
    }
    if (criticidadTotal.present) {
      map['criticidad_total'] = Variable<double>(criticidadTotal.value);
    }
    if (criticidadReparacion.present) {
      map['criticidad_reparacion'] =
          Variable<double>(criticidadReparacion.value);
    }
    if (momentoInicio.present) {
      map['momento_inicio'] = Variable<DateTime?>(momentoInicio.value);
    }
    if (momentoBorradorGuardado.present) {
      map['momento_borrador_guardado'] =
          Variable<DateTime?>(momentoBorradorGuardado.value);
    }
    if (momentoFinalizacion.present) {
      map['momento_finalizacion'] =
          Variable<DateTime?>(momentoFinalizacion.value);
    }
    if (momentoEnvio.present) {
      map['momento_envio'] = Variable<DateTime?>(momentoEnvio.value);
    }
    if (cuestionarioId.present) {
      map['cuestionario_id'] = Variable<int>(cuestionarioId.value);
    }
    if (activoId.present) {
      map['activo_id'] = Variable<int>(activoId.value);
    }
    if (esNueva.present) {
      map['es_nueva'] = Variable<bool>(esNueva.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InspeccionesCompanion(')
          ..write('id: $id, ')
          ..write('estado: $estado, ')
          ..write('criticidadTotal: $criticidadTotal, ')
          ..write('criticidadReparacion: $criticidadReparacion, ')
          ..write('momentoInicio: $momentoInicio, ')
          ..write('momentoBorradorGuardado: $momentoBorradorGuardado, ')
          ..write('momentoFinalizacion: $momentoFinalizacion, ')
          ..write('momentoEnvio: $momentoEnvio, ')
          ..write('cuestionarioId: $cuestionarioId, ')
          ..write('activoId: $activoId, ')
          ..write('esNueva: $esNueva')
          ..write(')'))
        .toString();
  }
}

class $InspeccionesTable extends Inspecciones
    with TableInfo<$InspeccionesTable, Inspeccion> {
  final GeneratedDatabase _db;
  final String? _alias;
  $InspeccionesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _estadoMeta = const VerificationMeta('estado');
  late final GeneratedColumnWithTypeConverter<EstadoDeInspeccion, int?> estado =
      GeneratedColumn<int?>('estado', aliasedName, false,
              typeName: 'INTEGER', requiredDuringInsert: true)
          .withConverter<EstadoDeInspeccion>($InspeccionesTable.$converter0);
  final VerificationMeta _criticidadTotalMeta =
      const VerificationMeta('criticidadTotal');
  late final GeneratedColumn<double?> criticidadTotal =
      GeneratedColumn<double?>('criticidad_total', aliasedName, false,
          typeName: 'REAL', requiredDuringInsert: true);
  final VerificationMeta _criticidadReparacionMeta =
      const VerificationMeta('criticidadReparacion');
  late final GeneratedColumn<double?> criticidadReparacion =
      GeneratedColumn<double?>('criticidad_reparacion', aliasedName, false,
          typeName: 'REAL', requiredDuringInsert: true);
  final VerificationMeta _momentoInicioMeta =
      const VerificationMeta('momentoInicio');
  late final GeneratedColumn<DateTime?> momentoInicio =
      GeneratedColumn<DateTime?>('momento_inicio', aliasedName, true,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _momentoBorradorGuardadoMeta =
      const VerificationMeta('momentoBorradorGuardado');
  late final GeneratedColumn<DateTime?> momentoBorradorGuardado =
      GeneratedColumn<DateTime?>('momento_borrador_guardado', aliasedName, true,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _momentoFinalizacionMeta =
      const VerificationMeta('momentoFinalizacion');
  late final GeneratedColumn<DateTime?> momentoFinalizacion =
      GeneratedColumn<DateTime?>('momento_finalizacion', aliasedName, true,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _momentoEnvioMeta =
      const VerificationMeta('momentoEnvio');
  late final GeneratedColumn<DateTime?> momentoEnvio =
      GeneratedColumn<DateTime?>('momento_envio', aliasedName, true,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _cuestionarioIdMeta =
      const VerificationMeta('cuestionarioId');
  late final GeneratedColumn<int?> cuestionarioId = GeneratedColumn<int?>(
      'cuestionario_id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES cuestionarios(id) ON DELETE CASCADE');
  final VerificationMeta _activoIdMeta = const VerificationMeta('activoId');
  late final GeneratedColumn<int?> activoId = GeneratedColumn<int?>(
      'activo_id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES activos(id) ON DELETE NO ACTION');
  final VerificationMeta _esNuevaMeta = const VerificationMeta('esNueva');
  late final GeneratedColumn<bool?> esNueva = GeneratedColumn<bool?>(
      'es_nueva', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (es_nueva IN (0, 1))',
      clientDefault: () => true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        estado,
        criticidadTotal,
        criticidadReparacion,
        momentoInicio,
        momentoBorradorGuardado,
        momentoFinalizacion,
        momentoEnvio,
        cuestionarioId,
        activoId,
        esNueva
      ];
  @override
  String get aliasedName => _alias ?? 'inspecciones';
  @override
  String get actualTableName => 'inspecciones';
  @override
  VerificationContext validateIntegrity(Insertable<Inspeccion> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    context.handle(_estadoMeta, const VerificationResult.success());
    if (data.containsKey('criticidad_total')) {
      context.handle(
          _criticidadTotalMeta,
          criticidadTotal.isAcceptableOrUnknown(
              data['criticidad_total']!, _criticidadTotalMeta));
    } else if (isInserting) {
      context.missing(_criticidadTotalMeta);
    }
    if (data.containsKey('criticidad_reparacion')) {
      context.handle(
          _criticidadReparacionMeta,
          criticidadReparacion.isAcceptableOrUnknown(
              data['criticidad_reparacion']!, _criticidadReparacionMeta));
    } else if (isInserting) {
      context.missing(_criticidadReparacionMeta);
    }
    if (data.containsKey('momento_inicio')) {
      context.handle(
          _momentoInicioMeta,
          momentoInicio.isAcceptableOrUnknown(
              data['momento_inicio']!, _momentoInicioMeta));
    }
    if (data.containsKey('momento_borrador_guardado')) {
      context.handle(
          _momentoBorradorGuardadoMeta,
          momentoBorradorGuardado.isAcceptableOrUnknown(
              data['momento_borrador_guardado']!,
              _momentoBorradorGuardadoMeta));
    }
    if (data.containsKey('momento_finalizacion')) {
      context.handle(
          _momentoFinalizacionMeta,
          momentoFinalizacion.isAcceptableOrUnknown(
              data['momento_finalizacion']!, _momentoFinalizacionMeta));
    }
    if (data.containsKey('momento_envio')) {
      context.handle(
          _momentoEnvioMeta,
          momentoEnvio.isAcceptableOrUnknown(
              data['momento_envio']!, _momentoEnvioMeta));
    }
    if (data.containsKey('cuestionario_id')) {
      context.handle(
          _cuestionarioIdMeta,
          cuestionarioId.isAcceptableOrUnknown(
              data['cuestionario_id']!, _cuestionarioIdMeta));
    } else if (isInserting) {
      context.missing(_cuestionarioIdMeta);
    }
    if (data.containsKey('activo_id')) {
      context.handle(_activoIdMeta,
          activoId.isAcceptableOrUnknown(data['activo_id']!, _activoIdMeta));
    } else if (isInserting) {
      context.missing(_activoIdMeta);
    }
    if (data.containsKey('es_nueva')) {
      context.handle(_esNuevaMeta,
          esNueva.isAcceptableOrUnknown(data['es_nueva']!, _esNuevaMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Inspeccion map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Inspeccion.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $InspeccionesTable createAlias(String alias) {
    return $InspeccionesTable(_db, alias);
  }

  static TypeConverter<EstadoDeInspeccion, int> $converter0 =
      const EnumIndexConverter<EstadoDeInspeccion>(EstadoDeInspeccion.values);
}

class Respuesta extends DataClass implements Insertable<Respuesta> {
  final int id;
  final KtList<String> fotosBase;
  final KtList<String> fotosReparacion;
  final String observacion;
  final bool reparado;

  /// Solo usado si la pregunta es de tipo numérica
  final double? valor;
  final String observacionReparacion;

  /// Solo usado en caso de que la pregunta sea calificable
  final int? calificacion;

  /// Momento de la ultima edición de la respuesta
  final DateTime? momentoRespuesta;
  final int inspeccionId;
  final int preguntaId;

  /// En este caso no sé que puede pasar si no es único, para el caso de las multiples se
  /// está dando el caso sin generar problema hasta ahora
  final int? opcionDeRespuestaId;
  Respuesta(
      {required this.id,
      required this.fotosBase,
      required this.fotosReparacion,
      required this.observacion,
      required this.reparado,
      this.valor,
      required this.observacionReparacion,
      this.calificacion,
      this.momentoRespuesta,
      required this.inspeccionId,
      required this.preguntaId,
      this.opcionDeRespuestaId});
  factory Respuesta.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Respuesta(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      fotosBase: $RespuestasTable.$converter0.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}fotos_base']))!,
      fotosReparacion: $RespuestasTable.$converter1.mapToDart(const StringType()
          .mapFromDatabaseResponse(
              data['${effectivePrefix}fotos_reparacion']))!,
      observacion: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}observacion'])!,
      reparado: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}reparado'])!,
      valor: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}valor']),
      observacionReparacion: const StringType().mapFromDatabaseResponse(
          data['${effectivePrefix}observacion_reparacion'])!,
      calificacion: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}calificacion']),
      momentoRespuesta: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}momento_respuesta']),
      inspeccionId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}inspeccion_id'])!,
      preguntaId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}pregunta_id'])!,
      opcionDeRespuestaId: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}opcion_de_respuesta_id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      final converter = $RespuestasTable.$converter0;
      map['fotos_base'] = Variable<String>(converter.mapToSql(fotosBase)!);
    }
    {
      final converter = $RespuestasTable.$converter1;
      map['fotos_reparacion'] =
          Variable<String>(converter.mapToSql(fotosReparacion)!);
    }
    map['observacion'] = Variable<String>(observacion);
    map['reparado'] = Variable<bool>(reparado);
    if (!nullToAbsent || valor != null) {
      map['valor'] = Variable<double?>(valor);
    }
    map['observacion_reparacion'] = Variable<String>(observacionReparacion);
    if (!nullToAbsent || calificacion != null) {
      map['calificacion'] = Variable<int?>(calificacion);
    }
    if (!nullToAbsent || momentoRespuesta != null) {
      map['momento_respuesta'] = Variable<DateTime?>(momentoRespuesta);
    }
    map['inspeccion_id'] = Variable<int>(inspeccionId);
    map['pregunta_id'] = Variable<int>(preguntaId);
    if (!nullToAbsent || opcionDeRespuestaId != null) {
      map['opcion_de_respuesta_id'] = Variable<int?>(opcionDeRespuestaId);
    }
    return map;
  }

  RespuestasCompanion toCompanion(bool nullToAbsent) {
    return RespuestasCompanion(
      id: Value(id),
      fotosBase: Value(fotosBase),
      fotosReparacion: Value(fotosReparacion),
      observacion: Value(observacion),
      reparado: Value(reparado),
      valor:
          valor == null && nullToAbsent ? const Value.absent() : Value(valor),
      observacionReparacion: Value(observacionReparacion),
      calificacion: calificacion == null && nullToAbsent
          ? const Value.absent()
          : Value(calificacion),
      momentoRespuesta: momentoRespuesta == null && nullToAbsent
          ? const Value.absent()
          : Value(momentoRespuesta),
      inspeccionId: Value(inspeccionId),
      preguntaId: Value(preguntaId),
      opcionDeRespuestaId: opcionDeRespuestaId == null && nullToAbsent
          ? const Value.absent()
          : Value(opcionDeRespuestaId),
    );
  }

  factory Respuesta.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Respuesta(
      id: serializer.fromJson<int>(json['id']),
      fotosBase: serializer.fromJson<KtList<String>>(json['fotosBase']),
      fotosReparacion:
          serializer.fromJson<KtList<String>>(json['fotosReparacion']),
      observacion: serializer.fromJson<String>(json['observacion']),
      reparado: serializer.fromJson<bool>(json['reparado']),
      valor: serializer.fromJson<double?>(json['valor']),
      observacionReparacion:
          serializer.fromJson<String>(json['observacionReparacion']),
      calificacion: serializer.fromJson<int?>(json['calificacion']),
      momentoRespuesta:
          serializer.fromJson<DateTime?>(json['momentoRespuesta']),
      inspeccionId: serializer.fromJson<int>(json['inspeccion']),
      preguntaId: serializer.fromJson<int>(json['pregunta']),
      opcionDeRespuestaId: serializer.fromJson<int?>(json['opcionDeRespuesta']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fotosBase': serializer.toJson<KtList<String>>(fotosBase),
      'fotosReparacion': serializer.toJson<KtList<String>>(fotosReparacion),
      'observacion': serializer.toJson<String>(observacion),
      'reparado': serializer.toJson<bool>(reparado),
      'valor': serializer.toJson<double?>(valor),
      'observacionReparacion': serializer.toJson<String>(observacionReparacion),
      'calificacion': serializer.toJson<int?>(calificacion),
      'momentoRespuesta': serializer.toJson<DateTime?>(momentoRespuesta),
      'inspeccion': serializer.toJson<int>(inspeccionId),
      'pregunta': serializer.toJson<int>(preguntaId),
      'opcionDeRespuesta': serializer.toJson<int?>(opcionDeRespuestaId),
    };
  }

  Respuesta copyWith(
          {int? id,
          KtList<String>? fotosBase,
          KtList<String>? fotosReparacion,
          String? observacion,
          bool? reparado,
          double? valor,
          String? observacionReparacion,
          int? calificacion,
          DateTime? momentoRespuesta,
          int? inspeccionId,
          int? preguntaId,
          int? opcionDeRespuestaId}) =>
      Respuesta(
        id: id ?? this.id,
        fotosBase: fotosBase ?? this.fotosBase,
        fotosReparacion: fotosReparacion ?? this.fotosReparacion,
        observacion: observacion ?? this.observacion,
        reparado: reparado ?? this.reparado,
        valor: valor ?? this.valor,
        observacionReparacion:
            observacionReparacion ?? this.observacionReparacion,
        calificacion: calificacion ?? this.calificacion,
        momentoRespuesta: momentoRespuesta ?? this.momentoRespuesta,
        inspeccionId: inspeccionId ?? this.inspeccionId,
        preguntaId: preguntaId ?? this.preguntaId,
        opcionDeRespuestaId: opcionDeRespuestaId ?? this.opcionDeRespuestaId,
      );
  @override
  String toString() {
    return (StringBuffer('Respuesta(')
          ..write('id: $id, ')
          ..write('fotosBase: $fotosBase, ')
          ..write('fotosReparacion: $fotosReparacion, ')
          ..write('observacion: $observacion, ')
          ..write('reparado: $reparado, ')
          ..write('valor: $valor, ')
          ..write('observacionReparacion: $observacionReparacion, ')
          ..write('calificacion: $calificacion, ')
          ..write('momentoRespuesta: $momentoRespuesta, ')
          ..write('inspeccionId: $inspeccionId, ')
          ..write('preguntaId: $preguntaId, ')
          ..write('opcionDeRespuestaId: $opcionDeRespuestaId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          fotosBase.hashCode,
          $mrjc(
              fotosReparacion.hashCode,
              $mrjc(
                  observacion.hashCode,
                  $mrjc(
                      reparado.hashCode,
                      $mrjc(
                          valor.hashCode,
                          $mrjc(
                              observacionReparacion.hashCode,
                              $mrjc(
                                  calificacion.hashCode,
                                  $mrjc(
                                      momentoRespuesta.hashCode,
                                      $mrjc(
                                          inspeccionId.hashCode,
                                          $mrjc(
                                              preguntaId.hashCode,
                                              opcionDeRespuestaId
                                                  .hashCode))))))))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Respuesta &&
          other.id == this.id &&
          other.fotosBase == this.fotosBase &&
          other.fotosReparacion == this.fotosReparacion &&
          other.observacion == this.observacion &&
          other.reparado == this.reparado &&
          other.valor == this.valor &&
          other.observacionReparacion == this.observacionReparacion &&
          other.calificacion == this.calificacion &&
          other.momentoRespuesta == this.momentoRespuesta &&
          other.inspeccionId == this.inspeccionId &&
          other.preguntaId == this.preguntaId &&
          other.opcionDeRespuestaId == this.opcionDeRespuestaId);
}

class RespuestasCompanion extends UpdateCompanion<Respuesta> {
  final Value<int> id;
  final Value<KtList<String>> fotosBase;
  final Value<KtList<String>> fotosReparacion;
  final Value<String> observacion;
  final Value<bool> reparado;
  final Value<double?> valor;
  final Value<String> observacionReparacion;
  final Value<int?> calificacion;
  final Value<DateTime?> momentoRespuesta;
  final Value<int> inspeccionId;
  final Value<int> preguntaId;
  final Value<int?> opcionDeRespuestaId;
  const RespuestasCompanion({
    this.id = const Value.absent(),
    this.fotosBase = const Value.absent(),
    this.fotosReparacion = const Value.absent(),
    this.observacion = const Value.absent(),
    this.reparado = const Value.absent(),
    this.valor = const Value.absent(),
    this.observacionReparacion = const Value.absent(),
    this.calificacion = const Value.absent(),
    this.momentoRespuesta = const Value.absent(),
    this.inspeccionId = const Value.absent(),
    this.preguntaId = const Value.absent(),
    this.opcionDeRespuestaId = const Value.absent(),
  });
  RespuestasCompanion.insert({
    this.id = const Value.absent(),
    this.fotosBase = const Value.absent(),
    this.fotosReparacion = const Value.absent(),
    this.observacion = const Value.absent(),
    this.reparado = const Value.absent(),
    this.valor = const Value.absent(),
    this.observacionReparacion = const Value.absent(),
    this.calificacion = const Value.absent(),
    this.momentoRespuesta = const Value.absent(),
    required int inspeccionId,
    required int preguntaId,
    this.opcionDeRespuestaId = const Value.absent(),
  })  : inspeccionId = Value(inspeccionId),
        preguntaId = Value(preguntaId);
  static Insertable<Respuesta> custom({
    Expression<int>? id,
    Expression<KtList<String>>? fotosBase,
    Expression<KtList<String>>? fotosReparacion,
    Expression<String>? observacion,
    Expression<bool>? reparado,
    Expression<double?>? valor,
    Expression<String>? observacionReparacion,
    Expression<int?>? calificacion,
    Expression<DateTime?>? momentoRespuesta,
    Expression<int>? inspeccionId,
    Expression<int>? preguntaId,
    Expression<int?>? opcionDeRespuestaId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fotosBase != null) 'fotos_base': fotosBase,
      if (fotosReparacion != null) 'fotos_reparacion': fotosReparacion,
      if (observacion != null) 'observacion': observacion,
      if (reparado != null) 'reparado': reparado,
      if (valor != null) 'valor': valor,
      if (observacionReparacion != null)
        'observacion_reparacion': observacionReparacion,
      if (calificacion != null) 'calificacion': calificacion,
      if (momentoRespuesta != null) 'momento_respuesta': momentoRespuesta,
      if (inspeccionId != null) 'inspeccion_id': inspeccionId,
      if (preguntaId != null) 'pregunta_id': preguntaId,
      if (opcionDeRespuestaId != null)
        'opcion_de_respuesta_id': opcionDeRespuestaId,
    });
  }

  RespuestasCompanion copyWith(
      {Value<int>? id,
      Value<KtList<String>>? fotosBase,
      Value<KtList<String>>? fotosReparacion,
      Value<String>? observacion,
      Value<bool>? reparado,
      Value<double?>? valor,
      Value<String>? observacionReparacion,
      Value<int?>? calificacion,
      Value<DateTime?>? momentoRespuesta,
      Value<int>? inspeccionId,
      Value<int>? preguntaId,
      Value<int?>? opcionDeRespuestaId}) {
    return RespuestasCompanion(
      id: id ?? this.id,
      fotosBase: fotosBase ?? this.fotosBase,
      fotosReparacion: fotosReparacion ?? this.fotosReparacion,
      observacion: observacion ?? this.observacion,
      reparado: reparado ?? this.reparado,
      valor: valor ?? this.valor,
      observacionReparacion:
          observacionReparacion ?? this.observacionReparacion,
      calificacion: calificacion ?? this.calificacion,
      momentoRespuesta: momentoRespuesta ?? this.momentoRespuesta,
      inspeccionId: inspeccionId ?? this.inspeccionId,
      preguntaId: preguntaId ?? this.preguntaId,
      opcionDeRespuestaId: opcionDeRespuestaId ?? this.opcionDeRespuestaId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fotosBase.present) {
      final converter = $RespuestasTable.$converter0;
      map['fotos_base'] =
          Variable<String>(converter.mapToSql(fotosBase.value)!);
    }
    if (fotosReparacion.present) {
      final converter = $RespuestasTable.$converter1;
      map['fotos_reparacion'] =
          Variable<String>(converter.mapToSql(fotosReparacion.value)!);
    }
    if (observacion.present) {
      map['observacion'] = Variable<String>(observacion.value);
    }
    if (reparado.present) {
      map['reparado'] = Variable<bool>(reparado.value);
    }
    if (valor.present) {
      map['valor'] = Variable<double?>(valor.value);
    }
    if (observacionReparacion.present) {
      map['observacion_reparacion'] =
          Variable<String>(observacionReparacion.value);
    }
    if (calificacion.present) {
      map['calificacion'] = Variable<int?>(calificacion.value);
    }
    if (momentoRespuesta.present) {
      map['momento_respuesta'] = Variable<DateTime?>(momentoRespuesta.value);
    }
    if (inspeccionId.present) {
      map['inspeccion_id'] = Variable<int>(inspeccionId.value);
    }
    if (preguntaId.present) {
      map['pregunta_id'] = Variable<int>(preguntaId.value);
    }
    if (opcionDeRespuestaId.present) {
      map['opcion_de_respuesta_id'] = Variable<int?>(opcionDeRespuestaId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RespuestasCompanion(')
          ..write('id: $id, ')
          ..write('fotosBase: $fotosBase, ')
          ..write('fotosReparacion: $fotosReparacion, ')
          ..write('observacion: $observacion, ')
          ..write('reparado: $reparado, ')
          ..write('valor: $valor, ')
          ..write('observacionReparacion: $observacionReparacion, ')
          ..write('calificacion: $calificacion, ')
          ..write('momentoRespuesta: $momentoRespuesta, ')
          ..write('inspeccionId: $inspeccionId, ')
          ..write('preguntaId: $preguntaId, ')
          ..write('opcionDeRespuestaId: $opcionDeRespuestaId')
          ..write(')'))
        .toString();
  }
}

class $RespuestasTable extends Respuestas
    with TableInfo<$RespuestasTable, Respuesta> {
  final GeneratedDatabase _db;
  final String? _alias;
  $RespuestasTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _fotosBaseMeta = const VerificationMeta('fotosBase');
  late final GeneratedColumnWithTypeConverter<KtList<String>, String?>
      fotosBase = GeneratedColumn<String?>('fotos_base', aliasedName, false,
              typeName: 'TEXT',
              requiredDuringInsert: false,
              defaultValue: const Constant("[]"))
          .withConverter<KtList<String>>($RespuestasTable.$converter0);
  final VerificationMeta _fotosReparacionMeta =
      const VerificationMeta('fotosReparacion');
  late final GeneratedColumnWithTypeConverter<KtList<String>, String?>
      fotosReparacion = GeneratedColumn<String?>(
              'fotos_reparacion', aliasedName, false,
              typeName: 'TEXT',
              requiredDuringInsert: false,
              defaultValue: const Constant("[]"))
          .withConverter<KtList<String>>($RespuestasTable.$converter1);
  final VerificationMeta _observacionMeta =
      const VerificationMeta('observacion');
  late final GeneratedColumn<String?> observacion = GeneratedColumn<String?>(
      'observacion', aliasedName, false,
      typeName: 'TEXT',
      requiredDuringInsert: false,
      defaultValue: const Constant(""));
  final VerificationMeta _reparadoMeta = const VerificationMeta('reparado');
  late final GeneratedColumn<bool?> reparado = GeneratedColumn<bool?>(
      'reparado', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (reparado IN (0, 1))',
      defaultValue: const Constant(false));
  final VerificationMeta _valorMeta = const VerificationMeta('valor');
  late final GeneratedColumn<double?> valor = GeneratedColumn<double?>(
      'valor', aliasedName, true,
      typeName: 'REAL', requiredDuringInsert: false);
  final VerificationMeta _observacionReparacionMeta =
      const VerificationMeta('observacionReparacion');
  late final GeneratedColumn<String?> observacionReparacion =
      GeneratedColumn<String?>('observacion_reparacion', aliasedName, false,
          typeName: 'TEXT',
          requiredDuringInsert: false,
          defaultValue: const Constant(""));
  final VerificationMeta _calificacionMeta =
      const VerificationMeta('calificacion');
  late final GeneratedColumn<int?> calificacion = GeneratedColumn<int?>(
      'calificacion', aliasedName, true,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _momentoRespuestaMeta =
      const VerificationMeta('momentoRespuesta');
  late final GeneratedColumn<DateTime?> momentoRespuesta =
      GeneratedColumn<DateTime?>('momento_respuesta', aliasedName, true,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _inspeccionIdMeta =
      const VerificationMeta('inspeccionId');
  late final GeneratedColumn<int?> inspeccionId = GeneratedColumn<int?>(
      'inspeccion_id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES inspecciones(id) ON DELETE CASCADE');
  final VerificationMeta _preguntaIdMeta = const VerificationMeta('preguntaId');
  late final GeneratedColumn<int?> preguntaId = GeneratedColumn<int?>(
      'pregunta_id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES preguntas(id) ON DELETE CASCADE');
  final VerificationMeta _opcionDeRespuestaIdMeta =
      const VerificationMeta('opcionDeRespuestaId');
  late final GeneratedColumn<int?> opcionDeRespuestaId = GeneratedColumn<int?>(
      'opcion_de_respuesta_id', aliasedName, true,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      $customConstraints:
          'REFERENCES opciones_de_respuesta(id) ON DELETE CASCADE');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        fotosBase,
        fotosReparacion,
        observacion,
        reparado,
        valor,
        observacionReparacion,
        calificacion,
        momentoRespuesta,
        inspeccionId,
        preguntaId,
        opcionDeRespuestaId
      ];
  @override
  String get aliasedName => _alias ?? 'respuestas';
  @override
  String get actualTableName => 'respuestas';
  @override
  VerificationContext validateIntegrity(Insertable<Respuesta> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    context.handle(_fotosBaseMeta, const VerificationResult.success());
    context.handle(_fotosReparacionMeta, const VerificationResult.success());
    if (data.containsKey('observacion')) {
      context.handle(
          _observacionMeta,
          observacion.isAcceptableOrUnknown(
              data['observacion']!, _observacionMeta));
    }
    if (data.containsKey('reparado')) {
      context.handle(_reparadoMeta,
          reparado.isAcceptableOrUnknown(data['reparado']!, _reparadoMeta));
    }
    if (data.containsKey('valor')) {
      context.handle(
          _valorMeta, valor.isAcceptableOrUnknown(data['valor']!, _valorMeta));
    }
    if (data.containsKey('observacion_reparacion')) {
      context.handle(
          _observacionReparacionMeta,
          observacionReparacion.isAcceptableOrUnknown(
              data['observacion_reparacion']!, _observacionReparacionMeta));
    }
    if (data.containsKey('calificacion')) {
      context.handle(
          _calificacionMeta,
          calificacion.isAcceptableOrUnknown(
              data['calificacion']!, _calificacionMeta));
    }
    if (data.containsKey('momento_respuesta')) {
      context.handle(
          _momentoRespuestaMeta,
          momentoRespuesta.isAcceptableOrUnknown(
              data['momento_respuesta']!, _momentoRespuestaMeta));
    }
    if (data.containsKey('inspeccion_id')) {
      context.handle(
          _inspeccionIdMeta,
          inspeccionId.isAcceptableOrUnknown(
              data['inspeccion_id']!, _inspeccionIdMeta));
    } else if (isInserting) {
      context.missing(_inspeccionIdMeta);
    }
    if (data.containsKey('pregunta_id')) {
      context.handle(
          _preguntaIdMeta,
          preguntaId.isAcceptableOrUnknown(
              data['pregunta_id']!, _preguntaIdMeta));
    } else if (isInserting) {
      context.missing(_preguntaIdMeta);
    }
    if (data.containsKey('opcion_de_respuesta_id')) {
      context.handle(
          _opcionDeRespuestaIdMeta,
          opcionDeRespuestaId.isAcceptableOrUnknown(
              data['opcion_de_respuesta_id']!, _opcionDeRespuestaIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Respuesta map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Respuesta.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $RespuestasTable createAlias(String alias) {
    return $RespuestasTable(_db, alias);
  }

  static TypeConverter<KtList<String>, String> $converter0 =
      const ListInColumnConverter();
  static TypeConverter<KtList<String>, String> $converter1 =
      const ListInColumnConverter();
}

class Contratista extends DataClass implements Insertable<Contratista> {
  final int id;
  final String nombre;
  Contratista({required this.id, required this.nombre});
  factory Contratista.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Contratista(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      nombre: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}nombre'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    return map;
  }

  ContratistasCompanion toCompanion(bool nullToAbsent) {
    return ContratistasCompanion(
      id: Value(id),
      nombre: Value(nombre),
    );
  }

  factory Contratista.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Contratista(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
    };
  }

  Contratista copyWith({int? id, String? nombre}) => Contratista(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
      );
  @override
  String toString() {
    return (StringBuffer('Contratista(')
          ..write('id: $id, ')
          ..write('nombre: $nombre')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode, nombre.hashCode));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Contratista &&
          other.id == this.id &&
          other.nombre == this.nombre);
}

class ContratistasCompanion extends UpdateCompanion<Contratista> {
  final Value<int> id;
  final Value<String> nombre;
  const ContratistasCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
  });
  ContratistasCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
  }) : nombre = Value(nombre);
  static Insertable<Contratista> custom({
    Expression<int>? id,
    Expression<String>? nombre,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
    });
  }

  ContratistasCompanion copyWith({Value<int>? id, Value<String>? nombre}) {
    return ContratistasCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContratistasCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre')
          ..write(')'))
        .toString();
  }
}

class $ContratistasTable extends Contratistas
    with TableInfo<$ContratistasTable, Contratista> {
  final GeneratedDatabase _db;
  final String? _alias;
  $ContratistasTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  late final GeneratedColumn<String?> nombre = GeneratedColumn<String?>(
      'nombre', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, nombre];
  @override
  String get aliasedName => _alias ?? 'contratistas';
  @override
  String get actualTableName => 'contratistas';
  @override
  VerificationContext validateIntegrity(Insertable<Contratista> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Contratista map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Contratista.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ContratistasTable createAlias(String alias) {
    return $ContratistasTable(_db, alias);
  }
}

class Sistema extends DataClass implements Insertable<Sistema> {
  final int id;
  final String nombre;
  Sistema({required this.id, required this.nombre});
  factory Sistema.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Sistema(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      nombre: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}nombre'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    return map;
  }

  SistemasCompanion toCompanion(bool nullToAbsent) {
    return SistemasCompanion(
      id: Value(id),
      nombre: Value(nombre),
    );
  }

  factory Sistema.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Sistema(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
    };
  }

  Sistema copyWith({int? id, String? nombre}) => Sistema(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
      );
  @override
  String toString() {
    return (StringBuffer('Sistema(')
          ..write('id: $id, ')
          ..write('nombre: $nombre')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode, nombre.hashCode));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Sistema && other.id == this.id && other.nombre == this.nombre);
}

class SistemasCompanion extends UpdateCompanion<Sistema> {
  final Value<int> id;
  final Value<String> nombre;
  const SistemasCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
  });
  SistemasCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
  }) : nombre = Value(nombre);
  static Insertable<Sistema> custom({
    Expression<int>? id,
    Expression<String>? nombre,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
    });
  }

  SistemasCompanion copyWith({Value<int>? id, Value<String>? nombre}) {
    return SistemasCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SistemasCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre')
          ..write(')'))
        .toString();
  }
}

class $SistemasTable extends Sistemas with TableInfo<$SistemasTable, Sistema> {
  final GeneratedDatabase _db;
  final String? _alias;
  $SistemasTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  late final GeneratedColumn<String?> nombre = GeneratedColumn<String?>(
      'nombre', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, nombre];
  @override
  String get aliasedName => _alias ?? 'sistemas';
  @override
  String get actualTableName => 'sistemas';
  @override
  VerificationContext validateIntegrity(Insertable<Sistema> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Sistema map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Sistema.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $SistemasTable createAlias(String alias) {
    return $SistemasTable(_db, alias);
  }
}

class SubSistema extends DataClass implements Insertable<SubSistema> {
  final int id;
  final String nombre;
  final int sistemaId;
  SubSistema({required this.id, required this.nombre, required this.sistemaId});
  factory SubSistema.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return SubSistema(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      nombre: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}nombre'])!,
      sistemaId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}sistema_id'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['sistema_id'] = Variable<int>(sistemaId);
    return map;
  }

  SubSistemasCompanion toCompanion(bool nullToAbsent) {
    return SubSistemasCompanion(
      id: Value(id),
      nombre: Value(nombre),
      sistemaId: Value(sistemaId),
    );
  }

  factory SubSistema.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return SubSistema(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      sistemaId: serializer.fromJson<int>(json['sistema']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'sistema': serializer.toJson<int>(sistemaId),
    };
  }

  SubSistema copyWith({int? id, String? nombre, int? sistemaId}) => SubSistema(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        sistemaId: sistemaId ?? this.sistemaId,
      );
  @override
  String toString() {
    return (StringBuffer('SubSistema(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('sistemaId: $sistemaId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(nombre.hashCode, sistemaId.hashCode)));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubSistema &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.sistemaId == this.sistemaId);
}

class SubSistemasCompanion extends UpdateCompanion<SubSistema> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<int> sistemaId;
  const SubSistemasCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.sistemaId = const Value.absent(),
  });
  SubSistemasCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required int sistemaId,
  })  : nombre = Value(nombre),
        sistemaId = Value(sistemaId);
  static Insertable<SubSistema> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<int>? sistemaId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (sistemaId != null) 'sistema_id': sistemaId,
    });
  }

  SubSistemasCompanion copyWith(
      {Value<int>? id, Value<String>? nombre, Value<int>? sistemaId}) {
    return SubSistemasCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      sistemaId: sistemaId ?? this.sistemaId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (sistemaId.present) {
      map['sistema_id'] = Variable<int>(sistemaId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubSistemasCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('sistemaId: $sistemaId')
          ..write(')'))
        .toString();
  }
}

class $SubSistemasTable extends SubSistemas
    with TableInfo<$SubSistemasTable, SubSistema> {
  final GeneratedDatabase _db;
  final String? _alias;
  $SubSistemasTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  late final GeneratedColumn<String?> nombre = GeneratedColumn<String?>(
      'nombre', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _sistemaIdMeta = const VerificationMeta('sistemaId');
  late final GeneratedColumn<int?> sistemaId = GeneratedColumn<int?>(
      'sistema_id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES sistemas(id) ON DELETE CASCADE');
  @override
  List<GeneratedColumn> get $columns => [id, nombre, sistemaId];
  @override
  String get aliasedName => _alias ?? 'sub_sistemas';
  @override
  String get actualTableName => 'sub_sistemas';
  @override
  VerificationContext validateIntegrity(Insertable<SubSistema> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('sistema_id')) {
      context.handle(_sistemaIdMeta,
          sistemaId.isAcceptableOrUnknown(data['sistema_id']!, _sistemaIdMeta));
    } else if (isInserting) {
      context.missing(_sistemaIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubSistema map(Map<String, dynamic> data, {String? tablePrefix}) {
    return SubSistema.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $SubSistemasTable createAlias(String alias) {
    return $SubSistemasTable(_db, alias);
  }
}

class CriticidadesNumerica extends DataClass
    implements Insertable<CriticidadesNumerica> {
  final int id;
  final double valorMinimo;
  final double valorMaximo;
  final int criticidad;
  final int preguntaId;
  CriticidadesNumerica(
      {required this.id,
      required this.valorMinimo,
      required this.valorMaximo,
      required this.criticidad,
      required this.preguntaId});
  factory CriticidadesNumerica.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return CriticidadesNumerica(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      valorMinimo: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}valor_minimo'])!,
      valorMaximo: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}valor_maximo'])!,
      criticidad: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}criticidad'])!,
      preguntaId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}pregunta_id'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['valor_minimo'] = Variable<double>(valorMinimo);
    map['valor_maximo'] = Variable<double>(valorMaximo);
    map['criticidad'] = Variable<int>(criticidad);
    map['pregunta_id'] = Variable<int>(preguntaId);
    return map;
  }

  CriticidadesNumericasCompanion toCompanion(bool nullToAbsent) {
    return CriticidadesNumericasCompanion(
      id: Value(id),
      valorMinimo: Value(valorMinimo),
      valorMaximo: Value(valorMaximo),
      criticidad: Value(criticidad),
      preguntaId: Value(preguntaId),
    );
  }

  factory CriticidadesNumerica.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return CriticidadesNumerica(
      id: serializer.fromJson<int>(json['id']),
      valorMinimo: serializer.fromJson<double>(json['valorMinimo']),
      valorMaximo: serializer.fromJson<double>(json['valorMaximo']),
      criticidad: serializer.fromJson<int>(json['criticidad']),
      preguntaId: serializer.fromJson<int>(json['pregunta']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'valorMinimo': serializer.toJson<double>(valorMinimo),
      'valorMaximo': serializer.toJson<double>(valorMaximo),
      'criticidad': serializer.toJson<int>(criticidad),
      'pregunta': serializer.toJson<int>(preguntaId),
    };
  }

  CriticidadesNumerica copyWith(
          {int? id,
          double? valorMinimo,
          double? valorMaximo,
          int? criticidad,
          int? preguntaId}) =>
      CriticidadesNumerica(
        id: id ?? this.id,
        valorMinimo: valorMinimo ?? this.valorMinimo,
        valorMaximo: valorMaximo ?? this.valorMaximo,
        criticidad: criticidad ?? this.criticidad,
        preguntaId: preguntaId ?? this.preguntaId,
      );
  @override
  String toString() {
    return (StringBuffer('CriticidadesNumerica(')
          ..write('id: $id, ')
          ..write('valorMinimo: $valorMinimo, ')
          ..write('valorMaximo: $valorMaximo, ')
          ..write('criticidad: $criticidad, ')
          ..write('preguntaId: $preguntaId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          valorMinimo.hashCode,
          $mrjc(valorMaximo.hashCode,
              $mrjc(criticidad.hashCode, preguntaId.hashCode)))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CriticidadesNumerica &&
          other.id == this.id &&
          other.valorMinimo == this.valorMinimo &&
          other.valorMaximo == this.valorMaximo &&
          other.criticidad == this.criticidad &&
          other.preguntaId == this.preguntaId);
}

class CriticidadesNumericasCompanion
    extends UpdateCompanion<CriticidadesNumerica> {
  final Value<int> id;
  final Value<double> valorMinimo;
  final Value<double> valorMaximo;
  final Value<int> criticidad;
  final Value<int> preguntaId;
  const CriticidadesNumericasCompanion({
    this.id = const Value.absent(),
    this.valorMinimo = const Value.absent(),
    this.valorMaximo = const Value.absent(),
    this.criticidad = const Value.absent(),
    this.preguntaId = const Value.absent(),
  });
  CriticidadesNumericasCompanion.insert({
    this.id = const Value.absent(),
    required double valorMinimo,
    required double valorMaximo,
    required int criticidad,
    required int preguntaId,
  })  : valorMinimo = Value(valorMinimo),
        valorMaximo = Value(valorMaximo),
        criticidad = Value(criticidad),
        preguntaId = Value(preguntaId);
  static Insertable<CriticidadesNumerica> custom({
    Expression<int>? id,
    Expression<double>? valorMinimo,
    Expression<double>? valorMaximo,
    Expression<int>? criticidad,
    Expression<int>? preguntaId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (valorMinimo != null) 'valor_minimo': valorMinimo,
      if (valorMaximo != null) 'valor_maximo': valorMaximo,
      if (criticidad != null) 'criticidad': criticidad,
      if (preguntaId != null) 'pregunta_id': preguntaId,
    });
  }

  CriticidadesNumericasCompanion copyWith(
      {Value<int>? id,
      Value<double>? valorMinimo,
      Value<double>? valorMaximo,
      Value<int>? criticidad,
      Value<int>? preguntaId}) {
    return CriticidadesNumericasCompanion(
      id: id ?? this.id,
      valorMinimo: valorMinimo ?? this.valorMinimo,
      valorMaximo: valorMaximo ?? this.valorMaximo,
      criticidad: criticidad ?? this.criticidad,
      preguntaId: preguntaId ?? this.preguntaId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (valorMinimo.present) {
      map['valor_minimo'] = Variable<double>(valorMinimo.value);
    }
    if (valorMaximo.present) {
      map['valor_maximo'] = Variable<double>(valorMaximo.value);
    }
    if (criticidad.present) {
      map['criticidad'] = Variable<int>(criticidad.value);
    }
    if (preguntaId.present) {
      map['pregunta_id'] = Variable<int>(preguntaId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CriticidadesNumericasCompanion(')
          ..write('id: $id, ')
          ..write('valorMinimo: $valorMinimo, ')
          ..write('valorMaximo: $valorMaximo, ')
          ..write('criticidad: $criticidad, ')
          ..write('preguntaId: $preguntaId')
          ..write(')'))
        .toString();
  }
}

class $CriticidadesNumericasTable extends CriticidadesNumericas
    with TableInfo<$CriticidadesNumericasTable, CriticidadesNumerica> {
  final GeneratedDatabase _db;
  final String? _alias;
  $CriticidadesNumericasTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _valorMinimoMeta =
      const VerificationMeta('valorMinimo');
  late final GeneratedColumn<double?> valorMinimo = GeneratedColumn<double?>(
      'valor_minimo', aliasedName, false,
      typeName: 'REAL', requiredDuringInsert: true);
  final VerificationMeta _valorMaximoMeta =
      const VerificationMeta('valorMaximo');
  late final GeneratedColumn<double?> valorMaximo = GeneratedColumn<double?>(
      'valor_maximo', aliasedName, false,
      typeName: 'REAL', requiredDuringInsert: true);
  final VerificationMeta _criticidadMeta = const VerificationMeta('criticidad');
  late final GeneratedColumn<int?> criticidad = GeneratedColumn<int?>(
      'criticidad', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _preguntaIdMeta = const VerificationMeta('preguntaId');
  late final GeneratedColumn<int?> preguntaId = GeneratedColumn<int?>(
      'pregunta_id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES preguntas(id) ON DELETE CASCADE');
  @override
  List<GeneratedColumn> get $columns =>
      [id, valorMinimo, valorMaximo, criticidad, preguntaId];
  @override
  String get aliasedName => _alias ?? 'criticidades_numericas';
  @override
  String get actualTableName => 'criticidades_numericas';
  @override
  VerificationContext validateIntegrity(
      Insertable<CriticidadesNumerica> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('valor_minimo')) {
      context.handle(
          _valorMinimoMeta,
          valorMinimo.isAcceptableOrUnknown(
              data['valor_minimo']!, _valorMinimoMeta));
    } else if (isInserting) {
      context.missing(_valorMinimoMeta);
    }
    if (data.containsKey('valor_maximo')) {
      context.handle(
          _valorMaximoMeta,
          valorMaximo.isAcceptableOrUnknown(
              data['valor_maximo']!, _valorMaximoMeta));
    } else if (isInserting) {
      context.missing(_valorMaximoMeta);
    }
    if (data.containsKey('criticidad')) {
      context.handle(
          _criticidadMeta,
          criticidad.isAcceptableOrUnknown(
              data['criticidad']!, _criticidadMeta));
    } else if (isInserting) {
      context.missing(_criticidadMeta);
    }
    if (data.containsKey('pregunta_id')) {
      context.handle(
          _preguntaIdMeta,
          preguntaId.isAcceptableOrUnknown(
              data['pregunta_id']!, _preguntaIdMeta));
    } else if (isInserting) {
      context.missing(_preguntaIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CriticidadesNumerica map(Map<String, dynamic> data, {String? tablePrefix}) {
    return CriticidadesNumerica.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $CriticidadesNumericasTable createAlias(String alias) {
    return $CriticidadesNumericasTable(_db, alias);
  }
}

class GruposInspecciones extends DataClass
    implements Insertable<GruposInspecciones> {
  final int id;
  final int nGrupo;
  final DateTime inicio;
  final DateTime fin;
  final int totalGrupos;
  final int tipoInspeccion;
  final int anio;
  GruposInspecciones(
      {required this.id,
      required this.nGrupo,
      required this.inicio,
      required this.fin,
      required this.totalGrupos,
      required this.tipoInspeccion,
      required this.anio});
  factory GruposInspecciones.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return GruposInspecciones(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      nGrupo: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}n_grupo'])!,
      inicio: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}inicio'])!,
      fin: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}fin'])!,
      totalGrupos: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}total_grupos'])!,
      tipoInspeccion: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}tipo_inspeccion'])!,
      anio: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}anio'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['n_grupo'] = Variable<int>(nGrupo);
    map['inicio'] = Variable<DateTime>(inicio);
    map['fin'] = Variable<DateTime>(fin);
    map['total_grupos'] = Variable<int>(totalGrupos);
    map['tipo_inspeccion'] = Variable<int>(tipoInspeccion);
    map['anio'] = Variable<int>(anio);
    return map;
  }

  GruposInspeccionessCompanion toCompanion(bool nullToAbsent) {
    return GruposInspeccionessCompanion(
      id: Value(id),
      nGrupo: Value(nGrupo),
      inicio: Value(inicio),
      fin: Value(fin),
      totalGrupos: Value(totalGrupos),
      tipoInspeccion: Value(tipoInspeccion),
      anio: Value(anio),
    );
  }

  factory GruposInspecciones.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return GruposInspecciones(
      id: serializer.fromJson<int>(json['id']),
      nGrupo: serializer.fromJson<int>(json['nGrupo']),
      inicio: serializer.fromJson<DateTime>(json['inicio']),
      fin: serializer.fromJson<DateTime>(json['fin']),
      totalGrupos: serializer.fromJson<int>(json['totalGrupos']),
      tipoInspeccion: serializer.fromJson<int>(json['tipoInspeccion']),
      anio: serializer.fromJson<int>(json['anio']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nGrupo': serializer.toJson<int>(nGrupo),
      'inicio': serializer.toJson<DateTime>(inicio),
      'fin': serializer.toJson<DateTime>(fin),
      'totalGrupos': serializer.toJson<int>(totalGrupos),
      'tipoInspeccion': serializer.toJson<int>(tipoInspeccion),
      'anio': serializer.toJson<int>(anio),
    };
  }

  GruposInspecciones copyWith(
          {int? id,
          int? nGrupo,
          DateTime? inicio,
          DateTime? fin,
          int? totalGrupos,
          int? tipoInspeccion,
          int? anio}) =>
      GruposInspecciones(
        id: id ?? this.id,
        nGrupo: nGrupo ?? this.nGrupo,
        inicio: inicio ?? this.inicio,
        fin: fin ?? this.fin,
        totalGrupos: totalGrupos ?? this.totalGrupos,
        tipoInspeccion: tipoInspeccion ?? this.tipoInspeccion,
        anio: anio ?? this.anio,
      );
  @override
  String toString() {
    return (StringBuffer('GruposInspecciones(')
          ..write('id: $id, ')
          ..write('nGrupo: $nGrupo, ')
          ..write('inicio: $inicio, ')
          ..write('fin: $fin, ')
          ..write('totalGrupos: $totalGrupos, ')
          ..write('tipoInspeccion: $tipoInspeccion, ')
          ..write('anio: $anio')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          nGrupo.hashCode,
          $mrjc(
              inicio.hashCode,
              $mrjc(
                  fin.hashCode,
                  $mrjc(totalGrupos.hashCode,
                      $mrjc(tipoInspeccion.hashCode, anio.hashCode)))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GruposInspecciones &&
          other.id == this.id &&
          other.nGrupo == this.nGrupo &&
          other.inicio == this.inicio &&
          other.fin == this.fin &&
          other.totalGrupos == this.totalGrupos &&
          other.tipoInspeccion == this.tipoInspeccion &&
          other.anio == this.anio);
}

class GruposInspeccionessCompanion extends UpdateCompanion<GruposInspecciones> {
  final Value<int> id;
  final Value<int> nGrupo;
  final Value<DateTime> inicio;
  final Value<DateTime> fin;
  final Value<int> totalGrupos;
  final Value<int> tipoInspeccion;
  final Value<int> anio;
  const GruposInspeccionessCompanion({
    this.id = const Value.absent(),
    this.nGrupo = const Value.absent(),
    this.inicio = const Value.absent(),
    this.fin = const Value.absent(),
    this.totalGrupos = const Value.absent(),
    this.tipoInspeccion = const Value.absent(),
    this.anio = const Value.absent(),
  });
  GruposInspeccionessCompanion.insert({
    this.id = const Value.absent(),
    required int nGrupo,
    required DateTime inicio,
    required DateTime fin,
    required int totalGrupos,
    required int tipoInspeccion,
    this.anio = const Value.absent(),
  })  : nGrupo = Value(nGrupo),
        inicio = Value(inicio),
        fin = Value(fin),
        totalGrupos = Value(totalGrupos),
        tipoInspeccion = Value(tipoInspeccion);
  static Insertable<GruposInspecciones> custom({
    Expression<int>? id,
    Expression<int>? nGrupo,
    Expression<DateTime>? inicio,
    Expression<DateTime>? fin,
    Expression<int>? totalGrupos,
    Expression<int>? tipoInspeccion,
    Expression<int>? anio,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nGrupo != null) 'n_grupo': nGrupo,
      if (inicio != null) 'inicio': inicio,
      if (fin != null) 'fin': fin,
      if (totalGrupos != null) 'total_grupos': totalGrupos,
      if (tipoInspeccion != null) 'tipo_inspeccion': tipoInspeccion,
      if (anio != null) 'anio': anio,
    });
  }

  GruposInspeccionessCompanion copyWith(
      {Value<int>? id,
      Value<int>? nGrupo,
      Value<DateTime>? inicio,
      Value<DateTime>? fin,
      Value<int>? totalGrupos,
      Value<int>? tipoInspeccion,
      Value<int>? anio}) {
    return GruposInspeccionessCompanion(
      id: id ?? this.id,
      nGrupo: nGrupo ?? this.nGrupo,
      inicio: inicio ?? this.inicio,
      fin: fin ?? this.fin,
      totalGrupos: totalGrupos ?? this.totalGrupos,
      tipoInspeccion: tipoInspeccion ?? this.tipoInspeccion,
      anio: anio ?? this.anio,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nGrupo.present) {
      map['n_grupo'] = Variable<int>(nGrupo.value);
    }
    if (inicio.present) {
      map['inicio'] = Variable<DateTime>(inicio.value);
    }
    if (fin.present) {
      map['fin'] = Variable<DateTime>(fin.value);
    }
    if (totalGrupos.present) {
      map['total_grupos'] = Variable<int>(totalGrupos.value);
    }
    if (tipoInspeccion.present) {
      map['tipo_inspeccion'] = Variable<int>(tipoInspeccion.value);
    }
    if (anio.present) {
      map['anio'] = Variable<int>(anio.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GruposInspeccionessCompanion(')
          ..write('id: $id, ')
          ..write('nGrupo: $nGrupo, ')
          ..write('inicio: $inicio, ')
          ..write('fin: $fin, ')
          ..write('totalGrupos: $totalGrupos, ')
          ..write('tipoInspeccion: $tipoInspeccion, ')
          ..write('anio: $anio')
          ..write(')'))
        .toString();
  }
}

class $GruposInspeccionessTable extends GruposInspeccioness
    with TableInfo<$GruposInspeccionessTable, GruposInspecciones> {
  final GeneratedDatabase _db;
  final String? _alias;
  $GruposInspeccionessTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _nGrupoMeta = const VerificationMeta('nGrupo');
  late final GeneratedColumn<int?> nGrupo = GeneratedColumn<int?>(
      'n_grupo', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _inicioMeta = const VerificationMeta('inicio');
  late final GeneratedColumn<DateTime?> inicio = GeneratedColumn<DateTime?>(
      'inicio', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _finMeta = const VerificationMeta('fin');
  late final GeneratedColumn<DateTime?> fin = GeneratedColumn<DateTime?>(
      'fin', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _totalGruposMeta =
      const VerificationMeta('totalGrupos');
  late final GeneratedColumn<int?> totalGrupos = GeneratedColumn<int?>(
      'total_grupos', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _tipoInspeccionMeta =
      const VerificationMeta('tipoInspeccion');
  late final GeneratedColumn<int?> tipoInspeccion = GeneratedColumn<int?>(
      'tipo_inspeccion', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      $customConstraints:
          'REFERENCES tipos_de_inspecciones(id) ON DELETE CASCADE');
  final VerificationMeta _anioMeta = const VerificationMeta('anio');
  late final GeneratedColumn<int?> anio = GeneratedColumn<int?>(
      'anio', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      clientDefault: () => inicio.year as int);
  @override
  List<GeneratedColumn> get $columns =>
      [id, nGrupo, inicio, fin, totalGrupos, tipoInspeccion, anio];
  @override
  String get aliasedName => _alias ?? 'grupos_inspeccioness';
  @override
  String get actualTableName => 'grupos_inspeccioness';
  @override
  VerificationContext validateIntegrity(Insertable<GruposInspecciones> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('n_grupo')) {
      context.handle(_nGrupoMeta,
          nGrupo.isAcceptableOrUnknown(data['n_grupo']!, _nGrupoMeta));
    } else if (isInserting) {
      context.missing(_nGrupoMeta);
    }
    if (data.containsKey('inicio')) {
      context.handle(_inicioMeta,
          inicio.isAcceptableOrUnknown(data['inicio']!, _inicioMeta));
    } else if (isInserting) {
      context.missing(_inicioMeta);
    }
    if (data.containsKey('fin')) {
      context.handle(
          _finMeta, fin.isAcceptableOrUnknown(data['fin']!, _finMeta));
    } else if (isInserting) {
      context.missing(_finMeta);
    }
    if (data.containsKey('total_grupos')) {
      context.handle(
          _totalGruposMeta,
          totalGrupos.isAcceptableOrUnknown(
              data['total_grupos']!, _totalGruposMeta));
    } else if (isInserting) {
      context.missing(_totalGruposMeta);
    }
    if (data.containsKey('tipo_inspeccion')) {
      context.handle(
          _tipoInspeccionMeta,
          tipoInspeccion.isAcceptableOrUnknown(
              data['tipo_inspeccion']!, _tipoInspeccionMeta));
    } else if (isInserting) {
      context.missing(_tipoInspeccionMeta);
    }
    if (data.containsKey('anio')) {
      context.handle(
          _anioMeta, anio.isAcceptableOrUnknown(data['anio']!, _anioMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GruposInspecciones map(Map<String, dynamic> data, {String? tablePrefix}) {
    return GruposInspecciones.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $GruposInspeccionessTable createAlias(String alias) {
    return $GruposInspeccionessTable(_db, alias);
  }
}

class ProgramacionSistema extends DataClass
    implements Insertable<ProgramacionSistema> {
  final int id;
  final int activoId;
  final int grupoId;
  final int mes;
  final EstadoProgramacion estado;
  ProgramacionSistema(
      {required this.id,
      required this.activoId,
      required this.grupoId,
      required this.mes,
      required this.estado});
  factory ProgramacionSistema.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return ProgramacionSistema(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      activoId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}activo_id'])!,
      grupoId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}grupo_id'])!,
      mes: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}mes'])!,
      estado: $ProgramacionSistemasTable.$converter0.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}estado']))!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['activo_id'] = Variable<int>(activoId);
    map['grupo_id'] = Variable<int>(grupoId);
    map['mes'] = Variable<int>(mes);
    {
      final converter = $ProgramacionSistemasTable.$converter0;
      map['estado'] = Variable<int>(converter.mapToSql(estado)!);
    }
    return map;
  }

  ProgramacionSistemasCompanion toCompanion(bool nullToAbsent) {
    return ProgramacionSistemasCompanion(
      id: Value(id),
      activoId: Value(activoId),
      grupoId: Value(grupoId),
      mes: Value(mes),
      estado: Value(estado),
    );
  }

  factory ProgramacionSistema.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return ProgramacionSistema(
      id: serializer.fromJson<int>(json['id']),
      activoId: serializer.fromJson<int>(json['activoId']),
      grupoId: serializer.fromJson<int>(json['grupoId']),
      mes: serializer.fromJson<int>(json['mes']),
      estado: serializer.fromJson<EstadoProgramacion>(json['estado']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'activoId': serializer.toJson<int>(activoId),
      'grupoId': serializer.toJson<int>(grupoId),
      'mes': serializer.toJson<int>(mes),
      'estado': serializer.toJson<EstadoProgramacion>(estado),
    };
  }

  ProgramacionSistema copyWith(
          {int? id,
          int? activoId,
          int? grupoId,
          int? mes,
          EstadoProgramacion? estado}) =>
      ProgramacionSistema(
        id: id ?? this.id,
        activoId: activoId ?? this.activoId,
        grupoId: grupoId ?? this.grupoId,
        mes: mes ?? this.mes,
        estado: estado ?? this.estado,
      );
  @override
  String toString() {
    return (StringBuffer('ProgramacionSistema(')
          ..write('id: $id, ')
          ..write('activoId: $activoId, ')
          ..write('grupoId: $grupoId, ')
          ..write('mes: $mes, ')
          ..write('estado: $estado')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(activoId.hashCode,
          $mrjc(grupoId.hashCode, $mrjc(mes.hashCode, estado.hashCode)))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProgramacionSistema &&
          other.id == this.id &&
          other.activoId == this.activoId &&
          other.grupoId == this.grupoId &&
          other.mes == this.mes &&
          other.estado == this.estado);
}

class ProgramacionSistemasCompanion
    extends UpdateCompanion<ProgramacionSistema> {
  final Value<int> id;
  final Value<int> activoId;
  final Value<int> grupoId;
  final Value<int> mes;
  final Value<EstadoProgramacion> estado;
  const ProgramacionSistemasCompanion({
    this.id = const Value.absent(),
    this.activoId = const Value.absent(),
    this.grupoId = const Value.absent(),
    this.mes = const Value.absent(),
    this.estado = const Value.absent(),
  });
  ProgramacionSistemasCompanion.insert({
    this.id = const Value.absent(),
    required int activoId,
    required int grupoId,
    required int mes,
    required EstadoProgramacion estado,
  })  : activoId = Value(activoId),
        grupoId = Value(grupoId),
        mes = Value(mes),
        estado = Value(estado);
  static Insertable<ProgramacionSistema> custom({
    Expression<int>? id,
    Expression<int>? activoId,
    Expression<int>? grupoId,
    Expression<int>? mes,
    Expression<EstadoProgramacion>? estado,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (activoId != null) 'activo_id': activoId,
      if (grupoId != null) 'grupo_id': grupoId,
      if (mes != null) 'mes': mes,
      if (estado != null) 'estado': estado,
    });
  }

  ProgramacionSistemasCompanion copyWith(
      {Value<int>? id,
      Value<int>? activoId,
      Value<int>? grupoId,
      Value<int>? mes,
      Value<EstadoProgramacion>? estado}) {
    return ProgramacionSistemasCompanion(
      id: id ?? this.id,
      activoId: activoId ?? this.activoId,
      grupoId: grupoId ?? this.grupoId,
      mes: mes ?? this.mes,
      estado: estado ?? this.estado,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (activoId.present) {
      map['activo_id'] = Variable<int>(activoId.value);
    }
    if (grupoId.present) {
      map['grupo_id'] = Variable<int>(grupoId.value);
    }
    if (mes.present) {
      map['mes'] = Variable<int>(mes.value);
    }
    if (estado.present) {
      final converter = $ProgramacionSistemasTable.$converter0;
      map['estado'] = Variable<int>(converter.mapToSql(estado.value)!);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgramacionSistemasCompanion(')
          ..write('id: $id, ')
          ..write('activoId: $activoId, ')
          ..write('grupoId: $grupoId, ')
          ..write('mes: $mes, ')
          ..write('estado: $estado')
          ..write(')'))
        .toString();
  }
}

class $ProgramacionSistemasTable extends ProgramacionSistemas
    with TableInfo<$ProgramacionSistemasTable, ProgramacionSistema> {
  final GeneratedDatabase _db;
  final String? _alias;
  $ProgramacionSistemasTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _activoIdMeta = const VerificationMeta('activoId');
  late final GeneratedColumn<int?> activoId = GeneratedColumn<int?>(
      'activo_id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES activos(id) ON DELETE CASCADE');
  final VerificationMeta _grupoIdMeta = const VerificationMeta('grupoId');
  late final GeneratedColumn<int?> grupoId = GeneratedColumn<int?>(
      'grupo_id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      $customConstraints:
          'REFERENCES grupos_inspeccioness(id) ON DELETE CASCADE');
  final VerificationMeta _mesMeta = const VerificationMeta('mes');
  late final GeneratedColumn<int?> mes = GeneratedColumn<int?>(
      'mes', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _estadoMeta = const VerificationMeta('estado');
  late final GeneratedColumnWithTypeConverter<EstadoProgramacion, int?> estado =
      GeneratedColumn<int?>('estado', aliasedName, false,
              typeName: 'INTEGER', requiredDuringInsert: true)
          .withConverter<EstadoProgramacion>(
              $ProgramacionSistemasTable.$converter0);
  @override
  List<GeneratedColumn> get $columns => [id, activoId, grupoId, mes, estado];
  @override
  String get aliasedName => _alias ?? 'programacion_sistemas';
  @override
  String get actualTableName => 'programacion_sistemas';
  @override
  VerificationContext validateIntegrity(
      Insertable<ProgramacionSistema> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('activo_id')) {
      context.handle(_activoIdMeta,
          activoId.isAcceptableOrUnknown(data['activo_id']!, _activoIdMeta));
    } else if (isInserting) {
      context.missing(_activoIdMeta);
    }
    if (data.containsKey('grupo_id')) {
      context.handle(_grupoIdMeta,
          grupoId.isAcceptableOrUnknown(data['grupo_id']!, _grupoIdMeta));
    } else if (isInserting) {
      context.missing(_grupoIdMeta);
    }
    if (data.containsKey('mes')) {
      context.handle(
          _mesMeta, mes.isAcceptableOrUnknown(data['mes']!, _mesMeta));
    } else if (isInserting) {
      context.missing(_mesMeta);
    }
    context.handle(_estadoMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProgramacionSistema map(Map<String, dynamic> data, {String? tablePrefix}) {
    return ProgramacionSistema.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ProgramacionSistemasTable createAlias(String alias) {
    return $ProgramacionSistemasTable(_db, alias);
  }

  static TypeConverter<EstadoProgramacion, int> $converter0 =
      const EnumIndexConverter<EstadoProgramacion>(EstadoProgramacion.values);
}

class ProgramacionSistemasXActivoData extends DataClass
    implements Insertable<ProgramacionSistemasXActivoData> {
  final int id;
  final int programacionSistemaId;
  final int sistemaId;
  ProgramacionSistemasXActivoData(
      {required this.id,
      required this.programacionSistemaId,
      required this.sistemaId});
  factory ProgramacionSistemasXActivoData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return ProgramacionSistemasXActivoData(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      programacionSistemaId: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}programacion_sistema_id'])!,
      sistemaId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}sistema_id'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['programacion_sistema_id'] = Variable<int>(programacionSistemaId);
    map['sistema_id'] = Variable<int>(sistemaId);
    return map;
  }

  ProgramacionSistemasXActivoCompanion toCompanion(bool nullToAbsent) {
    return ProgramacionSistemasXActivoCompanion(
      id: Value(id),
      programacionSistemaId: Value(programacionSistemaId),
      sistemaId: Value(sistemaId),
    );
  }

  factory ProgramacionSistemasXActivoData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return ProgramacionSistemasXActivoData(
      id: serializer.fromJson<int>(json['id']),
      programacionSistemaId:
          serializer.fromJson<int>(json['programacionSistemaId']),
      sistemaId: serializer.fromJson<int>(json['sistema']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'programacionSistemaId': serializer.toJson<int>(programacionSistemaId),
      'sistema': serializer.toJson<int>(sistemaId),
    };
  }

  ProgramacionSistemasXActivoData copyWith(
          {int? id, int? programacionSistemaId, int? sistemaId}) =>
      ProgramacionSistemasXActivoData(
        id: id ?? this.id,
        programacionSistemaId:
            programacionSistemaId ?? this.programacionSistemaId,
        sistemaId: sistemaId ?? this.sistemaId,
      );
  @override
  String toString() {
    return (StringBuffer('ProgramacionSistemasXActivoData(')
          ..write('id: $id, ')
          ..write('programacionSistemaId: $programacionSistemaId, ')
          ..write('sistemaId: $sistemaId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode, $mrjc(programacionSistemaId.hashCode, sistemaId.hashCode)));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProgramacionSistemasXActivoData &&
          other.id == this.id &&
          other.programacionSistemaId == this.programacionSistemaId &&
          other.sistemaId == this.sistemaId);
}

class ProgramacionSistemasXActivoCompanion
    extends UpdateCompanion<ProgramacionSistemasXActivoData> {
  final Value<int> id;
  final Value<int> programacionSistemaId;
  final Value<int> sistemaId;
  const ProgramacionSistemasXActivoCompanion({
    this.id = const Value.absent(),
    this.programacionSistemaId = const Value.absent(),
    this.sistemaId = const Value.absent(),
  });
  ProgramacionSistemasXActivoCompanion.insert({
    this.id = const Value.absent(),
    required int programacionSistemaId,
    required int sistemaId,
  })  : programacionSistemaId = Value(programacionSistemaId),
        sistemaId = Value(sistemaId);
  static Insertable<ProgramacionSistemasXActivoData> custom({
    Expression<int>? id,
    Expression<int>? programacionSistemaId,
    Expression<int>? sistemaId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (programacionSistemaId != null)
        'programacion_sistema_id': programacionSistemaId,
      if (sistemaId != null) 'sistema_id': sistemaId,
    });
  }

  ProgramacionSistemasXActivoCompanion copyWith(
      {Value<int>? id,
      Value<int>? programacionSistemaId,
      Value<int>? sistemaId}) {
    return ProgramacionSistemasXActivoCompanion(
      id: id ?? this.id,
      programacionSistemaId:
          programacionSistemaId ?? this.programacionSistemaId,
      sistemaId: sistemaId ?? this.sistemaId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (programacionSistemaId.present) {
      map['programacion_sistema_id'] =
          Variable<int>(programacionSistemaId.value);
    }
    if (sistemaId.present) {
      map['sistema_id'] = Variable<int>(sistemaId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgramacionSistemasXActivoCompanion(')
          ..write('id: $id, ')
          ..write('programacionSistemaId: $programacionSistemaId, ')
          ..write('sistemaId: $sistemaId')
          ..write(')'))
        .toString();
  }
}

class $ProgramacionSistemasXActivoTable extends ProgramacionSistemasXActivo
    with
        TableInfo<$ProgramacionSistemasXActivoTable,
            ProgramacionSistemasXActivoData> {
  final GeneratedDatabase _db;
  final String? _alias;
  $ProgramacionSistemasXActivoTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _programacionSistemaIdMeta =
      const VerificationMeta('programacionSistemaId');
  late final GeneratedColumn<int?> programacionSistemaId =
      GeneratedColumn<int?>('programacion_sistema_id', aliasedName, false,
          typeName: 'INTEGER',
          requiredDuringInsert: true,
          $customConstraints:
              'REFERENCES programacion_sistemas(id) ON DELETE CASCADE');
  final VerificationMeta _sistemaIdMeta = const VerificationMeta('sistemaId');
  late final GeneratedColumn<int?> sistemaId = GeneratedColumn<int?>(
      'sistema_id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES sistemas(id) ON DELETE CASCADE');
  @override
  List<GeneratedColumn> get $columns => [id, programacionSistemaId, sistemaId];
  @override
  String get aliasedName => _alias ?? 'programacion_sistemas_x_activo';
  @override
  String get actualTableName => 'programacion_sistemas_x_activo';
  @override
  VerificationContext validateIntegrity(
      Insertable<ProgramacionSistemasXActivoData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('programacion_sistema_id')) {
      context.handle(
          _programacionSistemaIdMeta,
          programacionSistemaId.isAcceptableOrUnknown(
              data['programacion_sistema_id']!, _programacionSistemaIdMeta));
    } else if (isInserting) {
      context.missing(_programacionSistemaIdMeta);
    }
    if (data.containsKey('sistema_id')) {
      context.handle(_sistemaIdMeta,
          sistemaId.isAcceptableOrUnknown(data['sistema_id']!, _sistemaIdMeta));
    } else if (isInserting) {
      context.missing(_sistemaIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProgramacionSistemasXActivoData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    return ProgramacionSistemasXActivoData.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ProgramacionSistemasXActivoTable createAlias(String alias) {
    return $ProgramacionSistemasXActivoTable(_db, alias);
  }
}

class TiposDeInspeccione extends DataClass
    implements Insertable<TiposDeInspeccione> {
  final int id;
  final String tipo;
  TiposDeInspeccione({required this.id, required this.tipo});
  factory TiposDeInspeccione.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return TiposDeInspeccione(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      tipo: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}tipo'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tipo'] = Variable<String>(tipo);
    return map;
  }

  TiposDeInspeccionesCompanion toCompanion(bool nullToAbsent) {
    return TiposDeInspeccionesCompanion(
      id: Value(id),
      tipo: Value(tipo),
    );
  }

  factory TiposDeInspeccione.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return TiposDeInspeccione(
      id: serializer.fromJson<int>(json['id']),
      tipo: serializer.fromJson<String>(json['tipo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tipo': serializer.toJson<String>(tipo),
    };
  }

  TiposDeInspeccione copyWith({int? id, String? tipo}) => TiposDeInspeccione(
        id: id ?? this.id,
        tipo: tipo ?? this.tipo,
      );
  @override
  String toString() {
    return (StringBuffer('TiposDeInspeccione(')
          ..write('id: $id, ')
          ..write('tipo: $tipo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode, tipo.hashCode));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TiposDeInspeccione &&
          other.id == this.id &&
          other.tipo == this.tipo);
}

class TiposDeInspeccionesCompanion extends UpdateCompanion<TiposDeInspeccione> {
  final Value<int> id;
  final Value<String> tipo;
  const TiposDeInspeccionesCompanion({
    this.id = const Value.absent(),
    this.tipo = const Value.absent(),
  });
  TiposDeInspeccionesCompanion.insert({
    this.id = const Value.absent(),
    required String tipo,
  }) : tipo = Value(tipo);
  static Insertable<TiposDeInspeccione> custom({
    Expression<int>? id,
    Expression<String>? tipo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tipo != null) 'tipo': tipo,
    });
  }

  TiposDeInspeccionesCompanion copyWith({Value<int>? id, Value<String>? tipo}) {
    return TiposDeInspeccionesCompanion(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TiposDeInspeccionesCompanion(')
          ..write('id: $id, ')
          ..write('tipo: $tipo')
          ..write(')'))
        .toString();
  }
}

class $TiposDeInspeccionesTable extends TiposDeInspecciones
    with TableInfo<$TiposDeInspeccionesTable, TiposDeInspeccione> {
  final GeneratedDatabase _db;
  final String? _alias;
  $TiposDeInspeccionesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  late final GeneratedColumn<String?> tipo = GeneratedColumn<String?>(
      'tipo', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, tipo];
  @override
  String get aliasedName => _alias ?? 'tipos_de_inspecciones';
  @override
  String get actualTableName => 'tipos_de_inspecciones';
  @override
  VerificationContext validateIntegrity(Insertable<TiposDeInspeccione> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tipo')) {
      context.handle(
          _tipoMeta, tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta));
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TiposDeInspeccione map(Map<String, dynamic> data, {String? tablePrefix}) {
    return TiposDeInspeccione.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $TiposDeInspeccionesTable createAlias(String alias) {
    return $TiposDeInspeccionesTable(_db, alias);
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $ActivosTable activos = $ActivosTable(this);
  late final $CuestionarioDeModelosTable cuestionarioDeModelos =
      $CuestionarioDeModelosTable(this);
  late final $CuestionariosTable cuestionarios = $CuestionariosTable(this);
  late final $BloquesTable bloques = $BloquesTable(this);
  late final $TitulosTable titulos = $TitulosTable(this);
  late final $CuadriculasDePreguntasTable cuadriculasDePreguntas =
      $CuadriculasDePreguntasTable(this);
  late final $PreguntasTable preguntas = $PreguntasTable(this);
  late final $OpcionesDeRespuestaTable opcionesDeRespuesta =
      $OpcionesDeRespuestaTable(this);
  late final $InspeccionesTable inspecciones = $InspeccionesTable(this);
  late final $RespuestasTable respuestas = $RespuestasTable(this);
  late final $ContratistasTable contratistas = $ContratistasTable(this);
  late final $SistemasTable sistemas = $SistemasTable(this);
  late final $SubSistemasTable subSistemas = $SubSistemasTable(this);
  late final $CriticidadesNumericasTable criticidadesNumericas =
      $CriticidadesNumericasTable(this);
  late final $GruposInspeccionessTable gruposInspeccioness =
      $GruposInspeccionessTable(this);
  late final $ProgramacionSistemasTable programacionSistemas =
      $ProgramacionSistemasTable(this);
  late final $ProgramacionSistemasXActivoTable programacionSistemasXActivo =
      $ProgramacionSistemasXActivoTable(this);
  late final $TiposDeInspeccionesTable tiposDeInspecciones =
      $TiposDeInspeccionesTable(this);
  late final LlenadoDao llenadoDao = LlenadoDao(this as Database);
  late final CreacionDao creacionDao = CreacionDao(this as Database);
  late final BorradoresDao borradoresDao = BorradoresDao(this as Database);
  late final PlaneacionDao planeacionDao = PlaneacionDao(this as Database);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        activos,
        cuestionarioDeModelos,
        cuestionarios,
        bloques,
        titulos,
        cuadriculasDePreguntas,
        preguntas,
        opcionesDeRespuesta,
        inspecciones,
        respuestas,
        contratistas,
        sistemas,
        subSistemas,
        criticidadesNumericas,
        gruposInspeccioness,
        programacionSistemas,
        programacionSistemasXActivo,
        tiposDeInspecciones
      ];
}
