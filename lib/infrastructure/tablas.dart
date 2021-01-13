part of 'moor_database.dart';

class Activos extends Table {
  IntColumn get id => integer()();

  TextColumn get modelo => text()();

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

  @JsonKey('sistema')
  IntColumn get sistemaId =>
      integer().customConstraint('REFERENCES sistemas(id) ON DELETE CASCADE')();

  @override
  Set<Column> get primaryKey => {id};
}

class Cuestionarios extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get tipoDeInspeccion => text()();

  // campo usado solo en la app para identificar los cuestionarios nuevos que deben ser enviados al server
  BoolColumn get esLocal => boolean().withDefault(const Constant(true))();
  // List<Inspecciones>
  // List<Bloques>
  //List<CuestionariosDeModelos>
}

//Tabla para asignar cuestionarios a modelos y a contratistas
class CuestionarioDeModelos extends Table {
  IntColumn get id => integer().autoIncrement()();
  //El modelo especial "todos" aplica para todos los vehiculos
  TextColumn get modelo => text()();

  IntColumn get periodicidad => integer()();

  @JsonKey('cuestionario')
  IntColumn get cuestionarioId => integer()
      .customConstraint('REFERENCES cuestionarios(id) ON DELETE CASCADE')();

  @JsonKey('contratista')
  IntColumn get contratistaId => integer()
      .nullable()
      .customConstraint('REFERENCES contratistas(id) ON DELETE SET NULL')();
}

class Bloques extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get nOrden => integer()();

  @JsonKey('cuestionario')
  IntColumn get cuestionarioId => integer()
      .customConstraint('REFERENCES cuestionarios(id) ON DELETE CASCADE')();

  //List<Preguntas>
  //List<Titulos>

  //CuadriculasDePreguntas

}

//Las consultas deben involucrar de manera independiente
//tablas de titulos y preguntas de tipo simple y de tipo cuadricula.
//los formularios deben tratar cada uno de estos casos y ordenarlos
//con el nOrden que tienen los bloques correspondientes.

class Titulos extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get titulo => text().withLength(min: 1, max: 100)();

  TextColumn get descripcion => text().withLength(min: 0, max: 1500)();

  TextColumn get fotos => text()
      .map(const ListInColumnConverter())
      .withDefault(const Constant("[]"))();

  @JsonKey('bloque')
  IntColumn get bloqueId =>
      integer().customConstraint('REFERENCES bloques(id) ON DELETE CASCADE')();
}

//Tabla para agrupar las preguntas de tipo cuadricula
//para acceder se debe hacer join con el bloque en comun con las preguntas
@DataClassName('CuadriculaDePreguntas')
class CuadriculasDePreguntas extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get titulo => text().withLength(min: 0, max: 100)();

  TextColumn get descripcion => text().withLength(min: 0, max: 1500)();

  @JsonKey('bloque')
  IntColumn get bloqueId => integer().customConstraint(
      'UNIQUE REFERENCES bloques(id) ON DELETE CASCADE')(); //debe ser unico por ser uno a uno, sera que es pk?

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

  TextColumn get titulo => text().withLength(min: 1, max: 100)();

  TextColumn get descripcion => text().withLength(min: 0, max: 1500)();

  IntColumn get criticidad => integer()();

  TextColumn get posicion => text().nullable().withLength(min: 0, max: 50)();

  TextColumn get fotosGuia => text()
      .map(const ListInColumnConverter())
      .withDefault(const Constant("[]"))();

  @JsonKey('bloque')
  IntColumn get bloqueId =>
      integer().customConstraint('REFERENCES bloques(id) ON DELETE CASCADE')();

  @JsonKey('sistema')
  IntColumn get sistemaId =>
      integer().nullable().customConstraint('REFERENCES sistemas(id)')();

  @JsonKey('subSistema')
  IntColumn get subSistemaId =>
      integer().nullable().customConstraint('REFERENCES sub_sistemas(id)')();

  IntColumn get tipo => intEnum<TipoDePregunta>()();

  //List<OpcionesDeRespuesta>
}

@DataClassName('OpcionDeRespuesta')
class OpcionesDeRespuesta extends Table {
  IntColumn get id => integer().autoIncrement()();

  //uno de estos 2 debe ser no nulo
  @JsonKey('pregunta')
  IntColumn get preguntaId => integer().nullable()();
  //.customConstraint('REFERENCES preguntas(id)')();
  @JsonKey('cuadricula')
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

  DateTimeColumn get momentoInicio => dateTime().nullable()();

  DateTimeColumn get momentoBorradorGuardado => dateTime().nullable()();

  DateTimeColumn get momentoEnvio => dateTime().nullable()();

  @JsonKey('cuestionario')
  IntColumn get cuestionarioId => integer()
      .customConstraint('REFERENCES cuestionarios(id) ON DELETE CASCADE')();

  @JsonKey('activo')
  IntColumn get activoId => integer()
      .customConstraint('REFERENCES activos(id) ON DELETE NO ACTION')();

  @override
  Set<Column> get primaryKey => {id};
}

class CriticidadesNumericas extends Table{
  IntColumn get id => integer().autoIncrement()();
  RealColumn get valorMinimo => real()();
  RealColumn get  valorMaximo => real()();
  IntColumn get criticidad => integer()();
  @JsonKey('pregunta')
  IntColumn get preguntaId => integer().nullable()();
}

class Respuestas extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get fotosBase => text()
      .map(const ListInColumnConverter())
      .withDefault(const Constant("[]"))();

  TextColumn get fotosReparacion => text()
      .map(const ListInColumnConverter())
      .withDefault(const Constant("[]"))();

  TextColumn get observacion => text().withDefault(const Constant(""))();

  BoolColumn get reparado => boolean().withDefault(const Constant(false))();

  RealColumn get valor => real().nullable()();

  TextColumn get observacionReparacion =>
      text().withDefault(const Constant(""))();

  DateTimeColumn get momentoRespuesta => dateTime().nullable()();

  @JsonKey('inspeccion')
  IntColumn get inspeccionId => integer()
      .customConstraint('REFERENCES inspecciones(id) ON DELETE CASCADE')();

  @JsonKey('pregunta')
  IntColumn get preguntaId => integer()
      .customConstraint('REFERENCES preguntas(id) ON DELETE CASCADE')();

  //TODO: verificar que el par inpeccionId-preguntaId sea unico

  //List<OpcionDeRespuesta>
}

class RespuestasXOpcionesDeRespuesta extends Table {
  IntColumn get id => integer().autoIncrement()();

  @JsonKey('respuesta')
  IntColumn get respuestaId => integer()
      .customConstraint('REFERENCES respuestas(id) ON DELETE CASCADE')();

  @JsonKey('opcionDeRespuesta')
  IntColumn get opcionDeRespuestaId => integer().customConstraint(
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
