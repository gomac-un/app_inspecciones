part of 'moor_database.dart';

class Activos extends Table {
  TextColumn get modelo => text()();

  TextColumn get identificador => text()();

  @override
  Set<Column> get primaryKey => {identificador};
}

class CuestionarioDeModelos extends Table {
  TextColumn get modelo => text()();

  TextColumn get tipoDeInspeccion => text()();

  IntColumn get periodicidad => integer()();

  IntColumn get cuestionarioId => integer()
      .customConstraint('REFERENCES cuestionarios(id) ON DELETE CASCADE')();

  IntColumn get contratistaId =>
      integer().customConstraint('REFERENCES contratistas(id)')();

  @override
  Set<Column> get primaryKey => {modelo, tipoDeInspeccion};
}

class Cuestionarios extends Table {
  IntColumn get id => integer()();
  @override
  Set<Column> get primaryKey => {id};
}

class Bloques extends Table {
  IntColumn get id => integer()();

  IntColumn get cuestionarioId => integer()
      .customConstraint('REFERENCES cuestionarios(id) ON DELETE CASCADE')();

  IntColumn get nOrden => integer()();

  TextColumn get titulo => text().withLength(min: 1, max: 100)();

  TextColumn get descripcion => text().withLength(min: 0, max: 200)();

  @override
  Set<Column> get primaryKey => {id};
}

class Preguntas extends Table {
  IntColumn get id => integer()();

  IntColumn get bloqueId =>
      integer().customConstraint('REFERENCES bloques(id) ON DELETE CASCADE')();

  IntColumn get sistemaId =>
      integer().customConstraint('REFERENCES sistemas(id)')();

  IntColumn get subSistemaId =>
      integer().customConstraint('REFERENCES sub_sistemas(id)')();

  TextColumn get posicion => text().withLength(min: 0, max: 50)();

  TextColumn get fotosGuia => text()
      .map(const ListInColumnConverter())
      .withDefault(const Constant("[]"))();

  IntColumn get tipo => intEnum<TipoDePregunta>()();

  TextColumn get opcionesDeRespuesta => text()
      .map(const OpcionDeRespuestaConverter())
      .withDefault(const Constant("[]"))();

  IntColumn get criticidad => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@j.JsonSerializable()
class OpcionDeRespuesta {
  String texto;
  int criticidad;

  OpcionDeRespuesta(this.texto, this.criticidad);

  factory OpcionDeRespuesta.fromJson(Map<String, dynamic> json) =>
      _$OpcionDeRespuestaFromJson(json);

  Map<String, dynamic> toJson() => _$OpcionDeRespuestaToJson(this);
}

@DataClassName('Inspeccion')
class Inspecciones extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get estado => intEnum<EstadoDeInspeccion>()();

  IntColumn get cuestionarioId =>
      integer().customConstraint('REFERENCES cuestionarios(id)')();

  TextColumn get identificadorActivo =>
      text().customConstraint('REFERENCES activos(identificador)')();

  DateTimeColumn get fechaHoraInicio => dateTime().nullable()();

  DateTimeColumn get fechaHoraEnvio => dateTime().nullable()();
}

class Respuestas extends Table {
  IntColumn get id => integer()();

  IntColumn get inspeccionId => integer()
      .customConstraint('REFERENCES inspecciones(id) ON DELETE CASCADE')();

  IntColumn get preguntaId =>
      integer().customConstraint('REFERENCES preguntas(id)')();

  TextColumn get respuestas => text()
      .map(const OpcionDeRespuestaConverter())
      .withDefault(const Constant("[]"))();

  TextColumn get fotosBase => text()
      .map(const ListInColumnConverter())
      .withDefault(const Constant("[]"))();

  TextColumn get fotosReparacion => text()
      .map(const ListInColumnConverter())
      .withDefault(const Constant("[]"))();

  TextColumn get observacion => text().withDefault(const Constant(""))();

  BoolColumn get novedad => boolean().withDefault(const Constant(false))();

  BoolColumn get reparado => boolean().withDefault(const Constant(false))();

  TextColumn get observacionReparacion =>
      text().withDefault(const Constant(""))();

  DateTimeColumn get fechaHoraRespuesta => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Contratistas extends Table {
  IntColumn get id => integer()();
  TextColumn get nombre => text()();
  @override
  Set<Column> get primaryKey => {id};
}

class Sistemas extends Table {
  IntColumn get id => integer()();
  TextColumn get nombre => text()();
  @override
  Set<Column> get primaryKey => {id};
}

class SubSistemas extends Table {
  IntColumn get id => integer()();
  TextColumn get nombre => text()();
  IntColumn get sistemaId =>
      integer().customConstraint('REFERENCES sistemas(id) ON DELETE CASCADE')();
  @override
  Set<Column> get primaryKey => {id};
}
