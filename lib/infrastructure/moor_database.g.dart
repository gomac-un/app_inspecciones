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
  final String eje;
  final String posicionZ;
  final String lado;
  final KtList<String> fotosGuia;
  final bool esCondicional;
  final int sistemaId;
  final int bloqueId;
  final int subSistemaId;
  final TipoDePregunta tipo;
  Pregunta(
      {@required this.id,
      @required this.titulo,
      @required this.descripcion,
      @required this.criticidad,
      this.posicion,
      this.eje,
      this.posicionZ,
      this.lado,
      @required this.fotosGuia,
      @required this.esCondicional,
      this.sistemaId,
      @required this.bloqueId,
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
      eje: stringType.mapFromDatabaseResponse(data['${effectivePrefix}eje']),
      posicionZ: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}posicion_z']),
      lado: stringType.mapFromDatabaseResponse(data['${effectivePrefix}lado']),
      fotosGuia: $PreguntasTable.$converter0.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}fotos_guia'])),
      esCondicional: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}es_condicional']),
      sistemaId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}sistema_id']),
      bloqueId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}bloque_id']),
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
    if (!nullToAbsent || eje != null) {
      map['eje'] = Variable<String>(eje);
    }
    if (!nullToAbsent || posicionZ != null) {
      map['posicion_z'] = Variable<String>(posicionZ);
    }
    if (!nullToAbsent || lado != null) {
      map['lado'] = Variable<String>(lado);
    }
    if (!nullToAbsent || fotosGuia != null) {
      final converter = $PreguntasTable.$converter0;
      map['fotos_guia'] = Variable<String>(converter.mapToSql(fotosGuia));
    }
    if (!nullToAbsent || esCondicional != null) {
      map['es_condicional'] = Variable<bool>(esCondicional);
    }
    if (!nullToAbsent || sistemaId != null) {
      map['sistema_id'] = Variable<int>(sistemaId);
    }
    if (!nullToAbsent || bloqueId != null) {
      map['bloque_id'] = Variable<int>(bloqueId);
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
      eje: eje == null && nullToAbsent ? const Value.absent() : Value(eje),
      posicionZ: posicionZ == null && nullToAbsent
          ? const Value.absent()
          : Value(posicionZ),
      lado: lado == null && nullToAbsent ? const Value.absent() : Value(lado),
      fotosGuia: fotosGuia == null && nullToAbsent
          ? const Value.absent()
          : Value(fotosGuia),
      esCondicional: esCondicional == null && nullToAbsent
          ? const Value.absent()
          : Value(esCondicional),
      sistemaId: sistemaId == null && nullToAbsent
          ? const Value.absent()
          : Value(sistemaId),
      bloqueId: bloqueId == null && nullToAbsent
          ? const Value.absent()
          : Value(bloqueId),
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
      eje: serializer.fromJson<String>(json['eje']),
      posicionZ: serializer.fromJson<String>(json['posicionZ']),
      lado: serializer.fromJson<String>(json['lado']),
      fotosGuia: serializer.fromJson<KtList<String>>(json['fotosGuia']),
      esCondicional: serializer.fromJson<bool>(json['esCondicional']),
      sistemaId: serializer.fromJson<int>(json['sistema']),
      bloqueId: serializer.fromJson<int>(json['bloque']),
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
      'eje': serializer.toJson<String>(eje),
      'posicionZ': serializer.toJson<String>(posicionZ),
      'lado': serializer.toJson<String>(lado),
      'fotosGuia': serializer.toJson<KtList<String>>(fotosGuia),
      'esCondicional': serializer.toJson<bool>(esCondicional),
      'sistema': serializer.toJson<int>(sistemaId),
      'bloque': serializer.toJson<int>(bloqueId),
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
          String eje,
          String posicionZ,
          String lado,
          KtList<String> fotosGuia,
          bool esCondicional,
          int sistemaId,
          int bloqueId,
          int subSistemaId,
          TipoDePregunta tipo}) =>
      Pregunta(
        id: id ?? this.id,
        titulo: titulo ?? this.titulo,
        descripcion: descripcion ?? this.descripcion,
        criticidad: criticidad ?? this.criticidad,
        posicion: posicion ?? this.posicion,
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
          ..write('posicion: $posicion, ')
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
                      posicion.hashCode,
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
                                                      tipo.hashCode))))))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Pregunta &&
          other.id == this.id &&
          other.titulo == this.titulo &&
          other.descripcion == this.descripcion &&
          other.criticidad == this.criticidad &&
          other.posicion == this.posicion &&
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
  final Value<String> posicion;
  final Value<String> eje;
  final Value<String> posicionZ;
  final Value<String> lado;
  final Value<KtList<String>> fotosGuia;
  final Value<bool> esCondicional;
  final Value<int> sistemaId;
  final Value<int> bloqueId;
  final Value<int> subSistemaId;
  final Value<TipoDePregunta> tipo;
  const PreguntasCompanion({
    this.id = const Value.absent(),
    this.titulo = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.criticidad = const Value.absent(),
    this.posicion = const Value.absent(),
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
    @required String titulo,
    @required String descripcion,
    @required int criticidad,
    this.posicion = const Value.absent(),
    this.eje = const Value.absent(),
    this.posicionZ = const Value.absent(),
    this.lado = const Value.absent(),
    this.fotosGuia = const Value.absent(),
    this.esCondicional = const Value.absent(),
    this.sistemaId = const Value.absent(),
    @required int bloqueId,
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
    Expression<String> eje,
    Expression<String> posicionZ,
    Expression<String> lado,
    Expression<String> fotosGuia,
    Expression<bool> esCondicional,
    Expression<int> sistemaId,
    Expression<int> bloqueId,
    Expression<int> subSistemaId,
    Expression<int> tipo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (titulo != null) 'titulo': titulo,
      if (descripcion != null) 'descripcion': descripcion,
      if (criticidad != null) 'criticidad': criticidad,
      if (posicion != null) 'posicion': posicion,
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
      {Value<int> id,
      Value<String> titulo,
      Value<String> descripcion,
      Value<int> criticidad,
      Value<String> posicion,
      Value<String> eje,
      Value<String> posicionZ,
      Value<String> lado,
      Value<KtList<String>> fotosGuia,
      Value<bool> esCondicional,
      Value<int> sistemaId,
      Value<int> bloqueId,
      Value<int> subSistemaId,
      Value<TipoDePregunta> tipo}) {
    return PreguntasCompanion(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      criticidad: criticidad ?? this.criticidad,
      posicion: posicion ?? this.posicion,
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
    if (posicion.present) {
      map['posicion'] = Variable<String>(posicion.value);
    }
    if (eje.present) {
      map['eje'] = Variable<String>(eje.value);
    }
    if (posicionZ.present) {
      map['posicion_z'] = Variable<String>(posicionZ.value);
    }
    if (lado.present) {
      map['lado'] = Variable<String>(lado.value);
    }
    if (fotosGuia.present) {
      final converter = $PreguntasTable.$converter0;
      map['fotos_guia'] = Variable<String>(converter.mapToSql(fotosGuia.value));
    }
    if (esCondicional.present) {
      map['es_condicional'] = Variable<bool>(esCondicional.value);
    }
    if (sistemaId.present) {
      map['sistema_id'] = Variable<int>(sistemaId.value);
    }
    if (bloqueId.present) {
      map['bloque_id'] = Variable<int>(bloqueId.value);
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

  final VerificationMeta _ejeMeta = const VerificationMeta('eje');
  GeneratedTextColumn _eje;
  @override
  GeneratedTextColumn get eje => _eje ??= _constructEje();
  GeneratedTextColumn _constructEje() {
    return GeneratedTextColumn('eje', $tableName, true,
        minTextLength: 0, maxTextLength: 50);
  }

  final VerificationMeta _posicionZMeta = const VerificationMeta('posicionZ');
  GeneratedTextColumn _posicionZ;
  @override
  GeneratedTextColumn get posicionZ => _posicionZ ??= _constructPosicionZ();
  GeneratedTextColumn _constructPosicionZ() {
    return GeneratedTextColumn('posicion_z', $tableName, true,
        minTextLength: 0, maxTextLength: 50);
  }

  final VerificationMeta _ladoMeta = const VerificationMeta('lado');
  GeneratedTextColumn _lado;
  @override
  GeneratedTextColumn get lado => _lado ??= _constructLado();
  GeneratedTextColumn _constructLado() {
    return GeneratedTextColumn('lado', $tableName, true,
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

  final VerificationMeta _sistemaIdMeta = const VerificationMeta('sistemaId');
  GeneratedIntColumn _sistemaId;
  @override
  GeneratedIntColumn get sistemaId => _sistemaId ??= _constructSistemaId();
  GeneratedIntColumn _constructSistemaId() {
    return GeneratedIntColumn('sistema_id', $tableName, true,
        $customConstraints: 'REFERENCES sistemas(id)');
  }

  final VerificationMeta _bloqueIdMeta = const VerificationMeta('bloqueId');
  GeneratedIntColumn _bloqueId;
  @override
  GeneratedIntColumn get bloqueId => _bloqueId ??= _constructBloqueId();
  GeneratedIntColumn _constructBloqueId() {
    return GeneratedIntColumn('bloque_id', $tableName, false,
        $customConstraints: 'REFERENCES bloques(id) ON DELETE CASCADE');
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
    if (data.containsKey('eje')) {
      context.handle(
          _ejeMeta, eje.isAcceptableOrUnknown(data['eje'], _ejeMeta));
    }
    if (data.containsKey('posicion_z')) {
      context.handle(_posicionZMeta,
          posicionZ.isAcceptableOrUnknown(data['posicion_z'], _posicionZMeta));
    }
    if (data.containsKey('lado')) {
      context.handle(
          _ladoMeta, lado.isAcceptableOrUnknown(data['lado'], _ladoMeta));
    }
    context.handle(_fotosGuiaMeta, const VerificationResult.success());
    if (data.containsKey('es_condicional')) {
      context.handle(
          _esCondicionalMeta,
          esCondicional.isAcceptableOrUnknown(
              data['es_condicional'], _esCondicionalMeta));
    }
    if (data.containsKey('sistema_id')) {
      context.handle(_sistemaIdMeta,
          sistemaId.isAcceptableOrUnknown(data['sistema_id'], _sistemaIdMeta));
    }
    if (data.containsKey('bloque_id')) {
      context.handle(_bloqueIdMeta,
          bloqueId.isAcceptableOrUnknown(data['bloque_id'], _bloqueIdMeta));
    } else if (isInserting) {
      context.missing(_bloqueIdMeta);
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
  final bool calificable;
  final String texto;
  final int criticidad;
  OpcionDeRespuesta(
      {@required this.id,
      this.preguntaId,
      this.cuadriculaId,
      @required this.calificable,
      @required this.texto,
      @required this.criticidad});
  factory OpcionDeRespuesta.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final boolType = db.typeSystem.forDartType<bool>();
    final stringType = db.typeSystem.forDartType<String>();
    return OpcionDeRespuesta(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      preguntaId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}pregunta_id']),
      cuadriculaId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}cuadricula_id']),
      calificable: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}calificable']),
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
    if (!nullToAbsent || calificable != null) {
      map['calificable'] = Variable<bool>(calificable);
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
      calificable: calificable == null && nullToAbsent
          ? const Value.absent()
          : Value(calificable),
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
      calificable: serializer.fromJson<bool>(json['calificable']),
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
      'calificable': serializer.toJson<bool>(calificable),
      'texto': serializer.toJson<String>(texto),
      'criticidad': serializer.toJson<int>(criticidad),
    };
  }

  OpcionDeRespuesta copyWith(
          {int id,
          int preguntaId,
          int cuadriculaId,
          bool calificable,
          String texto,
          int criticidad}) =>
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
  bool operator ==(dynamic other) =>
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
  final Value<int> preguntaId;
  final Value<int> cuadriculaId;
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
    @required String texto,
    @required int criticidad,
  })  : texto = Value(texto),
        criticidad = Value(criticidad);
  static Insertable<OpcionDeRespuesta> custom({
    Expression<int> id,
    Expression<int> preguntaId,
    Expression<int> cuadriculaId,
    Expression<bool> calificable,
    Expression<String> texto,
    Expression<int> criticidad,
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
      {Value<int> id,
      Value<int> preguntaId,
      Value<int> cuadriculaId,
      Value<bool> calificable,
      Value<String> texto,
      Value<int> criticidad}) {
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
      map['pregunta_id'] = Variable<int>(preguntaId.value);
    }
    if (cuadriculaId.present) {
      map['cuadricula_id'] = Variable<int>(cuadriculaId.value);
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

  final VerificationMeta _calificableMeta =
      const VerificationMeta('calificable');
  GeneratedBoolColumn _calificable;
  @override
  GeneratedBoolColumn get calificable =>
      _calificable ??= _constructCalificable();
  GeneratedBoolColumn _constructCalificable() {
    return GeneratedBoolColumn('calificable', $tableName, false,
        defaultValue: const Constant(false));
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
      [id, preguntaId, cuadriculaId, calificable, texto, criticidad];
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
    if (data.containsKey('calificable')) {
      context.handle(
          _calificableMeta,
          calificable.isAcceptableOrUnknown(
              data['calificable'], _calificableMeta));
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
  final double criticidadTotal;
  final double criticidadReparacion;
  final DateTime momentoInicio;
  final DateTime momentoBorradorGuardado;
  final DateTime momentoFinalizacion;
  final DateTime momentoEnvio;
  final int cuestionarioId;
  final int activoId;
  final bool esNueva;
  Inspeccion(
      {@required this.id,
      @required this.estado,
      @required this.criticidadTotal,
      @required this.criticidadReparacion,
      this.momentoInicio,
      this.momentoBorradorGuardado,
      this.momentoFinalizacion,
      this.momentoEnvio,
      @required this.cuestionarioId,
      @required this.activoId,
      @required this.esNueva});
  factory Inspeccion.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final doubleType = db.typeSystem.forDartType<double>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final boolType = db.typeSystem.forDartType<bool>();
    return Inspeccion(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      estado: $InspeccionesTable.$converter0.mapToDart(
          intType.mapFromDatabaseResponse(data['${effectivePrefix}estado'])),
      criticidadTotal: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}criticidad_total']),
      criticidadReparacion: doubleType.mapFromDatabaseResponse(
          data['${effectivePrefix}criticidad_reparacion']),
      momentoInicio: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}momento_inicio']),
      momentoBorradorGuardado: dateTimeType.mapFromDatabaseResponse(
          data['${effectivePrefix}momento_borrador_guardado']),
      momentoFinalizacion: dateTimeType.mapFromDatabaseResponse(
          data['${effectivePrefix}momento_finalizacion']),
      momentoEnvio: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}momento_envio']),
      cuestionarioId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}cuestionario_id']),
      activoId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}activo_id']),
      esNueva:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}es_nueva']),
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
      map['criticidad_total'] = Variable<double>(criticidadTotal);
    }
    if (!nullToAbsent || criticidadReparacion != null) {
      map['criticidad_reparacion'] = Variable<double>(criticidadReparacion);
    }
    if (!nullToAbsent || momentoInicio != null) {
      map['momento_inicio'] = Variable<DateTime>(momentoInicio);
    }
    if (!nullToAbsent || momentoBorradorGuardado != null) {
      map['momento_borrador_guardado'] =
          Variable<DateTime>(momentoBorradorGuardado);
    }
    if (!nullToAbsent || momentoFinalizacion != null) {
      map['momento_finalizacion'] = Variable<DateTime>(momentoFinalizacion);
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
    if (!nullToAbsent || esNueva != null) {
      map['es_nueva'] = Variable<bool>(esNueva);
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
      momentoFinalizacion: momentoFinalizacion == null && nullToAbsent
          ? const Value.absent()
          : Value(momentoFinalizacion),
      momentoEnvio: momentoEnvio == null && nullToAbsent
          ? const Value.absent()
          : Value(momentoEnvio),
      cuestionarioId: cuestionarioId == null && nullToAbsent
          ? const Value.absent()
          : Value(cuestionarioId),
      activoId: activoId == null && nullToAbsent
          ? const Value.absent()
          : Value(activoId),
      esNueva: esNueva == null && nullToAbsent
          ? const Value.absent()
          : Value(esNueva),
    );
  }

  factory Inspeccion.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Inspeccion(
      id: serializer.fromJson<int>(json['id']),
      estado: serializer.fromJson<EstadoDeInspeccion>(json['estado']),
      criticidadTotal: serializer.fromJson<double>(json['criticidadTotal']),
      criticidadReparacion:
          serializer.fromJson<double>(json['criticidadReparacion']),
      momentoInicio: serializer.fromJson<DateTime>(json['momentoInicio']),
      momentoBorradorGuardado:
          serializer.fromJson<DateTime>(json['momentoBorradorGuardado']),
      momentoFinalizacion:
          serializer.fromJson<DateTime>(json['momentoFinalizacion']),
      momentoEnvio: serializer.fromJson<DateTime>(json['momentoEnvio']),
      cuestionarioId: serializer.fromJson<int>(json['cuestionario']),
      activoId: serializer.fromJson<int>(json['activo']),
      esNueva: serializer.fromJson<bool>(json['esNueva']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'estado': serializer.toJson<EstadoDeInspeccion>(estado),
      'criticidadTotal': serializer.toJson<double>(criticidadTotal),
      'criticidadReparacion': serializer.toJson<double>(criticidadReparacion),
      'momentoInicio': serializer.toJson<DateTime>(momentoInicio),
      'momentoBorradorGuardado':
          serializer.toJson<DateTime>(momentoBorradorGuardado),
      'momentoFinalizacion': serializer.toJson<DateTime>(momentoFinalizacion),
      'momentoEnvio': serializer.toJson<DateTime>(momentoEnvio),
      'cuestionario': serializer.toJson<int>(cuestionarioId),
      'activo': serializer.toJson<int>(activoId),
      'esNueva': serializer.toJson<bool>(esNueva),
    };
  }

  Inspeccion copyWith(
          {int id,
          EstadoDeInspeccion estado,
          double criticidadTotal,
          double criticidadReparacion,
          DateTime momentoInicio,
          DateTime momentoBorradorGuardado,
          DateTime momentoFinalizacion,
          DateTime momentoEnvio,
          int cuestionarioId,
          int activoId,
          bool esNueva}) =>
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
  bool operator ==(dynamic other) =>
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
  final Value<DateTime> momentoInicio;
  final Value<DateTime> momentoBorradorGuardado;
  final Value<DateTime> momentoFinalizacion;
  final Value<DateTime> momentoEnvio;
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
    @required EstadoDeInspeccion estado,
    @required double criticidadTotal,
    @required double criticidadReparacion,
    this.momentoInicio = const Value.absent(),
    this.momentoBorradorGuardado = const Value.absent(),
    this.momentoFinalizacion = const Value.absent(),
    this.momentoEnvio = const Value.absent(),
    @required int cuestionarioId,
    @required int activoId,
    this.esNueva = const Value.absent(),
  })  : estado = Value(estado),
        criticidadTotal = Value(criticidadTotal),
        criticidadReparacion = Value(criticidadReparacion),
        cuestionarioId = Value(cuestionarioId),
        activoId = Value(activoId);
  static Insertable<Inspeccion> custom({
    Expression<int> id,
    Expression<int> estado,
    Expression<double> criticidadTotal,
    Expression<double> criticidadReparacion,
    Expression<DateTime> momentoInicio,
    Expression<DateTime> momentoBorradorGuardado,
    Expression<DateTime> momentoFinalizacion,
    Expression<DateTime> momentoEnvio,
    Expression<int> cuestionarioId,
    Expression<int> activoId,
    Expression<bool> esNueva,
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
      {Value<int> id,
      Value<EstadoDeInspeccion> estado,
      Value<double> criticidadTotal,
      Value<double> criticidadReparacion,
      Value<DateTime> momentoInicio,
      Value<DateTime> momentoBorradorGuardado,
      Value<DateTime> momentoFinalizacion,
      Value<DateTime> momentoEnvio,
      Value<int> cuestionarioId,
      Value<int> activoId,
      Value<bool> esNueva}) {
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
      map['estado'] = Variable<int>(converter.mapToSql(estado.value));
    }
    if (criticidadTotal.present) {
      map['criticidad_total'] = Variable<double>(criticidadTotal.value);
    }
    if (criticidadReparacion.present) {
      map['criticidad_reparacion'] =
          Variable<double>(criticidadReparacion.value);
    }
    if (momentoInicio.present) {
      map['momento_inicio'] = Variable<DateTime>(momentoInicio.value);
    }
    if (momentoBorradorGuardado.present) {
      map['momento_borrador_guardado'] =
          Variable<DateTime>(momentoBorradorGuardado.value);
    }
    if (momentoFinalizacion.present) {
      map['momento_finalizacion'] =
          Variable<DateTime>(momentoFinalizacion.value);
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
  GeneratedRealColumn _criticidadTotal;
  @override
  GeneratedRealColumn get criticidadTotal =>
      _criticidadTotal ??= _constructCriticidadTotal();
  GeneratedRealColumn _constructCriticidadTotal() {
    return GeneratedRealColumn(
      'criticidad_total',
      $tableName,
      false,
    );
  }

  final VerificationMeta _criticidadReparacionMeta =
      const VerificationMeta('criticidadReparacion');
  GeneratedRealColumn _criticidadReparacion;
  @override
  GeneratedRealColumn get criticidadReparacion =>
      _criticidadReparacion ??= _constructCriticidadReparacion();
  GeneratedRealColumn _constructCriticidadReparacion() {
    return GeneratedRealColumn(
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

  final VerificationMeta _momentoFinalizacionMeta =
      const VerificationMeta('momentoFinalizacion');
  GeneratedDateTimeColumn _momentoFinalizacion;
  @override
  GeneratedDateTimeColumn get momentoFinalizacion =>
      _momentoFinalizacion ??= _constructMomentoFinalizacion();
  GeneratedDateTimeColumn _constructMomentoFinalizacion() {
    return GeneratedDateTimeColumn(
      'momento_finalizacion',
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

  final VerificationMeta _esNuevaMeta = const VerificationMeta('esNueva');
  GeneratedBoolColumn _esNueva;
  @override
  GeneratedBoolColumn get esNueva => _esNueva ??= _constructEsNueva();
  GeneratedBoolColumn _constructEsNueva() {
    return GeneratedBoolColumn(
      'es_nueva',
      $tableName,
      false,
    )..clientDefault = () => true;
  }

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
    if (data.containsKey('momento_finalizacion')) {
      context.handle(
          _momentoFinalizacionMeta,
          momentoFinalizacion.isAcceptableOrUnknown(
              data['momento_finalizacion'], _momentoFinalizacionMeta));
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
    if (data.containsKey('es_nueva')) {
      context.handle(_esNuevaMeta,
          esNueva.isAcceptableOrUnknown(data['es_nueva'], _esNuevaMeta));
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
  final int calificacion;
  final DateTime momentoRespuesta;
  final int inspeccionId;
  final int preguntaId;
  final int opcionDeRespuestaId;
  Respuesta(
      {@required this.id,
      @required this.fotosBase,
      @required this.fotosReparacion,
      @required this.observacion,
      @required this.reparado,
      this.valor,
      @required this.observacionReparacion,
      this.calificacion,
      this.momentoRespuesta,
      @required this.inspeccionId,
      @required this.preguntaId,
      this.opcionDeRespuestaId});
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
      calificacion: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}calificacion']),
      momentoRespuesta: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}momento_respuesta']),
      inspeccionId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}inspeccion_id']),
      preguntaId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}pregunta_id']),
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
    if (!nullToAbsent || calificacion != null) {
      map['calificacion'] = Variable<int>(calificacion);
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
    if (!nullToAbsent || opcionDeRespuestaId != null) {
      map['opcion_de_respuesta_id'] = Variable<int>(opcionDeRespuestaId);
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
      calificacion: calificacion == null && nullToAbsent
          ? const Value.absent()
          : Value(calificacion),
      momentoRespuesta: momentoRespuesta == null && nullToAbsent
          ? const Value.absent()
          : Value(momentoRespuesta),
      inspeccionId: inspeccionId == null && nullToAbsent
          ? const Value.absent()
          : Value(inspeccionId),
      preguntaId: preguntaId == null && nullToAbsent
          ? const Value.absent()
          : Value(preguntaId),
      opcionDeRespuestaId: opcionDeRespuestaId == null && nullToAbsent
          ? const Value.absent()
          : Value(opcionDeRespuestaId),
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
      calificacion: serializer.fromJson<int>(json['calificacion']),
      momentoRespuesta: serializer.fromJson<DateTime>(json['momentoRespuesta']),
      inspeccionId: serializer.fromJson<int>(json['inspeccion']),
      preguntaId: serializer.fromJson<int>(json['pregunta']),
      opcionDeRespuestaId: serializer.fromJson<int>(json['opcionDeRespuesta']),
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
      'calificacion': serializer.toJson<int>(calificacion),
      'momentoRespuesta': serializer.toJson<DateTime>(momentoRespuesta),
      'inspeccion': serializer.toJson<int>(inspeccionId),
      'pregunta': serializer.toJson<int>(preguntaId),
      'opcionDeRespuesta': serializer.toJson<int>(opcionDeRespuestaId),
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
          int calificacion,
          DateTime momentoRespuesta,
          int inspeccionId,
          int preguntaId,
          int opcionDeRespuestaId}) =>
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
  final Value<double> valor;
  final Value<String> observacionReparacion;
  final Value<int> calificacion;
  final Value<DateTime> momentoRespuesta;
  final Value<int> inspeccionId;
  final Value<int> preguntaId;
  final Value<int> opcionDeRespuestaId;
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
    @required int inspeccionId,
    @required int preguntaId,
    this.opcionDeRespuestaId = const Value.absent(),
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
    Expression<int> calificacion,
    Expression<DateTime> momentoRespuesta,
    Expression<int> inspeccionId,
    Expression<int> preguntaId,
    Expression<int> opcionDeRespuestaId,
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
      {Value<int> id,
      Value<KtList<String>> fotosBase,
      Value<KtList<String>> fotosReparacion,
      Value<String> observacion,
      Value<bool> reparado,
      Value<double> valor,
      Value<String> observacionReparacion,
      Value<int> calificacion,
      Value<DateTime> momentoRespuesta,
      Value<int> inspeccionId,
      Value<int> preguntaId,
      Value<int> opcionDeRespuestaId}) {
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
    if (calificacion.present) {
      map['calificacion'] = Variable<int>(calificacion.value);
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
    if (opcionDeRespuestaId.present) {
      map['opcion_de_respuesta_id'] = Variable<int>(opcionDeRespuestaId.value);
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

  final VerificationMeta _calificacionMeta =
      const VerificationMeta('calificacion');
  GeneratedIntColumn _calificacion;
  @override
  GeneratedIntColumn get calificacion =>
      _calificacion ??= _constructCalificacion();
  GeneratedIntColumn _constructCalificacion() {
    return GeneratedIntColumn(
      'calificacion',
      $tableName,
      true,
    );
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

  final VerificationMeta _opcionDeRespuestaIdMeta =
      const VerificationMeta('opcionDeRespuestaId');
  GeneratedIntColumn _opcionDeRespuestaId;
  @override
  GeneratedIntColumn get opcionDeRespuestaId =>
      _opcionDeRespuestaId ??= _constructOpcionDeRespuestaId();
  GeneratedIntColumn _constructOpcionDeRespuestaId() {
    return GeneratedIntColumn('opcion_de_respuesta_id', $tableName, true,
        $customConstraints:
            'REFERENCES opciones_de_respuesta(id) ON DELETE CASCADE');
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
        calificacion,
        momentoRespuesta,
        inspeccionId,
        preguntaId,
        opcionDeRespuestaId
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
    if (data.containsKey('calificacion')) {
      context.handle(
          _calificacionMeta,
          calificacion.isAcceptableOrUnknown(
              data['calificacion'], _calificacionMeta));
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
    if (data.containsKey('opcion_de_respuesta_id')) {
      context.handle(
          _opcionDeRespuestaIdMeta,
          opcionDeRespuestaId.isAcceptableOrUnknown(
              data['opcion_de_respuesta_id'], _opcionDeRespuestaIdMeta));
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
      {@required this.id,
      @required this.nGrupo,
      @required this.inicio,
      @required this.fin,
      @required this.totalGrupos,
      @required this.tipoInspeccion,
      @required this.anio});
  factory GruposInspecciones.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return GruposInspecciones(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      nGrupo:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}n_grupo']),
      inicio: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}inicio']),
      fin: dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}fin']),
      totalGrupos: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}total_grupos']),
      tipoInspeccion: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}tipo_inspeccion']),
      anio: intType.mapFromDatabaseResponse(data['${effectivePrefix}anio']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || nGrupo != null) {
      map['n_grupo'] = Variable<int>(nGrupo);
    }
    if (!nullToAbsent || inicio != null) {
      map['inicio'] = Variable<DateTime>(inicio);
    }
    if (!nullToAbsent || fin != null) {
      map['fin'] = Variable<DateTime>(fin);
    }
    if (!nullToAbsent || totalGrupos != null) {
      map['total_grupos'] = Variable<int>(totalGrupos);
    }
    if (!nullToAbsent || tipoInspeccion != null) {
      map['tipo_inspeccion'] = Variable<int>(tipoInspeccion);
    }
    if (!nullToAbsent || anio != null) {
      map['anio'] = Variable<int>(anio);
    }
    return map;
  }

  GruposInspeccionessCompanion toCompanion(bool nullToAbsent) {
    return GruposInspeccionessCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      nGrupo:
          nGrupo == null && nullToAbsent ? const Value.absent() : Value(nGrupo),
      inicio:
          inicio == null && nullToAbsent ? const Value.absent() : Value(inicio),
      fin: fin == null && nullToAbsent ? const Value.absent() : Value(fin),
      totalGrupos: totalGrupos == null && nullToAbsent
          ? const Value.absent()
          : Value(totalGrupos),
      tipoInspeccion: tipoInspeccion == null && nullToAbsent
          ? const Value.absent()
          : Value(tipoInspeccion),
      anio: anio == null && nullToAbsent ? const Value.absent() : Value(anio),
    );
  }

  factory GruposInspecciones.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
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
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
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
          {int id,
          int nGrupo,
          DateTime inicio,
          DateTime fin,
          int totalGrupos,
          int tipoInspeccion,
          int anio}) =>
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
  bool operator ==(dynamic other) =>
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
    @required int nGrupo,
    @required DateTime inicio,
    @required DateTime fin,
    @required int totalGrupos,
    @required int tipoInspeccion,
    this.anio = const Value.absent(),
  })  : nGrupo = Value(nGrupo),
        inicio = Value(inicio),
        fin = Value(fin),
        totalGrupos = Value(totalGrupos),
        tipoInspeccion = Value(tipoInspeccion);
  static Insertable<GruposInspecciones> custom({
    Expression<int> id,
    Expression<int> nGrupo,
    Expression<DateTime> inicio,
    Expression<DateTime> fin,
    Expression<int> totalGrupos,
    Expression<int> tipoInspeccion,
    Expression<int> anio,
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
      {Value<int> id,
      Value<int> nGrupo,
      Value<DateTime> inicio,
      Value<DateTime> fin,
      Value<int> totalGrupos,
      Value<int> tipoInspeccion,
      Value<int> anio}) {
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
  final String _alias;
  $GruposInspeccionessTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nGrupoMeta = const VerificationMeta('nGrupo');
  GeneratedIntColumn _nGrupo;
  @override
  GeneratedIntColumn get nGrupo => _nGrupo ??= _constructNGrupo();
  GeneratedIntColumn _constructNGrupo() {
    return GeneratedIntColumn(
      'n_grupo',
      $tableName,
      false,
    );
  }

  final VerificationMeta _inicioMeta = const VerificationMeta('inicio');
  GeneratedDateTimeColumn _inicio;
  @override
  GeneratedDateTimeColumn get inicio => _inicio ??= _constructInicio();
  GeneratedDateTimeColumn _constructInicio() {
    return GeneratedDateTimeColumn(
      'inicio',
      $tableName,
      false,
    );
  }

  final VerificationMeta _finMeta = const VerificationMeta('fin');
  GeneratedDateTimeColumn _fin;
  @override
  GeneratedDateTimeColumn get fin => _fin ??= _constructFin();
  GeneratedDateTimeColumn _constructFin() {
    return GeneratedDateTimeColumn(
      'fin',
      $tableName,
      false,
    );
  }

  final VerificationMeta _totalGruposMeta =
      const VerificationMeta('totalGrupos');
  GeneratedIntColumn _totalGrupos;
  @override
  GeneratedIntColumn get totalGrupos =>
      _totalGrupos ??= _constructTotalGrupos();
  GeneratedIntColumn _constructTotalGrupos() {
    return GeneratedIntColumn(
      'total_grupos',
      $tableName,
      false,
    );
  }

  final VerificationMeta _tipoInspeccionMeta =
      const VerificationMeta('tipoInspeccion');
  GeneratedIntColumn _tipoInspeccion;
  @override
  GeneratedIntColumn get tipoInspeccion =>
      _tipoInspeccion ??= _constructTipoInspeccion();
  GeneratedIntColumn _constructTipoInspeccion() {
    return GeneratedIntColumn('tipo_inspeccion', $tableName, false,
        $customConstraints:
            'REFERENCES tipos_de_inspecciones(id) ON DELETE CASCADE');
  }

  final VerificationMeta _anioMeta = const VerificationMeta('anio');
  GeneratedIntColumn _anio;
  @override
  GeneratedIntColumn get anio => _anio ??= _constructAnio();
  GeneratedIntColumn _constructAnio() {
    return GeneratedIntColumn(
      'anio',
      $tableName,
      false,
    )..clientDefault = () => inicio.year as int;
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, nGrupo, inicio, fin, totalGrupos, tipoInspeccion, anio];
  @override
  $GruposInspeccionessTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'grupos_inspeccioness';
  @override
  final String actualTableName = 'grupos_inspeccioness';
  @override
  VerificationContext validateIntegrity(Insertable<GruposInspecciones> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('n_grupo')) {
      context.handle(_nGrupoMeta,
          nGrupo.isAcceptableOrUnknown(data['n_grupo'], _nGrupoMeta));
    } else if (isInserting) {
      context.missing(_nGrupoMeta);
    }
    if (data.containsKey('inicio')) {
      context.handle(_inicioMeta,
          inicio.isAcceptableOrUnknown(data['inicio'], _inicioMeta));
    } else if (isInserting) {
      context.missing(_inicioMeta);
    }
    if (data.containsKey('fin')) {
      context.handle(
          _finMeta, fin.isAcceptableOrUnknown(data['fin'], _finMeta));
    } else if (isInserting) {
      context.missing(_finMeta);
    }
    if (data.containsKey('total_grupos')) {
      context.handle(
          _totalGruposMeta,
          totalGrupos.isAcceptableOrUnknown(
              data['total_grupos'], _totalGruposMeta));
    } else if (isInserting) {
      context.missing(_totalGruposMeta);
    }
    if (data.containsKey('tipo_inspeccion')) {
      context.handle(
          _tipoInspeccionMeta,
          tipoInspeccion.isAcceptableOrUnknown(
              data['tipo_inspeccion'], _tipoInspeccionMeta));
    } else if (isInserting) {
      context.missing(_tipoInspeccionMeta);
    }
    if (data.containsKey('anio')) {
      context.handle(
          _anioMeta, anio.isAcceptableOrUnknown(data['anio'], _anioMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GruposInspecciones map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return GruposInspecciones.fromData(data, _db, prefix: effectivePrefix);
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
      {@required this.id,
      @required this.activoId,
      @required this.grupoId,
      @required this.mes,
      @required this.estado});
  factory ProgramacionSistema.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    return ProgramacionSistema(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      activoId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}activo_id']),
      grupoId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}grupo_id']),
      mes: intType.mapFromDatabaseResponse(data['${effectivePrefix}mes']),
      estado: $ProgramacionSistemasTable.$converter0.mapToDart(
          intType.mapFromDatabaseResponse(data['${effectivePrefix}estado'])),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || activoId != null) {
      map['activo_id'] = Variable<int>(activoId);
    }
    if (!nullToAbsent || grupoId != null) {
      map['grupo_id'] = Variable<int>(grupoId);
    }
    if (!nullToAbsent || mes != null) {
      map['mes'] = Variable<int>(mes);
    }
    if (!nullToAbsent || estado != null) {
      final converter = $ProgramacionSistemasTable.$converter0;
      map['estado'] = Variable<int>(converter.mapToSql(estado));
    }
    return map;
  }

  ProgramacionSistemasCompanion toCompanion(bool nullToAbsent) {
    return ProgramacionSistemasCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      activoId: activoId == null && nullToAbsent
          ? const Value.absent()
          : Value(activoId),
      grupoId: grupoId == null && nullToAbsent
          ? const Value.absent()
          : Value(grupoId),
      mes: mes == null && nullToAbsent ? const Value.absent() : Value(mes),
      estado:
          estado == null && nullToAbsent ? const Value.absent() : Value(estado),
    );
  }

  factory ProgramacionSistema.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
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
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
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
          {int id,
          int activoId,
          int grupoId,
          int mes,
          EstadoProgramacion estado}) =>
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
  bool operator ==(dynamic other) =>
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
    @required int activoId,
    @required int grupoId,
    @required int mes,
    @required EstadoProgramacion estado,
  })  : activoId = Value(activoId),
        grupoId = Value(grupoId),
        mes = Value(mes),
        estado = Value(estado);
  static Insertable<ProgramacionSistema> custom({
    Expression<int> id,
    Expression<int> activoId,
    Expression<int> grupoId,
    Expression<int> mes,
    Expression<int> estado,
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
      {Value<int> id,
      Value<int> activoId,
      Value<int> grupoId,
      Value<int> mes,
      Value<EstadoProgramacion> estado}) {
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
      map['estado'] = Variable<int>(converter.mapToSql(estado.value));
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
  final String _alias;
  $ProgramacionSistemasTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _activoIdMeta = const VerificationMeta('activoId');
  GeneratedIntColumn _activoId;
  @override
  GeneratedIntColumn get activoId => _activoId ??= _constructActivoId();
  GeneratedIntColumn _constructActivoId() {
    return GeneratedIntColumn('activo_id', $tableName, false,
        $customConstraints: 'REFERENCES activos(id) ON DELETE CASCADE');
  }

  final VerificationMeta _grupoIdMeta = const VerificationMeta('grupoId');
  GeneratedIntColumn _grupoId;
  @override
  GeneratedIntColumn get grupoId => _grupoId ??= _constructGrupoId();
  GeneratedIntColumn _constructGrupoId() {
    return GeneratedIntColumn('grupo_id', $tableName, false,
        $customConstraints:
            'REFERENCES grupos_inspeccioness(id) ON DELETE CASCADE');
  }

  final VerificationMeta _mesMeta = const VerificationMeta('mes');
  GeneratedIntColumn _mes;
  @override
  GeneratedIntColumn get mes => _mes ??= _constructMes();
  GeneratedIntColumn _constructMes() {
    return GeneratedIntColumn(
      'mes',
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

  @override
  List<GeneratedColumn> get $columns => [id, activoId, grupoId, mes, estado];
  @override
  $ProgramacionSistemasTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'programacion_sistemas';
  @override
  final String actualTableName = 'programacion_sistemas';
  @override
  VerificationContext validateIntegrity(
      Insertable<ProgramacionSistema> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('activo_id')) {
      context.handle(_activoIdMeta,
          activoId.isAcceptableOrUnknown(data['activo_id'], _activoIdMeta));
    } else if (isInserting) {
      context.missing(_activoIdMeta);
    }
    if (data.containsKey('grupo_id')) {
      context.handle(_grupoIdMeta,
          grupoId.isAcceptableOrUnknown(data['grupo_id'], _grupoIdMeta));
    } else if (isInserting) {
      context.missing(_grupoIdMeta);
    }
    if (data.containsKey('mes')) {
      context.handle(
          _mesMeta, mes.isAcceptableOrUnknown(data['mes'], _mesMeta));
    } else if (isInserting) {
      context.missing(_mesMeta);
    }
    context.handle(_estadoMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProgramacionSistema map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return ProgramacionSistema.fromData(data, _db, prefix: effectivePrefix);
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
      {@required this.id,
      @required this.programacionSistemaId,
      @required this.sistemaId});
  factory ProgramacionSistemasXActivoData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    return ProgramacionSistemasXActivoData(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      programacionSistemaId: intType.mapFromDatabaseResponse(
          data['${effectivePrefix}programacion_sistema_id']),
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
    if (!nullToAbsent || programacionSistemaId != null) {
      map['programacion_sistema_id'] = Variable<int>(programacionSistemaId);
    }
    if (!nullToAbsent || sistemaId != null) {
      map['sistema_id'] = Variable<int>(sistemaId);
    }
    return map;
  }

  ProgramacionSistemasXActivoCompanion toCompanion(bool nullToAbsent) {
    return ProgramacionSistemasXActivoCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      programacionSistemaId: programacionSistemaId == null && nullToAbsent
          ? const Value.absent()
          : Value(programacionSistemaId),
      sistemaId: sistemaId == null && nullToAbsent
          ? const Value.absent()
          : Value(sistemaId),
    );
  }

  factory ProgramacionSistemasXActivoData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return ProgramacionSistemasXActivoData(
      id: serializer.fromJson<int>(json['id']),
      programacionSistemaId:
          serializer.fromJson<int>(json['programacionSistemaId']),
      sistemaId: serializer.fromJson<int>(json['sistema']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'programacionSistemaId': serializer.toJson<int>(programacionSistemaId),
      'sistema': serializer.toJson<int>(sistemaId),
    };
  }

  ProgramacionSistemasXActivoData copyWith(
          {int id, int programacionSistemaId, int sistemaId}) =>
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
  bool operator ==(dynamic other) =>
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
    @required int programacionSistemaId,
    @required int sistemaId,
  })  : programacionSistemaId = Value(programacionSistemaId),
        sistemaId = Value(sistemaId);
  static Insertable<ProgramacionSistemasXActivoData> custom({
    Expression<int> id,
    Expression<int> programacionSistemaId,
    Expression<int> sistemaId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (programacionSistemaId != null)
        'programacion_sistema_id': programacionSistemaId,
      if (sistemaId != null) 'sistema_id': sistemaId,
    });
  }

  ProgramacionSistemasXActivoCompanion copyWith(
      {Value<int> id, Value<int> programacionSistemaId, Value<int> sistemaId}) {
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
  final String _alias;
  $ProgramacionSistemasXActivoTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _programacionSistemaIdMeta =
      const VerificationMeta('programacionSistemaId');
  GeneratedIntColumn _programacionSistemaId;
  @override
  GeneratedIntColumn get programacionSistemaId =>
      _programacionSistemaId ??= _constructProgramacionSistemaId();
  GeneratedIntColumn _constructProgramacionSistemaId() {
    return GeneratedIntColumn('programacion_sistema_id', $tableName, false,
        $customConstraints:
            'REFERENCES programacion_sistemas(id) ON DELETE CASCADE');
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
  List<GeneratedColumn> get $columns => [id, programacionSistemaId, sistemaId];
  @override
  $ProgramacionSistemasXActivoTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'programacion_sistemas_x_activo';
  @override
  final String actualTableName = 'programacion_sistemas_x_activo';
  @override
  VerificationContext validateIntegrity(
      Insertable<ProgramacionSistemasXActivoData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('programacion_sistema_id')) {
      context.handle(
          _programacionSistemaIdMeta,
          programacionSistemaId.isAcceptableOrUnknown(
              data['programacion_sistema_id'], _programacionSistemaIdMeta));
    } else if (isInserting) {
      context.missing(_programacionSistemaIdMeta);
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
  ProgramacionSistemasXActivoData map(Map<String, dynamic> data,
      {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return ProgramacionSistemasXActivoData.fromData(data, _db,
        prefix: effectivePrefix);
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
  TiposDeInspeccione({@required this.id, @required this.tipo});
  factory TiposDeInspeccione.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return TiposDeInspeccione(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      tipo: stringType.mapFromDatabaseResponse(data['${effectivePrefix}tipo']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || tipo != null) {
      map['tipo'] = Variable<String>(tipo);
    }
    return map;
  }

  TiposDeInspeccionesCompanion toCompanion(bool nullToAbsent) {
    return TiposDeInspeccionesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      tipo: tipo == null && nullToAbsent ? const Value.absent() : Value(tipo),
    );
  }

  factory TiposDeInspeccione.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return TiposDeInspeccione(
      id: serializer.fromJson<int>(json['id']),
      tipo: serializer.fromJson<String>(json['tipo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tipo': serializer.toJson<String>(tipo),
    };
  }

  TiposDeInspeccione copyWith({int id, String tipo}) => TiposDeInspeccione(
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
  bool operator ==(dynamic other) =>
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
    @required String tipo,
  }) : tipo = Value(tipo);
  static Insertable<TiposDeInspeccione> custom({
    Expression<int> id,
    Expression<String> tipo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tipo != null) 'tipo': tipo,
    });
  }

  TiposDeInspeccionesCompanion copyWith({Value<int> id, Value<String> tipo}) {
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
  final String _alias;
  $TiposDeInspeccionesTable(this._db, [this._alias]);
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

  final VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  GeneratedTextColumn _tipo;
  @override
  GeneratedTextColumn get tipo => _tipo ??= _constructTipo();
  GeneratedTextColumn _constructTipo() {
    return GeneratedTextColumn(
      'tipo',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, tipo];
  @override
  $TiposDeInspeccionesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'tipos_de_inspecciones';
  @override
  final String actualTableName = 'tipos_de_inspecciones';
  @override
  VerificationContext validateIntegrity(Insertable<TiposDeInspeccione> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('tipo')) {
      context.handle(
          _tipoMeta, tipo.isAcceptableOrUnknown(data['tipo'], _tipoMeta));
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TiposDeInspeccione map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return TiposDeInspeccione.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $TiposDeInspeccionesTable createAlias(String alias) {
    return $TiposDeInspeccionesTable(_db, alias);
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
  $GruposInspeccionessTable _gruposInspeccioness;
  $GruposInspeccionessTable get gruposInspeccioness =>
      _gruposInspeccioness ??= $GruposInspeccionessTable(this);
  $ProgramacionSistemasTable _programacionSistemas;
  $ProgramacionSistemasTable get programacionSistemas =>
      _programacionSistemas ??= $ProgramacionSistemasTable(this);
  $ProgramacionSistemasXActivoTable _programacionSistemasXActivo;
  $ProgramacionSistemasXActivoTable get programacionSistemasXActivo =>
      _programacionSistemasXActivo ??= $ProgramacionSistemasXActivoTable(this);
  $TiposDeInspeccionesTable _tiposDeInspecciones;
  $TiposDeInspeccionesTable get tiposDeInspecciones =>
      _tiposDeInspecciones ??= $TiposDeInspeccionesTable(this);
  LlenadoDao _llenadoDao;
  LlenadoDao get llenadoDao => _llenadoDao ??= LlenadoDao(this as Database);
  CreacionDao _creacionDao;
  CreacionDao get creacionDao => _creacionDao ??= CreacionDao(this as Database);
  BorradoresDao _borradoresDao;
  BorradoresDao get borradoresDao =>
      _borradoresDao ??= BorradoresDao(this as Database);
  PlaneacionDao _planeacionDao;
  PlaneacionDao get planeacionDao =>
      _planeacionDao ??= PlaneacionDao(this as Database);
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
