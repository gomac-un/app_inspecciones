part of 'moor_database.dart';

class Activos extends Table {
  TextColumn get modelo => text()();

  IntColumn get id => integer()();

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
  IntColumn get sistema =>
      integer().customConstraint('REFERENCES sistemas(id) ON DELETE CASCADE')();
  @override
  Set<Column> get primaryKey => {id};
}

//Tabla para asignar cuestionarios a modelos y a contratistas
class CuestionarioDeModelos extends Table {
  IntColumn get id => integer().autoIncrement()();
  //El modelo especial "todos" aplica para todos los vehiculos
  TextColumn get modelo => text()();

  IntColumn get periodicidad => integer()();

  IntColumn get cuestionario_id => integer()
      .customConstraint('REFERENCES cuestionarios(id) ON DELETE CASCADE')();

  IntColumn get contratista_id => integer()
      .customConstraint('REFERENCES contratistas(id) ON DELETE SET NULL')();
}

class Cuestionarios extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get tipoDeInspeccion => text()();
  // List<Inspecciones>
  // List<Bloques>
  //List<CuestionariosDeModelos>
}

class Bloques extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get cuestionario_id => integer()
      .customConstraint('REFERENCES cuestionarios(id) ON DELETE CASCADE')();

  IntColumn get nOrden => integer()();

  //List<Preguntas>
  //List<Titulos>

  //CuadriculasDePreguntas

}

//TODO: refactorizar ya que se sacó el titulo/descripcion del bloque y se puso
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

  TextColumn get descripcion => text().withLength(min: 0, max: 1500)();

  TextColumn get fotos => text()
      .map(const ListInColumnConverter())
      .withDefault(const Constant("[]"))();
}

//Tabla para agrupar las preguntas de tipo cuadricula
//para acceder se debe hacer join con el bloque en comun con las preguntas
@DataClassName('CuadriculaDePreguntas')
class CuadriculasDePreguntas extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get bloqueId => integer().customConstraint(
      'REFERENCES bloques(id) ON DELETE CASCADE')(); //debe ser unico por ser uno a uno, sera que es pk?

  TextColumn get titulo => text().withLength(min: 0, max: 100)();

  TextColumn get descripcion => text().withLength(min: 0, max: 1500)();
  //List<OpcionesDeRespuesta>

}

//Las preguntas de tipo seleccion unica o multiple pueden ser reunidas
//directamente con el bloque
//Las preguntas de tipo cuadricula deben ser
//TODO: agrupadas por el bloque
// a este bloque del grupo se le asocia tambien el CuadriculasDePreguntas que
//tiene (por medio de join) las opciones de respuesta para el grupo de preguntas

class Preguntas extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get bloqueId =>
      integer().customConstraint('REFERENCES bloques(id) ON DELETE CASCADE')();

  TextColumn get titulo => text().withLength(min: 1, max: 100)();

  TextColumn get descripcion => text().withLength(min: 0, max: 1500)();

  IntColumn get sistemaId =>
      integer().customConstraint('REFERENCES sistemas(id)')();

  IntColumn get subSistemaId =>
      integer().customConstraint('REFERENCES sub_sistemas(id)')();

  TextColumn get posicion => text().withLength(min: 0, max: 50)();

  TextColumn get fotosGuia => text()
      .map(const ListInColumnConverter())
      .withDefault(const Constant("[]"))();

  IntColumn get tipo => intEnum<TipoDePregunta>()();

  BoolColumn get parteDeCuadricula => boolean()();

  IntColumn get criticidad => integer()();

  //List<OpcionesDeRespuesta>
}

@DataClassName('OpcionDeRespuesta')
class OpcionesDeRespuesta extends Table {
  IntColumn get id => integer().autoIncrement()();

  //uno de estos 2 debe ser no nulo
  IntColumn get pregunta => integer().nullable()();
  //.customConstraint('REFERENCES preguntas(id)')();

  IntColumn get cuadriculaId => integer().nullable()();
  //.customConstraint('REFERENCES cuadriculas_de_preguntas(id) ')();

  TextColumn get texto => text().withLength(min: 1, max: 100)();

  IntColumn get criticidad => integer()();
}

@DataClassName('Inspeccion')
class Inspecciones extends Table {
  // este id tiene el formato: yymmddhhmm(activoId) ver [Database.generarId()]
  IntColumn get id => integer()();

  IntColumn get estado => intEnum<EstadoDeInspeccion>()();

  IntColumn get cuestionarioId => integer()
      .customConstraint('REFERENCES cuestionarios(id) ON DELETE CASCADE')();

  IntColumn get identificadorActivo => integer().customConstraint(
      'REFERENCES activos(identificador) ON DELETE CASCADE')();

  DateTimeColumn get momentoInicio => dateTime().nullable()();

  DateTimeColumn get momentoBorradorGuardado => dateTime().nullable()();

  DateTimeColumn get momentoEnvio => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Respuestas extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get inspeccionId => integer()
      .customConstraint('REFERENCES inspecciones(id) ON DELETE CASCADE')();

  IntColumn get preguntaId => integer()
      .customConstraint('REFERENCES preguntas(id) ON DELETE CASCADE')();

  //List<OpcionDeRespuesta>

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

class RespuestasXOpcionesDeRespuesta extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get respuesta_id => integer()
      .customConstraint('REFERENCES respuestas(id) ON DELETE CASCADE')();

  IntColumn get preguntaRespuesta_id => integer().customConstraint(
      'REFERENCES opciones_de_respuesta(id) ON DELETE CASCADE')();
}

class ListInColumnConverter extends TypeConverter<KtList<String>, String> {
  const ListInColumnConverter();
  @override
  KtList<String> mapToDart(String fromDb) {
    if (fromDb == null) {
      return null;
    }
    return (jsonDecode(fromDb) as List)
        .map((e) => e as String)
        .toImmutableList();
  }

  @override
  String mapToSql(KtList<String> value) {
    if (value == null) {
      return null;
    }
    if (value.size == 0) return "[]";
    final str = value.fold<String>("[", (acc, val) => '$acc"$val",');
    return str.replaceRange(str.length - 1, str.length, ']');
  }
}
