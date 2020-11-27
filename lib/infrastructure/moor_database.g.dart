// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpcionDeRespuesta _$OpcionDeRespuestaFromJson(Map<String, dynamic> json) {
  return OpcionDeRespuesta(
    json['texto'] as String,
    json['criticidad'] as int,
  );
}

Map<String, dynamic> _$OpcionDeRespuestaToJson(OpcionDeRespuesta instance) =>
    <String, dynamic>{
      'texto': instance.texto,
      'criticidad': instance.criticidad,
    };

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
        $customConstraints: 'REFERENCES contratistas(id)');
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
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
    );
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
  final String titulo;
  final String descripcion;
  Bloque(
      {@required this.id,
      @required this.cuestionarioId,
      @required this.nOrden,
      @required this.titulo,
      @required this.descripcion});
  factory Bloque.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Bloque(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      cuestionarioId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}cuestionario_id']),
      nOrden:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}n_orden']),
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
    if (!nullToAbsent || cuestionarioId != null) {
      map['cuestionario_id'] = Variable<int>(cuestionarioId);
    }
    if (!nullToAbsent || nOrden != null) {
      map['n_orden'] = Variable<int>(nOrden);
    }
    if (!nullToAbsent || titulo != null) {
      map['titulo'] = Variable<String>(titulo);
    }
    if (!nullToAbsent || descripcion != null) {
      map['descripcion'] = Variable<String>(descripcion);
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
      titulo:
          titulo == null && nullToAbsent ? const Value.absent() : Value(titulo),
      descripcion: descripcion == null && nullToAbsent
          ? const Value.absent()
          : Value(descripcion),
    );
  }

  factory Bloque.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Bloque(
      id: serializer.fromJson<int>(json['id']),
      cuestionarioId: serializer.fromJson<int>(json['cuestionarioId']),
      nOrden: serializer.fromJson<int>(json['nOrden']),
      titulo: serializer.fromJson<String>(json['titulo']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cuestionarioId': serializer.toJson<int>(cuestionarioId),
      'nOrden': serializer.toJson<int>(nOrden),
      'titulo': serializer.toJson<String>(titulo),
      'descripcion': serializer.toJson<String>(descripcion),
    };
  }

  Bloque copyWith(
          {int id,
          int cuestionarioId,
          int nOrden,
          String titulo,
          String descripcion}) =>
      Bloque(
        id: id ?? this.id,
        cuestionarioId: cuestionarioId ?? this.cuestionarioId,
        nOrden: nOrden ?? this.nOrden,
        titulo: titulo ?? this.titulo,
        descripcion: descripcion ?? this.descripcion,
      );
  @override
  String toString() {
    return (StringBuffer('Bloque(')
          ..write('id: $id, ')
          ..write('cuestionarioId: $cuestionarioId, ')
          ..write('nOrden: $nOrden, ')
          ..write('titulo: $titulo, ')
          ..write('descripcion: $descripcion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          cuestionarioId.hashCode,
          $mrjc(
              nOrden.hashCode, $mrjc(titulo.hashCode, descripcion.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Bloque &&
          other.id == this.id &&
          other.cuestionarioId == this.cuestionarioId &&
          other.nOrden == this.nOrden &&
          other.titulo == this.titulo &&
          other.descripcion == this.descripcion);
}

class BloquesCompanion extends UpdateCompanion<Bloque> {
  final Value<int> id;
  final Value<int> cuestionarioId;
  final Value<int> nOrden;
  final Value<String> titulo;
  final Value<String> descripcion;
  const BloquesCompanion({
    this.id = const Value.absent(),
    this.cuestionarioId = const Value.absent(),
    this.nOrden = const Value.absent(),
    this.titulo = const Value.absent(),
    this.descripcion = const Value.absent(),
  });
  BloquesCompanion.insert({
    this.id = const Value.absent(),
    @required int cuestionarioId,
    @required int nOrden,
    @required String titulo,
    @required String descripcion,
  })  : cuestionarioId = Value(cuestionarioId),
        nOrden = Value(nOrden),
        titulo = Value(titulo),
        descripcion = Value(descripcion);
  static Insertable<Bloque> custom({
    Expression<int> id,
    Expression<int> cuestionarioId,
    Expression<int> nOrden,
    Expression<String> titulo,
    Expression<String> descripcion,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cuestionarioId != null) 'cuestionario_id': cuestionarioId,
      if (nOrden != null) 'n_orden': nOrden,
      if (titulo != null) 'titulo': titulo,
      if (descripcion != null) 'descripcion': descripcion,
    });
  }

  BloquesCompanion copyWith(
      {Value<int> id,
      Value<int> cuestionarioId,
      Value<int> nOrden,
      Value<String> titulo,
      Value<String> descripcion}) {
    return BloquesCompanion(
      id: id ?? this.id,
      cuestionarioId: cuestionarioId ?? this.cuestionarioId,
      nOrden: nOrden ?? this.nOrden,
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
    if (cuestionarioId.present) {
      map['cuestionario_id'] = Variable<int>(cuestionarioId.value);
    }
    if (nOrden.present) {
      map['n_orden'] = Variable<int>(nOrden.value);
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
    return (StringBuffer('BloquesCompanion(')
          ..write('id: $id, ')
          ..write('cuestionarioId: $cuestionarioId, ')
          ..write('nOrden: $nOrden, ')
          ..write('titulo: $titulo, ')
          ..write('descripcion: $descripcion')
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
    return GeneratedIntColumn(
      'id',
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

  @override
  List<GeneratedColumn> get $columns =>
      [id, cuestionarioId, nOrden, titulo, descripcion];
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
  Bloque map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Bloque.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $BloquesTable createAlias(String alias) {
    return $BloquesTable(_db, alias);
  }
}

class Pregunta extends DataClass implements Insertable<Pregunta> {
  final int id;
  final int bloqueId;
  final int sistemaId;
  final int subSistemaId;
  final String posicion;
  final List<String> fotosGuia;
  final TipoDePregunta tipo;
  final List<OpcionDeRespuesta> opcionesDeRespuesta;
  final int criticidad;
  Pregunta(
      {@required this.id,
      @required this.bloqueId,
      @required this.sistemaId,
      @required this.subSistemaId,
      @required this.posicion,
      @required this.fotosGuia,
      @required this.tipo,
      @required this.opcionesDeRespuesta,
      @required this.criticidad});
  factory Pregunta.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Pregunta(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      bloqueId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}bloque_id']),
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
      opcionesDeRespuesta: $PreguntasTable.$converter2.mapToDart(
          stringType.mapFromDatabaseResponse(
              data['${effectivePrefix}opciones_de_respuesta'])),
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
    if (!nullToAbsent || opcionesDeRespuesta != null) {
      final converter = $PreguntasTable.$converter2;
      map['opciones_de_respuesta'] =
          Variable<String>(converter.mapToSql(opcionesDeRespuesta));
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
      opcionesDeRespuesta: opcionesDeRespuesta == null && nullToAbsent
          ? const Value.absent()
          : Value(opcionesDeRespuesta),
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
      sistemaId: serializer.fromJson<int>(json['sistemaId']),
      subSistemaId: serializer.fromJson<int>(json['subSistemaId']),
      posicion: serializer.fromJson<String>(json['posicion']),
      fotosGuia: serializer.fromJson<List<String>>(json['fotosGuia']),
      tipo: serializer.fromJson<TipoDePregunta>(json['tipo']),
      opcionesDeRespuesta: serializer
          .fromJson<List<OpcionDeRespuesta>>(json['opcionesDeRespuesta']),
      criticidad: serializer.fromJson<int>(json['criticidad']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bloqueId': serializer.toJson<int>(bloqueId),
      'sistemaId': serializer.toJson<int>(sistemaId),
      'subSistemaId': serializer.toJson<int>(subSistemaId),
      'posicion': serializer.toJson<String>(posicion),
      'fotosGuia': serializer.toJson<List<String>>(fotosGuia),
      'tipo': serializer.toJson<TipoDePregunta>(tipo),
      'opcionesDeRespuesta':
          serializer.toJson<List<OpcionDeRespuesta>>(opcionesDeRespuesta),
      'criticidad': serializer.toJson<int>(criticidad),
    };
  }

  Pregunta copyWith(
          {int id,
          int bloqueId,
          int sistemaId,
          int subSistemaId,
          String posicion,
          List<String> fotosGuia,
          TipoDePregunta tipo,
          List<OpcionDeRespuesta> opcionesDeRespuesta,
          int criticidad}) =>
      Pregunta(
        id: id ?? this.id,
        bloqueId: bloqueId ?? this.bloqueId,
        sistemaId: sistemaId ?? this.sistemaId,
        subSistemaId: subSistemaId ?? this.subSistemaId,
        posicion: posicion ?? this.posicion,
        fotosGuia: fotosGuia ?? this.fotosGuia,
        tipo: tipo ?? this.tipo,
        opcionesDeRespuesta: opcionesDeRespuesta ?? this.opcionesDeRespuesta,
        criticidad: criticidad ?? this.criticidad,
      );
  @override
  String toString() {
    return (StringBuffer('Pregunta(')
          ..write('id: $id, ')
          ..write('bloqueId: $bloqueId, ')
          ..write('sistemaId: $sistemaId, ')
          ..write('subSistemaId: $subSistemaId, ')
          ..write('posicion: $posicion, ')
          ..write('fotosGuia: $fotosGuia, ')
          ..write('tipo: $tipo, ')
          ..write('opcionesDeRespuesta: $opcionesDeRespuesta, ')
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
              sistemaId.hashCode,
              $mrjc(
                  subSistemaId.hashCode,
                  $mrjc(
                      posicion.hashCode,
                      $mrjc(
                          fotosGuia.hashCode,
                          $mrjc(
                              tipo.hashCode,
                              $mrjc(opcionesDeRespuesta.hashCode,
                                  criticidad.hashCode)))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Pregunta &&
          other.id == this.id &&
          other.bloqueId == this.bloqueId &&
          other.sistemaId == this.sistemaId &&
          other.subSistemaId == this.subSistemaId &&
          other.posicion == this.posicion &&
          other.fotosGuia == this.fotosGuia &&
          other.tipo == this.tipo &&
          other.opcionesDeRespuesta == this.opcionesDeRespuesta &&
          other.criticidad == this.criticidad);
}

class PreguntasCompanion extends UpdateCompanion<Pregunta> {
  final Value<int> id;
  final Value<int> bloqueId;
  final Value<int> sistemaId;
  final Value<int> subSistemaId;
  final Value<String> posicion;
  final Value<List<String>> fotosGuia;
  final Value<TipoDePregunta> tipo;
  final Value<List<OpcionDeRespuesta>> opcionesDeRespuesta;
  final Value<int> criticidad;
  const PreguntasCompanion({
    this.id = const Value.absent(),
    this.bloqueId = const Value.absent(),
    this.sistemaId = const Value.absent(),
    this.subSistemaId = const Value.absent(),
    this.posicion = const Value.absent(),
    this.fotosGuia = const Value.absent(),
    this.tipo = const Value.absent(),
    this.opcionesDeRespuesta = const Value.absent(),
    this.criticidad = const Value.absent(),
  });
  PreguntasCompanion.insert({
    this.id = const Value.absent(),
    @required int bloqueId,
    @required int sistemaId,
    @required int subSistemaId,
    @required String posicion,
    this.fotosGuia = const Value.absent(),
    @required TipoDePregunta tipo,
    this.opcionesDeRespuesta = const Value.absent(),
    @required int criticidad,
  })  : bloqueId = Value(bloqueId),
        sistemaId = Value(sistemaId),
        subSistemaId = Value(subSistemaId),
        posicion = Value(posicion),
        tipo = Value(tipo),
        criticidad = Value(criticidad);
  static Insertable<Pregunta> custom({
    Expression<int> id,
    Expression<int> bloqueId,
    Expression<int> sistemaId,
    Expression<int> subSistemaId,
    Expression<String> posicion,
    Expression<String> fotosGuia,
    Expression<int> tipo,
    Expression<String> opcionesDeRespuesta,
    Expression<int> criticidad,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bloqueId != null) 'bloque_id': bloqueId,
      if (sistemaId != null) 'sistema_id': sistemaId,
      if (subSistemaId != null) 'sub_sistema_id': subSistemaId,
      if (posicion != null) 'posicion': posicion,
      if (fotosGuia != null) 'fotos_guia': fotosGuia,
      if (tipo != null) 'tipo': tipo,
      if (opcionesDeRespuesta != null)
        'opciones_de_respuesta': opcionesDeRespuesta,
      if (criticidad != null) 'criticidad': criticidad,
    });
  }

  PreguntasCompanion copyWith(
      {Value<int> id,
      Value<int> bloqueId,
      Value<int> sistemaId,
      Value<int> subSistemaId,
      Value<String> posicion,
      Value<List<String>> fotosGuia,
      Value<TipoDePregunta> tipo,
      Value<List<OpcionDeRespuesta>> opcionesDeRespuesta,
      Value<int> criticidad}) {
    return PreguntasCompanion(
      id: id ?? this.id,
      bloqueId: bloqueId ?? this.bloqueId,
      sistemaId: sistemaId ?? this.sistemaId,
      subSistemaId: subSistemaId ?? this.subSistemaId,
      posicion: posicion ?? this.posicion,
      fotosGuia: fotosGuia ?? this.fotosGuia,
      tipo: tipo ?? this.tipo,
      opcionesDeRespuesta: opcionesDeRespuesta ?? this.opcionesDeRespuesta,
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
    if (opcionesDeRespuesta.present) {
      final converter = $PreguntasTable.$converter2;
      map['opciones_de_respuesta'] =
          Variable<String>(converter.mapToSql(opcionesDeRespuesta.value));
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
          ..write('sistemaId: $sistemaId, ')
          ..write('subSistemaId: $subSistemaId, ')
          ..write('posicion: $posicion, ')
          ..write('fotosGuia: $fotosGuia, ')
          ..write('tipo: $tipo, ')
          ..write('opcionesDeRespuesta: $opcionesDeRespuesta, ')
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
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
    );
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

  final VerificationMeta _opcionesDeRespuestaMeta =
      const VerificationMeta('opcionesDeRespuesta');
  GeneratedTextColumn _opcionesDeRespuesta;
  @override
  GeneratedTextColumn get opcionesDeRespuesta =>
      _opcionesDeRespuesta ??= _constructOpcionesDeRespuesta();
  GeneratedTextColumn _constructOpcionesDeRespuesta() {
    return GeneratedTextColumn('opciones_de_respuesta', $tableName, false,
        defaultValue: const Constant("[]"));
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
        sistemaId,
        subSistemaId,
        posicion,
        fotosGuia,
        tipo,
        opcionesDeRespuesta,
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
    context.handle(
        _opcionesDeRespuestaMeta, const VerificationResult.success());
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

  static TypeConverter<List<String>, String> $converter0 =
      const ListInColumnConverter();
  static TypeConverter<TipoDePregunta, int> $converter1 =
      const EnumIndexConverter<TipoDePregunta>(TipoDePregunta.values);
  static TypeConverter<List<OpcionDeRespuesta>, String> $converter2 =
      const OpcionDeRespuestaConverter();
}

class Inspeccion extends DataClass implements Insertable<Inspeccion> {
  final int id;
  final EstadoDeInspeccion estado;
  final int cuestionarioId;
  final String identificadorActivo;
  final DateTime fechaHoraInicio;
  final DateTime fechaHoraBorradorGuardado;
  final DateTime fechaHoraEnvio;
  Inspeccion(
      {@required this.id,
      @required this.estado,
      @required this.cuestionarioId,
      @required this.identificadorActivo,
      this.fechaHoraInicio,
      this.fechaHoraBorradorGuardado,
      this.fechaHoraEnvio});
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
      fechaHoraInicio: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}fecha_hora_inicio']),
      fechaHoraBorradorGuardado: dateTimeType.mapFromDatabaseResponse(
          data['${effectivePrefix}fecha_hora_borrador_guardado']),
      fechaHoraEnvio: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}fecha_hora_envio']),
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
    if (!nullToAbsent || fechaHoraInicio != null) {
      map['fecha_hora_inicio'] = Variable<DateTime>(fechaHoraInicio);
    }
    if (!nullToAbsent || fechaHoraBorradorGuardado != null) {
      map['fecha_hora_borrador_guardado'] =
          Variable<DateTime>(fechaHoraBorradorGuardado);
    }
    if (!nullToAbsent || fechaHoraEnvio != null) {
      map['fecha_hora_envio'] = Variable<DateTime>(fechaHoraEnvio);
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
      fechaHoraInicio: fechaHoraInicio == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaHoraInicio),
      fechaHoraBorradorGuardado:
          fechaHoraBorradorGuardado == null && nullToAbsent
              ? const Value.absent()
              : Value(fechaHoraBorradorGuardado),
      fechaHoraEnvio: fechaHoraEnvio == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaHoraEnvio),
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
      fechaHoraInicio: serializer.fromJson<DateTime>(json['fechaHoraInicio']),
      fechaHoraBorradorGuardado:
          serializer.fromJson<DateTime>(json['fechaHoraBorradorGuardado']),
      fechaHoraEnvio: serializer.fromJson<DateTime>(json['fechaHoraEnvio']),
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
      'fechaHoraInicio': serializer.toJson<DateTime>(fechaHoraInicio),
      'fechaHoraBorradorGuardado':
          serializer.toJson<DateTime>(fechaHoraBorradorGuardado),
      'fechaHoraEnvio': serializer.toJson<DateTime>(fechaHoraEnvio),
    };
  }

  Inspeccion copyWith(
          {int id,
          EstadoDeInspeccion estado,
          int cuestionarioId,
          String identificadorActivo,
          DateTime fechaHoraInicio,
          DateTime fechaHoraBorradorGuardado,
          DateTime fechaHoraEnvio}) =>
      Inspeccion(
        id: id ?? this.id,
        estado: estado ?? this.estado,
        cuestionarioId: cuestionarioId ?? this.cuestionarioId,
        identificadorActivo: identificadorActivo ?? this.identificadorActivo,
        fechaHoraInicio: fechaHoraInicio ?? this.fechaHoraInicio,
        fechaHoraBorradorGuardado:
            fechaHoraBorradorGuardado ?? this.fechaHoraBorradorGuardado,
        fechaHoraEnvio: fechaHoraEnvio ?? this.fechaHoraEnvio,
      );
  @override
  String toString() {
    return (StringBuffer('Inspeccion(')
          ..write('id: $id, ')
          ..write('estado: $estado, ')
          ..write('cuestionarioId: $cuestionarioId, ')
          ..write('identificadorActivo: $identificadorActivo, ')
          ..write('fechaHoraInicio: $fechaHoraInicio, ')
          ..write('fechaHoraBorradorGuardado: $fechaHoraBorradorGuardado, ')
          ..write('fechaHoraEnvio: $fechaHoraEnvio')
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
                      fechaHoraInicio.hashCode,
                      $mrjc(fechaHoraBorradorGuardado.hashCode,
                          fechaHoraEnvio.hashCode)))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Inspeccion &&
          other.id == this.id &&
          other.estado == this.estado &&
          other.cuestionarioId == this.cuestionarioId &&
          other.identificadorActivo == this.identificadorActivo &&
          other.fechaHoraInicio == this.fechaHoraInicio &&
          other.fechaHoraBorradorGuardado == this.fechaHoraBorradorGuardado &&
          other.fechaHoraEnvio == this.fechaHoraEnvio);
}

class InspeccionesCompanion extends UpdateCompanion<Inspeccion> {
  final Value<int> id;
  final Value<EstadoDeInspeccion> estado;
  final Value<int> cuestionarioId;
  final Value<String> identificadorActivo;
  final Value<DateTime> fechaHoraInicio;
  final Value<DateTime> fechaHoraBorradorGuardado;
  final Value<DateTime> fechaHoraEnvio;
  const InspeccionesCompanion({
    this.id = const Value.absent(),
    this.estado = const Value.absent(),
    this.cuestionarioId = const Value.absent(),
    this.identificadorActivo = const Value.absent(),
    this.fechaHoraInicio = const Value.absent(),
    this.fechaHoraBorradorGuardado = const Value.absent(),
    this.fechaHoraEnvio = const Value.absent(),
  });
  InspeccionesCompanion.insert({
    this.id = const Value.absent(),
    @required EstadoDeInspeccion estado,
    @required int cuestionarioId,
    @required String identificadorActivo,
    this.fechaHoraInicio = const Value.absent(),
    this.fechaHoraBorradorGuardado = const Value.absent(),
    this.fechaHoraEnvio = const Value.absent(),
  })  : estado = Value(estado),
        cuestionarioId = Value(cuestionarioId),
        identificadorActivo = Value(identificadorActivo);
  static Insertable<Inspeccion> custom({
    Expression<int> id,
    Expression<int> estado,
    Expression<int> cuestionarioId,
    Expression<String> identificadorActivo,
    Expression<DateTime> fechaHoraInicio,
    Expression<DateTime> fechaHoraBorradorGuardado,
    Expression<DateTime> fechaHoraEnvio,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (estado != null) 'estado': estado,
      if (cuestionarioId != null) 'cuestionario_id': cuestionarioId,
      if (identificadorActivo != null)
        'identificador_activo': identificadorActivo,
      if (fechaHoraInicio != null) 'fecha_hora_inicio': fechaHoraInicio,
      if (fechaHoraBorradorGuardado != null)
        'fecha_hora_borrador_guardado': fechaHoraBorradorGuardado,
      if (fechaHoraEnvio != null) 'fecha_hora_envio': fechaHoraEnvio,
    });
  }

  InspeccionesCompanion copyWith(
      {Value<int> id,
      Value<EstadoDeInspeccion> estado,
      Value<int> cuestionarioId,
      Value<String> identificadorActivo,
      Value<DateTime> fechaHoraInicio,
      Value<DateTime> fechaHoraBorradorGuardado,
      Value<DateTime> fechaHoraEnvio}) {
    return InspeccionesCompanion(
      id: id ?? this.id,
      estado: estado ?? this.estado,
      cuestionarioId: cuestionarioId ?? this.cuestionarioId,
      identificadorActivo: identificadorActivo ?? this.identificadorActivo,
      fechaHoraInicio: fechaHoraInicio ?? this.fechaHoraInicio,
      fechaHoraBorradorGuardado:
          fechaHoraBorradorGuardado ?? this.fechaHoraBorradorGuardado,
      fechaHoraEnvio: fechaHoraEnvio ?? this.fechaHoraEnvio,
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
    if (fechaHoraInicio.present) {
      map['fecha_hora_inicio'] = Variable<DateTime>(fechaHoraInicio.value);
    }
    if (fechaHoraBorradorGuardado.present) {
      map['fecha_hora_borrador_guardado'] =
          Variable<DateTime>(fechaHoraBorradorGuardado.value);
    }
    if (fechaHoraEnvio.present) {
      map['fecha_hora_envio'] = Variable<DateTime>(fechaHoraEnvio.value);
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
          ..write('fechaHoraInicio: $fechaHoraInicio, ')
          ..write('fechaHoraBorradorGuardado: $fechaHoraBorradorGuardado, ')
          ..write('fechaHoraEnvio: $fechaHoraEnvio')
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
        $customConstraints: 'REFERENCES cuestionarios(id)');
  }

  final VerificationMeta _identificadorActivoMeta =
      const VerificationMeta('identificadorActivo');
  GeneratedTextColumn _identificadorActivo;
  @override
  GeneratedTextColumn get identificadorActivo =>
      _identificadorActivo ??= _constructIdentificadorActivo();
  GeneratedTextColumn _constructIdentificadorActivo() {
    return GeneratedTextColumn('identificador_activo', $tableName, false,
        $customConstraints: 'REFERENCES activos(identificador)');
  }

  final VerificationMeta _fechaHoraInicioMeta =
      const VerificationMeta('fechaHoraInicio');
  GeneratedDateTimeColumn _fechaHoraInicio;
  @override
  GeneratedDateTimeColumn get fechaHoraInicio =>
      _fechaHoraInicio ??= _constructFechaHoraInicio();
  GeneratedDateTimeColumn _constructFechaHoraInicio() {
    return GeneratedDateTimeColumn(
      'fecha_hora_inicio',
      $tableName,
      true,
    );
  }

  final VerificationMeta _fechaHoraBorradorGuardadoMeta =
      const VerificationMeta('fechaHoraBorradorGuardado');
  GeneratedDateTimeColumn _fechaHoraBorradorGuardado;
  @override
  GeneratedDateTimeColumn get fechaHoraBorradorGuardado =>
      _fechaHoraBorradorGuardado ??= _constructFechaHoraBorradorGuardado();
  GeneratedDateTimeColumn _constructFechaHoraBorradorGuardado() {
    return GeneratedDateTimeColumn(
      'fecha_hora_borrador_guardado',
      $tableName,
      true,
    );
  }

  final VerificationMeta _fechaHoraEnvioMeta =
      const VerificationMeta('fechaHoraEnvio');
  GeneratedDateTimeColumn _fechaHoraEnvio;
  @override
  GeneratedDateTimeColumn get fechaHoraEnvio =>
      _fechaHoraEnvio ??= _constructFechaHoraEnvio();
  GeneratedDateTimeColumn _constructFechaHoraEnvio() {
    return GeneratedDateTimeColumn(
      'fecha_hora_envio',
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
        fechaHoraInicio,
        fechaHoraBorradorGuardado,
        fechaHoraEnvio
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
    if (data.containsKey('fecha_hora_inicio')) {
      context.handle(
          _fechaHoraInicioMeta,
          fechaHoraInicio.isAcceptableOrUnknown(
              data['fecha_hora_inicio'], _fechaHoraInicioMeta));
    }
    if (data.containsKey('fecha_hora_borrador_guardado')) {
      context.handle(
          _fechaHoraBorradorGuardadoMeta,
          fechaHoraBorradorGuardado.isAcceptableOrUnknown(
              data['fecha_hora_borrador_guardado'],
              _fechaHoraBorradorGuardadoMeta));
    }
    if (data.containsKey('fecha_hora_envio')) {
      context.handle(
          _fechaHoraEnvioMeta,
          fechaHoraEnvio.isAcceptableOrUnknown(
              data['fecha_hora_envio'], _fechaHoraEnvioMeta));
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
  final List<OpcionDeRespuesta> respuestas;
  final List<String> fotosBase;
  final List<String> fotosReparacion;
  final String observacion;
  final bool novedad;
  final bool reparado;
  final String observacionReparacion;
  final DateTime fechaHoraRespuesta;
  Respuesta(
      {@required this.id,
      @required this.inspeccionId,
      @required this.preguntaId,
      @required this.respuestas,
      @required this.fotosBase,
      @required this.fotosReparacion,
      @required this.observacion,
      @required this.novedad,
      @required this.reparado,
      @required this.observacionReparacion,
      this.fechaHoraRespuesta});
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
      respuestas: $RespuestasTable.$converter0.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}respuestas'])),
      fotosBase: $RespuestasTable.$converter1.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}fotos_base'])),
      fotosReparacion: $RespuestasTable.$converter2.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}fotos_reparacion'])),
      observacion: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}observacion']),
      novedad:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}novedad']),
      reparado:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}reparado']),
      observacionReparacion: stringType.mapFromDatabaseResponse(
          data['${effectivePrefix}observacion_reparacion']),
      fechaHoraRespuesta: dateTimeType.mapFromDatabaseResponse(
          data['${effectivePrefix}fecha_hora_respuesta']),
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
    if (!nullToAbsent || respuestas != null) {
      final converter = $RespuestasTable.$converter0;
      map['respuestas'] = Variable<String>(converter.mapToSql(respuestas));
    }
    if (!nullToAbsent || fotosBase != null) {
      final converter = $RespuestasTable.$converter1;
      map['fotos_base'] = Variable<String>(converter.mapToSql(fotosBase));
    }
    if (!nullToAbsent || fotosReparacion != null) {
      final converter = $RespuestasTable.$converter2;
      map['fotos_reparacion'] =
          Variable<String>(converter.mapToSql(fotosReparacion));
    }
    if (!nullToAbsent || observacion != null) {
      map['observacion'] = Variable<String>(observacion);
    }
    if (!nullToAbsent || novedad != null) {
      map['novedad'] = Variable<bool>(novedad);
    }
    if (!nullToAbsent || reparado != null) {
      map['reparado'] = Variable<bool>(reparado);
    }
    if (!nullToAbsent || observacionReparacion != null) {
      map['observacion_reparacion'] = Variable<String>(observacionReparacion);
    }
    if (!nullToAbsent || fechaHoraRespuesta != null) {
      map['fecha_hora_respuesta'] = Variable<DateTime>(fechaHoraRespuesta);
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
      respuestas: respuestas == null && nullToAbsent
          ? const Value.absent()
          : Value(respuestas),
      fotosBase: fotosBase == null && nullToAbsent
          ? const Value.absent()
          : Value(fotosBase),
      fotosReparacion: fotosReparacion == null && nullToAbsent
          ? const Value.absent()
          : Value(fotosReparacion),
      observacion: observacion == null && nullToAbsent
          ? const Value.absent()
          : Value(observacion),
      novedad: novedad == null && nullToAbsent
          ? const Value.absent()
          : Value(novedad),
      reparado: reparado == null && nullToAbsent
          ? const Value.absent()
          : Value(reparado),
      observacionReparacion: observacionReparacion == null && nullToAbsent
          ? const Value.absent()
          : Value(observacionReparacion),
      fechaHoraRespuesta: fechaHoraRespuesta == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaHoraRespuesta),
    );
  }

  factory Respuesta.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Respuesta(
      id: serializer.fromJson<int>(json['id']),
      inspeccionId: serializer.fromJson<int>(json['inspeccionId']),
      preguntaId: serializer.fromJson<int>(json['preguntaId']),
      respuestas:
          serializer.fromJson<List<OpcionDeRespuesta>>(json['respuestas']),
      fotosBase: serializer.fromJson<List<String>>(json['fotosBase']),
      fotosReparacion:
          serializer.fromJson<List<String>>(json['fotosReparacion']),
      observacion: serializer.fromJson<String>(json['observacion']),
      novedad: serializer.fromJson<bool>(json['novedad']),
      reparado: serializer.fromJson<bool>(json['reparado']),
      observacionReparacion:
          serializer.fromJson<String>(json['observacionReparacion']),
      fechaHoraRespuesta:
          serializer.fromJson<DateTime>(json['fechaHoraRespuesta']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'inspeccionId': serializer.toJson<int>(inspeccionId),
      'preguntaId': serializer.toJson<int>(preguntaId),
      'respuestas': serializer.toJson<List<OpcionDeRespuesta>>(respuestas),
      'fotosBase': serializer.toJson<List<String>>(fotosBase),
      'fotosReparacion': serializer.toJson<List<String>>(fotosReparacion),
      'observacion': serializer.toJson<String>(observacion),
      'novedad': serializer.toJson<bool>(novedad),
      'reparado': serializer.toJson<bool>(reparado),
      'observacionReparacion': serializer.toJson<String>(observacionReparacion),
      'fechaHoraRespuesta': serializer.toJson<DateTime>(fechaHoraRespuesta),
    };
  }

  Respuesta copyWith(
          {int id,
          int inspeccionId,
          int preguntaId,
          List<OpcionDeRespuesta> respuestas,
          List<String> fotosBase,
          List<String> fotosReparacion,
          String observacion,
          bool novedad,
          bool reparado,
          String observacionReparacion,
          DateTime fechaHoraRespuesta}) =>
      Respuesta(
        id: id ?? this.id,
        inspeccionId: inspeccionId ?? this.inspeccionId,
        preguntaId: preguntaId ?? this.preguntaId,
        respuestas: respuestas ?? this.respuestas,
        fotosBase: fotosBase ?? this.fotosBase,
        fotosReparacion: fotosReparacion ?? this.fotosReparacion,
        observacion: observacion ?? this.observacion,
        novedad: novedad ?? this.novedad,
        reparado: reparado ?? this.reparado,
        observacionReparacion:
            observacionReparacion ?? this.observacionReparacion,
        fechaHoraRespuesta: fechaHoraRespuesta ?? this.fechaHoraRespuesta,
      );
  @override
  String toString() {
    return (StringBuffer('Respuesta(')
          ..write('id: $id, ')
          ..write('inspeccionId: $inspeccionId, ')
          ..write('preguntaId: $preguntaId, ')
          ..write('respuestas: $respuestas, ')
          ..write('fotosBase: $fotosBase, ')
          ..write('fotosReparacion: $fotosReparacion, ')
          ..write('observacion: $observacion, ')
          ..write('novedad: $novedad, ')
          ..write('reparado: $reparado, ')
          ..write('observacionReparacion: $observacionReparacion, ')
          ..write('fechaHoraRespuesta: $fechaHoraRespuesta')
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
                  respuestas.hashCode,
                  $mrjc(
                      fotosBase.hashCode,
                      $mrjc(
                          fotosReparacion.hashCode,
                          $mrjc(
                              observacion.hashCode,
                              $mrjc(
                                  novedad.hashCode,
                                  $mrjc(
                                      reparado.hashCode,
                                      $mrjc(
                                          observacionReparacion.hashCode,
                                          fechaHoraRespuesta
                                              .hashCode)))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Respuesta &&
          other.id == this.id &&
          other.inspeccionId == this.inspeccionId &&
          other.preguntaId == this.preguntaId &&
          other.respuestas == this.respuestas &&
          other.fotosBase == this.fotosBase &&
          other.fotosReparacion == this.fotosReparacion &&
          other.observacion == this.observacion &&
          other.novedad == this.novedad &&
          other.reparado == this.reparado &&
          other.observacionReparacion == this.observacionReparacion &&
          other.fechaHoraRespuesta == this.fechaHoraRespuesta);
}

class RespuestasCompanion extends UpdateCompanion<Respuesta> {
  final Value<int> id;
  final Value<int> inspeccionId;
  final Value<int> preguntaId;
  final Value<List<OpcionDeRespuesta>> respuestas;
  final Value<List<String>> fotosBase;
  final Value<List<String>> fotosReparacion;
  final Value<String> observacion;
  final Value<bool> novedad;
  final Value<bool> reparado;
  final Value<String> observacionReparacion;
  final Value<DateTime> fechaHoraRespuesta;
  const RespuestasCompanion({
    this.id = const Value.absent(),
    this.inspeccionId = const Value.absent(),
    this.preguntaId = const Value.absent(),
    this.respuestas = const Value.absent(),
    this.fotosBase = const Value.absent(),
    this.fotosReparacion = const Value.absent(),
    this.observacion = const Value.absent(),
    this.novedad = const Value.absent(),
    this.reparado = const Value.absent(),
    this.observacionReparacion = const Value.absent(),
    this.fechaHoraRespuesta = const Value.absent(),
  });
  RespuestasCompanion.insert({
    this.id = const Value.absent(),
    @required int inspeccionId,
    @required int preguntaId,
    this.respuestas = const Value.absent(),
    this.fotosBase = const Value.absent(),
    this.fotosReparacion = const Value.absent(),
    this.observacion = const Value.absent(),
    this.novedad = const Value.absent(),
    this.reparado = const Value.absent(),
    this.observacionReparacion = const Value.absent(),
    this.fechaHoraRespuesta = const Value.absent(),
  })  : inspeccionId = Value(inspeccionId),
        preguntaId = Value(preguntaId);
  static Insertable<Respuesta> custom({
    Expression<int> id,
    Expression<int> inspeccionId,
    Expression<int> preguntaId,
    Expression<String> respuestas,
    Expression<String> fotosBase,
    Expression<String> fotosReparacion,
    Expression<String> observacion,
    Expression<bool> novedad,
    Expression<bool> reparado,
    Expression<String> observacionReparacion,
    Expression<DateTime> fechaHoraRespuesta,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (inspeccionId != null) 'inspeccion_id': inspeccionId,
      if (preguntaId != null) 'pregunta_id': preguntaId,
      if (respuestas != null) 'respuestas': respuestas,
      if (fotosBase != null) 'fotos_base': fotosBase,
      if (fotosReparacion != null) 'fotos_reparacion': fotosReparacion,
      if (observacion != null) 'observacion': observacion,
      if (novedad != null) 'novedad': novedad,
      if (reparado != null) 'reparado': reparado,
      if (observacionReparacion != null)
        'observacion_reparacion': observacionReparacion,
      if (fechaHoraRespuesta != null)
        'fecha_hora_respuesta': fechaHoraRespuesta,
    });
  }

  RespuestasCompanion copyWith(
      {Value<int> id,
      Value<int> inspeccionId,
      Value<int> preguntaId,
      Value<List<OpcionDeRespuesta>> respuestas,
      Value<List<String>> fotosBase,
      Value<List<String>> fotosReparacion,
      Value<String> observacion,
      Value<bool> novedad,
      Value<bool> reparado,
      Value<String> observacionReparacion,
      Value<DateTime> fechaHoraRespuesta}) {
    return RespuestasCompanion(
      id: id ?? this.id,
      inspeccionId: inspeccionId ?? this.inspeccionId,
      preguntaId: preguntaId ?? this.preguntaId,
      respuestas: respuestas ?? this.respuestas,
      fotosBase: fotosBase ?? this.fotosBase,
      fotosReparacion: fotosReparacion ?? this.fotosReparacion,
      observacion: observacion ?? this.observacion,
      novedad: novedad ?? this.novedad,
      reparado: reparado ?? this.reparado,
      observacionReparacion:
          observacionReparacion ?? this.observacionReparacion,
      fechaHoraRespuesta: fechaHoraRespuesta ?? this.fechaHoraRespuesta,
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
    if (respuestas.present) {
      final converter = $RespuestasTable.$converter0;
      map['respuestas'] =
          Variable<String>(converter.mapToSql(respuestas.value));
    }
    if (fotosBase.present) {
      final converter = $RespuestasTable.$converter1;
      map['fotos_base'] = Variable<String>(converter.mapToSql(fotosBase.value));
    }
    if (fotosReparacion.present) {
      final converter = $RespuestasTable.$converter2;
      map['fotos_reparacion'] =
          Variable<String>(converter.mapToSql(fotosReparacion.value));
    }
    if (observacion.present) {
      map['observacion'] = Variable<String>(observacion.value);
    }
    if (novedad.present) {
      map['novedad'] = Variable<bool>(novedad.value);
    }
    if (reparado.present) {
      map['reparado'] = Variable<bool>(reparado.value);
    }
    if (observacionReparacion.present) {
      map['observacion_reparacion'] =
          Variable<String>(observacionReparacion.value);
    }
    if (fechaHoraRespuesta.present) {
      map['fecha_hora_respuesta'] =
          Variable<DateTime>(fechaHoraRespuesta.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RespuestasCompanion(')
          ..write('id: $id, ')
          ..write('inspeccionId: $inspeccionId, ')
          ..write('preguntaId: $preguntaId, ')
          ..write('respuestas: $respuestas, ')
          ..write('fotosBase: $fotosBase, ')
          ..write('fotosReparacion: $fotosReparacion, ')
          ..write('observacion: $observacion, ')
          ..write('novedad: $novedad, ')
          ..write('reparado: $reparado, ')
          ..write('observacionReparacion: $observacionReparacion, ')
          ..write('fechaHoraRespuesta: $fechaHoraRespuesta')
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
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
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
        $customConstraints: 'REFERENCES preguntas(id)');
  }

  final VerificationMeta _respuestasMeta = const VerificationMeta('respuestas');
  GeneratedTextColumn _respuestas;
  @override
  GeneratedTextColumn get respuestas => _respuestas ??= _constructRespuestas();
  GeneratedTextColumn _constructRespuestas() {
    return GeneratedTextColumn('respuestas', $tableName, false,
        defaultValue: const Constant("[]"));
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

  final VerificationMeta _novedadMeta = const VerificationMeta('novedad');
  GeneratedBoolColumn _novedad;
  @override
  GeneratedBoolColumn get novedad => _novedad ??= _constructNovedad();
  GeneratedBoolColumn _constructNovedad() {
    return GeneratedBoolColumn('novedad', $tableName, false,
        defaultValue: const Constant(false));
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

  final VerificationMeta _fechaHoraRespuestaMeta =
      const VerificationMeta('fechaHoraRespuesta');
  GeneratedDateTimeColumn _fechaHoraRespuesta;
  @override
  GeneratedDateTimeColumn get fechaHoraRespuesta =>
      _fechaHoraRespuesta ??= _constructFechaHoraRespuesta();
  GeneratedDateTimeColumn _constructFechaHoraRespuesta() {
    return GeneratedDateTimeColumn(
      'fecha_hora_respuesta',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        inspeccionId,
        preguntaId,
        respuestas,
        fotosBase,
        fotosReparacion,
        observacion,
        novedad,
        reparado,
        observacionReparacion,
        fechaHoraRespuesta
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
    context.handle(_respuestasMeta, const VerificationResult.success());
    context.handle(_fotosBaseMeta, const VerificationResult.success());
    context.handle(_fotosReparacionMeta, const VerificationResult.success());
    if (data.containsKey('observacion')) {
      context.handle(
          _observacionMeta,
          observacion.isAcceptableOrUnknown(
              data['observacion'], _observacionMeta));
    }
    if (data.containsKey('novedad')) {
      context.handle(_novedadMeta,
          novedad.isAcceptableOrUnknown(data['novedad'], _novedadMeta));
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
    if (data.containsKey('fecha_hora_respuesta')) {
      context.handle(
          _fechaHoraRespuestaMeta,
          fechaHoraRespuesta.isAcceptableOrUnknown(
              data['fecha_hora_respuesta'], _fechaHoraRespuestaMeta));
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

  static TypeConverter<List<OpcionDeRespuesta>, String> $converter0 =
      const OpcionDeRespuestaConverter();
  static TypeConverter<List<String>, String> $converter1 =
      const ListInColumnConverter();
  static TypeConverter<List<String>, String> $converter2 =
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
  $PreguntasTable _preguntas;
  $PreguntasTable get preguntas => _preguntas ??= $PreguntasTable(this);
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
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        activos,
        cuestionarioDeModelos,
        cuestionarios,
        bloques,
        preguntas,
        inspecciones,
        respuestas,
        contratistas,
        sistemas,
        subSistemas
      ];
}
