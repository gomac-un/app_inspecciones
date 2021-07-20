part of 'moor_database.dart';

/// Definición de todas las tablas usadas en la Bd
///

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

class TiposDeInspecciones extends Table {
  IntColumn get id => integer()();
  TextColumn get tipo => text()();
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

  @JsonKey('sistema')
  IntColumn get sistemaId =>
      integer().nullable().customConstraint('REFERENCES sistemas(id)')();

  IntColumn get estado => intEnum<EstadoDeCuestionario>()();

  /// Campo usado solo en la app para identificar los cuestionarios nuevos que deben ser enviados al server.
  BoolColumn get esLocal => boolean().withDefault(const Constant(true))();
  // List<Inspecciones>
  // List<Bloques>
  //List<CuestionariosDeModelos>
}

///Tabla para asignar cuestionarios a modelos y a contratistas.
class CuestionarioDeModelos extends Table {
  IntColumn get id => integer().autoIncrement()();

  ///El modelo especial "Todos" aplica para todos los vehiculos.
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

/// Usada para poder organizar cada pregunta y titulo de los cuestionarios.

class Bloques extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Indica la posición en el cuestionario iniciando desde 0
  IntColumn get nOrden => integer()();

  @JsonKey('cuestionario')
  IntColumn get cuestionarioId => integer()
      .customConstraint('REFERENCES cuestionarios(id) ON DELETE CASCADE')();

  //List<Preguntas>
  //List<Titulos>

  //CuadriculasDePreguntas

}

///Las consultas deben involucrar de manera independiente
///tablas de titulos y preguntas de tipo simple y de tipo cuadricula.
///los formularios deben tratar cada uno de estos casos y ordenarlos
///con el nOrden que tienen los bloques correspondientes.

class Titulos extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get titulo => text().withLength(min: 1, max: 100)();

  TextColumn get descripcion => text().withLength(min: 0, max: 1500)();

  /// Este campo no es usado actualmente para los titulos
  TextColumn get fotos => text()
      .map(const ListInColumnConverter())
      .withDefault(const Constant("[]"))();

  @JsonKey('bloque')
  IntColumn get bloqueId =>
      integer().customConstraint('REFERENCES bloques(id) ON DELETE CASCADE')();
}

///Tabla para agrupar las preguntas de tipo cuadricula
///para acceder se debe hacer join con el bloque en comun con las preguntas
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

///Las preguntas de tipo seleccion unica o multiple pueden ser reunidas
///directamente con el bloque
///Las preguntas de tipo cuadricula deben ser
//TODO: agrupadas por el bloque
/// a este bloque del grupo se le asocia tambien el CuadriculasDePreguntas que
///tiene (por medio de join) las opciones de respuesta para el grupo de preguntas

class Preguntas extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get titulo => text().withLength(min: 1, max: 100)();

  TextColumn get descripcion => text().withLength(min: 0, max: 1500)();

  IntColumn get criticidad => integer()();

  /// Atributo usado para información al inspector. Indica a que posición del vehiculo hace referencia la pregunta.
  TextColumn get posicion => text().nullable().withLength(min: 0, max: 50)();

  TextColumn get fotosGuia => text()
      .map(const ListInColumnConverter())
      .withDefault(const Constant("[]"))();

  /// Campo usado paraa preguntas que actian otras dependiendo de laa respuesta.
  //TODO: implementar
  BoolColumn get esCondicional =>
      boolean().withDefault(const Constant(false))();

  @JsonKey('bloque')
  IntColumn get bloqueId =>
      integer().customConstraint('REFERENCES bloques(id) ON DELETE CASCADE')();

  @JsonKey('subSistema')
  IntColumn get subSistemaId =>
      integer().nullable().customConstraint('REFERENCES sub_sistemas(id)')();

  IntColumn get tipo => intEnum<TipoDePregunta>()();

  //List<OpcionesDeRespuesta>
}

@DataClassName('OpcionDeRespuesta')
class OpcionesDeRespuesta extends Table {
  IntColumn get id => integer().autoIncrement()();

  ///uno de estos 2 debe ser no nulo.
  @JsonKey('pregunta')
  IntColumn get preguntaId => integer()
      .nullable()
      .customConstraint('REFERENCES preguntas(id) ON DELETE CASCADE')();
  @JsonKey('cuadricula')
  IntColumn get cuadriculaId => integer().nullable().customConstraint(
      'REFERENCES cuadriculas_de_preguntas(id) ON DELETE CASCADE')();

  /// Si el inspector puede asignar un nivel de gravedad a la respuesta
  BoolColumn get calificable => boolean().withDefault(const Constant(false))();
  //.customConstraint('REFERENCES cuadriculas_de_preguntas(id) ')();

  TextColumn get texto => text().withLength(min: 1, max: 100)();

  IntColumn get criticidad => integer()();
}

@DataClassName('Inspeccion')
class Inspecciones extends Table {
  /// Este id tiene el formato: yymmddhhmm(activoId) ver [Database.generarId()]
  IntColumn get id => integer()();

  IntColumn get estado => intEnum<EstadoDeInspeccion>()();

  IntColumn get criticidadTotal => integer()();

  IntColumn get criticidadReparacion => integer()();
/// Cuando se inicia la inspeccion
  DateTimeColumn get momentoInicio => dateTime().nullable()();
  /// Se actualiza cada que se presiona guardar en el llenado
  DateTimeColumn get momentoBorradorGuardado => dateTime().nullable()();

  /// Se marca solo cuando se presiona finalizar y el estado de la inspeccion es reparacion
  DateTimeColumn get momentoFinalizacion => dateTime().nullable()();
  //TODO: Verificar  como es que funcionan estas fechas.
  /// Nulo hasta que se envia la inspección al server
  DateTimeColumn get momentoEnvio => dateTime().nullable()();

  @JsonKey('cuestionario')
  IntColumn get cuestionarioId => integer()
      .customConstraint('REFERENCES cuestionarios(id) ON DELETE CASCADE')();

  @JsonKey('activo')
  IntColumn get activoId => integer()
      .customConstraint('REFERENCES activos(id) ON DELETE NO ACTION')();

  /// Esta columna es usada en la app para saber si es creada por el usuario o la descargó del servidor
  BoolColumn get esNueva => boolean().clientDefault(() => true)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Rangos de criticidad para las preguntas numericas del tipo [[valorMinimo],[valorMaximo])
/// Si la respuesta está en ese rango, su criticidad será igual a [criticidad]
class CriticidadesNumericas extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get valorMinimo => real()();
  RealColumn get valorMaximo => real()();
  IntColumn get criticidad => integer()();
  @JsonKey('pregunta')
  IntColumn get preguntaId => integer()
      .customConstraint('REFERENCES preguntas(id) ON DELETE CASCADE')();
}

class GruposInspeccioness extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get nGrupo => integer()();

  DateTimeColumn get inicio => dateTime()();

  DateTimeColumn get fin => dateTime()();

  IntColumn get totalGrupos => integer()();

  IntColumn get tipoInspeccion => integer().customConstraint(
      'REFERENCES tipos_de_inspecciones(id) ON DELETE CASCADE')();

  IntColumn get anio => integer().clientDefault(() => inicio.year as int)();

  //List<OpcionDeRespuesta>
}

class ProgramacionSistemas extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get activoId =>
      integer().customConstraint('REFERENCES activos(id) ON DELETE CASCADE')();
  IntColumn get grupoId => integer().customConstraint(
      'REFERENCES grupos_inspeccioness(id) ON DELETE CASCADE')();
  IntColumn get mes => integer()();
  IntColumn get estado => intEnum<EstadoProgramacion>()();
}

class ProgramacionSistemasXActivo extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get programacionSistemaId => integer().customConstraint(
      'REFERENCES programacion_sistemas(id) ON DELETE CASCADE')();
  @JsonKey('sistema')
  IntColumn get sistemaId =>
      integer().customConstraint('REFERENCES sistemas(id) ON DELETE CASCADE')();
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

  /// Solo usado si la pregunta es de tipo numérica
  RealColumn get valor => real().nullable()();

  TextColumn get observacionReparacion =>
      text().withDefault(const Constant(""))();

  /// Solo usado en caso de que la pregunta sea calificable
  IntColumn get calificacion => integer().nullable()();

  /// Momento de la ultima edición de la respuesta
  DateTimeColumn get momentoRespuesta => dateTime().nullable()();

  @JsonKey('inspeccion')
  IntColumn get inspeccionId => integer()
      .customConstraint('REFERENCES inspecciones(id) ON DELETE CASCADE')();

  @JsonKey('pregunta')
  IntColumn get preguntaId => integer()
      .customConstraint('REFERENCES preguntas(id) ON DELETE CASCADE')();

  //TODO: verificar que el par inpeccionId-preguntaId sea unico
  /// En este caso no sé que puede pasar si no es único, para el caso de las multiples se
  /// está dando el caso sin generar problema hasta ahora
  @JsonKey('opcionDeRespuesta')
  IntColumn get opcionDeRespuestaId => integer()
      .customConstraint(
          'REFERENCES opciones_de_respuesta(id) ON DELETE CASCADE')
      .nullable()();

  //List<OpcionDeRespuesta>
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
