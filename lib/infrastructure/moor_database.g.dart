// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RespuestaConOpcionesDeRespuesta2 _$RespuestaConOpcionesDeRespuesta2FromJson(
    Map<String, dynamic> json) {
  return RespuestaConOpcionesDeRespuesta2(
    json['respuesta'],
    json['opcionesDeRespuesta'] as List,
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
  Activo({@required this.id, @required this.modelo});
  factory Activo.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Activo(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      modelo:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}modelo']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || modelo != null) {
      map['modelo'] = Variable<String>(modelo);
    }
    return map;
  }

  ActivosCompanion toCompanion(bool nullToAbsent) {
    return ActivosCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      modelo:
          modelo == null && nullToAbsent ? const Value.absent() : Value(modelo),
    );
  }

  factory Activo.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Activo(
      id: serializer.fromJson<int>(json['id']),
      modelo: serializer.fromJson<String>(json['modelo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'modelo': serializer.toJson<String>(modelo),
    };
  }

  Activo copyWith({int id, String modelo}) => Activo(
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
  bool operator ==(dynamic other) =>
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
    @required String modelo,
  }) : modelo = Value(modelo);
  static Insertable<Activo> custom({
    Expression<int> id,
    Expression<String> modelo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (modelo != null) 'modelo': modelo,
    });
  }

  ActivosCompanion copyWith({Value<int> id, Value<String> modelo}) {
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
  final String _alias;
  $ActivosTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _modeloMeta = const VerificationMeta('modelo');
  GeneratedTextColumn _modelo;
  @override
  GeneratedTextColumn get modelo => _modelo ??= _constructModelo();
  GeneratedTextColumn _constructModelo() {
    return GeneratedTextColumn(
      'modelo',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, modelo];
  @override
  $ActivosTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'activos';
  @override
  final String actualTableName = 'activos';
  @override
  VerificationContext validateIntegrity(Insertable<Activo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('modelo')) {
      context.handle(_modeloMeta,
          modelo.isAcceptableOrUnknown(data['modelo'], _modeloMeta));
    } else if (isInserting) {
      context.missing(_modeloMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Activo map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Activo.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $ActivosTable createAlias(String alias) {
    return $ActivosTable(_db, alias);
  }
}

class CuestionarioDeModelo extends DataClass
    implements Insertable<CuestionarioDeModelo> {
  final int id;
  final String modelo;
  final int periodicidad;
  final int cuestionarioId;
  final int contratistaId;
  CuestionarioDeModelo(
      {@required this.id,
      @required this.modelo,
      @required this.periodicidad,
      @required this.cuestionarioId,
      this.contratistaId});
  factory CuestionarioDeModelo.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return CuestionarioDeModelo(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      modelo:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}modelo']),
      periodicidad: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}periodicidad']),
      cuestionarioId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}cuestionario_id']),
      contratistaId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}contratista_id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || modelo != null) {
      map['modelo'] = Variable<String>(modelo);
    }
    if (!nullToAbsent || periodicidad != null) {
      map['periodicidad'] = Variable<int>(periodicidad);
    }
    if (!nullToAbsent || cuestionarioId != null) {
      map['cuestionario_id'] = Variable<int>(cuestionarioId);
    }
    if (!nullToAbsent || contratistaId != null) {
      map['contratista_id'] = Variable<int>(contratistaId);
    }
    return map;
  }

  CuestionarioDeModelosCompanion toCompanion(bool nullToAbsent) {
    return CuestionarioDeModelosCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      modelo:
          modelo == null && nullToAbsent ? const Value.absent() : Value(modelo),
      periodicidad: periodicidad == null && nullToAbsent
          ? const Value.absent()
          : Value(periodicidad),
      cuestionarioId: cuestionarioId == null && nullToAbsent
          ? const Value.absent()
          : Value(cuestionarioId),
      contratistaId: contratistaId == null && nullToAbsent
          ? const Value.absent()
          : Value(contratistaId),
    );
  }

  factory CuestionarioDeModelo.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return CuestionarioDeModelo(
      id: serializer.fromJson<int>(json['id']),
      modelo: serializer.fromJson<String>(json['modelo']),
      periodicidad: serializer.fromJson<int>(json['periodicidad']),
      cuestionarioId: serializer.fromJson<int>(json['cuestionario']),
      contratistaId: serializer.fromJson<int>(json['contratista']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'modelo': serializer.toJson<String>(modelo),
      'periodicidad': serializer.toJson<int>(periodicidad),
      'cuestionario': serializer.toJson<int>(cuestionarioId),
      'contratista': serializer.toJson<int>(contratistaId),
    };
  }

  CuestionarioDeModelo copyWith(
          {int id,
          String modelo,
          int periodicidad,
          int cuestionarioId,
          int contratistaId}) =>
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
  bool operator ==(dynamic other) =>
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
  final Value<int> contratistaId;
  const CuestionarioDeModelosCompanion({
    this.id = const Value.absent(),
    this.modelo = const Value.absent(),
    this.periodicidad = const Value.absent(),
    this.cuestionarioId = const Value.absent(),
    this.contratistaId = const Value.absent(),
  });
  CuestionarioDeModelosCompanion.insert({
    this.id = const Value.absent(),
    @required String modelo,
    @required int periodicidad,
    @required int cuestionarioId,
    this.contratistaId = const Value.absent(),
  })  : modelo = Value(modelo),
        periodicidad = Value(periodicidad),
        cuestionarioId = Value(cuestionarioId);
  static Insertable<CuestionarioDeModelo> custom({
    Expression<int> id,
    Expression<String> modelo,
    Expression<int> periodicidad,
    Expression<int> cuestionarioId,
    Expression<int> contratistaId,
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
      {Value<int> id,
      Value<String> modelo,
      Value<int> periodicidad,
      Value<int> cuestionarioId,
      Value<int> contratistaId}) {
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
      map['contratista_id'] = Variable<int>(contratistaId.value);
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
  final String _alias;
  $CuestionarioDeModelosTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _modeloMeta = const VerificationMeta('modelo');
  GeneratedTextColumn _modelo;
  @override
  GeneratedTextColumn get modelo => _modelo ??= _constructModelo();
  GeneratedTextColumn _constructModelo() {
    return GeneratedTextColumn(
      'modelo',
      $tableName,
      false,
    );
  }

  final VerificationMeta _periodicidadMeta =
      const VerificationMeta('periodicidad');
  GeneratedIntColumn _periodicidad;
  @override
  GeneratedIntColumn get periodicidad =>
      _periodicidad ??= _constructPeriodicidad();
  GeneratedIntColumn _constructPeriodicidad() {
    return GeneratedIntColumn(
      'periodicidad',
      $tableName,
      false,
    );
  }

  final VerificationMeta _cuestionarioIdMeta =
      const VerificationMeta('cuestionarioId');
  GeneratedIntColumn _cuestionarioId;
  @override
  GeneratedIntColumn get cuestionarioId =>
      _cuestionarioId ??= _constructCuestionarioId();
  GeneratedIntColumn _constructCuestionarioId() {
    return GeneratedIntColumn('cuestionario_id', $tableName, false,
        $customConstraints: 'REFERENCES cuestionarios(id) ON DELETE CASCADE');
  }

  final VerificationMeta _contratistaIdMeta =
      const VerificationMeta('contratistaId');
  GeneratedIntColumn _contratistaId;
  @override
  GeneratedIntColumn get contratistaId =>
      _contratistaId ??= _constructContratistaId();
  GeneratedIntColumn _constructContratistaId() {
    return GeneratedIntColumn('contratista_id', $tableName, true,
        $customConstraints: 'REFERENCES contratistas(id) ON DELETE SET NULL');
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, modelo, periodicidad, cuestionarioId, contratistaId];
  @override
  $CuestionarioDeModelosTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'cuestionario_de_modelos';
  @override
  final String actualTableName = 'cuestionario_de_modelos';
  @override
  VerificationContext validateIntegrity(
      Insertable<CuestionarioDeModelo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('modelo')) {
      context.handle(_modeloMeta,
          modelo.isAcceptableOrUnknown(data['modelo'], _modeloMeta));
    } else if (isInserting) {
      context.missing(_modeloMeta);
    }
    if (data.containsKey('periodicidad')) {
      context.handle(
          _periodicidadMeta,
          periodicidad.isAcceptableOrUnknown(
              data['periodicidad'], _periodicidadMeta));
    } else if (isInserting) {
      context.missing(_periodicidadMeta);
    }
    if (data.containsKey('cuestionario_id')) {
      context.handle(
          _cuestionarioIdMeta,
          cuestionarioId.isAcceptableOrUnknown(
              data['cuestionario_id'], _cuestionarioIdMeta));
    } else if (isInserting) {
      context.missing(_cuestionarioIdMeta);
    }
    if (data.containsKey('contratista_id')) {
      context.handle(
          _contratistaIdMeta,
          contratistaId.isAcceptableOrUnknown(
              data['contratista_id'], _contratistaIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CuestionarioDeModelo map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return CuestionarioDeModelo.fromData(data, _db, prefix: effectivePrefix);
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
  final bool esLocal;
  Cuestionario(
      {@required this.id,
      @required this.tipoDeInspeccion,
      @required this.estado,
      @required this.esLocal});
  factory Cuestionario.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    return Cuestionario(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      tipoDeInspeccion: stringType.mapFromDatabaseResponse(
          data['${effectivePrefix}tipo_de_inspeccion']),
      estado: $CuestionariosTable.$converter0.mapToDart(
          intType.mapFromDatabaseResponse(data['${effectivePrefix}estado'])),
      esLocal:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}es_local']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || tipoDeInspeccion != null) {
      map['tipo_de_inspeccion'] = Variable<String>(tipoDeInspeccion);
    }
    if (!nullToAbsent || estado != null) {
      final converter = $CuestionariosTable.$converter0;
      map['estado'] = Variable<int>(converter.mapToSql(estado));
    }
    if (!nullToAbsent || esLocal != null) {
      map['es_local'] = Variable<bool>(esLocal);
    }
    return map;
  }

  CuestionariosCompanion toCompanion(bool nullToAbsent) {
    return CuestionariosCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      tipoDeInspeccion: tipoDeInspeccion == null && nullToAbsent
          ? const Value.absent()
          : Value(tipoDeInspeccion),
      estado:
          estado == null && nullToAbsent ? const Value.absent() : Value(estado),
      esLocal: esLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(esLocal),
    );
  }

  factory Cuestionario.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Cuestionario(
      id: serializer.fromJson<int>(json['id']),
      tipoDeInspeccion: serializer.fromJson<String>(json['tipoDeInspeccion']),
      estado: serializer.fromJson<EstadoDeCuestionario>(json['estado']),
      esLocal: serializer.fromJson<bool>(json['esLocal']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tipoDeInspeccion': serializer.toJson<String>(tipoDeInspeccion),
      'estado': serializer.toJson<EstadoDeCuestionario>(estado),
      'esLocal': serializer.toJson<bool>(esLocal),
    };
  }

  Cuestionario copyWith(
          {int id,
          String tipoDeInspeccion,
          EstadoDeCuestionario estado,
          bool esLocal}) =>
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
  bool operator ==(dynamic other) =>
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
    @required String tipoDeInspeccion,
    @required EstadoDeCuestionario estado,
    this.esLocal = const Value.absent(),
  })  : tipoDeInspeccion = Value(tipoDeInspeccion),
        estado = Value(estado);
  static Insertable<Cuestionario> custom({
    Expression<int> id,
    Expression<String> tipoDeInspeccion,
    Expression<int> estado,
    Expression<bool> esLocal,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tipoDeInspeccion != null) 'tipo_de_inspeccion': tipoDeInspeccion,
      if (estado != null) 'estado': estado,
      if (esLocal != null) 'es_local': esLocal,
    });
  }

  CuestionariosCompanion copyWith(
      {Value<int> id,
      Value<String> tipoDeInspeccion,
      Value<EstadoDeCuestionario> estado,
      Value<bool> esLocal}) {
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
      map['estado'] = Variable<int>(converter.mapToSql(estado.value));
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
  final String _alias;
  $CuestionariosTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _tipoDeInspeccionMeta =
      const VerificationMeta('tipoDeInspeccion');
  GeneratedTextColumn _tipoDeInspeccion;
  @override
  GeneratedTextColumn get tipoDeInspeccion =>
      _tipoDeInspeccion ??= _constructTipoDeInspeccion();
  GeneratedTextColumn _constructTipoDeInspeccion() {
    return GeneratedTextColumn(
      'tipo_de_inspeccion',
      $tableName,
      false,
    );
  }

  final VerificationMeta _estadoMeta = const VerificationMeta('estado');
  GeneratedIntColumn _estado;
  @override
  GeneratedIntColumn get estado => _estado ??= _constructEstado();
  GeneratedIntColumn _constructEstado() {
    return GeneratedIntColumn(
      'estado',
      $tableName,
      false,
    );
  }

  final VerificationMeta _esLocalMeta = const VerificationMeta('esLocal');
  GeneratedBoolColumn _esLocal;
  @override
  GeneratedBoolColumn get esLocal => _esLocal ??= _constructEsLocal();
  GeneratedBoolColumn _constructEsLocal() {
    return GeneratedBoolColumn('es_local', $tableName, false,
        defaultValue: const Constant(true));
  }

  @override
  List<GeneratedColumn> get $columns => [id, tipoDeInspeccion, estado, esLocal];
  @override
  $CuestionariosTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'cuestionarios';
  @override
  final String actualTableName = 'cuestionarios';
  @override
  VerificationContext validateIntegrity(Insertable<Cuestionario> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('tipo_de_inspeccion')) {
      context.handle(
          _tipoDeInspeccionMeta,
          tipoDeInspeccion.isAcceptableOrUnknown(
              data['tipo_de_inspeccion'], _tipoDeInspeccionMeta));
    } else if (isInserting) {
      context.missing(_tipoDeInspeccionMeta);
    }
    context.handle(_estadoMeta, const VerificationResult.success());
    if (data.containsKey('es_local')) {
      context.handle(_esLocalMeta,
          esLocal.isAcceptableOrUnknown(data['es_local'], _esLocalMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Cuestionario map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Cuestionario.fromData(data, _db, prefix: effectivePrefix);
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
  final int nOrden;
  final int cuestionarioId;
  Bloque(
      {@required this.id,
      @required this.nOrden,
      @required this.cuestionarioId});
  factory Bloque.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    return Bloque(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      nOrden:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}n_orden']),
      cuestionarioId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}cuestionario_id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || nOrden != null) {
      map['n_orden'] = Variable<int>(nOrden);
    }
    if (!nullToAbsent || cuestionarioId != null) {
      map['cuestionario_id'] = Variable<int>(cuestionarioId);
    }
    return map;
  }

  BloquesCompanion toCompanion(bool nullToAbsent) {
    return BloquesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      nOrden:
          nOrden == null && nullToAbsent ? const Value.absent() : Value(nOrden),
      cuestionarioId: cuestionarioId == null && nullToAbsent
          ? const Value.absent()
          : Value(cuestionarioId),
    );
  }

  factory Bloque.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Bloque(
      id: serializer.fromJson<int>(json['id']),
      nOrden: serializer.fromJson<int>(json['nOrden']),
      cuestionarioId: serializer.fromJson<int>(json['cuestionario']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nOrden': serializer.toJson<int>(nOrden),
      'cuestionario': serializer.toJson<int>(cuestionarioId),
    };
  }

  Bloque copyWith({int id, int nOrden, int cuestionarioId}) => Bloque(
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
  bool operator ==(dynamic other) =>
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
    @required int nOrden,
    @required int cuestionarioId,
  })  : nOrden = Value(nOrden),
        cuestionarioId = Value(cuestionarioId);
  static Insertable<Bloque> custom({
    Expression<int> id,
    Expression<int> nOrden,
    Expression<int> cuestionarioId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nOrden != null) 'n_orden': nOrden,
      if (cuestionarioId != null) 'cuestionario_id': cuestionarioId,
    });
  }

  BloquesCompanion copyWith(
      {Value<int> id, Value<int> nOrden, Value<int> cuestionarioId}) {
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
  final String _alias;
  $BloquesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nOrdenMeta = const VerificationMeta('nOrden');
  GeneratedIntColumn _nOrden;
  @override
  GeneratedIntColumn get nOrden => _nOrden ??= _constructNOrden();
  GeneratedIntColumn _constructNOrden() {
    return GeneratedIntColumn(
      'n_orden',
      $tableName,
      false,
    );
  }

  final VerificationMeta _cuestionarioIdMeta =
      const VerificationMeta('cuestionarioId');
  GeneratedIntColumn _cuestionarioId;
  @override
  GeneratedIntColumn get cuestionarioId =>
      _cuestionarioId ??= _constructCuestionarioId();
  GeneratedIntColumn _constructCuestionarioId() {
    return GeneratedIntColumn('cuestionario_id', $tableName, false,
        $customConstraints: 'REFERENCES cuestionarios(id) ON DELETE CASCADE');
  }

  @override
  List<GeneratedColumn> get $columns => [id, nOrden, cuestionarioId];
  @override
  $BloquesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'bloques';
  @override
  final String actualTableName = 'bloques';
  @override
  VerificationContext validateIntegrity(Insertable<Bloque> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('n_orden')) {
      context.handle(_nOrdenMeta,
          nOrden.isAcceptableOrUnknown(data['n_orden'], _nOrdenMeta));
    } else if (isInserting) {
      context.missing(_nOrdenMeta);
    }
    if (data.containsKey('cuestionario_id')) {
      context.handle(
          _cuestionarioIdMeta,
          cuestionarioId.isAcceptableOrUnknown(
              data['cuestionario_id'], _cuestionarioIdMeta));
    } else if (isInserting) {
      context.missing(_cuestionarioIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Bloque map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Bloque.fromData(data, _db, prefix: effectivePrefix);
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
  final KtList<String> fotos;
  final int bloqueId;
  Titulo(
      {@required this.id,
      @required this.titulo,
      @required this.descripcion,
      @required this.fotos,
      @required this.bloqueId});
  factory Titulo.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Titulo(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      titulo:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}titulo']),
      descripcion: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}descripcion']),
      fotos: $TitulosTable.$converter0.mapToDart(
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}fotos'])),
      bloqueId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}bloque_id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || titulo != null) {
      map['titulo'] = Variable<String>(titulo);
    }
    if (!nullToAbsent || descripcion != null) {
      map['descripcion'] = Variable<String>(descripcion);
    }
    if (!nullToAbsent || fotos != null) {
      final converter = $TitulosTable.$converter0;
      map['fotos'] = Variable<String>(converter.mapToSql(fotos));
    }
    if (!nullToAbsent || bloqueId != null) {
      map['bloque_id'] = Variable<int>(bloqueId);
    }
    return map;
  }

  TitulosCompanion toCompanion(bool nullToAbsent) {
    return TitulosCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      titulo:
          titulo == null && nullToAbsent ? const Value.absent() : Value(titulo),
      descripcion: descripcion == null && nullToAbsent
          ? const Value.absent()
          : Value(descripcion),
      fotos:
          fotos == null && nullToAbsent ? const Value.absent() : Value(fotos),
      bloqueId: bloqueId == null && nullToAbsent
          ? const Value.absent()
          : Value(bloqueId),
    );
  }

  factory Titulo.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
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
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
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
          {int id,
          String titulo,
          String descripcion,
          KtList<String> fotos,
          int bloqueId}) =>
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
  bool operator ==(dynamic other) =>
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
    @required String titulo,
    @required String descripcion,
    this.fotos = const Value.absent(),
    @required int bloqueId,
  })  : titulo = Value(titulo),
        descripcion = Value(descripcion),
        bloqueId = Value(bloqueId);
  static Insertable<Titulo> custom({
    Expression<int> id,
    Expression<String> titulo,
    Expression<String> descripcion,
    Expression<String> fotos,
    Expression<int> bloqueId,
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
      {Value<int> id,
      Value<String> titulo,
      Value<String> descripcion,
      Value<KtList<String>> fotos,
      Value<int> bloqueId}) {
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
      map['fotos'] = Variable<String>(converter.mapToSql(fotos.value));
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
  final String _alias;
  $TitulosTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _tituloMeta = const VerificationMeta('titulo');
  GeneratedTextColumn _titulo;
  @override
  GeneratedTextColumn get titulo => _titulo ??= _constructTitulo();
  GeneratedTextColumn _constructTitulo() {
    return GeneratedTextColumn('titulo', $tableName, false,
        minTextLength: 1, maxTextLength: 100);
  }

  final VerificationMeta _descripcionMeta =
      const VerificationMeta('descripcion');
  GeneratedTextColumn _descripcion;
  @override
  GeneratedTextColumn get descripcion =>
      _descripcion ??= _constructDescripcion();
  GeneratedTextColumn _constructDescripcion() {
    return GeneratedTextColumn('descripcion', $tableName, false,
        minTextLength: 0, maxTextLength: 1500);
  }

  final VerificationMeta _fotosMeta = const VerificationMeta('fotos');
  GeneratedTextColumn _fotos;
  @override
  GeneratedTextColumn get fotos => _fotos ??= _constructFotos();
  GeneratedTextColumn _constructFotos() {
    return GeneratedTextColumn('fotos', $tableName, false,
        defaultValue: const Constant("[]"));
  }

  final VerificationMeta _bloqueIdMeta = const VerificationMeta('bloqueId');
  GeneratedIntColumn _bloqueId;
  @override
  GeneratedIntColumn get bloqueId => _bloqueId ??= _constructBloqueId();
  GeneratedIntColumn _constructBloqueId() {
    return GeneratedIntColumn('bloque_id', $tableName, false,
        $customConstraints: 'REFERENCES bloques(id) ON DELETE CASCADE');
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, titulo, descripcion, fotos, bloqueId];
  @override
  $TitulosTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'titulos';
  @override
  final String actualTableName = 'titulos';
  @override
  VerificationContext validateIntegrity(Insertable<Titulo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('titulo')) {
      context.handle(_tituloMeta,
          titulo.isAcceptableOrUnknown(data['titulo'], _tituloMeta));
    } else if (isInserting) {
      context.missing(_tituloMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
          _descripcionMeta,
          descripcion.isAcceptableOrUnknown(
              data['descripcion'], _descripcionMeta));
    } else if (isInserting) {
      context.missing(_descripcionMeta);
    }
    context.handle(_fotosMeta, const VerificationResult.success());
    if (data.containsKey('bloque_id')) {
      context.handle(_bloqueIdMeta,
          bloqueId.isAcceptableOrUnknown(data['bloque_id'], _bloqueIdMeta));
    } else if (isInserting) {
      context.missing(_bloqueIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Titulo map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Titulo.fromData(data, _db, prefix: effectivePrefix);
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
      {@required this.id,
      @required this.titulo,
      @required this.descripcion,
      @required this.bloqueId});
  factory CuadriculaDePreguntas.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return CuadriculaDePreguntas(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      titulo:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}titulo']),
      descripcion: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}descripcion']),
      bloqueId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}bloque_id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || titulo != null) {
      map['titulo'] = Variable<String>(titulo);
    }
    if (!nullToAbsent || descripcion != null) {
      map['descripcion'] = Variable<String>(descripcion);
    }
    if (!nullToAbsent || bloqueId != null) {
      map['bloque_id'] = Variable<int>(bloqueId);
    }
    return map;
  }

  CuadriculasDePreguntasCompanion toCompanion(bool nullToAbsent) {
    return CuadriculasDePreguntasCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      titulo:
          titulo == null && nullToAbsent ? const Value.absent() : Value(titulo),
      descripcion: descripcion == null && nullToAbsent
          ? const Value.absent()
          : Value(descripcion),
      bloqueId: bloqueId == null && nullToAbsent
          ? const Value.absent()
          : Value(bloqueId),
    );
  }

  factory CuadriculaDePreguntas.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return CuadriculaDePreguntas(
      id: serializer.fromJson<int>(json['id']),
      titulo: serializer.fromJson<String>(json['titulo']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      bloqueId: serializer.fromJson<int>(json['bloque']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'titulo': serializer.toJson<String>(titulo),
      'descripcion': serializer.toJson<String>(descripcion),
      'bloque': serializer.toJson<int>(bloqueId),
    };
  }

  CuadriculaDePreguntas copyWith(
          {int id, String titulo, String descripcion, int bloqueId}) =>
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
  bool operator ==(dynamic other) =>
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
    @required String titulo,
    @required String descripcion,
    @required int bloqueId,
  })  : titulo = Value(titulo),
        descripcion = Value(descripcion),
        bloqueId = Value(bloqueId);
  static Insertable<CuadriculaDePreguntas> custom({
    Expression<int> id,
    Expression<String> titulo,
    Expression<String> descripcion,
    Expression<int> bloqueId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (titulo != null) 'titulo': titulo,
      if (descripcion != null) 'descripcion': descripcion,
      if (bloqueId != null) 'bloque_id': bloqueId,
    });
  }

  CuadriculasDePreguntasCompanion copyWith(
      {Value<int> id,
      Value<String> titulo,
      Value<String> descripcion,
      Value<int> bloqueId}) {
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
  final String _alias;
  $CuadriculasDePreguntasTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _tituloMeta = const VerificationMeta('titulo');
  GeneratedTextColumn _titulo;
  @override
  GeneratedTextColumn get titulo => _titulo ??= _constructTitulo();
  GeneratedTextColumn _constructTitulo() {
    return GeneratedTextColumn('titulo', $tableName, false,
        minTextLength: 0, maxTextLength: 100);
  }

  final VerificationMeta _descripcionMeta =
      const VerificationMeta('descripcion');
  GeneratedTextColumn _descripcion;
  @override
  GeneratedTextColumn get descripcion =>
      _descripcion ??= _constructDescripcion();
  GeneratedTextColumn _constructDescripcion() {
    return GeneratedTextColumn('descripcion', $tableName, false,
        minTextLength: 0, maxTextLength: 1500);
  }

  final VerificationMeta _bloqueIdMeta = const VerificationMeta('bloqueId');
  GeneratedIntColumn _bloqueId;
  @override
  GeneratedIntColumn get bloqueId => _bloqueId ??= _constructBloqueId();
  GeneratedIntColumn _constructBloqueId() {
    return GeneratedIntColumn('bloque_id', $tableName, false,
        $customConstraints: 'UNIQUE REFERENCES bloques(id) ON DELETE CASCADE');
  }

  @override
  List<GeneratedColumn> get $columns => [id, titulo, descripcion, bloqueId];
  @override
  $CuadriculasDePreguntasTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'cuadriculas_de_preguntas';
  @override
  final String actualTableName = 'cuadriculas_de_preguntas';
  @override
  VerificationContext validateIntegrity(
      Insertable<CuadriculaDePreguntas> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('titulo')) {
      context.handle(_tituloMeta,
          titulo.isAcceptableOrUnknown(data['titulo'], _tituloMeta));
    } else if (isInserting) {
      context.missing(_tituloMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
          _descripcionMeta,
          descripcion.isAcceptableOrUnknown(
              data['descripcion'], _descripcionMeta));
    } else if (isInserting) {
      context.missing(_descripcionMeta);
    }
    if (data.containsKey('bloque_id')) {
      context.handle(_bloqueIdMeta,
          bloqueId.isAcceptableOrUnknown(data['bloque_id'], _bloqueIdMeta));
    } else if (isInserting) {
      context.missing(_bloqueIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CuadriculaDePreguntas map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return CuadriculaDePreguntas.fromData(data, _db, prefix: effectivePrefix);
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
  final String posicion;
  final KtList<String> fotosGuia;
  final bool esCondicional;
  final int bloqueId;
  final int sistemaId;
  final int subSistemaId;
  final TipoDePregunta tipo;
  Pregunta(
      {@required this.id,
      @required this.titulo,
      @required this.descripcion,
      @required this.criticidad,
      this.posicion,
      @required this.fotosGuia,
      @required this.esCondicional,
      @required this.bloqueId,
      this.sistemaId,
      this.subSistemaId,
      @required this.tipo});
  factory Pregunta.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    return Pregunta(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      titulo:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}titulo']),
      descripcion: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}descripcion']),
      criticidad:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}criticidad']),
      posicion: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}posicion']),
      fotosGuia: $PreguntasTable.$converter0.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}fotos_guia'])),
      esCondicional: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}es_condicional']),
      bloqueId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}bloque_id']),
      sistemaId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}sistema_id']),
      subSistemaId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}sub_sistema_id']),
      tipo: $PreguntasTable.$converter1.mapToDart(
          intType.mapFromDatabaseResponse(data['${effectivePrefix}tipo'])),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || titulo != null) {
      map['titulo'] = Variable<String>(titulo);
    }
    if (!nullToAbsent || descripcion != null) {
      map['descripcion'] = Variable<String>(descripcion);
    }
    if (!nullToAbsent || criticidad != null) {
      map['criticidad'] = Variable<int>(criticidad);
    }
    if (!nullToAbsent || posicion != null) {
      map['posicion'] = Variable<String>(posicion);
    }
    if (!nullToAbsent || fotosGuia != null) {
      final converter = $PreguntasTable.$converter0;
      map['fotos_guia'] = Variable<String>(converter.mapToSql(fotosGuia));
    }
    if (!nullToAbsent || esCondicional != null) {
      map['es_condicional'] = Variable<bool>(esCondicional);
    }
    if (!nullToAbsent || bloqueId != null) {
      map['bloque_id'] = Variable<int>(bloqueId);
    }
    if (!nullToAbsent || sistemaId != null) {
      map['sistema_id'] = Variable<int>(sistemaId);
    }
    if (!nullToAbsent || subSistemaId != null) {
      map['sub_sistema_id'] = Variable<int>(subSistemaId);
    }
    if (!nullToAbsent || tipo != null) {
      final converter = $PreguntasTable.$converter1;
      map['tipo'] = Variable<int>(converter.mapToSql(tipo));
    }
    return map;
  }

  PreguntasCompanion toCompanion(bool nullToAbsent) {
    return PreguntasCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      titulo:
          titulo == null && nullToAbsent ? const Value.absent() : Value(titulo),
      descripcion: descripcion == null && nullToAbsent
          ? const Value.absent()
          : Value(descripcion),
      criticidad: criticidad == null && nullToAbsent
          ? const Value.absent()
          : Value(criticidad),
      posicion: posicion == null && nullToAbsent
          ? const Value.absent()
          : Value(posicion),
      fotosGuia: fotosGuia == null && nullToAbsent
          ? const Value.absent()
          : Value(fotosGuia),
      esCondicional: esCondicional == null && nullToAbsent
          ? const Value.absent()
          : Value(esCondicional),
      bloqueId: bloqueId == null && nullToAbsent
          ? const Value.absent()
          : Value(bloqueId),
      sistemaId: sistemaId == null && nullToAbsent
          ? const Value.absent()
          : Value(sistemaId),
      subSistemaId: subSistemaId == null && nullToAbsent
          ? const Value.absent()
          : Value(subSistemaId),
      tipo: tipo == null && nullToAbsent ? const Value.absent() : Value(tipo),
    );
  }

  factory Pregunta.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Pregunta(
      id: serializer.fromJson<int>(json['id']),
      titulo: serializer.fromJson<String>(json['titulo']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      criticidad: serializer.fromJson<int>(json['criticidad']),
      posicion: serializer.fromJson<String>(json['posicion']),
      fotosGuia: serializer.fromJson<KtList<String>>(json['fotosGuia']),
      esCondicional: serializer.fromJson<bool>(json['esCondicional']),
      bloqueId: serializer.fromJson<int>(json['bloque']),
      sistemaId: serializer.fromJson<int>(json['sistema']),
      subSistemaId: serializer.fromJson<int>(json['subSistema']),
      tipo: serializer.fromJson<TipoDePregunta>(json['tipo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'titulo': serializer.toJson<String>(titulo),
      'descripcion': serializer.toJson<String>(descripcion),
      'criticidad': serializer.toJson<int>(criticidad),
      'posicion': serializer.toJson<String>(posicion),
      'fotosGuia': serializer.toJson<KtList<String>>(fotosGuia),
      'esCondicional': serializer.toJson<bool>(esCondicional),
      'bloque': serializer.toJson<int>(bloqueId),
      'sistema': serializer.toJson<int>(sistemaId),
      'subSistema': serializer.toJson<int>(subSistemaId),
      'tipo': serializer.toJson<TipoDePregunta>(tipo),
    };
  }

  Pregunta copyWith(
          {int id,
          String titulo,
          String descripcion,
          int criticidad,
          String posicion,
          KtList<String> fotosGuia,
          bool esCondicional,
          int bloqueId,
          int sistemaId,
          int subSistemaId,
          TipoDePregunta tipo}) =>
      Pregunta(
        id: id ?? this.id,
        titulo: titulo ?? this.titulo,
        descripcion: descripcion ?? this.descripcion,
        criticidad: criticidad ?? this.criticidad,
        posicion: posicion ?? this.posicion,
        fotosGuia: fotosGuia ?? this.fotosGuia,
        esCondicional: esCondicional ?? this.esCondicional,
        bloqueId: bloqueId ?? this.bloqueId,
        sistemaId: sistemaId ?? this.sistemaId,
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
          ..write('posicion: $posicion, ')
          ..write('fotosGuia: $fotosGuia, ')
          ..write('esCondicional: $esCondicional, ')
          ..write('bloqueId: $bloqueId, ')
          ..write('sistemaId: $sistemaId, ')
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
                      posicion.hashCode,
                      $mrjc(
                          fotosGuia.hashCode,
                          $mrjc(
                              esCondicional.hashCode,
                              $mrjc(
                                  bloqueId.hashCode,
                                  $mrjc(
                                      sistemaId.hashCode,
                                      $mrjc(subSistemaId.hashCode,
                                          tipo.hashCode)))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Pregunta &&
          other.id == this.id &&
          other.titulo == this.titulo &&
          other.descripcion == this.descripcion &&
          other.criticidad == this.criticidad &&
          other.posicion == this.posicion &&
          other.fotosGuia == this.fotosGuia &&
          other.esCondicional == this.esCondicional &&
          other.bloqueId == this.bloqueId &&
          other.sistemaId == this.sistemaId &&
          other.subSistemaId == this.subSistemaId &&
          other.tipo == this.tipo);
}

class PreguntasCompanion extends UpdateCompanion<Pregunta> {
  final Value<int> id;
  final Value<String> titulo;
  final Value<String> descripcion;
  final Value<int> criticidad;
  final Value<String> posicion;
  final Value<KtList<String>> fotosGuia;
  final Value<bool> esCondicional;
  final Value<int> bloqueId;
  final Value<int> sistemaId;
  final Value<int> subSistemaId;
  final Value<TipoDePregunta> tipo;
  const PreguntasCompanion({
    this.id = const Value.absent(),
    this.titulo = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.criticidad = const Value.absent(),
    this.posicion = const Value.absent(),
    this.fotosGuia = const Value.absent(),
    this.esCondicional = const Value.absent(),
    this.bloqueId = const Value.absent(),
    this.sistemaId = const Value.absent(),
    this.subSistemaId = const Value.absent(),
    this.tipo = const Value.absent(),
  });
  PreguntasCompanion.insert({
    this.id = const Value.absent(),
    @required String titulo,
    @required String descripcion,
    @required int criticidad,
    this.posicion = const Value.absent(),
    this.fotosGuia = const Value.absent(),
    this.esCondicional = const Value.absent(),
    @required int bloqueId,
    this.sistemaId = const Value.absent(),
    this.subSistemaId = const Value.absent(),
    @required TipoDePregunta tipo,
  })  : titulo = Value(titulo),
        descripcion = Value(descripcion),
        criticidad = Value(criticidad),
        bloqueId = Value(bloqueId),
        tipo = Value(tipo);
  static Insertable<Pregunta> custom({
    Expression<int> id,
    Expression<String> titulo,
    Expression<String> descripcion,
    Expression<int> criticidad,
    Expression<String> posicion,
    Expression<String> fotosGuia,
    Expression<bool> esCondicional,
    Expression<int> bloqueId,
    Expression<int> sistemaId,
    Expression<int> subSistemaId,
    Expression<int> tipo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (titulo != null) 'titulo': titulo,
      if (descripcion != null) 'descripcion': descripcion,
      if (criticidad != null) 'criticidad': criticidad,
      if (posicion != null) 'posicion': posicion,
      if (fotosGuia != null) 'fotos_guia': fotosGuia,
      if (esCondicional != null) 'es_condicional': esCondicional,
      if (bloqueId != null) 'bloque_id': bloqueId,
      if (sistemaId != null) 'sistema_id': sistemaId,
      if (subSistemaId != null) 'sub_sistema_id': subSistemaId,
      if (tipo != null) 'tipo': tipo,
    });
  }

  PreguntasCompanion copyWith(
      {Value<int> id,
      Value<String> titulo,
      Value<String> descripcion,
      Value<int> criticidad,
      Value<String> posicion,
      Value<KtList<String>> fotosGuia,
      Value<bool> esCondicional,
      Value<int> bloqueId,
      Value<int> sistemaId,
      Value<int> subSistemaId,
      Value<TipoDePregunta> tipo}) {
    return PreguntasCompanion(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      criticidad: criticidad ?? this.criticidad,
      posicion: posicion ?? this.posicion,
      fotosGuia: fotosGuia ?? this.fotosGuia,
      esCondicional: esCondicional ?? this.esCondicional,
      bloqueId: bloqueId ?? this.bloqueId,
      sistemaId: sistemaId ?? this.sistemaId,
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
    if (posicion.present) {
      map['posicion'] = Variable<String>(posicion.value);
    }
    if (fotosGuia.present) {
      final converter = $PreguntasTable.$converter0;
      map['fotos_guia'] = Variable<String>(converter.mapToSql(fotosGuia.value));
    }
    if (esCondicional.present) {
      map['es_condicional'] = Variable<bool>(esCondicional.value);
    }
    if (bloqueId.present) {
      map['bloque_id'] = Variable<int>(bloqueId.value);
    }
    if (sistemaId.present) {
      map['sistema_id'] = Variable<int>(sistemaId.value);
    }
    if (subSistemaId.present) {
      map['sub_sistema_id'] = Variable<int>(subSistemaId.value);
    }
    if (tipo.present) {
      final converter = $PreguntasTable.$converter1;
      map['tipo'] = Variable<int>(converter.mapToSql(tipo.value));
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
          ..write('posicion: $posicion, ')
          ..write('fotosGuia: $fotosGuia, ')
          ..write('esCondicional: $esCondicional, ')
          ..write('bloqueId: $bloqueId, ')
          ..write('sistemaId: $sistemaId, ')
          ..write('subSistemaId: $subSistemaId, ')
          ..write('tipo: $tipo')
          ..write(')'))
        .toString();
  }
}

class $PreguntasTable extends Preguntas
    with TableInfo<$PreguntasTable, Pregunta> {
  final GeneratedDatabase _db;
  final String _alias;
  $PreguntasTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _tituloMeta = const VerificationMeta('titulo');
  GeneratedTextColumn _titulo;
  @override
  GeneratedTextColumn get titulo => _titulo ??= _constructTitulo();
  GeneratedTextColumn _constructTitulo() {
    return GeneratedTextColumn('titulo', $tableName, false,
        minTextLength: 1, maxTextLength: 100);
  }

  final VerificationMeta _descripcionMeta =
      const VerificationMeta('descripcion');
  GeneratedTextColumn _descripcion;
  @override
  GeneratedTextColumn get descripcion =>
      _descripcion ??= _constructDescripcion();
  GeneratedTextColumn _constructDescripcion() {
    return GeneratedTextColumn('descripcion', $tableName, false,
        minTextLength: 0, maxTextLength: 1500);
  }

  final VerificationMeta _criticidadMeta = const VerificationMeta('criticidad');
  GeneratedIntColumn _criticidad;
  @override
  GeneratedIntColumn get criticidad => _criticidad ??= _constructCriticidad();
  GeneratedIntColumn _constructCriticidad() {
    return GeneratedIntColumn(
      'criticidad',
      $tableName,
      false,
    );
  }

  final VerificationMeta _posicionMeta = const VerificationMeta('posicion');
  GeneratedTextColumn _posicion;
  @override
  GeneratedTextColumn get posicion => _posicion ??= _constructPosicion();
  GeneratedTextColumn _constructPosicion() {
    return GeneratedTextColumn('posicion', $tableName, true,
        minTextLength: 0, maxTextLength: 50);
  }

  final VerificationMeta _fotosGuiaMeta = const VerificationMeta('fotosGuia');
  GeneratedTextColumn _fotosGuia;
  @override
  GeneratedTextColumn get fotosGuia => _fotosGuia ??= _constructFotosGuia();
  GeneratedTextColumn _constructFotosGuia() {
    return GeneratedTextColumn('fotos_guia', $tableName, false,
        defaultValue: const Constant("[]"));
  }

  final VerificationMeta _esCondicionalMeta =
      const VerificationMeta('esCondicional');
  GeneratedBoolColumn _esCondicional;
  @override
  GeneratedBoolColumn get esCondicional =>
      _esCondicional ??= _constructEsCondicional();
  GeneratedBoolColumn _constructEsCondicional() {
    return GeneratedBoolColumn('es_condicional', $tableName, false,
        defaultValue: const Constant(false));
  }

  final VerificationMeta _bloqueIdMeta = const VerificationMeta('bloqueId');
  GeneratedIntColumn _bloqueId;
  @override
  GeneratedIntColumn get bloqueId => _bloqueId ??= _constructBloqueId();
  GeneratedIntColumn _constructBloqueId() {
    return GeneratedIntColumn('bloque_id', $tableName, false,
        $customConstraints: 'REFERENCES bloques(id) ON DELETE CASCADE');
  }

  final VerificationMeta _sistemaIdMeta = const VerificationMeta('sistemaId');
  GeneratedIntColumn _sistemaId;
  @override
  GeneratedIntColumn get sistemaId => _sistemaId ??= _constructSistemaId();
  GeneratedIntColumn _constructSistemaId() {
    return GeneratedIntColumn('sistema_id', $tableName, true,
        $customConstraints: 'REFERENCES sistemas(id)');
  }

  final VerificationMeta _subSistemaIdMeta =
      const VerificationMeta('subSistemaId');
  GeneratedIntColumn _subSistemaId;
  @override
  GeneratedIntColumn get subSistemaId =>
      _subSistemaId ??= _constructSubSistemaId();
  GeneratedIntColumn _constructSubSistemaId() {
    return GeneratedIntColumn('sub_sistema_id', $tableName, true,
        $customConstraints: 'REFERENCES sub_sistemas(id)');
  }

  final VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  GeneratedIntColumn _tipo;
  @override
  GeneratedIntColumn get tipo => _tipo ??= _constructTipo();
  GeneratedIntColumn _constructTipo() {
    return GeneratedIntColumn(
      'tipo',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        titulo,
        descripcion,
        criticidad,
        posicion,
        fotosGuia,
        esCondicional,
        bloqueId,
        sistemaId,
        subSistemaId,
        tipo
      ];
  @override
  $PreguntasTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'preguntas';
  @override
  final String actualTableName = 'preguntas';
  @override
  VerificationContext validateIntegrity(Insertable<Pregunta> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('titulo')) {
      context.handle(_tituloMeta,
          titulo.isAcceptableOrUnknown(data['titulo'], _tituloMeta));
    } else if (isInserting) {
      context.missing(_tituloMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
          _descripcionMeta,
          descripcion.isAcceptableOrUnknown(
              data['descripcion'], _descripcionMeta));
    } else if (isInserting) {
      context.missing(_descripcionMeta);
    }
    if (data.containsKey('criticidad')) {
      context.handle(
          _criticidadMeta,
          criticidad.isAcceptableOrUnknown(
              data['criticidad'], _criticidadMeta));
    } else if (isInserting) {
      context.missing(_criticidadMeta);
    }
    if (data.containsKey('posicion')) {
      context.handle(_posicionMeta,
          posicion.isAcceptableOrUnknown(data['posicion'], _posicionMeta));
    }
    context.handle(_fotosGuiaMeta, const VerificationResult.success());
    if (data.containsKey('es_condicional')) {
      context.handle(
          _esCondicionalMeta,
          esCondicional.isAcceptableOrUnknown(
              data['es_condicional'], _esCondicionalMeta));
    }
    if (data.containsKey('bloque_id')) {
      context.handle(_bloqueIdMeta,
          bloqueId.isAcceptableOrUnknown(data['bloque_id'], _bloqueIdMeta));
    } else if (isInserting) {
      context.missing(_bloqueIdMeta);
    }
    if (data.containsKey('sistema_id')) {
      context.handle(_sistemaIdMeta,
          sistemaId.isAcceptableOrUnknown(data['sistema_id'], _sistemaIdMeta));
    }
    if (data.containsKey('sub_sistema_id')) {
      context.handle(
          _subSistemaIdMeta,
          subSistemaId.isAcceptableOrUnknown(
              data['sub_sistema_id'], _subSistemaIdMeta));
    }
    context.handle(_tipoMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Pregunta map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Pregunta.fromData(data, _db, prefix: effectivePrefix);
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
  final int preguntaId;
  final int cuadriculaId;
  final String texto;
  final int criticidad;
  OpcionDeRespuesta(
      {@required this.id,
      this.preguntaId,
      this.cuadriculaId,
      @required this.texto,
      @required this.criticidad});
  factory OpcionDeRespuesta.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return OpcionDeRespuesta(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      preguntaId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}pregunta_id']),
      cuadriculaId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}cuadricula_id']),
      texto:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}texto']),
      criticidad:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}criticidad']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || preguntaId != null) {
      map['pregunta_id'] = Variable<int>(preguntaId);
    }
    if (!nullToAbsent || cuadriculaId != null) {
      map['cuadricula_id'] = Variable<int>(cuadriculaId);
    }
    if (!nullToAbsent || texto != null) {
      map['texto'] = Variable<String>(texto);
    }
    if (!nullToAbsent || criticidad != null) {
      map['criticidad'] = Variable<int>(criticidad);
    }
    return map;
  }

  OpcionesDeRespuestaCompanion toCompanion(bool nullToAbsent) {
    return OpcionesDeRespuestaCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      preguntaId: preguntaId == null && nullToAbsent
          ? const Value.absent()
          : Value(preguntaId),
      cuadriculaId: cuadriculaId == null && nullToAbsent
          ? const Value.absent()
          : Value(cuadriculaId),
      texto:
          texto == null && nullToAbsent ? const Value.absent() : Value(texto),
      criticidad: criticidad == null && nullToAbsent
          ? const Value.absent()
          : Value(criticidad),
    );
  }

  factory OpcionDeRespuesta.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return OpcionDeRespuesta(
      id: serializer.fromJson<int>(json['id']),
      preguntaId: serializer.fromJson<int>(json['pregunta']),
      cuadriculaId: serializer.fromJson<int>(json['cuadricula']),
      texto: serializer.fromJson<String>(json['texto']),
      criticidad: serializer.fromJson<int>(json['criticidad']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pregunta': serializer.toJson<int>(preguntaId),
      'cuadricula': serializer.toJson<int>(cuadriculaId),
      'texto': serializer.toJson<String>(texto),
      'criticidad': serializer.toJson<int>(criticidad),
    };
  }

  OpcionDeRespuesta copyWith(
          {int id,
          int preguntaId,
          int cuadriculaId,
          String texto,
          int criticidad}) =>
      OpcionDeRespuesta(
        id: id ?? this.id,
        preguntaId: preguntaId ?? this.preguntaId,
        cuadriculaId: cuadriculaId ?? this.cuadriculaId,
        texto: texto ?? this.texto,
        criticidad: criticidad ?? this.criticidad,
      );
  @override
  String toString() {
    return (StringBuffer('OpcionDeRespuesta(')
          ..write('id: $id, ')
          ..write('preguntaId: $preguntaId, ')
          ..write('cuadriculaId: $cuadriculaId, ')
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
          $mrjc(cuadriculaId.hashCode,
              $mrjc(texto.hashCode, criticidad.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is OpcionDeRespuesta &&
          other.id == this.id &&
          other.preguntaId == this.preguntaId &&
          other.cuadriculaId == this.cuadriculaId &&
          other.texto == this.texto &&
          other.criticidad == this.criticidad);
}

class OpcionesDeRespuestaCompanion extends UpdateCompanion<OpcionDeRespuesta> {
  final Value<int> id;
  final Value<int> preguntaId;
  final Value<int> cuadriculaId;
  final Value<String> texto;
  final Value<int> criticidad;
  const OpcionesDeRespuestaCompanion({
    this.id = const Value.absent(),
    this.preguntaId = const Value.absent(),
    this.cuadriculaId = const Value.absent(),
    this.texto = const Value.absent(),
    this.criticidad = const Value.absent(),
  });
  OpcionesDeRespuestaCompanion.insert({
    this.id = const Value.absent(),
    this.preguntaId = const Value.absent(),
    this.cuadriculaId = const Value.absent(),
    @required String texto,
    @required int criticidad,
  })  : texto = Value(texto),
        criticidad = Value(criticidad);
  static Insertable<OpcionDeRespuesta> custom({
    Expression<int> id,
    Expression<int> preguntaId,
    Expression<int> cuadriculaId,
    Expression<String> texto,
    Expression<int> criticidad,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (preguntaId != null) 'pregunta_id': preguntaId,
      if (cuadriculaId != null) 'cuadricula_id': cuadriculaId,
      if (texto != null) 'texto': texto,
      if (criticidad != null) 'criticidad': criticidad,
    });
  }

  OpcionesDeRespuestaCompanion copyWith(
      {Value<int> id,
      Value<int> preguntaId,
      Value<int> cuadriculaId,
      Value<String> texto,
      Value<int> criticidad}) {
    return OpcionesDeRespuestaCompanion(
      id: id ?? this.id,
      preguntaId: preguntaId ?? this.preguntaId,
      cuadriculaId: cuadriculaId ?? this.cuadriculaId,
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
      map['pregunta_id'] = Variable<int>(preguntaId.value);
    }
    if (cuadriculaId.present) {
      map['cuadricula_id'] = Variable<int>(cuadriculaId.value);
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
          ..write('texto: $texto, ')
          ..write('criticidad: $criticidad')
          ..write(')'))
        .toString();
  }
}

class $OpcionesDeRespuestaTable extends OpcionesDeRespuesta
    with TableInfo<$OpcionesDeRespuestaTable, OpcionDeRespuesta> {
  final GeneratedDatabase _db;
  final String _alias;
  $OpcionesDeRespuestaTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _preguntaIdMeta = const VerificationMeta('preguntaId');
  GeneratedIntColumn _preguntaId;
  @override
  GeneratedIntColumn get preguntaId => _preguntaId ??= _constructPreguntaId();
  GeneratedIntColumn _constructPreguntaId() {
    return GeneratedIntColumn('pregunta_id', $tableName, true,
        $customConstraints: 'REFERENCES preguntas(id) ON DELETE CASCADE');
  }

  final VerificationMeta _cuadriculaIdMeta =
      const VerificationMeta('cuadriculaId');
  GeneratedIntColumn _cuadriculaId;
  @override
  GeneratedIntColumn get cuadriculaId =>
      _cuadriculaId ??= _constructCuadriculaId();
  GeneratedIntColumn _constructCuadriculaId() {
    return GeneratedIntColumn('cuadricula_id', $tableName, true,
        $customConstraints:
            'REFERENCES cuadriculas_de_preguntas(id) ON DELETE CASCADE');
  }

  final VerificationMeta _textoMeta = const VerificationMeta('texto');
  GeneratedTextColumn _texto;
  @override
  GeneratedTextColumn get texto => _texto ??= _constructTexto();
  GeneratedTextColumn _constructTexto() {
    return GeneratedTextColumn('texto', $tableName, false,
        minTextLength: 1, maxTextLength: 100);
  }

  final VerificationMeta _criticidadMeta = const VerificationMeta('criticidad');
  GeneratedIntColumn _criticidad;
  @override
  GeneratedIntColumn get criticidad => _criticidad ??= _constructCriticidad();
  GeneratedIntColumn _constructCriticidad() {
    return GeneratedIntColumn(
      'criticidad',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, preguntaId, cuadriculaId, texto, criticidad];
  @override
  $OpcionesDeRespuestaTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'opciones_de_respuesta';
  @override
  final String actualTableName = 'opciones_de_respuesta';
  @override
  VerificationContext validateIntegrity(Insertable<OpcionDeRespuesta> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('pregunta_id')) {
      context.handle(
          _preguntaIdMeta,
          preguntaId.isAcceptableOrUnknown(
              data['pregunta_id'], _preguntaIdMeta));
    }
    if (data.containsKey('cuadricula_id')) {
      context.handle(
          _cuadriculaIdMeta,
          cuadriculaId.isAcceptableOrUnknown(
              data['cuadricula_id'], _cuadriculaIdMeta));
    }
    if (data.containsKey('texto')) {
      context.handle(
          _textoMeta, texto.isAcceptableOrUnknown(data['texto'], _textoMeta));
    } else if (isInserting) {
      context.missing(_textoMeta);
    }
    if (data.containsKey('criticidad')) {
      context.handle(
          _criticidadMeta,
          criticidad.isAcceptableOrUnknown(
              data['criticidad'], _criticidadMeta));
    } else if (isInserting) {
      context.missing(_criticidadMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OpcionDeRespuesta map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return OpcionDeRespuesta.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $OpcionesDeRespuestaTable createAlias(String alias) {
    return $OpcionesDeRespuestaTable(_db, alias);
  }
}

class Inspeccion extends DataClass implements Insertable<Inspeccion> {
  final int id;
  final EstadoDeInspeccion estado;
  final int criticidadTotal;
  final int criticidadReparacion;
  final DateTime momentoInicio;
  final DateTime momentoBorradorGuardado;
  final DateTime momentoEnvio;
  final int cuestionarioId;
  final int activoId;
  Inspeccion(
      {@required this.id,
      @required this.estado,
      @required this.criticidadTotal,
      @required this.criticidadReparacion,
      this.momentoInicio,
      this.momentoBorradorGuardado,
      this.momentoEnvio,
      @required this.cuestionarioId,
      @required this.activoId});
  factory Inspeccion.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return Inspeccion(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      estado: $InspeccionesTable.$converter0.mapToDart(
          intType.mapFromDatabaseResponse(data['${effectivePrefix}estado'])),
      criticidadTotal: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}criticidad_total']),
      criticidadReparacion: intType.mapFromDatabaseResponse(
          data['${effectivePrefix}criticidad_reparacion']),
      momentoInicio: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}momento_inicio']),
      momentoBorradorGuardado: dateTimeType.mapFromDatabaseResponse(
          data['${effectivePrefix}momento_borrador_guardado']),
      momentoEnvio: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}momento_envio']),
      cuestionarioId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}cuestionario_id']),
      activoId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}activo_id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || estado != null) {
      final converter = $InspeccionesTable.$converter0;
      map['estado'] = Variable<int>(converter.mapToSql(estado));
    }
    if (!nullToAbsent || criticidadTotal != null) {
      map['criticidad_total'] = Variable<int>(criticidadTotal);
    }
    if (!nullToAbsent || criticidadReparacion != null) {
      map['criticidad_reparacion'] = Variable<int>(criticidadReparacion);
    }
    if (!nullToAbsent || momentoInicio != null) {
      map['momento_inicio'] = Variable<DateTime>(momentoInicio);
    }
    if (!nullToAbsent || momentoBorradorGuardado != null) {
      map['momento_borrador_guardado'] =
          Variable<DateTime>(momentoBorradorGuardado);
    }
    if (!nullToAbsent || momentoEnvio != null) {
      map['momento_envio'] = Variable<DateTime>(momentoEnvio);
    }
    if (!nullToAbsent || cuestionarioId != null) {
      map['cuestionario_id'] = Variable<int>(cuestionarioId);
    }
    if (!nullToAbsent || activoId != null) {
      map['activo_id'] = Variable<int>(activoId);
    }
    return map;
  }

  InspeccionesCompanion toCompanion(bool nullToAbsent) {
    return InspeccionesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      estado:
          estado == null && nullToAbsent ? const Value.absent() : Value(estado),
      criticidadTotal: criticidadTotal == null && nullToAbsent
          ? const Value.absent()
          : Value(criticidadTotal),
      criticidadReparacion: criticidadReparacion == null && nullToAbsent
          ? const Value.absent()
          : Value(criticidadReparacion),
      momentoInicio: momentoInicio == null && nullToAbsent
          ? const Value.absent()
          : Value(momentoInicio),
      momentoBorradorGuardado: momentoBorradorGuardado == null && nullToAbsent
          ? const Value.absent()
          : Value(momentoBorradorGuardado),
      momentoEnvio: momentoEnvio == null && nullToAbsent
          ? const Value.absent()
          : Value(momentoEnvio),
      cuestionarioId: cuestionarioId == null && nullToAbsent
          ? const Value.absent()
          : Value(cuestionarioId),
      activoId: activoId == null && nullToAbsent
          ? const Value.absent()
          : Value(activoId),
    );
  }

  factory Inspeccion.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Inspeccion(
      id: serializer.fromJson<int>(json['id']),
      estado: serializer.fromJson<EstadoDeInspeccion>(json['estado']),
      criticidadTotal: serializer.fromJson<int>(json['criticidadTotal']),
      criticidadReparacion:
          serializer.fromJson<int>(json['criticidadReparacion']),
      momentoInicio: serializer.fromJson<DateTime>(json['momentoInicio']),
      momentoBorradorGuardado:
          serializer.fromJson<DateTime>(json['momentoBorradorGuardado']),
      momentoEnvio: serializer.fromJson<DateTime>(json['momentoEnvio']),
      cuestionarioId: serializer.fromJson<int>(json['cuestionario']),
      activoId: serializer.fromJson<int>(json['activo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'estado': serializer.toJson<EstadoDeInspeccion>(estado),
      'criticidadTotal': serializer.toJson<int>(criticidadTotal),
      'criticidadReparacion': serializer.toJson<int>(criticidadReparacion),
      'momentoInicio': serializer.toJson<DateTime>(momentoInicio),
      'momentoBorradorGuardado':
          serializer.toJson<DateTime>(momentoBorradorGuardado),
      'momentoEnvio': serializer.toJson<DateTime>(momentoEnvio),
      'cuestionario': serializer.toJson<int>(cuestionarioId),
      'activo': serializer.toJson<int>(activoId),
    };
  }

  Inspeccion copyWith(
          {int id,
          EstadoDeInspeccion estado,
          int criticidadTotal,
          int criticidadReparacion,
          DateTime momentoInicio,
          DateTime momentoBorradorGuardado,
          DateTime momentoEnvio,
          int cuestionarioId,
          int activoId}) =>
      Inspeccion(
        id: id ?? this.id,
        estado: estado ?? this.estado,
        criticidadTotal: criticidadTotal ?? this.criticidadTotal,
        criticidadReparacion: criticidadReparacion ?? this.criticidadReparacion,
        momentoInicio: momentoInicio ?? this.momentoInicio,
        momentoBorradorGuardado:
            momentoBorradorGuardado ?? this.momentoBorradorGuardado,
        momentoEnvio: momentoEnvio ?? this.momentoEnvio,
        cuestionarioId: cuestionarioId ?? this.cuestionarioId,
        activoId: activoId ?? this.activoId,
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
          ..write('momentoEnvio: $momentoEnvio, ')
          ..write('cuestionarioId: $cuestionarioId, ')
          ..write('activoId: $activoId')
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
                              momentoEnvio.hashCode,
                              $mrjc(cuestionarioId.hashCode,
                                  activoId.hashCode)))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Inspeccion &&
          other.id == this.id &&
          other.estado == this.estado &&
          other.criticidadTotal == this.criticidadTotal &&
          other.criticidadReparacion == this.criticidadReparacion &&
          other.momentoInicio == this.momentoInicio &&
          other.momentoBorradorGuardado == this.momentoBorradorGuardado &&
          other.momentoEnvio == this.momentoEnvio &&
          other.cuestionarioId == this.cuestionarioId &&
          other.activoId == this.activoId);
}

class InspeccionesCompanion extends UpdateCompanion<Inspeccion> {
  final Value<int> id;
  final Value<EstadoDeInspeccion> estado;
  final Value<int> criticidadTotal;
  final Value<int> criticidadReparacion;
  final Value<DateTime> momentoInicio;
  final Value<DateTime> momentoBorradorGuardado;
  final Value<DateTime> momentoEnvio;
  final Value<int> cuestionarioId;
  final Value<int> activoId;
  const InspeccionesCompanion({
    this.id = const Value.absent(),
    this.estado = const Value.absent(),
    this.criticidadTotal = const Value.absent(),
    this.criticidadReparacion = const Value.absent(),
    this.momentoInicio = const Value.absent(),
    this.momentoBorradorGuardado = const Value.absent(),
    this.momentoEnvio = const Value.absent(),
    this.cuestionarioId = const Value.absent(),
    this.activoId = const Value.absent(),
  });
  InspeccionesCompanion.insert({
    this.id = const Value.absent(),
    @required EstadoDeInspeccion estado,
    @required int criticidadTotal,
    @required int criticidadReparacion,
    this.momentoInicio = const Value.absent(),
    this.momentoBorradorGuardado = const Value.absent(),
    this.momentoEnvio = const Value.absent(),
    @required int cuestionarioId,
    @required int activoId,
  })  : estado = Value(estado),
        criticidadTotal = Value(criticidadTotal),
        criticidadReparacion = Value(criticidadReparacion),
        cuestionarioId = Value(cuestionarioId),
        activoId = Value(activoId);
  static Insertable<Inspeccion> custom({
    Expression<int> id,
    Expression<int> estado,
    Expression<int> criticidadTotal,
    Expression<int> criticidadReparacion,
    Expression<DateTime> momentoInicio,
    Expression<DateTime> momentoBorradorGuardado,
    Expression<DateTime> momentoEnvio,
    Expression<int> cuestionarioId,
    Expression<int> activoId,
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
      if (momentoEnvio != null) 'momento_envio': momentoEnvio,
      if (cuestionarioId != null) 'cuestionario_id': cuestionarioId,
      if (activoId != null) 'activo_id': activoId,
    });
  }

  InspeccionesCompanion copyWith(
      {Value<int> id,
      Value<EstadoDeInspeccion> estado,
      Value<int> criticidadTotal,
      Value<int> criticidadReparacion,
      Value<DateTime> momentoInicio,
      Value<DateTime> momentoBorradorGuardado,
      Value<DateTime> momentoEnvio,
      Value<int> cuestionarioId,
      Value<int> activoId}) {
    return InspeccionesCompanion(
      id: id ?? this.id,
      estado: estado ?? this.estado,
      criticidadTotal: criticidadTotal ?? this.criticidadTotal,
      criticidadReparacion: criticidadReparacion ?? this.criticidadReparacion,
      momentoInicio: momentoInicio ?? this.momentoInicio,
      momentoBorradorGuardado:
          momentoBorradorGuardado ?? this.momentoBorradorGuardado,
      momentoEnvio: momentoEnvio ?? this.momentoEnvio,
      cuestionarioId: cuestionarioId ?? this.cuestionarioId,
      activoId: activoId ?? this.activoId,
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
      map['estado'] = Variable<int>(converter.mapToSql(estado.value));
    }
    if (criticidadTotal.present) {
      map['criticidad_total'] = Variable<int>(criticidadTotal.value);
    }
    if (criticidadReparacion.present) {
      map['criticidad_reparacion'] = Variable<int>(criticidadReparacion.value);
    }
    if (momentoInicio.present) {
      map['momento_inicio'] = Variable<DateTime>(momentoInicio.value);
    }
    if (momentoBorradorGuardado.present) {
      map['momento_borrador_guardado'] =
          Variable<DateTime>(momentoBorradorGuardado.value);
    }
    if (momentoEnvio.present) {
      map['momento_envio'] = Variable<DateTime>(momentoEnvio.value);
    }
    if (cuestionarioId.present) {
      map['cuestionario_id'] = Variable<int>(cuestionarioId.value);
    }
    if (activoId.present) {
      map['activo_id'] = Variable<int>(activoId.value);
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
          ..write('momentoEnvio: $momentoEnvio, ')
          ..write('cuestionarioId: $cuestionarioId, ')
          ..write('activoId: $activoId')
          ..write(')'))
        .toString();
  }
}

class $InspeccionesTable extends Inspecciones
    with TableInfo<$InspeccionesTable, Inspeccion> {
  final GeneratedDatabase _db;
  final String _alias;
  $InspeccionesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _estadoMeta = const VerificationMeta('estado');
  GeneratedIntColumn _estado;
  @override
  GeneratedIntColumn get estado => _estado ??= _constructEstado();
  GeneratedIntColumn _constructEstado() {
    return GeneratedIntColumn(
      'estado',
      $tableName,
      false,
    );
  }

  final VerificationMeta _criticidadTotalMeta =
      const VerificationMeta('criticidadTotal');
  GeneratedIntColumn _criticidadTotal;
  @override
  GeneratedIntColumn get criticidadTotal =>
      _criticidadTotal ??= _constructCriticidadTotal();
  GeneratedIntColumn _constructCriticidadTotal() {
    return GeneratedIntColumn(
      'criticidad_total',
      $tableName,
      false,
    );
  }

  final VerificationMeta _criticidadReparacionMeta =
      const VerificationMeta('criticidadReparacion');
  GeneratedIntColumn _criticidadReparacion;
  @override
  GeneratedIntColumn get criticidadReparacion =>
      _criticidadReparacion ??= _constructCriticidadReparacion();
  GeneratedIntColumn _constructCriticidadReparacion() {
    return GeneratedIntColumn(
      'criticidad_reparacion',
      $tableName,
      false,
    );
  }

  final VerificationMeta _momentoInicioMeta =
      const VerificationMeta('momentoInicio');
  GeneratedDateTimeColumn _momentoInicio;
  @override
  GeneratedDateTimeColumn get momentoInicio =>
      _momentoInicio ??= _constructMomentoInicio();
  GeneratedDateTimeColumn _constructMomentoInicio() {
    return GeneratedDateTimeColumn(
      'momento_inicio',
      $tableName,
      true,
    );
  }

  final VerificationMeta _momentoBorradorGuardadoMeta =
      const VerificationMeta('momentoBorradorGuardado');
  GeneratedDateTimeColumn _momentoBorradorGuardado;
  @override
  GeneratedDateTimeColumn get momentoBorradorGuardado =>
      _momentoBorradorGuardado ??= _constructMomentoBorradorGuardado();
  GeneratedDateTimeColumn _constructMomentoBorradorGuardado() {
    return GeneratedDateTimeColumn(
      'momento_borrador_guardado',
      $tableName,
      true,
    );
  }

  final VerificationMeta _momentoEnvioMeta =
      const VerificationMeta('momentoEnvio');
  GeneratedDateTimeColumn _momentoEnvio;
  @override
  GeneratedDateTimeColumn get momentoEnvio =>
      _momentoEnvio ??= _constructMomentoEnvio();
  GeneratedDateTimeColumn _constructMomentoEnvio() {
    return GeneratedDateTimeColumn(
      'momento_envio',
      $tableName,
      true,
    );
  }

  final VerificationMeta _cuestionarioIdMeta =
      const VerificationMeta('cuestionarioId');
  GeneratedIntColumn _cuestionarioId;
  @override
  GeneratedIntColumn get cuestionarioId =>
      _cuestionarioId ??= _constructCuestionarioId();
  GeneratedIntColumn _constructCuestionarioId() {
    return GeneratedIntColumn('cuestionario_id', $tableName, false,
        $customConstraints: 'REFERENCES cuestionarios(id) ON DELETE CASCADE');
  }

  final VerificationMeta _activoIdMeta = const VerificationMeta('activoId');
  GeneratedIntColumn _activoId;
  @override
  GeneratedIntColumn get activoId => _activoId ??= _constructActivoId();
  GeneratedIntColumn _constructActivoId() {
    return GeneratedIntColumn('activo_id', $tableName, false,
        $customConstraints: 'REFERENCES activos(id) ON DELETE NO ACTION');
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        estado,
        criticidadTotal,
        criticidadReparacion,
        momentoInicio,
        momentoBorradorGuardado,
        momentoEnvio,
        cuestionarioId,
        activoId
      ];
  @override
  $InspeccionesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'inspecciones';
  @override
  final String actualTableName = 'inspecciones';
  @override
  VerificationContext validateIntegrity(Insertable<Inspeccion> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    context.handle(_estadoMeta, const VerificationResult.success());
    if (data.containsKey('criticidad_total')) {
      context.handle(
          _criticidadTotalMeta,
          criticidadTotal.isAcceptableOrUnknown(
              data['criticidad_total'], _criticidadTotalMeta));
    } else if (isInserting) {
      context.missing(_criticidadTotalMeta);
    }
    if (data.containsKey('criticidad_reparacion')) {
      context.handle(
          _criticidadReparacionMeta,
          criticidadReparacion.isAcceptableOrUnknown(
              data['criticidad_reparacion'], _criticidadReparacionMeta));
    } else if (isInserting) {
      context.missing(_criticidadReparacionMeta);
    }
    if (data.containsKey('momento_inicio')) {
      context.handle(
          _momentoInicioMeta,
          momentoInicio.isAcceptableOrUnknown(
              data['momento_inicio'], _momentoInicioMeta));
    }
    if (data.containsKey('momento_borrador_guardado')) {
      context.handle(
          _momentoBorradorGuardadoMeta,
          momentoBorradorGuardado.isAcceptableOrUnknown(
              data['momento_borrador_guardado'], _momentoBorradorGuardadoMeta));
    }
    if (data.containsKey('momento_envio')) {
      context.handle(
          _momentoEnvioMeta,
          momentoEnvio.isAcceptableOrUnknown(
              data['momento_envio'], _momentoEnvioMeta));
    }
    if (data.containsKey('cuestionario_id')) {
      context.handle(
          _cuestionarioIdMeta,
          cuestionarioId.isAcceptableOrUnknown(
              data['cuestionario_id'], _cuestionarioIdMeta));
    } else if (isInserting) {
      context.missing(_cuestionarioIdMeta);
    }
    if (data.containsKey('activo_id')) {
      context.handle(_activoIdMeta,
          activoId.isAcceptableOrUnknown(data['activo_id'], _activoIdMeta));
    } else if (isInserting) {
      context.missing(_activoIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Inspeccion map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Inspeccion.fromData(data, _db, prefix: effectivePrefix);
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
  final double valor;
  final String observacionReparacion;
  final DateTime momentoRespuesta;
  final int inspeccionId;
  final int preguntaId;
  Respuesta(
      {@required this.id,
      @required this.fotosBase,
      @required this.fotosReparacion,
      @required this.observacion,
      @required this.reparado,
      this.valor,
      @required this.observacionReparacion,
      this.momentoRespuesta,
      @required this.inspeccionId,
      @required this.preguntaId});
  factory Respuesta.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    final doubleType = db.typeSystem.forDartType<double>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return Respuesta(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      fotosBase: $RespuestasTable.$converter0.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}fotos_base'])),
      fotosReparacion: $RespuestasTable.$converter1.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}fotos_reparacion'])),
      observacion: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}observacion']),
      reparado:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}reparado']),
      valor:
          doubleType.mapFromDatabaseResponse(data['${effectivePrefix}valor']),
      observacionReparacion: stringType.mapFromDatabaseResponse(
          data['${effectivePrefix}observacion_reparacion']),
      momentoRespuesta: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}momento_respuesta']),
      inspeccionId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}inspeccion_id']),
      preguntaId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}pregunta_id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || fotosBase != null) {
      final converter = $RespuestasTable.$converter0;
      map['fotos_base'] = Variable<String>(converter.mapToSql(fotosBase));
    }
    if (!nullToAbsent || fotosReparacion != null) {
      final converter = $RespuestasTable.$converter1;
      map['fotos_reparacion'] =
          Variable<String>(converter.mapToSql(fotosReparacion));
    }
    if (!nullToAbsent || observacion != null) {
      map['observacion'] = Variable<String>(observacion);
    }
    if (!nullToAbsent || reparado != null) {
      map['reparado'] = Variable<bool>(reparado);
    }
    if (!nullToAbsent || valor != null) {
      map['valor'] = Variable<double>(valor);
    }
    if (!nullToAbsent || observacionReparacion != null) {
      map['observacion_reparacion'] = Variable<String>(observacionReparacion);
    }
    if (!nullToAbsent || momentoRespuesta != null) {
      map['momento_respuesta'] = Variable<DateTime>(momentoRespuesta);
    }
    if (!nullToAbsent || inspeccionId != null) {
      map['inspeccion_id'] = Variable<int>(inspeccionId);
    }
    if (!nullToAbsent || preguntaId != null) {
      map['pregunta_id'] = Variable<int>(preguntaId);
    }
    return map;
  }

  RespuestasCompanion toCompanion(bool nullToAbsent) {
    return RespuestasCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      fotosBase: fotosBase == null && nullToAbsent
          ? const Value.absent()
          : Value(fotosBase),
      fotosReparacion: fotosReparacion == null && nullToAbsent
          ? const Value.absent()
          : Value(fotosReparacion),
      observacion: observacion == null && nullToAbsent
          ? const Value.absent()
          : Value(observacion),
      reparado: reparado == null && nullToAbsent
          ? const Value.absent()
          : Value(reparado),
      valor:
          valor == null && nullToAbsent ? const Value.absent() : Value(valor),
      observacionReparacion: observacionReparacion == null && nullToAbsent
          ? const Value.absent()
          : Value(observacionReparacion),
      momentoRespuesta: momentoRespuesta == null && nullToAbsent
          ? const Value.absent()
          : Value(momentoRespuesta),
      inspeccionId: inspeccionId == null && nullToAbsent
          ? const Value.absent()
          : Value(inspeccionId),
      preguntaId: preguntaId == null && nullToAbsent
          ? const Value.absent()
          : Value(preguntaId),
    );
  }

  factory Respuesta.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Respuesta(
      id: serializer.fromJson<int>(json['id']),
      fotosBase: serializer.fromJson<KtList<String>>(json['fotosBase']),
      fotosReparacion:
          serializer.fromJson<KtList<String>>(json['fotosReparacion']),
      observacion: serializer.fromJson<String>(json['observacion']),
      reparado: serializer.fromJson<bool>(json['reparado']),
      valor: serializer.fromJson<double>(json['valor']),
      observacionReparacion:
          serializer.fromJson<String>(json['observacionReparacion']),
      momentoRespuesta: serializer.fromJson<DateTime>(json['momentoRespuesta']),
      inspeccionId: serializer.fromJson<int>(json['inspeccion']),
      preguntaId: serializer.fromJson<int>(json['pregunta']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fotosBase': serializer.toJson<KtList<String>>(fotosBase),
      'fotosReparacion': serializer.toJson<KtList<String>>(fotosReparacion),
      'observacion': serializer.toJson<String>(observacion),
      'reparado': serializer.toJson<bool>(reparado),
      'valor': serializer.toJson<double>(valor),
      'observacionReparacion': serializer.toJson<String>(observacionReparacion),
      'momentoRespuesta': serializer.toJson<DateTime>(momentoRespuesta),
      'inspeccion': serializer.toJson<int>(inspeccionId),
      'pregunta': serializer.toJson<int>(preguntaId),
    };
  }

  Respuesta copyWith(
          {int id,
          KtList<String> fotosBase,
          KtList<String> fotosReparacion,
          String observacion,
          bool reparado,
          double valor,
          String observacionReparacion,
          DateTime momentoRespuesta,
          int inspeccionId,
          int preguntaId}) =>
      Respuesta(
        id: id ?? this.id,
        fotosBase: fotosBase ?? this.fotosBase,
        fotosReparacion: fotosReparacion ?? this.fotosReparacion,
        observacion: observacion ?? this.observacion,
        reparado: reparado ?? this.reparado,
        valor: valor ?? this.valor,
        observacionReparacion:
            observacionReparacion ?? this.observacionReparacion,
        momentoRespuesta: momentoRespuesta ?? this.momentoRespuesta,
        inspeccionId: inspeccionId ?? this.inspeccionId,
        preguntaId: preguntaId ?? this.preguntaId,
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
          ..write('momentoRespuesta: $momentoRespuesta, ')
          ..write('inspeccionId: $inspeccionId, ')
          ..write('preguntaId: $preguntaId')
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
                                  momentoRespuesta.hashCode,
                                  $mrjc(inspeccionId.hashCode,
                                      preguntaId.hashCode))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Respuesta &&
          other.id == this.id &&
          other.fotosBase == this.fotosBase &&
          other.fotosReparacion == this.fotosReparacion &&
          other.observacion == this.observacion &&
          other.reparado == this.reparado &&
          other.valor == this.valor &&
          other.observacionReparacion == this.observacionReparacion &&
          other.momentoRespuesta == this.momentoRespuesta &&
          other.inspeccionId == this.inspeccionId &&
          other.preguntaId == this.preguntaId);
}

class RespuestasCompanion extends UpdateCompanion<Respuesta> {
  final Value<int> id;
  final Value<KtList<String>> fotosBase;
  final Value<KtList<String>> fotosReparacion;
  final Value<String> observacion;
  final Value<bool> reparado;
  final Value<double> valor;
  final Value<String> observacionReparacion;
  final Value<DateTime> momentoRespuesta;
  final Value<int> inspeccionId;
  final Value<int> preguntaId;
  const RespuestasCompanion({
    this.id = const Value.absent(),
    this.fotosBase = const Value.absent(),
    this.fotosReparacion = const Value.absent(),
    this.observacion = const Value.absent(),
    this.reparado = const Value.absent(),
    this.valor = const Value.absent(),
    this.observacionReparacion = const Value.absent(),
    this.momentoRespuesta = const Value.absent(),
    this.inspeccionId = const Value.absent(),
    this.preguntaId = const Value.absent(),
  });
  RespuestasCompanion.insert({
    this.id = const Value.absent(),
    this.fotosBase = const Value.absent(),
    this.fotosReparacion = const Value.absent(),
    this.observacion = const Value.absent(),
    this.reparado = const Value.absent(),
    this.valor = const Value.absent(),
    this.observacionReparacion = const Value.absent(),
    this.momentoRespuesta = const Value.absent(),
    @required int inspeccionId,
    @required int preguntaId,
  })  : inspeccionId = Value(inspeccionId),
        preguntaId = Value(preguntaId);
  static Insertable<Respuesta> custom({
    Expression<int> id,
    Expression<String> fotosBase,
    Expression<String> fotosReparacion,
    Expression<String> observacion,
    Expression<bool> reparado,
    Expression<double> valor,
    Expression<String> observacionReparacion,
    Expression<DateTime> momentoRespuesta,
    Expression<int> inspeccionId,
    Expression<int> preguntaId,
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
      if (momentoRespuesta != null) 'momento_respuesta': momentoRespuesta,
      if (inspeccionId != null) 'inspeccion_id': inspeccionId,
      if (preguntaId != null) 'pregunta_id': preguntaId,
    });
  }

  RespuestasCompanion copyWith(
      {Value<int> id,
      Value<KtList<String>> fotosBase,
      Value<KtList<String>> fotosReparacion,
      Value<String> observacion,
      Value<bool> reparado,
      Value<double> valor,
      Value<String> observacionReparacion,
      Value<DateTime> momentoRespuesta,
      Value<int> inspeccionId,
      Value<int> preguntaId}) {
    return RespuestasCompanion(
      id: id ?? this.id,
      fotosBase: fotosBase ?? this.fotosBase,
      fotosReparacion: fotosReparacion ?? this.fotosReparacion,
      observacion: observacion ?? this.observacion,
      reparado: reparado ?? this.reparado,
      valor: valor ?? this.valor,
      observacionReparacion:
          observacionReparacion ?? this.observacionReparacion,
      momentoRespuesta: momentoRespuesta ?? this.momentoRespuesta,
      inspeccionId: inspeccionId ?? this.inspeccionId,
      preguntaId: preguntaId ?? this.preguntaId,
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
      map['fotos_base'] = Variable<String>(converter.mapToSql(fotosBase.value));
    }
    if (fotosReparacion.present) {
      final converter = $RespuestasTable.$converter1;
      map['fotos_reparacion'] =
          Variable<String>(converter.mapToSql(fotosReparacion.value));
    }
    if (observacion.present) {
      map['observacion'] = Variable<String>(observacion.value);
    }
    if (reparado.present) {
      map['reparado'] = Variable<bool>(reparado.value);
    }
    if (valor.present) {
      map['valor'] = Variable<double>(valor.value);
    }
    if (observacionReparacion.present) {
      map['observacion_reparacion'] =
          Variable<String>(observacionReparacion.value);
    }
    if (momentoRespuesta.present) {
      map['momento_respuesta'] = Variable<DateTime>(momentoRespuesta.value);
    }
    if (inspeccionId.present) {
      map['inspeccion_id'] = Variable<int>(inspeccionId.value);
    }
    if (preguntaId.present) {
      map['pregunta_id'] = Variable<int>(preguntaId.value);
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
          ..write('momentoRespuesta: $momentoRespuesta, ')
          ..write('inspeccionId: $inspeccionId, ')
          ..write('preguntaId: $preguntaId')
          ..write(')'))
        .toString();
  }
}

class $RespuestasTable extends Respuestas
    with TableInfo<$RespuestasTable, Respuesta> {
  final GeneratedDatabase _db;
  final String _alias;
  $RespuestasTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _fotosBaseMeta = const VerificationMeta('fotosBase');
  GeneratedTextColumn _fotosBase;
  @override
  GeneratedTextColumn get fotosBase => _fotosBase ??= _constructFotosBase();
  GeneratedTextColumn _constructFotosBase() {
    return GeneratedTextColumn('fotos_base', $tableName, false,
        defaultValue: const Constant("[]"));
  }

  final VerificationMeta _fotosReparacionMeta =
      const VerificationMeta('fotosReparacion');
  GeneratedTextColumn _fotosReparacion;
  @override
  GeneratedTextColumn get fotosReparacion =>
      _fotosReparacion ??= _constructFotosReparacion();
  GeneratedTextColumn _constructFotosReparacion() {
    return GeneratedTextColumn('fotos_reparacion', $tableName, false,
        defaultValue: const Constant("[]"));
  }

  final VerificationMeta _observacionMeta =
      const VerificationMeta('observacion');
  GeneratedTextColumn _observacion;
  @override
  GeneratedTextColumn get observacion =>
      _observacion ??= _constructObservacion();
  GeneratedTextColumn _constructObservacion() {
    return GeneratedTextColumn('observacion', $tableName, false,
        defaultValue: const Constant(""));
  }

  final VerificationMeta _reparadoMeta = const VerificationMeta('reparado');
  GeneratedBoolColumn _reparado;
  @override
  GeneratedBoolColumn get reparado => _reparado ??= _constructReparado();
  GeneratedBoolColumn _constructReparado() {
    return GeneratedBoolColumn('reparado', $tableName, false,
        defaultValue: const Constant(false));
  }

  final VerificationMeta _valorMeta = const VerificationMeta('valor');
  GeneratedRealColumn _valor;
  @override
  GeneratedRealColumn get valor => _valor ??= _constructValor();
  GeneratedRealColumn _constructValor() {
    return GeneratedRealColumn(
      'valor',
      $tableName,
      true,
    );
  }

  final VerificationMeta _observacionReparacionMeta =
      const VerificationMeta('observacionReparacion');
  GeneratedTextColumn _observacionReparacion;
  @override
  GeneratedTextColumn get observacionReparacion =>
      _observacionReparacion ??= _constructObservacionReparacion();
  GeneratedTextColumn _constructObservacionReparacion() {
    return GeneratedTextColumn('observacion_reparacion', $tableName, false,
        defaultValue: const Constant(""));
  }

  final VerificationMeta _momentoRespuestaMeta =
      const VerificationMeta('momentoRespuesta');
  GeneratedDateTimeColumn _momentoRespuesta;
  @override
  GeneratedDateTimeColumn get momentoRespuesta =>
      _momentoRespuesta ??= _constructMomentoRespuesta();
  GeneratedDateTimeColumn _constructMomentoRespuesta() {
    return GeneratedDateTimeColumn(
      'momento_respuesta',
      $tableName,
      true,
    );
  }

  final VerificationMeta _inspeccionIdMeta =
      const VerificationMeta('inspeccionId');
  GeneratedIntColumn _inspeccionId;
  @override
  GeneratedIntColumn get inspeccionId =>
      _inspeccionId ??= _constructInspeccionId();
  GeneratedIntColumn _constructInspeccionId() {
    return GeneratedIntColumn('inspeccion_id', $tableName, false,
        $customConstraints: 'REFERENCES inspecciones(id) ON DELETE CASCADE');
  }

  final VerificationMeta _preguntaIdMeta = const VerificationMeta('preguntaId');
  GeneratedIntColumn _preguntaId;
  @override
  GeneratedIntColumn get preguntaId => _preguntaId ??= _constructPreguntaId();
  GeneratedIntColumn _constructPreguntaId() {
    return GeneratedIntColumn('pregunta_id', $tableName, false,
        $customConstraints: 'REFERENCES preguntas(id) ON DELETE CASCADE');
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        fotosBase,
        fotosReparacion,
        observacion,
        reparado,
        valor,
        observacionReparacion,
        momentoRespuesta,
        inspeccionId,
        preguntaId
      ];
  @override
  $RespuestasTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'respuestas';
  @override
  final String actualTableName = 'respuestas';
  @override
  VerificationContext validateIntegrity(Insertable<Respuesta> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    context.handle(_fotosBaseMeta, const VerificationResult.success());
    context.handle(_fotosReparacionMeta, const VerificationResult.success());
    if (data.containsKey('observacion')) {
      context.handle(
          _observacionMeta,
          observacion.isAcceptableOrUnknown(
              data['observacion'], _observacionMeta));
    }
    if (data.containsKey('reparado')) {
      context.handle(_reparadoMeta,
          reparado.isAcceptableOrUnknown(data['reparado'], _reparadoMeta));
    }
    if (data.containsKey('valor')) {
      context.handle(
          _valorMeta, valor.isAcceptableOrUnknown(data['valor'], _valorMeta));
    }
    if (data.containsKey('observacion_reparacion')) {
      context.handle(
          _observacionReparacionMeta,
          observacionReparacion.isAcceptableOrUnknown(
              data['observacion_reparacion'], _observacionReparacionMeta));
    }
    if (data.containsKey('momento_respuesta')) {
      context.handle(
          _momentoRespuestaMeta,
          momentoRespuesta.isAcceptableOrUnknown(
              data['momento_respuesta'], _momentoRespuestaMeta));
    }
    if (data.containsKey('inspeccion_id')) {
      context.handle(
          _inspeccionIdMeta,
          inspeccionId.isAcceptableOrUnknown(
              data['inspeccion_id'], _inspeccionIdMeta));
    } else if (isInserting) {
      context.missing(_inspeccionIdMeta);
    }
    if (data.containsKey('pregunta_id')) {
      context.handle(
          _preguntaIdMeta,
          preguntaId.isAcceptableOrUnknown(
              data['pregunta_id'], _preguntaIdMeta));
    } else if (isInserting) {
      context.missing(_preguntaIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Respuesta map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Respuesta.fromData(data, _db, prefix: effectivePrefix);
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

class RespuestasXOpcionesDeRespuestaData extends DataClass
    implements Insertable<RespuestasXOpcionesDeRespuestaData> {
  final int id;
  final int respuestaId;
  final int opcionDeRespuestaId;
  RespuestasXOpcionesDeRespuestaData(
      {@required this.id,
      @required this.respuestaId,
      @required this.opcionDeRespuestaId});
  factory RespuestasXOpcionesDeRespuestaData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    return RespuestasXOpcionesDeRespuestaData(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      respuestaId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}respuesta_id']),
      opcionDeRespuestaId: intType.mapFromDatabaseResponse(
          data['${effectivePrefix}opcion_de_respuesta_id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || respuestaId != null) {
      map['respuesta_id'] = Variable<int>(respuestaId);
    }
    if (!nullToAbsent || opcionDeRespuestaId != null) {
      map['opcion_de_respuesta_id'] = Variable<int>(opcionDeRespuestaId);
    }
    return map;
  }

  RespuestasXOpcionesDeRespuestaCompanion toCompanion(bool nullToAbsent) {
    return RespuestasXOpcionesDeRespuestaCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      respuestaId: respuestaId == null && nullToAbsent
          ? const Value.absent()
          : Value(respuestaId),
      opcionDeRespuestaId: opcionDeRespuestaId == null && nullToAbsent
          ? const Value.absent()
          : Value(opcionDeRespuestaId),
    );
  }

  factory RespuestasXOpcionesDeRespuestaData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return RespuestasXOpcionesDeRespuestaData(
      id: serializer.fromJson<int>(json['id']),
      respuestaId: serializer.fromJson<int>(json['respuesta']),
      opcionDeRespuestaId: serializer.fromJson<int>(json['opcionDeRespuesta']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'respuesta': serializer.toJson<int>(respuestaId),
      'opcionDeRespuesta': serializer.toJson<int>(opcionDeRespuestaId),
    };
  }

  RespuestasXOpcionesDeRespuestaData copyWith(
          {int id, int respuestaId, int opcionDeRespuestaId}) =>
      RespuestasXOpcionesDeRespuestaData(
        id: id ?? this.id,
        respuestaId: respuestaId ?? this.respuestaId,
        opcionDeRespuestaId: opcionDeRespuestaId ?? this.opcionDeRespuestaId,
      );
  @override
  String toString() {
    return (StringBuffer('RespuestasXOpcionesDeRespuestaData(')
          ..write('id: $id, ')
          ..write('respuestaId: $respuestaId, ')
          ..write('opcionDeRespuestaId: $opcionDeRespuestaId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode, $mrjc(respuestaId.hashCode, opcionDeRespuestaId.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is RespuestasXOpcionesDeRespuestaData &&
          other.id == this.id &&
          other.respuestaId == this.respuestaId &&
          other.opcionDeRespuestaId == this.opcionDeRespuestaId);
}

class RespuestasXOpcionesDeRespuestaCompanion
    extends UpdateCompanion<RespuestasXOpcionesDeRespuestaData> {
  final Value<int> id;
  final Value<int> respuestaId;
  final Value<int> opcionDeRespuestaId;
  const RespuestasXOpcionesDeRespuestaCompanion({
    this.id = const Value.absent(),
    this.respuestaId = const Value.absent(),
    this.opcionDeRespuestaId = const Value.absent(),
  });
  RespuestasXOpcionesDeRespuestaCompanion.insert({
    this.id = const Value.absent(),
    @required int respuestaId,
    @required int opcionDeRespuestaId,
  })  : respuestaId = Value(respuestaId),
        opcionDeRespuestaId = Value(opcionDeRespuestaId);
  static Insertable<RespuestasXOpcionesDeRespuestaData> custom({
    Expression<int> id,
    Expression<int> respuestaId,
    Expression<int> opcionDeRespuestaId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (respuestaId != null) 'respuesta_id': respuestaId,
      if (opcionDeRespuestaId != null)
        'opcion_de_respuesta_id': opcionDeRespuestaId,
    });
  }

  RespuestasXOpcionesDeRespuestaCompanion copyWith(
      {Value<int> id, Value<int> respuestaId, Value<int> opcionDeRespuestaId}) {
    return RespuestasXOpcionesDeRespuestaCompanion(
      id: id ?? this.id,
      respuestaId: respuestaId ?? this.respuestaId,
      opcionDeRespuestaId: opcionDeRespuestaId ?? this.opcionDeRespuestaId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (respuestaId.present) {
      map['respuesta_id'] = Variable<int>(respuestaId.value);
    }
    if (opcionDeRespuestaId.present) {
      map['opcion_de_respuesta_id'] = Variable<int>(opcionDeRespuestaId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RespuestasXOpcionesDeRespuestaCompanion(')
          ..write('id: $id, ')
          ..write('respuestaId: $respuestaId, ')
          ..write('opcionDeRespuestaId: $opcionDeRespuestaId')
          ..write(')'))
        .toString();
  }
}

class $RespuestasXOpcionesDeRespuestaTable
    extends RespuestasXOpcionesDeRespuesta
    with
        TableInfo<$RespuestasXOpcionesDeRespuestaTable,
            RespuestasXOpcionesDeRespuestaData> {
  final GeneratedDatabase _db;
  final String _alias;
  $RespuestasXOpcionesDeRespuestaTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _respuestaIdMeta =
      const VerificationMeta('respuestaId');
  GeneratedIntColumn _respuestaId;
  @override
  GeneratedIntColumn get respuestaId =>
      _respuestaId ??= _constructRespuestaId();
  GeneratedIntColumn _constructRespuestaId() {
    return GeneratedIntColumn('respuesta_id', $tableName, false,
        $customConstraints: 'REFERENCES respuestas(id) ON DELETE CASCADE');
  }

  final VerificationMeta _opcionDeRespuestaIdMeta =
      const VerificationMeta('opcionDeRespuestaId');
  GeneratedIntColumn _opcionDeRespuestaId;
  @override
  GeneratedIntColumn get opcionDeRespuestaId =>
      _opcionDeRespuestaId ??= _constructOpcionDeRespuestaId();
  GeneratedIntColumn _constructOpcionDeRespuestaId() {
    return GeneratedIntColumn('opcion_de_respuesta_id', $tableName, false,
        $customConstraints:
            'REFERENCES opciones_de_respuesta(id) ON DELETE CASCADE');
  }

  @override
  List<GeneratedColumn> get $columns => [id, respuestaId, opcionDeRespuestaId];
  @override
  $RespuestasXOpcionesDeRespuestaTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'respuestas_x_opciones_de_respuesta';
  @override
  final String actualTableName = 'respuestas_x_opciones_de_respuesta';
  @override
  VerificationContext validateIntegrity(
      Insertable<RespuestasXOpcionesDeRespuestaData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('respuesta_id')) {
      context.handle(
          _respuestaIdMeta,
          respuestaId.isAcceptableOrUnknown(
              data['respuesta_id'], _respuestaIdMeta));
    } else if (isInserting) {
      context.missing(_respuestaIdMeta);
    }
    if (data.containsKey('opcion_de_respuesta_id')) {
      context.handle(
          _opcionDeRespuestaIdMeta,
          opcionDeRespuestaId.isAcceptableOrUnknown(
              data['opcion_de_respuesta_id'], _opcionDeRespuestaIdMeta));
    } else if (isInserting) {
      context.missing(_opcionDeRespuestaIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RespuestasXOpcionesDeRespuestaData map(Map<String, dynamic> data,
      {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return RespuestasXOpcionesDeRespuestaData.fromData(data, _db,
        prefix: effectivePrefix);
  }

  @override
  $RespuestasXOpcionesDeRespuestaTable createAlias(String alias) {
    return $RespuestasXOpcionesDeRespuestaTable(_db, alias);
  }
}

class Contratista extends DataClass implements Insertable<Contratista> {
  final int id;
  final String nombre;
  Contratista({@required this.id, @required this.nombre});
  factory Contratista.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Contratista(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      nombre:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}nombre']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || nombre != null) {
      map['nombre'] = Variable<String>(nombre);
    }
    return map;
  }

  ContratistasCompanion toCompanion(bool nullToAbsent) {
    return ContratistasCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      nombre:
          nombre == null && nullToAbsent ? const Value.absent() : Value(nombre),
    );
  }

  factory Contratista.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Contratista(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
    };
  }

  Contratista copyWith({int id, String nombre}) => Contratista(
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
  bool operator ==(dynamic other) =>
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
    @required String nombre,
  }) : nombre = Value(nombre);
  static Insertable<Contratista> custom({
    Expression<int> id,
    Expression<String> nombre,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
    });
  }

  ContratistasCompanion copyWith({Value<int> id, Value<String> nombre}) {
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
  final String _alias;
  $ContratistasTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  GeneratedTextColumn _nombre;
  @override
  GeneratedTextColumn get nombre => _nombre ??= _constructNombre();
  GeneratedTextColumn _constructNombre() {
    return GeneratedTextColumn(
      'nombre',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, nombre];
  @override
  $ContratistasTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'contratistas';
  @override
  final String actualTableName = 'contratistas';
  @override
  VerificationContext validateIntegrity(Insertable<Contratista> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre'], _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Contratista map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Contratista.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $ContratistasTable createAlias(String alias) {
    return $ContratistasTable(_db, alias);
  }
}

class Sistema extends DataClass implements Insertable<Sistema> {
  final int id;
  final String nombre;
  Sistema({@required this.id, @required this.nombre});
  factory Sistema.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Sistema(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      nombre:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}nombre']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || nombre != null) {
      map['nombre'] = Variable<String>(nombre);
    }
    return map;
  }

  SistemasCompanion toCompanion(bool nullToAbsent) {
    return SistemasCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      nombre:
          nombre == null && nullToAbsent ? const Value.absent() : Value(nombre),
    );
  }

  factory Sistema.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Sistema(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
    };
  }

  Sistema copyWith({int id, String nombre}) => Sistema(
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
  bool operator ==(dynamic other) =>
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
    @required String nombre,
  }) : nombre = Value(nombre);
  static Insertable<Sistema> custom({
    Expression<int> id,
    Expression<String> nombre,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
    });
  }

  SistemasCompanion copyWith({Value<int> id, Value<String> nombre}) {
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
  final String _alias;
  $SistemasTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  GeneratedTextColumn _nombre;
  @override
  GeneratedTextColumn get nombre => _nombre ??= _constructNombre();
  GeneratedTextColumn _constructNombre() {
    return GeneratedTextColumn(
      'nombre',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, nombre];
  @override
  $SistemasTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'sistemas';
  @override
  final String actualTableName = 'sistemas';
  @override
  VerificationContext validateIntegrity(Insertable<Sistema> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre'], _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Sistema map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Sistema.fromData(data, _db, prefix: effectivePrefix);
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
  SubSistema(
      {@required this.id, @required this.nombre, @required this.sistemaId});
  factory SubSistema.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return SubSistema(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      nombre:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}nombre']),
      sistemaId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}sistema_id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || nombre != null) {
      map['nombre'] = Variable<String>(nombre);
    }
    if (!nullToAbsent || sistemaId != null) {
      map['sistema_id'] = Variable<int>(sistemaId);
    }
    return map;
  }

  SubSistemasCompanion toCompanion(bool nullToAbsent) {
    return SubSistemasCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      nombre:
          nombre == null && nullToAbsent ? const Value.absent() : Value(nombre),
      sistemaId: sistemaId == null && nullToAbsent
          ? const Value.absent()
          : Value(sistemaId),
    );
  }

  factory SubSistema.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return SubSistema(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      sistemaId: serializer.fromJson<int>(json['sistema']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'sistema': serializer.toJson<int>(sistemaId),
    };
  }

  SubSistema copyWith({int id, String nombre, int sistemaId}) => SubSistema(
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
  bool operator ==(dynamic other) =>
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
    @required String nombre,
    @required int sistemaId,
  })  : nombre = Value(nombre),
        sistemaId = Value(sistemaId);
  static Insertable<SubSistema> custom({
    Expression<int> id,
    Expression<String> nombre,
    Expression<int> sistemaId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (sistemaId != null) 'sistema_id': sistemaId,
    });
  }

  SubSistemasCompanion copyWith(
      {Value<int> id, Value<String> nombre, Value<int> sistemaId}) {
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
  final String _alias;
  $SubSistemasTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  GeneratedTextColumn _nombre;
  @override
  GeneratedTextColumn get nombre => _nombre ??= _constructNombre();
  GeneratedTextColumn _constructNombre() {
    return GeneratedTextColumn(
      'nombre',
      $tableName,
      false,
    );
  }

  final VerificationMeta _sistemaIdMeta = const VerificationMeta('sistemaId');
  GeneratedIntColumn _sistemaId;
  @override
  GeneratedIntColumn get sistemaId => _sistemaId ??= _constructSistemaId();
  GeneratedIntColumn _constructSistemaId() {
    return GeneratedIntColumn('sistema_id', $tableName, false,
        $customConstraints: 'REFERENCES sistemas(id) ON DELETE CASCADE');
  }

  @override
  List<GeneratedColumn> get $columns => [id, nombre, sistemaId];
  @override
  $SubSistemasTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'sub_sistemas';
  @override
  final String actualTableName = 'sub_sistemas';
  @override
  VerificationContext validateIntegrity(Insertable<SubSistema> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre'], _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('sistema_id')) {
      context.handle(_sistemaIdMeta,
          sistemaId.isAcceptableOrUnknown(data['sistema_id'], _sistemaIdMeta));
    } else if (isInserting) {
      context.missing(_sistemaIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubSistema map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return SubSistema.fromData(data, _db, prefix: effectivePrefix);
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
      {@required this.id,
      @required this.valorMinimo,
      @required this.valorMaximo,
      @required this.criticidad,
      @required this.preguntaId});
  factory CriticidadesNumerica.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final doubleType = db.typeSystem.forDartType<double>();
    return CriticidadesNumerica(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      valorMinimo: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}valor_minimo']),
      valorMaximo: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}valor_maximo']),
      criticidad:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}criticidad']),
      preguntaId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}pregunta_id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || valorMinimo != null) {
      map['valor_minimo'] = Variable<double>(valorMinimo);
    }
    if (!nullToAbsent || valorMaximo != null) {
      map['valor_maximo'] = Variable<double>(valorMaximo);
    }
    if (!nullToAbsent || criticidad != null) {
      map['criticidad'] = Variable<int>(criticidad);
    }
    if (!nullToAbsent || preguntaId != null) {
      map['pregunta_id'] = Variable<int>(preguntaId);
    }
    return map;
  }

  CriticidadesNumericasCompanion toCompanion(bool nullToAbsent) {
    return CriticidadesNumericasCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      valorMinimo: valorMinimo == null && nullToAbsent
          ? const Value.absent()
          : Value(valorMinimo),
      valorMaximo: valorMaximo == null && nullToAbsent
          ? const Value.absent()
          : Value(valorMaximo),
      criticidad: criticidad == null && nullToAbsent
          ? const Value.absent()
          : Value(criticidad),
      preguntaId: preguntaId == null && nullToAbsent
          ? const Value.absent()
          : Value(preguntaId),
    );
  }

  factory CriticidadesNumerica.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
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
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
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
          {int id,
          double valorMinimo,
          double valorMaximo,
          int criticidad,
          int preguntaId}) =>
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
  bool operator ==(dynamic other) =>
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
    @required double valorMinimo,
    @required double valorMaximo,
    @required int criticidad,
    @required int preguntaId,
  })  : valorMinimo = Value(valorMinimo),
        valorMaximo = Value(valorMaximo),
        criticidad = Value(criticidad),
        preguntaId = Value(preguntaId);
  static Insertable<CriticidadesNumerica> custom({
    Expression<int> id,
    Expression<double> valorMinimo,
    Expression<double> valorMaximo,
    Expression<int> criticidad,
    Expression<int> preguntaId,
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
      {Value<int> id,
      Value<double> valorMinimo,
      Value<double> valorMaximo,
      Value<int> criticidad,
      Value<int> preguntaId}) {
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
  final String _alias;
  $CriticidadesNumericasTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _valorMinimoMeta =
      const VerificationMeta('valorMinimo');
  GeneratedRealColumn _valorMinimo;
  @override
  GeneratedRealColumn get valorMinimo =>
      _valorMinimo ??= _constructValorMinimo();
  GeneratedRealColumn _constructValorMinimo() {
    return GeneratedRealColumn(
      'valor_minimo',
      $tableName,
      false,
    );
  }

  final VerificationMeta _valorMaximoMeta =
      const VerificationMeta('valorMaximo');
  GeneratedRealColumn _valorMaximo;
  @override
  GeneratedRealColumn get valorMaximo =>
      _valorMaximo ??= _constructValorMaximo();
  GeneratedRealColumn _constructValorMaximo() {
    return GeneratedRealColumn(
      'valor_maximo',
      $tableName,
      false,
    );
  }

  final VerificationMeta _criticidadMeta = const VerificationMeta('criticidad');
  GeneratedIntColumn _criticidad;
  @override
  GeneratedIntColumn get criticidad => _criticidad ??= _constructCriticidad();
  GeneratedIntColumn _constructCriticidad() {
    return GeneratedIntColumn(
      'criticidad',
      $tableName,
      false,
    );
  }

  final VerificationMeta _preguntaIdMeta = const VerificationMeta('preguntaId');
  GeneratedIntColumn _preguntaId;
  @override
  GeneratedIntColumn get preguntaId => _preguntaId ??= _constructPreguntaId();
  GeneratedIntColumn _constructPreguntaId() {
    return GeneratedIntColumn('pregunta_id', $tableName, false,
        $customConstraints: 'REFERENCES preguntas(id) ON DELETE CASCADE');
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, valorMinimo, valorMaximo, criticidad, preguntaId];
  @override
  $CriticidadesNumericasTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'criticidades_numericas';
  @override
  final String actualTableName = 'criticidades_numericas';
  @override
  VerificationContext validateIntegrity(
      Insertable<CriticidadesNumerica> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('valor_minimo')) {
      context.handle(
          _valorMinimoMeta,
          valorMinimo.isAcceptableOrUnknown(
              data['valor_minimo'], _valorMinimoMeta));
    } else if (isInserting) {
      context.missing(_valorMinimoMeta);
    }
    if (data.containsKey('valor_maximo')) {
      context.handle(
          _valorMaximoMeta,
          valorMaximo.isAcceptableOrUnknown(
              data['valor_maximo'], _valorMaximoMeta));
    } else if (isInserting) {
      context.missing(_valorMaximoMeta);
    }
    if (data.containsKey('criticidad')) {
      context.handle(
          _criticidadMeta,
          criticidad.isAcceptableOrUnknown(
              data['criticidad'], _criticidadMeta));
    } else if (isInserting) {
      context.missing(_criticidadMeta);
    }
    if (data.containsKey('pregunta_id')) {
      context.handle(
          _preguntaIdMeta,
          preguntaId.isAcceptableOrUnknown(
              data['pregunta_id'], _preguntaIdMeta));
    } else if (isInserting) {
      context.missing(_preguntaIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CriticidadesNumerica map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return CriticidadesNumerica.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $CriticidadesNumericasTable createAlias(String alias) {
    return $CriticidadesNumericasTable(_db, alias);
  }
}

class PreguntasCondicionalData extends DataClass
    implements Insertable<PreguntasCondicionalData> {
  final int id;
  final int preguntaId;
  final int seccion;
  final String opcionDeRespuesta;
  PreguntasCondicionalData(
      {@required this.id,
      @required this.preguntaId,
      @required this.seccion,
      @required this.opcionDeRespuesta});
  factory PreguntasCondicionalData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return PreguntasCondicionalData(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      preguntaId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}pregunta_id']),
      seccion:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}seccion']),
      opcionDeRespuesta: stringType.mapFromDatabaseResponse(
          data['${effectivePrefix}opcion_de_respuesta']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || preguntaId != null) {
      map['pregunta_id'] = Variable<int>(preguntaId);
    }
    if (!nullToAbsent || seccion != null) {
      map['seccion'] = Variable<int>(seccion);
    }
    if (!nullToAbsent || opcionDeRespuesta != null) {
      map['opcion_de_respuesta'] = Variable<String>(opcionDeRespuesta);
    }
    return map;
  }

  PreguntasCondicionalCompanion toCompanion(bool nullToAbsent) {
    return PreguntasCondicionalCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      preguntaId: preguntaId == null && nullToAbsent
          ? const Value.absent()
          : Value(preguntaId),
      seccion: seccion == null && nullToAbsent
          ? const Value.absent()
          : Value(seccion),
      opcionDeRespuesta: opcionDeRespuesta == null && nullToAbsent
          ? const Value.absent()
          : Value(opcionDeRespuesta),
    );
  }

  factory PreguntasCondicionalData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return PreguntasCondicionalData(
      id: serializer.fromJson<int>(json['id']),
      preguntaId: serializer.fromJson<int>(json['pregunta']),
      seccion: serializer.fromJson<int>(json['seccion']),
      opcionDeRespuesta: serializer.fromJson<String>(json['opcionDeRespuesta']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pregunta': serializer.toJson<int>(preguntaId),
      'seccion': serializer.toJson<int>(seccion),
      'opcionDeRespuesta': serializer.toJson<String>(opcionDeRespuesta),
    };
  }

  PreguntasCondicionalData copyWith(
          {int id, int preguntaId, int seccion, String opcionDeRespuesta}) =>
      PreguntasCondicionalData(
        id: id ?? this.id,
        preguntaId: preguntaId ?? this.preguntaId,
        seccion: seccion ?? this.seccion,
        opcionDeRespuesta: opcionDeRespuesta ?? this.opcionDeRespuesta,
      );
  @override
  String toString() {
    return (StringBuffer('PreguntasCondicionalData(')
          ..write('id: $id, ')
          ..write('preguntaId: $preguntaId, ')
          ..write('seccion: $seccion, ')
          ..write('opcionDeRespuesta: $opcionDeRespuesta')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(preguntaId.hashCode,
          $mrjc(seccion.hashCode, opcionDeRespuesta.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is PreguntasCondicionalData &&
          other.id == this.id &&
          other.preguntaId == this.preguntaId &&
          other.seccion == this.seccion &&
          other.opcionDeRespuesta == this.opcionDeRespuesta);
}

class PreguntasCondicionalCompanion
    extends UpdateCompanion<PreguntasCondicionalData> {
  final Value<int> id;
  final Value<int> preguntaId;
  final Value<int> seccion;
  final Value<String> opcionDeRespuesta;
  const PreguntasCondicionalCompanion({
    this.id = const Value.absent(),
    this.preguntaId = const Value.absent(),
    this.seccion = const Value.absent(),
    this.opcionDeRespuesta = const Value.absent(),
  });
  PreguntasCondicionalCompanion.insert({
    this.id = const Value.absent(),
    @required int preguntaId,
    @required int seccion,
    @required String opcionDeRespuesta,
  })  : preguntaId = Value(preguntaId),
        seccion = Value(seccion),
        opcionDeRespuesta = Value(opcionDeRespuesta);
  static Insertable<PreguntasCondicionalData> custom({
    Expression<int> id,
    Expression<int> preguntaId,
    Expression<int> seccion,
    Expression<String> opcionDeRespuesta,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (preguntaId != null) 'pregunta_id': preguntaId,
      if (seccion != null) 'seccion': seccion,
      if (opcionDeRespuesta != null) 'opcion_de_respuesta': opcionDeRespuesta,
    });
  }

  PreguntasCondicionalCompanion copyWith(
      {Value<int> id,
      Value<int> preguntaId,
      Value<int> seccion,
      Value<String> opcionDeRespuesta}) {
    return PreguntasCondicionalCompanion(
      id: id ?? this.id,
      preguntaId: preguntaId ?? this.preguntaId,
      seccion: seccion ?? this.seccion,
      opcionDeRespuesta: opcionDeRespuesta ?? this.opcionDeRespuesta,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (preguntaId.present) {
      map['pregunta_id'] = Variable<int>(preguntaId.value);
    }
    if (seccion.present) {
      map['seccion'] = Variable<int>(seccion.value);
    }
    if (opcionDeRespuesta.present) {
      map['opcion_de_respuesta'] = Variable<String>(opcionDeRespuesta.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreguntasCondicionalCompanion(')
          ..write('id: $id, ')
          ..write('preguntaId: $preguntaId, ')
          ..write('seccion: $seccion, ')
          ..write('opcionDeRespuesta: $opcionDeRespuesta')
          ..write(')'))
        .toString();
  }
}

class $PreguntasCondicionalTable extends PreguntasCondicional
    with TableInfo<$PreguntasCondicionalTable, PreguntasCondicionalData> {
  final GeneratedDatabase _db;
  final String _alias;
  $PreguntasCondicionalTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _preguntaIdMeta = const VerificationMeta('preguntaId');
  GeneratedIntColumn _preguntaId;
  @override
  GeneratedIntColumn get preguntaId => _preguntaId ??= _constructPreguntaId();
  GeneratedIntColumn _constructPreguntaId() {
    return GeneratedIntColumn('pregunta_id', $tableName, false,
        $customConstraints: 'REFERENCES preguntas(id) ON DELETE CASCADE');
  }

  final VerificationMeta _seccionMeta = const VerificationMeta('seccion');
  GeneratedIntColumn _seccion;
  @override
  GeneratedIntColumn get seccion => _seccion ??= _constructSeccion();
  GeneratedIntColumn _constructSeccion() {
    return GeneratedIntColumn(
      'seccion',
      $tableName,
      false,
    );
  }

  final VerificationMeta _opcionDeRespuestaMeta =
      const VerificationMeta('opcionDeRespuesta');
  GeneratedTextColumn _opcionDeRespuesta;
  @override
  GeneratedTextColumn get opcionDeRespuesta =>
      _opcionDeRespuesta ??= _constructOpcionDeRespuesta();
  GeneratedTextColumn _constructOpcionDeRespuesta() {
    return GeneratedTextColumn('opcion_de_respuesta', $tableName, false,
        minTextLength: 1, maxTextLength: 100);
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, preguntaId, seccion, opcionDeRespuesta];
  @override
  $PreguntasCondicionalTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'preguntas_condicional';
  @override
  final String actualTableName = 'preguntas_condicional';
  @override
  VerificationContext validateIntegrity(
      Insertable<PreguntasCondicionalData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('pregunta_id')) {
      context.handle(
          _preguntaIdMeta,
          preguntaId.isAcceptableOrUnknown(
              data['pregunta_id'], _preguntaIdMeta));
    } else if (isInserting) {
      context.missing(_preguntaIdMeta);
    }
    if (data.containsKey('seccion')) {
      context.handle(_seccionMeta,
          seccion.isAcceptableOrUnknown(data['seccion'], _seccionMeta));
    } else if (isInserting) {
      context.missing(_seccionMeta);
    }
    if (data.containsKey('opcion_de_respuesta')) {
      context.handle(
          _opcionDeRespuestaMeta,
          opcionDeRespuesta.isAcceptableOrUnknown(
              data['opcion_de_respuesta'], _opcionDeRespuestaMeta));
    } else if (isInserting) {
      context.missing(_opcionDeRespuestaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PreguntasCondicionalData map(Map<String, dynamic> data,
      {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return PreguntasCondicionalData.fromData(data, _db,
        prefix: effectivePrefix);
  }

  @override
  $PreguntasCondicionalTable createAlias(String alias) {
    return $PreguntasCondicionalTable(_db, alias);
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $ActivosTable _activos;
  $ActivosTable get activos => _activos ??= $ActivosTable(this);
  $CuestionarioDeModelosTable _cuestionarioDeModelos;
  $CuestionarioDeModelosTable get cuestionarioDeModelos =>
      _cuestionarioDeModelos ??= $CuestionarioDeModelosTable(this);
  $CuestionariosTable _cuestionarios;
  $CuestionariosTable get cuestionarios =>
      _cuestionarios ??= $CuestionariosTable(this);
  $BloquesTable _bloques;
  $BloquesTable get bloques => _bloques ??= $BloquesTable(this);
  $TitulosTable _titulos;
  $TitulosTable get titulos => _titulos ??= $TitulosTable(this);
  $CuadriculasDePreguntasTable _cuadriculasDePreguntas;
  $CuadriculasDePreguntasTable get cuadriculasDePreguntas =>
      _cuadriculasDePreguntas ??= $CuadriculasDePreguntasTable(this);
  $PreguntasTable _preguntas;
  $PreguntasTable get preguntas => _preguntas ??= $PreguntasTable(this);
  $OpcionesDeRespuestaTable _opcionesDeRespuesta;
  $OpcionesDeRespuestaTable get opcionesDeRespuesta =>
      _opcionesDeRespuesta ??= $OpcionesDeRespuestaTable(this);
  $InspeccionesTable _inspecciones;
  $InspeccionesTable get inspecciones =>
      _inspecciones ??= $InspeccionesTable(this);
  $RespuestasTable _respuestas;
  $RespuestasTable get respuestas => _respuestas ??= $RespuestasTable(this);
  $RespuestasXOpcionesDeRespuestaTable _respuestasXOpcionesDeRespuesta;
  $RespuestasXOpcionesDeRespuestaTable get respuestasXOpcionesDeRespuesta =>
      _respuestasXOpcionesDeRespuesta ??=
          $RespuestasXOpcionesDeRespuestaTable(this);
  $ContratistasTable _contratistas;
  $ContratistasTable get contratistas =>
      _contratistas ??= $ContratistasTable(this);
  $SistemasTable _sistemas;
  $SistemasTable get sistemas => _sistemas ??= $SistemasTable(this);
  $SubSistemasTable _subSistemas;
  $SubSistemasTable get subSistemas => _subSistemas ??= $SubSistemasTable(this);
  $CriticidadesNumericasTable _criticidadesNumericas;
  $CriticidadesNumericasTable get criticidadesNumericas =>
      _criticidadesNumericas ??= $CriticidadesNumericasTable(this);
  $PreguntasCondicionalTable _preguntasCondicional;
  $PreguntasCondicionalTable get preguntasCondicional =>
      _preguntasCondicional ??= $PreguntasCondicionalTable(this);
  LlenadoDao _llenadoDao;
  LlenadoDao get llenadoDao => _llenadoDao ??= LlenadoDao(this as Database);
  CreacionDao _creacionDao;
  CreacionDao get creacionDao => _creacionDao ??= CreacionDao(this as Database);
  BorradoresDao _borradoresDao;
  BorradoresDao get borradoresDao =>
      _borradoresDao ??= BorradoresDao(this as Database);
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
        respuestasXOpcionesDeRespuesta,
        contratistas,
        sistemas,
        subSistemas,
        criticidadesNumericas,
        preguntasCondicional
      ];
}
