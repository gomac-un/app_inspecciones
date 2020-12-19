// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Activo extends DataClass implements Insertable<Activo> {
  final String modelo;
  final String identificador;
  Activo({@required this.modelo, @required this.identificador});
  factory Activo.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    return Activo(
      modelo:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}modelo']),
      identificador: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}identificador']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || modelo != null) {
      map['modelo'] = Variable<String>(modelo);
    }
    if (!nullToAbsent || identificador != null) {
      map['identificador'] = Variable<String>(identificador);
    }
    return map;
  }

  ActivosCompanion toCompanion(bool nullToAbsent) {
    return ActivosCompanion(
      modelo:
          modelo == null && nullToAbsent ? const Value.absent() : Value(modelo),
      identificador: identificador == null && nullToAbsent
          ? const Value.absent()
          : Value(identificador),
    );
  }

  factory Activo.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Activo(
      modelo: serializer.fromJson<String>(json['modelo']),
      identificador: serializer.fromJson<String>(json['identificador']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'modelo': serializer.toJson<String>(modelo),
      'identificador': serializer.toJson<String>(identificador),
    };
  }

  Activo copyWith({String modelo, String identificador}) => Activo(
        modelo: modelo ?? this.modelo,
        identificador: identificador ?? this.identificador,
      );
  @override
  String toString() {
    return (StringBuffer('Activo(')
          ..write('modelo: $modelo, ')
          ..write('identificador: $identificador')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(modelo.hashCode, identificador.hashCode));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Activo &&
          other.modelo == this.modelo &&
          other.identificador == this.identificador);
}

class ActivosCompanion extends UpdateCompanion<Activo> {
  final Value<String> modelo;
  final Value<String> identificador;
  const ActivosCompanion({
    this.modelo = const Value.absent(),
    this.identificador = const Value.absent(),
  });
  ActivosCompanion.insert({
    @required String modelo,
    @required String identificador,
  })  : modelo = Value(modelo),
        identificador = Value(identificador);
  static Insertable<Activo> custom({
    Expression<String> modelo,
    Expression<String> identificador,
  }) {
    return RawValuesInsertable({
      if (modelo != null) 'modelo': modelo,
      if (identificador != null) 'identificador': identificador,
    });
  }

  ActivosCompanion copyWith(
      {Value<String> modelo, Value<String> identificador}) {
    return ActivosCompanion(
      modelo: modelo ?? this.modelo,
      identificador: identificador ?? this.identificador,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (modelo.present) {
      map['modelo'] = Variable<String>(modelo.value);
    }
    if (identificador.present) {
      map['identificador'] = Variable<String>(identificador.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivosCompanion(')
          ..write('modelo: $modelo, ')
          ..write('identificador: $identificador')
          ..write(')'))
        .toString();
  }
}

class $ActivosTable extends Activos with TableInfo<$ActivosTable, Activo> {
  final GeneratedDatabase _db;
  final String _alias;
  $ActivosTable(this._db, [this._alias]);
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

  final VerificationMeta _identificadorMeta =
      const VerificationMeta('identificador');
  GeneratedTextColumn _identificador;
  @override
  GeneratedTextColumn get identificador =>
      _identificador ??= _constructIdentificador();
  GeneratedTextColumn _constructIdentificador() {
    return GeneratedTextColumn(
      'identificador',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [modelo, identificador];
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
    if (data.containsKey('modelo')) {
      context.handle(_modeloMeta,
          modelo.isAcceptableOrUnknown(data['modelo'], _modeloMeta));
    } else if (isInserting) {
      context.missing(_modeloMeta);
    }
    if (data.containsKey('identificador')) {
      context.handle(
          _identificadorMeta,
          identificador.isAcceptableOrUnknown(
              data['identificador'], _identificadorMeta));
    } else if (isInserting) {
      context.missing(_identificadorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {identificador};
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
  final String modelo;
  final String tipoDeInspeccion;
  final int periodicidad;
  final int cuestionarioId;
  final int contratistaId;
  CuestionarioDeModelo(
      {@required this.modelo,
      @required this.tipoDeInspeccion,
      @required this.periodicidad,
      @required this.cuestionarioId,
      @required this.contratistaId});
  factory CuestionarioDeModelo.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final intType = db.typeSystem.forDartType<int>();
    return CuestionarioDeModelo(
      modelo:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}modelo']),
      tipoDeInspeccion: stringType.mapFromDatabaseResponse(
          data['${effectivePrefix}tipo_de_inspeccion']),
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
    if (!nullToAbsent || modelo != null) {
      map['modelo'] = Variable<String>(modelo);
    }
    if (!nullToAbsent || tipoDeInspeccion != null) {
      map['tipo_de_inspeccion'] = Variable<String>(tipoDeInspeccion);
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
      modelo:
          modelo == null && nullToAbsent ? const Value.absent() : Value(modelo),
      tipoDeInspeccion: tipoDeInspeccion == null && nullToAbsent
          ? const Value.absent()
          : Value(tipoDeInspeccion),
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
      modelo: serializer.fromJson<String>(json['modelo']),
      tipoDeInspeccion: serializer.fromJson<String>(json['tipoDeInspeccion']),
      periodicidad: serializer.fromJson<int>(json['periodicidad']),
      cuestionarioId: serializer.fromJson<int>(json['cuestionarioId']),
      contratistaId: serializer.fromJson<int>(json['contratistaId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'modelo': serializer.toJson<String>(modelo),
      'tipoDeInspeccion': serializer.toJson<String>(tipoDeInspeccion),
      'periodicidad': serializer.toJson<int>(periodicidad),
      'cuestionarioId': serializer.toJson<int>(cuestionarioId),
      'contratistaId': serializer.toJson<int>(contratistaId),
    };
  }

  CuestionarioDeModelo copyWith(
          {String modelo,
          String tipoDeInspeccion,
          int periodicidad,
          int cuestionarioId,
          int contratistaId}) =>
      CuestionarioDeModelo(
        modelo: modelo ?? this.modelo,
        tipoDeInspeccion: tipoDeInspeccion ?? this.tipoDeInspeccion,
        periodicidad: periodicidad ?? this.periodicidad,
        cuestionarioId: cuestionarioId ?? this.cuestionarioId,
        contratistaId: contratistaId ?? this.contratistaId,
      );
  @override
  String toString() {
    return (StringBuffer('CuestionarioDeModelo(')
          ..write('modelo: $modelo, ')
          ..write('tipoDeInspeccion: $tipoDeInspeccion, ')
          ..write('periodicidad: $periodicidad, ')
          ..write('cuestionarioId: $cuestionarioId, ')
          ..write('contratistaId: $contratistaId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      modelo.hashCode,
      $mrjc(
          tipoDeInspeccion.hashCode,
          $mrjc(periodicidad.hashCode,
              $mrjc(cuestionarioId.hashCode, contratistaId.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is CuestionarioDeModelo &&
          other.modelo == this.modelo &&
          other.tipoDeInspeccion == this.tipoDeInspeccion &&
          other.periodicidad == this.periodicidad &&
          other.cuestionarioId == this.cuestionarioId &&
          other.contratistaId == this.contratistaId);
}

class CuestionarioDeModelosCompanion
    extends UpdateCompanion<CuestionarioDeModelo> {
  final Value<String> modelo;
  final Value<String> tipoDeInspeccion;
  final Value<int> periodicidad;
  final Value<int> cuestionarioId;
  final Value<int> contratistaId;
  const CuestionarioDeModelosCompanion({
    this.modelo = const Value.absent(),
    this.tipoDeInspeccion = const Value.absent(),
    this.periodicidad = const Value.absent(),
    this.cuestionarioId = const Value.absent(),
    this.contratistaId = const Value.absent(),
  });
  CuestionarioDeModelosCompanion.insert({
    @required String modelo,
    @required String tipoDeInspeccion,
    @required int periodicidad,
    @required int cuestionarioId,
    @required int contratistaId,
  })  : modelo = Value(modelo),
        tipoDeInspeccion = Value(tipoDeInspeccion),
        periodicidad = Value(periodicidad),
        cuestionarioId = Value(cuestionarioId),
        contratistaId = Value(contratistaId);
  static Insertable<CuestionarioDeModelo> custom({
    Expression<String> modelo,
    Expression<String> tipoDeInspeccion,
    Expression<int> periodicidad,
    Expression<int> cuestionarioId,
    Expression<int> contratistaId,
  }) {
    return RawValuesInsertable({
      if (modelo != null) 'modelo': modelo,
      if (tipoDeInspeccion != null) 'tipo_de_inspeccion': tipoDeInspeccion,
      if (periodicidad != null) 'periodicidad': periodicidad,
      if (cuestionarioId != null) 'cuestionario_id': cuestionarioId,
      if (contratistaId != null) 'contratista_id': contratistaId,
    });
  }

  CuestionarioDeModelosCompanion copyWith(
      {Value<String> modelo,
      Value<String> tipoDeInspeccion,
      Value<int> periodicidad,
      Value<int> cuestionarioId,
      Value<int> contratistaId}) {
    return CuestionarioDeModelosCompanion(
      modelo: modelo ?? this.modelo,
      tipoDeInspeccion: tipoDeInspeccion ?? this.tipoDeInspeccion,
      periodicidad: periodicidad ?? this.periodicidad,
      cuestionarioId: cuestionarioId ?? this.cuestionarioId,
      contratistaId: contratistaId ?? this.contratistaId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (modelo.present) {
      map['modelo'] = Variable<String>(modelo.value);
    }
    if (tipoDeInspeccion.present) {
      map['tipo_de_inspeccion'] = Variable<String>(tipoDeInspeccion.value);
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
          ..write('modelo: $modelo, ')
          ..write('tipoDeInspeccion: $tipoDeInspeccion, ')
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
    return GeneratedIntColumn('contratista_id', $tableName, false,
        $customConstraints: 'REFERENCES contratistas(id) ON DELETE SET NULL');
  }

  @override
  List<GeneratedColumn> get $columns =>
      [modelo, tipoDeInspeccion, periodicidad, cuestionarioId, contratistaId];
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
    if (data.containsKey('modelo')) {
      context.handle(_modeloMeta,
          modelo.isAcceptableOrUnknown(data['modelo'], _modeloMeta));
    } else if (isInserting) {
      context.missing(_modeloMeta);
    }
    if (data.containsKey('tipo_de_inspeccion')) {
      context.handle(
          _tipoDeInspeccionMeta,
          tipoDeInspeccion.isAcceptableOrUnknown(
              data['tipo_de_inspeccion'], _tipoDeInspeccionMeta));
    } else if (isInserting) {
      context.missing(_tipoDeInspeccionMeta);
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
    } else if (isInserting) {
      context.missing(_contratistaIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {modelo, tipoDeInspeccion};
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
  Cuestionario({@required this.id});
  factory Cuestionario.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    return Cuestionario(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    return map;
  }

  CuestionariosCompanion toCompanion(bool nullToAbsent) {
    return CuestionariosCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
    );
  }

  factory Cuestionario.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Cuestionario(
      id: serializer.fromJson<int>(json['id']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
    };
  }

  Cuestionario copyWith({int id}) => Cuestionario(
        id: id ?? this.id,
      );
  @override
  String toString() {
    return (StringBuffer('Cuestionario(')..write('id: $id')..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf(id.hashCode);
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) || (other is Cuestionario && other.id == this.id);
}

class CuestionariosCompanion extends UpdateCompanion<Cuestionario> {
  final Value<int> id;
  const CuestionariosCompanion({
    this.id = const Value.absent(),
  });
  CuestionariosCompanion.insert({
    this.id = const Value.absent(),
  });
  static Insertable<Cuestionario> custom({
    Expression<int> id,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
    });
  }

  CuestionariosCompanion copyWith({Value<int> id}) {
    return CuestionariosCompanion(
      id: id ?? this.id,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CuestionariosCompanion(')
          ..write('id: $id')
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

  @override
  List<GeneratedColumn> get $columns => [id];
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
}

class Bloque extends DataClass implements Insertable<Bloque> {
  final int id;
  final int cuestionarioId;
  final int nOrden;
  Bloque(
      {@required this.id,
      @required this.cuestionarioId,
      @required this.nOrden});
  factory Bloque.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    return Bloque(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      cuestionarioId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}cuestionario_id']),
      nOrden:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}n_orden']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || cuestionarioId != null) {
      map['cuestionario_id'] = Variable<int>(cuestionarioId);
    }
    if (!nullToAbsent || nOrden != null) {
      map['n_orden'] = Variable<int>(nOrden);
    }
    return map;
  }

  BloquesCompanion toCompanion(bool nullToAbsent) {
    return BloquesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      cuestionarioId: cuestionarioId == null && nullToAbsent
          ? const Value.absent()
          : Value(cuestionarioId),
      nOrden:
          nOrden == null && nullToAbsent ? const Value.absent() : Value(nOrden),
    );
  }

  factory Bloque.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Bloque(
      id: serializer.fromJson<int>(json['id']),
      cuestionarioId: serializer.fromJson<int>(json['cuestionarioId']),
      nOrden: serializer.fromJson<int>(json['nOrden']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cuestionarioId': serializer.toJson<int>(cuestionarioId),
      'nOrden': serializer.toJson<int>(nOrden),
    };
  }

  Bloque copyWith({int id, int cuestionarioId, int nOrden}) => Bloque(
        id: id ?? this.id,
        cuestionarioId: cuestionarioId ?? this.cuestionarioId,
        nOrden: nOrden ?? this.nOrden,
      );
  @override
  String toString() {
    return (StringBuffer('Bloque(')
          ..write('id: $id, ')
          ..write('cuestionarioId: $cuestionarioId, ')
          ..write('nOrden: $nOrden')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf(
      $mrjc(id.hashCode, $mrjc(cuestionarioId.hashCode, nOrden.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Bloque &&
          other.id == this.id &&
          other.cuestionarioId == this.cuestionarioId &&
          other.nOrden == this.nOrden);
}

class BloquesCompanion extends UpdateCompanion<Bloque> {
  final Value<int> id;
  final Value<int> cuestionarioId;
  final Value<int> nOrden;
  const BloquesCompanion({
    this.id = const Value.absent(),
    this.cuestionarioId = const Value.absent(),
    this.nOrden = const Value.absent(),
  });
  BloquesCompanion.insert({
    this.id = const Value.absent(),
    @required int cuestionarioId,
    @required int nOrden,
  })  : cuestionarioId = Value(cuestionarioId),
        nOrden = Value(nOrden);
  static Insertable<Bloque> custom({
    Expression<int> id,
    Expression<int> cuestionarioId,
    Expression<int> nOrden,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cuestionarioId != null) 'cuestionario_id': cuestionarioId,
      if (nOrden != null) 'n_orden': nOrden,
    });
  }

  BloquesCompanion copyWith(
      {Value<int> id, Value<int> cuestionarioId, Value<int> nOrden}) {
    return BloquesCompanion(
      id: id ?? this.id,
      cuestionarioId: cuestionarioId ?? this.cuestionarioId,
      nOrden: nOrden ?? this.nOrden,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cuestionarioId.present) {
      map['cuestionario_id'] = Variable<int>(cuestionarioId.value);
    }
    if (nOrden.present) {
      map['n_orden'] = Variable<int>(nOrden.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BloquesCompanion(')
          ..write('id: $id, ')
          ..write('cuestionarioId: $cuestionarioId, ')
          ..write('nOrden: $nOrden')
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

  @override
  List<GeneratedColumn> get $columns => [id, cuestionarioId, nOrden];
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
    if (data.containsKey('cuestionario_id')) {
      context.handle(
          _cuestionarioIdMeta,
          cuestionarioId.isAcceptableOrUnknown(
              data['cuestionario_id'], _cuestionarioIdMeta));
    } else if (isInserting) {
      context.missing(_cuestionarioIdMeta);
    }
    if (data.containsKey('n_orden')) {
      context.handle(_nOrdenMeta,
          nOrden.isAcceptableOrUnknown(data['n_orden'], _nOrdenMeta));
    } else if (isInserting) {
      context.missing(_nOrdenMeta);
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
  final int bloqueId;
  final String titulo;
  final String descripcion;
  final KtList<String> fotos;
  Titulo(
      {@required this.id,
      @required this.bloqueId,
      @required this.titulo,
      @required this.descripcion,
      @required this.fotos});
  factory Titulo.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Titulo(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      bloqueId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}bloque_id']),
      titulo:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}titulo']),
      descripcion: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}descripcion']),
      fotos: $TitulosTable.$converter0.mapToDart(
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}fotos'])),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || bloqueId != null) {
      map['bloque_id'] = Variable<int>(bloqueId);
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
    return map;
  }

  TitulosCompanion toCompanion(bool nullToAbsent) {
    return TitulosCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      bloqueId: bloqueId == null && nullToAbsent
          ? const Value.absent()
          : Value(bloqueId),
      titulo:
          titulo == null && nullToAbsent ? const Value.absent() : Value(titulo),
      descripcion: descripcion == null && nullToAbsent
          ? const Value.absent()
          : Value(descripcion),
      fotos:
          fotos == null && nullToAbsent ? const Value.absent() : Value(fotos),
    );
  }

  factory Titulo.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Titulo(
      id: serializer.fromJson<int>(json['id']),
      bloqueId: serializer.fromJson<int>(json['bloqueId']),
      titulo: serializer.fromJson<String>(json['titulo']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      fotos: serializer.fromJson<KtList<String>>(json['fotos']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bloqueId': serializer.toJson<int>(bloqueId),
      'titulo': serializer.toJson<String>(titulo),
      'descripcion': serializer.toJson<String>(descripcion),
      'fotos': serializer.toJson<KtList<String>>(fotos),
    };
  }

  Titulo copyWith(
          {int id,
          int bloqueId,
          String titulo,
          String descripcion,
          KtList<String> fotos}) =>
      Titulo(
        id: id ?? this.id,
        bloqueId: bloqueId ?? this.bloqueId,
        titulo: titulo ?? this.titulo,
        descripcion: descripcion ?? this.descripcion,
        fotos: fotos ?? this.fotos,
      );
  @override
  String toString() {
    return (StringBuffer('Titulo(')
          ..write('id: $id, ')
          ..write('bloqueId: $bloqueId, ')
          ..write('titulo: $titulo, ')
          ..write('descripcion: $descripcion, ')
          ..write('fotos: $fotos')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          bloqueId.hashCode,
          $mrjc(
              titulo.hashCode, $mrjc(descripcion.hashCode, fotos.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Titulo &&
          other.id == this.id &&
          other.bloqueId == this.bloqueId &&
          other.titulo == this.titulo &&
          other.descripcion == this.descripcion &&
          other.fotos == this.fotos);
}

class TitulosCompanion extends UpdateCompanion<Titulo> {
  final Value<int> id;
  final Value<int> bloqueId;
  final Value<String> titulo;
  final Value<String> descripcion;
  final Value<KtList<String>> fotos;
  const TitulosCompanion({
    this.id = const Value.absent(),
    this.bloqueId = const Value.absent(),
    this.titulo = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.fotos = const Value.absent(),
  });
  TitulosCompanion.insert({
    this.id = const Value.absent(),
    @required int bloqueId,
    @required String titulo,
    @required String descripcion,
    this.fotos = const Value.absent(),
  })  : bloqueId = Value(bloqueId),
        titulo = Value(titulo),
        descripcion = Value(descripcion);
  static Insertable<Titulo> custom({
    Expression<int> id,
    Expression<int> bloqueId,
    Expression<String> titulo,
    Expression<String> descripcion,
    Expression<String> fotos,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bloqueId != null) 'bloque_id': bloqueId,
      if (titulo != null) 'titulo': titulo,
      if (descripcion != null) 'descripcion': descripcion,
      if (fotos != null) 'fotos': fotos,
    });
  }

  TitulosCompanion copyWith(
      {Value<int> id,
      Value<int> bloqueId,
      Value<String> titulo,
      Value<String> descripcion,
      Value<KtList<String>> fotos}) {
    return TitulosCompanion(
      id: id ?? this.id,
      bloqueId: bloqueId ?? this.bloqueId,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      fotos: fotos ?? this.fotos,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bloqueId.present) {
      map['bloque_id'] = Variable<int>(bloqueId.value);
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TitulosCompanion(')
          ..write('id: $id, ')
          ..write('bloqueId: $bloqueId, ')
          ..write('titulo: $titulo, ')
          ..write('descripcion: $descripcion, ')
          ..write('fotos: $fotos')
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

  final VerificationMeta _bloqueIdMeta = const VerificationMeta('bloqueId');
  GeneratedIntColumn _bloqueId;
  @override
  GeneratedIntColumn get bloqueId => _bloqueId ??= _constructBloqueId();
  GeneratedIntColumn _constructBloqueId() {
    return GeneratedIntColumn('bloque_id', $tableName, false,
        $customConstraints: 'REFERENCES bloques(id) ON DELETE CASCADE');
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
        minTextLength: 0, maxTextLength: 200);
  }

  final VerificationMeta _fotosMeta = const VerificationMeta('fotos');
  GeneratedTextColumn _fotos;
  @override
  GeneratedTextColumn get fotos => _fotos ??= _constructFotos();
  GeneratedTextColumn _constructFotos() {
    return GeneratedTextColumn('fotos', $tableName, false,
        defaultValue: const Constant("[]"));
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, bloqueId, titulo, descripcion, fotos];
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
    if (data.containsKey('bloque_id')) {
      context.handle(_bloqueIdMeta,
          bloqueId.isAcceptableOrUnknown(data['bloque_id'], _bloqueIdMeta));
    } else if (isInserting) {
      context.missing(_bloqueIdMeta);
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
  final int bloqueId;
  final String titulo;
  final String descripcion;
  CuadriculaDePreguntas(
      {@required this.id,
      @required this.bloqueId,
      @required this.titulo,
      @required this.descripcion});
  factory CuadriculaDePreguntas.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return CuadriculaDePreguntas(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      bloqueId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}bloque_id']),
      titulo:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}titulo']),
      descripcion: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}descripcion']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || bloqueId != null) {
      map['bloque_id'] = Variable<int>(bloqueId);
    }
    if (!nullToAbsent || titulo != null) {
      map['titulo'] = Variable<String>(titulo);
    }
    if (!nullToAbsent || descripcion != null) {
      map['descripcion'] = Variable<String>(descripcion);
    }
    return map;
  }

  CuadriculasDePreguntasCompanion toCompanion(bool nullToAbsent) {
    return CuadriculasDePreguntasCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      bloqueId: bloqueId == null && nullToAbsent
          ? const Value.absent()
          : Value(bloqueId),
      titulo:
          titulo == null && nullToAbsent ? const Value.absent() : Value(titulo),
      descripcion: descripcion == null && nullToAbsent
          ? const Value.absent()
          : Value(descripcion),
    );
  }

  factory CuadriculaDePreguntas.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return CuadriculaDePreguntas(
      id: serializer.fromJson<int>(json['id']),
      bloqueId: serializer.fromJson<int>(json['bloqueId']),
      titulo: serializer.fromJson<String>(json['titulo']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bloqueId': serializer.toJson<int>(bloqueId),
      'titulo': serializer.toJson<String>(titulo),
      'descripcion': serializer.toJson<String>(descripcion),
    };
  }

  CuadriculaDePreguntas copyWith(
          {int id, int bloqueId, String titulo, String descripcion}) =>
      CuadriculaDePreguntas(
        id: id ?? this.id,
        bloqueId: bloqueId ?? this.bloqueId,
        titulo: titulo ?? this.titulo,
        descripcion: descripcion ?? this.descripcion,
      );
  @override
  String toString() {
    return (StringBuffer('CuadriculaDePreguntas(')
          ..write('id: $id, ')
          ..write('bloqueId: $bloqueId, ')
          ..write('titulo: $titulo, ')
          ..write('descripcion: $descripcion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(bloqueId.hashCode, $mrjc(titulo.hashCode, descripcion.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is CuadriculaDePreguntas &&
          other.id == this.id &&
          other.bloqueId == this.bloqueId &&
          other.titulo == this.titulo &&
          other.descripcion == this.descripcion);
}

class CuadriculasDePreguntasCompanion
    extends UpdateCompanion<CuadriculaDePreguntas> {
  final Value<int> id;
  final Value<int> bloqueId;
  final Value<String> titulo;
  final Value<String> descripcion;
  const CuadriculasDePreguntasCompanion({
    this.id = const Value.absent(),
    this.bloqueId = const Value.absent(),
    this.titulo = const Value.absent(),
    this.descripcion = const Value.absent(),
  });
  CuadriculasDePreguntasCompanion.insert({
    this.id = const Value.absent(),
    @required int bloqueId,
    @required String titulo,
    @required String descripcion,
  })  : bloqueId = Value(bloqueId),
        titulo = Value(titulo),
        descripcion = Value(descripcion);
  static Insertable<CuadriculaDePreguntas> custom({
    Expression<int> id,
    Expression<int> bloqueId,
    Expression<String> titulo,
    Expression<String> descripcion,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bloqueId != null) 'bloque_id': bloqueId,
      if (titulo != null) 'titulo': titulo,
      if (descripcion != null) 'descripcion': descripcion,
    });
  }

  CuadriculasDePreguntasCompanion copyWith(
      {Value<int> id,
      Value<int> bloqueId,
      Value<String> titulo,
      Value<String> descripcion}) {
    return CuadriculasDePreguntasCompanion(
      id: id ?? this.id,
      bloqueId: bloqueId ?? this.bloqueId,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bloqueId.present) {
      map['bloque_id'] = Variable<int>(bloqueId.value);
    }
    if (titulo.present) {
      map['titulo'] = Variable<String>(titulo.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CuadriculasDePreguntasCompanion(')
          ..write('id: $id, ')
          ..write('bloqueId: $bloqueId, ')
          ..write('titulo: $titulo, ')
          ..write('descripcion: $descripcion')
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

  final VerificationMeta _bloqueIdMeta = const VerificationMeta('bloqueId');
  GeneratedIntColumn _bloqueId;
  @override
  GeneratedIntColumn get bloqueId => _bloqueId ??= _constructBloqueId();
  GeneratedIntColumn _constructBloqueId() {
    return GeneratedIntColumn('bloque_id', $tableName, false,
        $customConstraints: 'REFERENCES bloques(id) ON DELETE CASCADE');
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
        minTextLength: 0, maxTextLength: 200);
  }

  @override
  List<GeneratedColumn> get $columns => [id, bloqueId, titulo, descripcion];
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
    if (data.containsKey('bloque_id')) {
      context.handle(_bloqueIdMeta,
          bloqueId.isAcceptableOrUnknown(data['bloque_id'], _bloqueIdMeta));
    } else if (isInserting) {
      context.missing(_bloqueIdMeta);
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
  final int bloqueId;
  final String titulo;
  final String descripcion;
  final int sistemaId;
  final int subSistemaId;
  final String posicion;
  final KtList<String> fotosGuia;
  final TipoDePregunta tipo;
  final bool parteDeCuadricula;
  final int criticidad;
  Pregunta(
      {@required this.id,
      @required this.bloqueId,
      @required this.titulo,
      @required this.descripcion,
      @required this.sistemaId,
      @required this.subSistemaId,
      @required this.posicion,
      @required this.fotosGuia,
      @required this.tipo,
      @required this.parteDeCuadricula,
      @required this.criticidad});
  factory Pregunta.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    return Pregunta(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      bloqueId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}bloque_id']),
      titulo:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}titulo']),
      descripcion: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}descripcion']),
      sistemaId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}sistema_id']),
      subSistemaId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}sub_sistema_id']),
      posicion: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}posicion']),
      fotosGuia: $PreguntasTable.$converter0.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}fotos_guia'])),
      tipo: $PreguntasTable.$converter1.mapToDart(
          intType.mapFromDatabaseResponse(data['${effectivePrefix}tipo'])),
      parteDeCuadricula: boolType.mapFromDatabaseResponse(
          data['${effectivePrefix}parte_de_cuadricula']),
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
    if (!nullToAbsent || bloqueId != null) {
      map['bloque_id'] = Variable<int>(bloqueId);
    }
    if (!nullToAbsent || titulo != null) {
      map['titulo'] = Variable<String>(titulo);
    }
    if (!nullToAbsent || descripcion != null) {
      map['descripcion'] = Variable<String>(descripcion);
    }
    if (!nullToAbsent || sistemaId != null) {
      map['sistema_id'] = Variable<int>(sistemaId);
    }
    if (!nullToAbsent || subSistemaId != null) {
      map['sub_sistema_id'] = Variable<int>(subSistemaId);
    }
    if (!nullToAbsent || posicion != null) {
      map['posicion'] = Variable<String>(posicion);
    }
    if (!nullToAbsent || fotosGuia != null) {
      final converter = $PreguntasTable.$converter0;
      map['fotos_guia'] = Variable<String>(converter.mapToSql(fotosGuia));
    }
    if (!nullToAbsent || tipo != null) {
      final converter = $PreguntasTable.$converter1;
      map['tipo'] = Variable<int>(converter.mapToSql(tipo));
    }
    if (!nullToAbsent || parteDeCuadricula != null) {
      map['parte_de_cuadricula'] = Variable<bool>(parteDeCuadricula);
    }
    if (!nullToAbsent || criticidad != null) {
      map['criticidad'] = Variable<int>(criticidad);
    }
    return map;
  }

  PreguntasCompanion toCompanion(bool nullToAbsent) {
    return PreguntasCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      bloqueId: bloqueId == null && nullToAbsent
          ? const Value.absent()
          : Value(bloqueId),
      titulo:
          titulo == null && nullToAbsent ? const Value.absent() : Value(titulo),
      descripcion: descripcion == null && nullToAbsent
          ? const Value.absent()
          : Value(descripcion),
      sistemaId: sistemaId == null && nullToAbsent
          ? const Value.absent()
          : Value(sistemaId),
      subSistemaId: subSistemaId == null && nullToAbsent
          ? const Value.absent()
          : Value(subSistemaId),
      posicion: posicion == null && nullToAbsent
          ? const Value.absent()
          : Value(posicion),
      fotosGuia: fotosGuia == null && nullToAbsent
          ? const Value.absent()
          : Value(fotosGuia),
      tipo: tipo == null && nullToAbsent ? const Value.absent() : Value(tipo),
      parteDeCuadricula: parteDeCuadricula == null && nullToAbsent
          ? const Value.absent()
          : Value(parteDeCuadricula),
      criticidad: criticidad == null && nullToAbsent
          ? const Value.absent()
          : Value(criticidad),
    );
  }

  factory Pregunta.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Pregunta(
      id: serializer.fromJson<int>(json['id']),
      bloqueId: serializer.fromJson<int>(json['bloqueId']),
      titulo: serializer.fromJson<String>(json['titulo']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      sistemaId: serializer.fromJson<int>(json['sistemaId']),
      subSistemaId: serializer.fromJson<int>(json['subSistemaId']),
      posicion: serializer.fromJson<String>(json['posicion']),
      fotosGuia: serializer.fromJson<KtList<String>>(json['fotosGuia']),
      tipo: serializer.fromJson<TipoDePregunta>(json['tipo']),
      parteDeCuadricula: serializer.fromJson<bool>(json['parteDeCuadricula']),
      criticidad: serializer.fromJson<int>(json['criticidad']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bloqueId': serializer.toJson<int>(bloqueId),
      'titulo': serializer.toJson<String>(titulo),
      'descripcion': serializer.toJson<String>(descripcion),
      'sistemaId': serializer.toJson<int>(sistemaId),
      'subSistemaId': serializer.toJson<int>(subSistemaId),
      'posicion': serializer.toJson<String>(posicion),
      'fotosGuia': serializer.toJson<KtList<String>>(fotosGuia),
      'tipo': serializer.toJson<TipoDePregunta>(tipo),
      'parteDeCuadricula': serializer.toJson<bool>(parteDeCuadricula),
      'criticidad': serializer.toJson<int>(criticidad),
    };
  }

  Pregunta copyWith(
          {int id,
          int bloqueId,
          String titulo,
          String descripcion,
          int sistemaId,
          int subSistemaId,
          String posicion,
          KtList<String> fotosGuia,
          TipoDePregunta tipo,
          bool parteDeCuadricula,
          int criticidad}) =>
      Pregunta(
        id: id ?? this.id,
        bloqueId: bloqueId ?? this.bloqueId,
        titulo: titulo ?? this.titulo,
        descripcion: descripcion ?? this.descripcion,
        sistemaId: sistemaId ?? this.sistemaId,
        subSistemaId: subSistemaId ?? this.subSistemaId,
        posicion: posicion ?? this.posicion,
        fotosGuia: fotosGuia ?? this.fotosGuia,
        tipo: tipo ?? this.tipo,
        parteDeCuadricula: parteDeCuadricula ?? this.parteDeCuadricula,
        criticidad: criticidad ?? this.criticidad,
      );
  @override
  String toString() {
    return (StringBuffer('Pregunta(')
          ..write('id: $id, ')
          ..write('bloqueId: $bloqueId, ')
          ..write('titulo: $titulo, ')
          ..write('descripcion: $descripcion, ')
          ..write('sistemaId: $sistemaId, ')
          ..write('subSistemaId: $subSistemaId, ')
          ..write('posicion: $posicion, ')
          ..write('fotosGuia: $fotosGuia, ')
          ..write('tipo: $tipo, ')
          ..write('parteDeCuadricula: $parteDeCuadricula, ')
          ..write('criticidad: $criticidad')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          bloqueId.hashCode,
          $mrjc(
              titulo.hashCode,
              $mrjc(
                  descripcion.hashCode,
                  $mrjc(
                      sistemaId.hashCode,
                      $mrjc(
                          subSistemaId.hashCode,
                          $mrjc(
                              posicion.hashCode,
                              $mrjc(
                                  fotosGuia.hashCode,
                                  $mrjc(
                                      tipo.hashCode,
                                      $mrjc(parteDeCuadricula.hashCode,
                                          criticidad.hashCode)))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Pregunta &&
          other.id == this.id &&
          other.bloqueId == this.bloqueId &&
          other.titulo == this.titulo &&
          other.descripcion == this.descripcion &&
          other.sistemaId == this.sistemaId &&
          other.subSistemaId == this.subSistemaId &&
          other.posicion == this.posicion &&
          other.fotosGuia == this.fotosGuia &&
          other.tipo == this.tipo &&
          other.parteDeCuadricula == this.parteDeCuadricula &&
          other.criticidad == this.criticidad);
}

class PreguntasCompanion extends UpdateCompanion<Pregunta> {
  final Value<int> id;
  final Value<int> bloqueId;
  final Value<String> titulo;
  final Value<String> descripcion;
  final Value<int> sistemaId;
  final Value<int> subSistemaId;
  final Value<String> posicion;
  final Value<KtList<String>> fotosGuia;
  final Value<TipoDePregunta> tipo;
  final Value<bool> parteDeCuadricula;
  final Value<int> criticidad;
  const PreguntasCompanion({
    this.id = const Value.absent(),
    this.bloqueId = const Value.absent(),
    this.titulo = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.sistemaId = const Value.absent(),
    this.subSistemaId = const Value.absent(),
    this.posicion = const Value.absent(),
    this.fotosGuia = const Value.absent(),
    this.tipo = const Value.absent(),
    this.parteDeCuadricula = const Value.absent(),
    this.criticidad = const Value.absent(),
  });
  PreguntasCompanion.insert({
    this.id = const Value.absent(),
    @required int bloqueId,
    @required String titulo,
    @required String descripcion,
    @required int sistemaId,
    @required int subSistemaId,
    @required String posicion,
    this.fotosGuia = const Value.absent(),
    @required TipoDePregunta tipo,
    @required bool parteDeCuadricula,
    @required int criticidad,
  })  : bloqueId = Value(bloqueId),
        titulo = Value(titulo),
        descripcion = Value(descripcion),
        sistemaId = Value(sistemaId),
        subSistemaId = Value(subSistemaId),
        posicion = Value(posicion),
        tipo = Value(tipo),
        parteDeCuadricula = Value(parteDeCuadricula),
        criticidad = Value(criticidad);
  static Insertable<Pregunta> custom({
    Expression<int> id,
    Expression<int> bloqueId,
    Expression<String> titulo,
    Expression<String> descripcion,
    Expression<int> sistemaId,
    Expression<int> subSistemaId,
    Expression<String> posicion,
    Expression<String> fotosGuia,
    Expression<int> tipo,
    Expression<bool> parteDeCuadricula,
    Expression<int> criticidad,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bloqueId != null) 'bloque_id': bloqueId,
      if (titulo != null) 'titulo': titulo,
      if (descripcion != null) 'descripcion': descripcion,
      if (sistemaId != null) 'sistema_id': sistemaId,
      if (subSistemaId != null) 'sub_sistema_id': subSistemaId,
      if (posicion != null) 'posicion': posicion,
      if (fotosGuia != null) 'fotos_guia': fotosGuia,
      if (tipo != null) 'tipo': tipo,
      if (parteDeCuadricula != null) 'parte_de_cuadricula': parteDeCuadricula,
      if (criticidad != null) 'criticidad': criticidad,
    });
  }

  PreguntasCompanion copyWith(
      {Value<int> id,
      Value<int> bloqueId,
      Value<String> titulo,
      Value<String> descripcion,
      Value<int> sistemaId,
      Value<int> subSistemaId,
      Value<String> posicion,
      Value<KtList<String>> fotosGuia,
      Value<TipoDePregunta> tipo,
      Value<bool> parteDeCuadricula,
      Value<int> criticidad}) {
    return PreguntasCompanion(
      id: id ?? this.id,
      bloqueId: bloqueId ?? this.bloqueId,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      sistemaId: sistemaId ?? this.sistemaId,
      subSistemaId: subSistemaId ?? this.subSistemaId,
      posicion: posicion ?? this.posicion,
      fotosGuia: fotosGuia ?? this.fotosGuia,
      tipo: tipo ?? this.tipo,
      parteDeCuadricula: parteDeCuadricula ?? this.parteDeCuadricula,
      criticidad: criticidad ?? this.criticidad,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bloqueId.present) {
      map['bloque_id'] = Variable<int>(bloqueId.value);
    }
    if (titulo.present) {
      map['titulo'] = Variable<String>(titulo.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (sistemaId.present) {
      map['sistema_id'] = Variable<int>(sistemaId.value);
    }
    if (subSistemaId.present) {
      map['sub_sistema_id'] = Variable<int>(subSistemaId.value);
    }
    if (posicion.present) {
      map['posicion'] = Variable<String>(posicion.value);
    }
    if (fotosGuia.present) {
      final converter = $PreguntasTable.$converter0;
      map['fotos_guia'] = Variable<String>(converter.mapToSql(fotosGuia.value));
    }
    if (tipo.present) {
      final converter = $PreguntasTable.$converter1;
      map['tipo'] = Variable<int>(converter.mapToSql(tipo.value));
    }
    if (parteDeCuadricula.present) {
      map['parte_de_cuadricula'] = Variable<bool>(parteDeCuadricula.value);
    }
    if (criticidad.present) {
      map['criticidad'] = Variable<int>(criticidad.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreguntasCompanion(')
          ..write('id: $id, ')
          ..write('bloqueId: $bloqueId, ')
          ..write('titulo: $titulo, ')
          ..write('descripcion: $descripcion, ')
          ..write('sistemaId: $sistemaId, ')
          ..write('subSistemaId: $subSistemaId, ')
          ..write('posicion: $posicion, ')
          ..write('fotosGuia: $fotosGuia, ')
          ..write('tipo: $tipo, ')
          ..write('parteDeCuadricula: $parteDeCuadricula, ')
          ..write('criticidad: $criticidad')
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

  final VerificationMeta _bloqueIdMeta = const VerificationMeta('bloqueId');
  GeneratedIntColumn _bloqueId;
  @override
  GeneratedIntColumn get bloqueId => _bloqueId ??= _constructBloqueId();
  GeneratedIntColumn _constructBloqueId() {
    return GeneratedIntColumn('bloque_id', $tableName, false,
        $customConstraints: 'REFERENCES bloques(id) ON DELETE CASCADE');
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
        minTextLength: 0, maxTextLength: 200);
  }

  final VerificationMeta _sistemaIdMeta = const VerificationMeta('sistemaId');
  GeneratedIntColumn _sistemaId;
  @override
  GeneratedIntColumn get sistemaId => _sistemaId ??= _constructSistemaId();
  GeneratedIntColumn _constructSistemaId() {
    return GeneratedIntColumn('sistema_id', $tableName, false,
        $customConstraints: 'REFERENCES sistemas(id)');
  }

  final VerificationMeta _subSistemaIdMeta =
      const VerificationMeta('subSistemaId');
  GeneratedIntColumn _subSistemaId;
  @override
  GeneratedIntColumn get subSistemaId =>
      _subSistemaId ??= _constructSubSistemaId();
  GeneratedIntColumn _constructSubSistemaId() {
    return GeneratedIntColumn('sub_sistema_id', $tableName, false,
        $customConstraints: 'REFERENCES sub_sistemas(id)');
  }

  final VerificationMeta _posicionMeta = const VerificationMeta('posicion');
  GeneratedTextColumn _posicion;
  @override
  GeneratedTextColumn get posicion => _posicion ??= _constructPosicion();
  GeneratedTextColumn _constructPosicion() {
    return GeneratedTextColumn('posicion', $tableName, false,
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

  final VerificationMeta _parteDeCuadriculaMeta =
      const VerificationMeta('parteDeCuadricula');
  GeneratedBoolColumn _parteDeCuadricula;
  @override
  GeneratedBoolColumn get parteDeCuadricula =>
      _parteDeCuadricula ??= _constructParteDeCuadricula();
  GeneratedBoolColumn _constructParteDeCuadricula() {
    return GeneratedBoolColumn(
      'parte_de_cuadricula',
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

  @override
  List<GeneratedColumn> get $columns => [
        id,
        bloqueId,
        titulo,
        descripcion,
        sistemaId,
        subSistemaId,
        posicion,
        fotosGuia,
        tipo,
        parteDeCuadricula,
        criticidad
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
    if (data.containsKey('bloque_id')) {
      context.handle(_bloqueIdMeta,
          bloqueId.isAcceptableOrUnknown(data['bloque_id'], _bloqueIdMeta));
    } else if (isInserting) {
      context.missing(_bloqueIdMeta);
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
    if (data.containsKey('sistema_id')) {
      context.handle(_sistemaIdMeta,
          sistemaId.isAcceptableOrUnknown(data['sistema_id'], _sistemaIdMeta));
    } else if (isInserting) {
      context.missing(_sistemaIdMeta);
    }
    if (data.containsKey('sub_sistema_id')) {
      context.handle(
          _subSistemaIdMeta,
          subSistemaId.isAcceptableOrUnknown(
              data['sub_sistema_id'], _subSistemaIdMeta));
    } else if (isInserting) {
      context.missing(_subSistemaIdMeta);
    }
    if (data.containsKey('posicion')) {
      context.handle(_posicionMeta,
          posicion.isAcceptableOrUnknown(data['posicion'], _posicionMeta));
    } else if (isInserting) {
      context.missing(_posicionMeta);
    }
    context.handle(_fotosGuiaMeta, const VerificationResult.success());
    context.handle(_tipoMeta, const VerificationResult.success());
    if (data.containsKey('parte_de_cuadricula')) {
      context.handle(
          _parteDeCuadriculaMeta,
          parteDeCuadricula.isAcceptableOrUnknown(
              data['parte_de_cuadricula'], _parteDeCuadriculaMeta));
    } else if (isInserting) {
      context.missing(_parteDeCuadriculaMeta);
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
      preguntaId: serializer.fromJson<int>(json['preguntaId']),
      cuadriculaId: serializer.fromJson<int>(json['cuadriculaId']),
      texto: serializer.fromJson<String>(json['texto']),
      criticidad: serializer.fromJson<int>(json['criticidad']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'preguntaId': serializer.toJson<int>(preguntaId),
      'cuadriculaId': serializer.toJson<int>(cuadriculaId),
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
    return GeneratedIntColumn(
      'pregunta_id',
      $tableName,
      true,
    );
  }

  final VerificationMeta _cuadriculaIdMeta =
      const VerificationMeta('cuadriculaId');
  GeneratedIntColumn _cuadriculaId;
  @override
  GeneratedIntColumn get cuadriculaId =>
      _cuadriculaId ??= _constructCuadriculaId();
  GeneratedIntColumn _constructCuadriculaId() {
    return GeneratedIntColumn(
      'cuadricula_id',
      $tableName,
      true,
    );
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
  final int cuestionarioId;
  final String identificadorActivo;
  final DateTime momentoInicio;
  final DateTime momentoBorradorGuardado;
  final DateTime momentoEnvio;
  Inspeccion(
      {@required this.id,
      @required this.estado,
      @required this.cuestionarioId,
      @required this.identificadorActivo,
      this.momentoInicio,
      this.momentoBorradorGuardado,
      this.momentoEnvio});
  factory Inspeccion.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return Inspeccion(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      estado: $InspeccionesTable.$converter0.mapToDart(
          intType.mapFromDatabaseResponse(data['${effectivePrefix}estado'])),
      cuestionarioId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}cuestionario_id']),
      identificadorActivo: stringType.mapFromDatabaseResponse(
          data['${effectivePrefix}identificador_activo']),
      momentoInicio: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}momento_inicio']),
      momentoBorradorGuardado: dateTimeType.mapFromDatabaseResponse(
          data['${effectivePrefix}momento_borrador_guardado']),
      momentoEnvio: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}momento_envio']),
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
    if (!nullToAbsent || cuestionarioId != null) {
      map['cuestionario_id'] = Variable<int>(cuestionarioId);
    }
    if (!nullToAbsent || identificadorActivo != null) {
      map['identificador_activo'] = Variable<String>(identificadorActivo);
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
    return map;
  }

  InspeccionesCompanion toCompanion(bool nullToAbsent) {
    return InspeccionesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      estado:
          estado == null && nullToAbsent ? const Value.absent() : Value(estado),
      cuestionarioId: cuestionarioId == null && nullToAbsent
          ? const Value.absent()
          : Value(cuestionarioId),
      identificadorActivo: identificadorActivo == null && nullToAbsent
          ? const Value.absent()
          : Value(identificadorActivo),
      momentoInicio: momentoInicio == null && nullToAbsent
          ? const Value.absent()
          : Value(momentoInicio),
      momentoBorradorGuardado: momentoBorradorGuardado == null && nullToAbsent
          ? const Value.absent()
          : Value(momentoBorradorGuardado),
      momentoEnvio: momentoEnvio == null && nullToAbsent
          ? const Value.absent()
          : Value(momentoEnvio),
    );
  }

  factory Inspeccion.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Inspeccion(
      id: serializer.fromJson<int>(json['id']),
      estado: serializer.fromJson<EstadoDeInspeccion>(json['estado']),
      cuestionarioId: serializer.fromJson<int>(json['cuestionarioId']),
      identificadorActivo:
          serializer.fromJson<String>(json['identificadorActivo']),
      momentoInicio: serializer.fromJson<DateTime>(json['momentoInicio']),
      momentoBorradorGuardado:
          serializer.fromJson<DateTime>(json['momentoBorradorGuardado']),
      momentoEnvio: serializer.fromJson<DateTime>(json['momentoEnvio']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'estado': serializer.toJson<EstadoDeInspeccion>(estado),
      'cuestionarioId': serializer.toJson<int>(cuestionarioId),
      'identificadorActivo': serializer.toJson<String>(identificadorActivo),
      'momentoInicio': serializer.toJson<DateTime>(momentoInicio),
      'momentoBorradorGuardado':
          serializer.toJson<DateTime>(momentoBorradorGuardado),
      'momentoEnvio': serializer.toJson<DateTime>(momentoEnvio),
    };
  }

  Inspeccion copyWith(
          {int id,
          EstadoDeInspeccion estado,
          int cuestionarioId,
          String identificadorActivo,
          DateTime momentoInicio,
          DateTime momentoBorradorGuardado,
          DateTime momentoEnvio}) =>
      Inspeccion(
        id: id ?? this.id,
        estado: estado ?? this.estado,
        cuestionarioId: cuestionarioId ?? this.cuestionarioId,
        identificadorActivo: identificadorActivo ?? this.identificadorActivo,
        momentoInicio: momentoInicio ?? this.momentoInicio,
        momentoBorradorGuardado:
            momentoBorradorGuardado ?? this.momentoBorradorGuardado,
        momentoEnvio: momentoEnvio ?? this.momentoEnvio,
      );
  @override
  String toString() {
    return (StringBuffer('Inspeccion(')
          ..write('id: $id, ')
          ..write('estado: $estado, ')
          ..write('cuestionarioId: $cuestionarioId, ')
          ..write('identificadorActivo: $identificadorActivo, ')
          ..write('momentoInicio: $momentoInicio, ')
          ..write('momentoBorradorGuardado: $momentoBorradorGuardado, ')
          ..write('momentoEnvio: $momentoEnvio')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          estado.hashCode,
          $mrjc(
              cuestionarioId.hashCode,
              $mrjc(
                  identificadorActivo.hashCode,
                  $mrjc(
                      momentoInicio.hashCode,
                      $mrjc(momentoBorradorGuardado.hashCode,
                          momentoEnvio.hashCode)))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Inspeccion &&
          other.id == this.id &&
          other.estado == this.estado &&
          other.cuestionarioId == this.cuestionarioId &&
          other.identificadorActivo == this.identificadorActivo &&
          other.momentoInicio == this.momentoInicio &&
          other.momentoBorradorGuardado == this.momentoBorradorGuardado &&
          other.momentoEnvio == this.momentoEnvio);
}

class InspeccionesCompanion extends UpdateCompanion<Inspeccion> {
  final Value<int> id;
  final Value<EstadoDeInspeccion> estado;
  final Value<int> cuestionarioId;
  final Value<String> identificadorActivo;
  final Value<DateTime> momentoInicio;
  final Value<DateTime> momentoBorradorGuardado;
  final Value<DateTime> momentoEnvio;
  const InspeccionesCompanion({
    this.id = const Value.absent(),
    this.estado = const Value.absent(),
    this.cuestionarioId = const Value.absent(),
    this.identificadorActivo = const Value.absent(),
    this.momentoInicio = const Value.absent(),
    this.momentoBorradorGuardado = const Value.absent(),
    this.momentoEnvio = const Value.absent(),
  });
  InspeccionesCompanion.insert({
    this.id = const Value.absent(),
    @required EstadoDeInspeccion estado,
    @required int cuestionarioId,
    @required String identificadorActivo,
    this.momentoInicio = const Value.absent(),
    this.momentoBorradorGuardado = const Value.absent(),
    this.momentoEnvio = const Value.absent(),
  })  : estado = Value(estado),
        cuestionarioId = Value(cuestionarioId),
        identificadorActivo = Value(identificadorActivo);
  static Insertable<Inspeccion> custom({
    Expression<int> id,
    Expression<int> estado,
    Expression<int> cuestionarioId,
    Expression<String> identificadorActivo,
    Expression<DateTime> momentoInicio,
    Expression<DateTime> momentoBorradorGuardado,
    Expression<DateTime> momentoEnvio,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (estado != null) 'estado': estado,
      if (cuestionarioId != null) 'cuestionario_id': cuestionarioId,
      if (identificadorActivo != null)
        'identificador_activo': identificadorActivo,
      if (momentoInicio != null) 'momento_inicio': momentoInicio,
      if (momentoBorradorGuardado != null)
        'momento_borrador_guardado': momentoBorradorGuardado,
      if (momentoEnvio != null) 'momento_envio': momentoEnvio,
    });
  }

  InspeccionesCompanion copyWith(
      {Value<int> id,
      Value<EstadoDeInspeccion> estado,
      Value<int> cuestionarioId,
      Value<String> identificadorActivo,
      Value<DateTime> momentoInicio,
      Value<DateTime> momentoBorradorGuardado,
      Value<DateTime> momentoEnvio}) {
    return InspeccionesCompanion(
      id: id ?? this.id,
      estado: estado ?? this.estado,
      cuestionarioId: cuestionarioId ?? this.cuestionarioId,
      identificadorActivo: identificadorActivo ?? this.identificadorActivo,
      momentoInicio: momentoInicio ?? this.momentoInicio,
      momentoBorradorGuardado:
          momentoBorradorGuardado ?? this.momentoBorradorGuardado,
      momentoEnvio: momentoEnvio ?? this.momentoEnvio,
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
    if (cuestionarioId.present) {
      map['cuestionario_id'] = Variable<int>(cuestionarioId.value);
    }
    if (identificadorActivo.present) {
      map['identificador_activo'] = Variable<String>(identificadorActivo.value);
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InspeccionesCompanion(')
          ..write('id: $id, ')
          ..write('estado: $estado, ')
          ..write('cuestionarioId: $cuestionarioId, ')
          ..write('identificadorActivo: $identificadorActivo, ')
          ..write('momentoInicio: $momentoInicio, ')
          ..write('momentoBorradorGuardado: $momentoBorradorGuardado, ')
          ..write('momentoEnvio: $momentoEnvio')
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
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
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

  final VerificationMeta _identificadorActivoMeta =
      const VerificationMeta('identificadorActivo');
  GeneratedTextColumn _identificadorActivo;
  @override
  GeneratedTextColumn get identificadorActivo =>
      _identificadorActivo ??= _constructIdentificadorActivo();
  GeneratedTextColumn _constructIdentificadorActivo() {
    return GeneratedTextColumn('identificador_activo', $tableName, false,
        $customConstraints:
            'REFERENCES activos(identificador) ON DELETE CASCADE');
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

  @override
  List<GeneratedColumn> get $columns => [
        id,
        estado,
        cuestionarioId,
        identificadorActivo,
        momentoInicio,
        momentoBorradorGuardado,
        momentoEnvio
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
    if (data.containsKey('cuestionario_id')) {
      context.handle(
          _cuestionarioIdMeta,
          cuestionarioId.isAcceptableOrUnknown(
              data['cuestionario_id'], _cuestionarioIdMeta));
    } else if (isInserting) {
      context.missing(_cuestionarioIdMeta);
    }
    if (data.containsKey('identificador_activo')) {
      context.handle(
          _identificadorActivoMeta,
          identificadorActivo.isAcceptableOrUnknown(
              data['identificador_activo'], _identificadorActivoMeta));
    } else if (isInserting) {
      context.missing(_identificadorActivoMeta);
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
  final int inspeccionId;
  final int preguntaId;
  final KtList<String> fotosBase;
  final KtList<String> fotosReparacion;
  final String observacion;
  final bool reparado;
  final String observacionReparacion;
  final DateTime momentoRespuesta;
  Respuesta(
      {@required this.id,
      @required this.inspeccionId,
      @required this.preguntaId,
      @required this.fotosBase,
      @required this.fotosReparacion,
      @required this.observacion,
      @required this.reparado,
      @required this.observacionReparacion,
      this.momentoRespuesta});
  factory Respuesta.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return Respuesta(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      inspeccionId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}inspeccion_id']),
      preguntaId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}pregunta_id']),
      fotosBase: $RespuestasTable.$converter0.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}fotos_base'])),
      fotosReparacion: $RespuestasTable.$converter1.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}fotos_reparacion'])),
      observacion: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}observacion']),
      reparado:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}reparado']),
      observacionReparacion: stringType.mapFromDatabaseResponse(
          data['${effectivePrefix}observacion_reparacion']),
      momentoRespuesta: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}momento_respuesta']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || inspeccionId != null) {
      map['inspeccion_id'] = Variable<int>(inspeccionId);
    }
    if (!nullToAbsent || preguntaId != null) {
      map['pregunta_id'] = Variable<int>(preguntaId);
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
    if (!nullToAbsent || observacionReparacion != null) {
      map['observacion_reparacion'] = Variable<String>(observacionReparacion);
    }
    if (!nullToAbsent || momentoRespuesta != null) {
      map['momento_respuesta'] = Variable<DateTime>(momentoRespuesta);
    }
    return map;
  }

  RespuestasCompanion toCompanion(bool nullToAbsent) {
    return RespuestasCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      inspeccionId: inspeccionId == null && nullToAbsent
          ? const Value.absent()
          : Value(inspeccionId),
      preguntaId: preguntaId == null && nullToAbsent
          ? const Value.absent()
          : Value(preguntaId),
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
      observacionReparacion: observacionReparacion == null && nullToAbsent
          ? const Value.absent()
          : Value(observacionReparacion),
      momentoRespuesta: momentoRespuesta == null && nullToAbsent
          ? const Value.absent()
          : Value(momentoRespuesta),
    );
  }

  factory Respuesta.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Respuesta(
      id: serializer.fromJson<int>(json['id']),
      inspeccionId: serializer.fromJson<int>(json['inspeccionId']),
      preguntaId: serializer.fromJson<int>(json['preguntaId']),
      fotosBase: serializer.fromJson<KtList<String>>(json['fotosBase']),
      fotosReparacion:
          serializer.fromJson<KtList<String>>(json['fotosReparacion']),
      observacion: serializer.fromJson<String>(json['observacion']),
      reparado: serializer.fromJson<bool>(json['reparado']),
      observacionReparacion:
          serializer.fromJson<String>(json['observacionReparacion']),
      momentoRespuesta: serializer.fromJson<DateTime>(json['momentoRespuesta']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'inspeccionId': serializer.toJson<int>(inspeccionId),
      'preguntaId': serializer.toJson<int>(preguntaId),
      'fotosBase': serializer.toJson<KtList<String>>(fotosBase),
      'fotosReparacion': serializer.toJson<KtList<String>>(fotosReparacion),
      'observacion': serializer.toJson<String>(observacion),
      'reparado': serializer.toJson<bool>(reparado),
      'observacionReparacion': serializer.toJson<String>(observacionReparacion),
      'momentoRespuesta': serializer.toJson<DateTime>(momentoRespuesta),
    };
  }

  Respuesta copyWith(
          {int id,
          int inspeccionId,
          int preguntaId,
          KtList<String> fotosBase,
          KtList<String> fotosReparacion,
          String observacion,
          bool reparado,
          String observacionReparacion,
          DateTime momentoRespuesta}) =>
      Respuesta(
        id: id ?? this.id,
        inspeccionId: inspeccionId ?? this.inspeccionId,
        preguntaId: preguntaId ?? this.preguntaId,
        fotosBase: fotosBase ?? this.fotosBase,
        fotosReparacion: fotosReparacion ?? this.fotosReparacion,
        observacion: observacion ?? this.observacion,
        reparado: reparado ?? this.reparado,
        observacionReparacion:
            observacionReparacion ?? this.observacionReparacion,
        momentoRespuesta: momentoRespuesta ?? this.momentoRespuesta,
      );
  @override
  String toString() {
    return (StringBuffer('Respuesta(')
          ..write('id: $id, ')
          ..write('inspeccionId: $inspeccionId, ')
          ..write('preguntaId: $preguntaId, ')
          ..write('fotosBase: $fotosBase, ')
          ..write('fotosReparacion: $fotosReparacion, ')
          ..write('observacion: $observacion, ')
          ..write('reparado: $reparado, ')
          ..write('observacionReparacion: $observacionReparacion, ')
          ..write('momentoRespuesta: $momentoRespuesta')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          inspeccionId.hashCode,
          $mrjc(
              preguntaId.hashCode,
              $mrjc(
                  fotosBase.hashCode,
                  $mrjc(
                      fotosReparacion.hashCode,
                      $mrjc(
                          observacion.hashCode,
                          $mrjc(
                              reparado.hashCode,
                              $mrjc(observacionReparacion.hashCode,
                                  momentoRespuesta.hashCode)))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Respuesta &&
          other.id == this.id &&
          other.inspeccionId == this.inspeccionId &&
          other.preguntaId == this.preguntaId &&
          other.fotosBase == this.fotosBase &&
          other.fotosReparacion == this.fotosReparacion &&
          other.observacion == this.observacion &&
          other.reparado == this.reparado &&
          other.observacionReparacion == this.observacionReparacion &&
          other.momentoRespuesta == this.momentoRespuesta);
}

class RespuestasCompanion extends UpdateCompanion<Respuesta> {
  final Value<int> id;
  final Value<int> inspeccionId;
  final Value<int> preguntaId;
  final Value<KtList<String>> fotosBase;
  final Value<KtList<String>> fotosReparacion;
  final Value<String> observacion;
  final Value<bool> reparado;
  final Value<String> observacionReparacion;
  final Value<DateTime> momentoRespuesta;
  const RespuestasCompanion({
    this.id = const Value.absent(),
    this.inspeccionId = const Value.absent(),
    this.preguntaId = const Value.absent(),
    this.fotosBase = const Value.absent(),
    this.fotosReparacion = const Value.absent(),
    this.observacion = const Value.absent(),
    this.reparado = const Value.absent(),
    this.observacionReparacion = const Value.absent(),
    this.momentoRespuesta = const Value.absent(),
  });
  RespuestasCompanion.insert({
    this.id = const Value.absent(),
    @required int inspeccionId,
    @required int preguntaId,
    this.fotosBase = const Value.absent(),
    this.fotosReparacion = const Value.absent(),
    this.observacion = const Value.absent(),
    this.reparado = const Value.absent(),
    this.observacionReparacion = const Value.absent(),
    this.momentoRespuesta = const Value.absent(),
  })  : inspeccionId = Value(inspeccionId),
        preguntaId = Value(preguntaId);
  static Insertable<Respuesta> custom({
    Expression<int> id,
    Expression<int> inspeccionId,
    Expression<int> preguntaId,
    Expression<String> fotosBase,
    Expression<String> fotosReparacion,
    Expression<String> observacion,
    Expression<bool> reparado,
    Expression<String> observacionReparacion,
    Expression<DateTime> momentoRespuesta,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (inspeccionId != null) 'inspeccion_id': inspeccionId,
      if (preguntaId != null) 'pregunta_id': preguntaId,
      if (fotosBase != null) 'fotos_base': fotosBase,
      if (fotosReparacion != null) 'fotos_reparacion': fotosReparacion,
      if (observacion != null) 'observacion': observacion,
      if (reparado != null) 'reparado': reparado,
      if (observacionReparacion != null)
        'observacion_reparacion': observacionReparacion,
      if (momentoRespuesta != null) 'momento_respuesta': momentoRespuesta,
    });
  }

  RespuestasCompanion copyWith(
      {Value<int> id,
      Value<int> inspeccionId,
      Value<int> preguntaId,
      Value<KtList<String>> fotosBase,
      Value<KtList<String>> fotosReparacion,
      Value<String> observacion,
      Value<bool> reparado,
      Value<String> observacionReparacion,
      Value<DateTime> momentoRespuesta}) {
    return RespuestasCompanion(
      id: id ?? this.id,
      inspeccionId: inspeccionId ?? this.inspeccionId,
      preguntaId: preguntaId ?? this.preguntaId,
      fotosBase: fotosBase ?? this.fotosBase,
      fotosReparacion: fotosReparacion ?? this.fotosReparacion,
      observacion: observacion ?? this.observacion,
      reparado: reparado ?? this.reparado,
      observacionReparacion:
          observacionReparacion ?? this.observacionReparacion,
      momentoRespuesta: momentoRespuesta ?? this.momentoRespuesta,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (inspeccionId.present) {
      map['inspeccion_id'] = Variable<int>(inspeccionId.value);
    }
    if (preguntaId.present) {
      map['pregunta_id'] = Variable<int>(preguntaId.value);
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
    if (observacionReparacion.present) {
      map['observacion_reparacion'] =
          Variable<String>(observacionReparacion.value);
    }
    if (momentoRespuesta.present) {
      map['momento_respuesta'] = Variable<DateTime>(momentoRespuesta.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RespuestasCompanion(')
          ..write('id: $id, ')
          ..write('inspeccionId: $inspeccionId, ')
          ..write('preguntaId: $preguntaId, ')
          ..write('fotosBase: $fotosBase, ')
          ..write('fotosReparacion: $fotosReparacion, ')
          ..write('observacion: $observacion, ')
          ..write('reparado: $reparado, ')
          ..write('observacionReparacion: $observacionReparacion, ')
          ..write('momentoRespuesta: $momentoRespuesta')
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

  @override
  List<GeneratedColumn> get $columns => [
        id,
        inspeccionId,
        preguntaId,
        fotosBase,
        fotosReparacion,
        observacion,
        reparado,
        observacionReparacion,
        momentoRespuesta
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
      respuestaId: serializer.fromJson<int>(json['respuestaId']),
      opcionDeRespuestaId:
          serializer.fromJson<int>(json['opcionDeRespuestaId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'respuestaId': serializer.toJson<int>(respuestaId),
      'opcionDeRespuestaId': serializer.toJson<int>(opcionDeRespuestaId),
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
      sistemaId: serializer.fromJson<int>(json['sistemaId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'sistemaId': serializer.toJson<int>(sistemaId),
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
        subSistemas
      ];
}
