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
  IntColumn get id =>
      integer().autoIncrement()(); //se podria agregar mas informacion aqui
  // List<Inspecciones>
  // List<Bloques>
  //List<CuestionariosDeModelos>
}

class Bloques extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get cuestionarioId => integer()
      .customConstraint('REFERENCES cuestionarios(id) ON DELETE CASCADE')();

  IntColumn get nOrden => integer()();

  //List<Preguntas>
  //List<Titulos>

  //CuadriculasDePreguntas

}

//TODO: refactorizar ya que se saco el titulo/descripcion del bloque y se puso
//en las tablas titulo y pregunta.
//Las consultas ya deben involucrar de manera independiente
//tablas de titulos y preguntas de tipo simple y de tipo cuadricula.
//los formularios deben tratar cada uno de estos casos y ordenarlos
//con el nOrden que tienen los bloques correspondientes.
class Titulos extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get bloqueId =>
      integer().customConstraint('REFERENCES bloques(id) ON DELETE CASCADE')();

  TextColumn get titulo => text().withLength(min: 1, max: 100)();

  TextColumn get descripcion => text().withLength(min: 0, max: 200)();

  TextColumn get fotos => text()
      .map(const ListInColumnConverter())
      .withDefault(const Constant("[]"))();
}

//Tabla para agrupar las preguntas de tipo cuadricula
//para acceder se debe hacer join con el bloque en comun con las preguntas
class CuadriculasDePreguntas extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get bloqueId => integer().customConstraint(
      'REFERENCES bloques(id)')(); //debe ser unico por ser uno a uno, sera que es pk?

  //List<OpcionesDeRespuesta>

}

//Las preguntas de tipo seleccion unica o multiple pueden ser reunidas
//directamente con el bloque
//Las preguntas de tipo cuadricula deben ser
//TODO:agrupadas por el bloque
// a este bloque del grupo se le asocia tambien el CuadriculasDePreguntas que
//tiene (por medio de join) las opciones de respuesta para el grupo de preguntas
class Preguntas extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get bloqueId =>
      integer().customConstraint('REFERENCES bloques(id) ON DELETE CASCADE')();

  TextColumn get titulo => text().withLength(min: 1, max: 100)();

  TextColumn get descripcion => text().withLength(min: 0, max: 200)();

  IntColumn get sistemaId =>
      integer().customConstraint('REFERENCES sistemas(id)')();

  IntColumn get subSistemaId =>
      integer().customConstraint('REFERENCES sub_sistemas(id)')();

  TextColumn get posicion => text().withLength(min: 0, max: 50)();

  TextColumn get fotosGuia => text()
      .map(const ListInColumnConverter())
      .withDefault(const Constant("[]"))();

  IntColumn get tipo => intEnum<TipoDePregunta>()();

  IntColumn get criticidad => integer()();

  //List<OpcionesDeRespuesta>
}

class OpcionesDeRespuesta extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get preguntaId =>
      integer()();//No se le pone el references ya que puede referenciar tanto a una pregunta como a una cuadricula

  TextColumn get texto => text().withLength(min: 1, max: 100)();

  IntColumn get criticidad => integer()();
}

@DataClassName('Inspeccion')
class Inspecciones extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get estado => intEnum<EstadoDeInspeccion>()();

  IntColumn get cuestionarioId =>
      integer().customConstraint('REFERENCES cuestionarios(id)')();

  TextColumn get identificadorActivo =>
      text().customConstraint('REFERENCES activos(identificador)')();

  DateTimeColumn get momentoInicio => dateTime().nullable()();

  DateTimeColumn get momentoBorradorGuardado => dateTime().nullable()();

  DateTimeColumn get momentoEnvio => dateTime().nullable()();
}

class Respuestas extends Table {
  IntColumn get id => integer().autoIncrement()();

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

  BoolColumn get reparado => boolean().withDefault(const Constant(false))();

  TextColumn get observacionReparacion =>
      text().withDefault(const Constant(""))();

  DateTimeColumn get momentoRespuesta => dateTime().nullable()();
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
