part of 'drift_database.dart';

// Definición de todas las tablas usadas en la Bd

const _uuid = Uuid();

class Etiquetas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get clave => text()();
  TextColumn get valor => text()();

  @override
  List<String> get customConstraints => ["UNIQUE (clave, valor)"];
}

@DataClassName('EtiquetaDeActivo')
class EtiquetasDeActivo extends Etiquetas {}

class Activos extends Table {
  TextColumn get id => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ActivoXEtiqueta')
class ActivosXEtiquetas extends Table {
  TextColumn get activoId => text()
      .customConstraint('NOT NULL REFERENCES activos(id) ON DELETE CASCADE')();
  IntColumn get etiquetaId => integer().customConstraint(
      'NOT NULL REFERENCES etiquetas_de_activo(id) ON DELETE RESTRICT')();

  @override
  Set<Column> get primaryKey => {activoId, etiquetaId};
}

class Cuestionarios extends Table {
  TextColumn get id => text().clientDefault(() => _uuid.v4())();
  TextColumn get tipoDeInspeccion => text()();
  IntColumn get version => integer()();
  IntColumn get periodicidadDias => integer()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints =>
      ["UNIQUE (tipo_de_inspeccion, version)"];
}

@DataClassName('CuestionarioXEtiqueta')
class CuestionariosXEtiquetas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get cuestionarioId => text().customConstraint(
      'NOT NULL REFERENCES cuestionarios(id) ON DELETE CASCADE')();
  IntColumn get etiquetaId => integer().customConstraint(
      'NOT NULL REFERENCES etiquetas_de_activo(id) ON DELETE RESTRICT')();
}

class Bloques extends Table {
  TextColumn get id => text().clientDefault(() => _uuid.v4())();
  IntColumn get nOrden => integer()();
  TextColumn get cuestionarioId => text().customConstraint(
      'NOT NULL REFERENCES cuestionarios(id) ON DELETE CASCADE')();

  @override
  Set<Column> get primaryKey => {id};
}

class Titulos extends Table {
  TextColumn get id => text().clientDefault(() => _uuid.v4())();
  TextColumn get bloqueId => text().customConstraint(
      'NOT NULL UNIQUE REFERENCES bloques(id) ON DELETE CASCADE')();
  TextColumn get titulo => text()();
  TextColumn get descripcion => text()();
  TextColumn get fotos => text().map(const _ListImagesToTextConverter())();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('EtiquetaDePregunta')
class EtiquetasDePregunta extends Etiquetas {}

enum TipoDePregunta {
  cuadricula,
  parteDeCuadricula,
  seleccionUnica,
  seleccionMultiple,
  numerica,
}
enum TipoDeCuadricula {
  seleccionUnica,
  seleccionMultiple,
}

class Preguntas extends Table {
  TextColumn get id => text().clientDefault(() => _uuid.v4())();
  TextColumn get titulo => text()();
  TextColumn get descripcion => text()();
  IntColumn get criticidad => integer()();
  TextColumn get fotosGuia => text().map(const _ListImagesToTextConverter())();

  TextColumn get bloqueId => text().nullable().customConstraint(
      'NULLABLE UNIQUE REFERENCES bloques(id) ON DELETE CASCADE')();
  TextColumn get cuadriculaId => text().nullable().customConstraint(
      'NULLABLE REFERENCES preguntas(id) ON DELETE CASCADE')();

  TextColumn get tipoDePregunta => text().map(
      const _EnumToStringConverter<TipoDePregunta>(TipoDePregunta.values))();

  TextColumn get tipoDeCuadricula =>
      text().nullable().map(const _EnumToStringConverter<TipoDeCuadricula>(
          TipoDeCuadricula.values))();

  TextColumn get unidades => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PreguntaXEtiqueta')
class PreguntasXEtiquetas extends Table {
  TextColumn get preguntaId => text().customConstraint(
      'NOT NULL REFERENCES preguntas(id) ON DELETE CASCADE')();
  IntColumn get etiquetaId => integer().customConstraint(
      'NOT NULL REFERENCES etiquetas_de_pregunta(id) ON DELETE RESTRICT')();

  @override
  Set<Column> get primaryKey => {preguntaId, etiquetaId};
}

@DataClassName('OpcionDeRespuesta')
class OpcionesDeRespuesta extends Table {
  TextColumn get id => text().clientDefault(() => _uuid.v4())();
  TextColumn get titulo => text()();
  TextColumn get descripcion => text()();
  IntColumn get criticidad => integer()();
  TextColumn get preguntaId => text().customConstraint(
      'NOT NULL REFERENCES preguntas(id) ON DELETE CASCADE')();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CriticidadNumerica')
class CriticidadesNumericas extends Table {
  TextColumn get id => text().clientDefault(() => _uuid.v4())();
  RealColumn get valorMinimo => real()();
  RealColumn get valorMaximo => real()();
  IntColumn get criticidad => integer()();
  TextColumn get preguntaId => text().customConstraint(
      'NOT NULL REFERENCES preguntas(id) ON DELETE CASCADE')();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('Inspeccion')
class Inspecciones extends Table {
  TextColumn get id => text()();

  TextColumn get cuestionarioId => text().customConstraint(
      'NOT NULL REFERENCES cuestionarios(id) ON DELETE NO ACTION')();
  TextColumn get activoId => text()
      .customConstraint('NOT NULL REFERENCES activos(id) ON DELETE CASCADE')();
  TextColumn get inspectorId => text()();

  DateTimeColumn get momentoInicio => dateTime()();
  DateTimeColumn get momentoBorradorGuardado => dateTime().nullable()();
  DateTimeColumn get momentoFinalizacion => dateTime().nullable()();
  DateTimeColumn get momentoEnvio => dateTime().nullable()();

  TextColumn get estado =>
      text().map(const _EnumToStringConverter<EstadoDeInspeccion>(
          EstadoDeInspeccion.values))();

  @override
  Set<Column> get primaryKey => {id};
}

enum TipoDeRespuesta {
  cuadricula,
  seleccionUnica,
  seleccionMultiple,
  parteDeSeleccionMultiple,
  numerica,
}

class Respuestas extends Table {
  TextColumn get id => text().clientDefault(() => _uuid.v4())();
  TextColumn get observacion => text()();
  BoolColumn get reparado => boolean()();
  TextColumn get observacionReparacion => text()();
  DateTimeColumn get momentoRespuesta => dateTime().nullable()();

  TextColumn get fotosBase => text().map(const _ListImagesToTextConverter())();
  TextColumn get fotosReparacion =>
      text().map(const _ListImagesToTextConverter())();

  TextColumn get tipoDeRespuesta => text().map(
      const _EnumToStringConverter<TipoDeRespuesta>(TipoDeRespuesta.values))();

  TextColumn get preguntaId => text().nullable().customConstraint(
      'NULLABLE REFERENCES preguntas(id) ON DELETE CASCADE')();

  TextColumn get respuestaCuadriculaId => text().nullable().customConstraint(
      'NULLABLE REFERENCES respuestas(id) ON DELETE CASCADE')();

  TextColumn get respuestaMultipleId => text().nullable().customConstraint(
      'NULLABLE REFERENCES respuestas(id) ON DELETE CASCADE')();

  TextColumn get inspeccionId => text().nullable().customConstraint(
      'NULLABLE REFERENCES inspecciones(id) ON DELETE CASCADE')();

  TextColumn get opcionSeleccionadaId => text().nullable().customConstraint(
      'NULLABLE REFERENCES opciones_de_respuesta(id) ON DELETE NO ACTION')();

  TextColumn get opcionRespondidaId => text().nullable().customConstraint(
      'NULLABLE REFERENCES opciones_de_respuesta(id) ON DELETE NO ACTION')();

  BoolColumn get opcionRespondidaEstaSeleccionada => boolean().nullable()();

  RealColumn get valorNumerico => real().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/*
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

  TextColumn get tipoDeInspeccion => text().nullable()();

  IntColumn get estado => intEnum<EstadoDeCuestionario>()();

  /// Campo usado solo en la app para identificar los cuestionarios nuevos que deben ser enviados al server.
  BoolColumn get esLocal => boolean()();
  // List<Inspecciones>
  // List<Bloques>
  //List<CuestionariosDeModelos>
}

///Tabla para asignar cuestionarios a modelos y a contratistas.
///TODO: renombrar a ModelosDeCuestionario
class CuestionarioDeModelos extends Table {
  IntColumn get id => integer().autoIncrement()();

  ///El modelo especial "Todos" aplica para todos los vehiculos.
  TextColumn get modelo => text()();

  /// En la UI por defecto el valor es 0
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

  TextColumn get titulo => text().withLength(min: 0, max: 100)();

  TextColumn get descripcion => text().withLength(min: 0, max: 1500)();

  /// Este campo no es usado actualmente para los titulos
  TextColumn get fotos => text()
      .map(const ListOfImagesInColumnConverter())
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
///Las preguntas de tipo cuadricula deben ser agrupadas por el bloque
/// a este bloque del grupo se le asocia tambien el CuadriculasDePreguntas que
///tiene (por medio de join) las opciones de respuesta para el grupo de preguntas

class Preguntas extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get titulo => text().withLength(min: 0, max: 100)();

  TextColumn get descripcion => text().withLength(min: 0, max: 1500)();

  IntColumn get criticidad => integer()();

  /// Atributo usado para información al inspector. Indica a que posición del vehiculo hace referencia la pregunta.

  TextColumn get eje => text().nullable().withLength(min: 0, max: 50)();
  TextColumn get posicionZ => text().nullable().withLength(min: 0, max: 50)();
  TextColumn get lado => text().nullable().withLength(min: 0, max: 50)();

  TextColumn get fotosGuia => text()
      .map(const ListOfImagesInColumnConverter())
      .withDefault(
        const Constant("[]"),
      )(); // en la dataclass es una IList<String> para mantener la igualdad por valor

  @JsonKey('sistema')
  IntColumn get sistemaId =>
      integer().nullable().customConstraint('REFERENCES sistemas(id)')();

  @JsonKey('bloque')
  IntColumn get bloqueId =>
      integer().customConstraint('REFERENCES bloques(id) ON DELETE CASCADE')();

  @JsonKey('subSistema')
  IntColumn get subSistemaId =>
      integer().nullable().customConstraint('REFERENCES sub_sistemas(id)')();

  IntColumn get tipo => intEnum<TipoDePregunta>()();

  //List<OpcionesDeRespuesta>
}

/// Opcion de respuesta asociada a una pregunta de seleccion ya sea simple o
/// multiple. Si pertenece a una pregunta de tipo [CuadriculaDePreguntas], debe
/// referenciar a la cuadricula por medio de [cuadriculaId], si pertenece a
/// una pregunta de seleccion, debe tener [preguntaId] no nulo.
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

  TextColumn get texto => text().withLength(min: 1, max: 100)();

  IntColumn get criticidad => integer()();
}

@DataClassName('Inspeccion')
class Inspecciones extends Table {
  /// Este id tiene el formato: yymmddhhmmss(activoId) ver [Database.generarId()]
  IntColumn get id => integer()();

  IntColumn get estado => intEnum<EstadoDeInspeccion>()();

  RealColumn get criticidadTotal => real()();

  RealColumn get criticidadReparacion => real()();

  /// Cuando se inicia la inspeccion
  DateTimeColumn get momentoInicio => dateTime().nullable()();

  /// Se actualiza cada que se presiona guardar en el llenado
  DateTimeColumn get momentoBorradorGuardado => dateTime().nullable()();

  /// Se marca solo cuando se presiona finalizar y el estado de la inspeccion es reparacion
  DateTimeColumn get momentoFinalizacion => dateTime().nullable()();

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

class Respuestas extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get fotosBase => text()
      .map(const ListOfImagesInColumnConverter())
      .withDefault(const Constant("[]"))();

  TextColumn get fotosReparacion => text()
      .map(const ListOfImagesInColumnConverter())
      .withDefault(const Constant("[]"))();

  TextColumn get observacion => text().withDefault(const Constant(""))();

  BoolColumn get reparado => boolean().withDefault(const Constant(false))();

  TextColumn get observacionReparacion =>
      text().withDefault(const Constant(""))();

  /// Momento de la ultima edición de la respuesta
  DateTimeColumn get momentoRespuesta => dateTime().nullable()();

  @JsonKey('inspeccion')
  IntColumn get inspeccionId => integer()
      .customConstraint('REFERENCES inspecciones(id) ON DELETE CASCADE')();

  @JsonKey('pregunta')
  IntColumn get preguntaId => integer()
      .customConstraint('REFERENCES preguntas(id) ON DELETE CASCADE')();

  /// no se restringe a tener una respuesta por pregunta (por inspeccion)
  /// debido a que las de seleccion multiple deben guardar toda la información
  /// de una respuesta para cada opción seleccionada y se deben agrupar por
  /// preguntaXinspeccion
  ///
  /// Código eliminado:
  /// Si la pregunta asociada es de tipo [TipoDePregunta.multipleRespuesta
  /// Esta respuesta está referenciada por 0 o mas [OpcionDeRespuesta]s
  //List<OpcionDeRespuesta>
  //@override
  //List<String> get customConstraints => ['UNIQUE (inspeccionId, preguntaId)'];

  ///! Campos especiales

  /// Solo usado en caso de que la pregunta sea calificable
  IntColumn get calificacion => integer().nullable()();

  /// Si la pregunta asociada es de tipo [TipoDePregunta.unicaRespuesta] o
  /// [TipoDePregunta.unicaRespuesta] o sus respectivas versiones de cuadricula,
  /// este campo es no nulo y referencia a la [OpcionDeRespuesta] seleccionada.
  @JsonKey('opcionDeRespuesta')
  IntColumn get opcionDeRespuestaId => integer()
      .customConstraint(
          'REFERENCES opciones_de_respuesta(id) ON DELETE CASCADE')
      .nullable()();

  /// Si la pregunta asociada es de tipo [TipoDePregunta.numerica], este campo
  /// es no nulo e indica el valor numerico reportado
  RealColumn get valor => real().nullable()();
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

class ListOfImagesInColumnConverter extends TypeConverter<ListImages, String> {
  const ListOfImagesInColumnConverter();
  @override
  ListImages? mapToDart(fromDb) {
    if (fromDb == null) {
      return null;
    }

    /// Como es DB entonces es mobil, y si empieza por http es remota
    /// TODO: hacerlo mas robusto
    return IList.from(jsonDecode(fromDb) as List).map((path) =>
        (path as String).startsWith('http')
            ? AppImage.remote(path)
            : AppImage.mobile(path));
  }

  @override
  String? mapToSql(value) {
    if (value == null) {
      return null;
    }
    if (value.length() == 0) return "[]";

    final str = value.foldLeft<String>("[",
        (acc, val) => acc + '"${val.when(remote: id, mobile: id, web: id)}",');
    return str.replaceRange(str.length - 1, str.length, ']');
  }
}
*/

class _ListToTextConverter extends TypeConverter<List<String>, String> {
  const _ListToTextConverter();
  @override
  List<String>? mapToDart(fromDb) {
    if (fromDb == null) {
      return null;
    }

    return (jsonDecode(fromDb) as List).cast<String>();
  }

  @override
  String? mapToSql(value) {
    if (value == null) {
      return null;
    }
    return jsonEncode(value);
  }
}

class _ListImagesToTextConverter extends TypeConverter<List<AppImage>, String> {
  const _ListImagesToTextConverter();
  @override
  List<AppImage>? mapToDart(fromDb) {
    if (fromDb == null) {
      return null;
    }
    return (jsonDecode(fromDb) as List)
        .cast<String>()
        .map((p) =>
            p.startsWith("http") ? AppImage.remote(p) : AppImage.mobile(p))
        .toList();
  }

  @override
  String? mapToSql(value) {
    if (value == null) {
      return null;
    }
    return jsonEncode(value
        .map((i) => i.when(
            remote: (p) => p,
            mobile: (p) => p,
            web: (_) =>
                throw UnsupportedError("No se puede guardar una imagen web")))
        .toList());
  }
}
/*
class TipoDePreguntaConverter extends TypeConverter<TipoDePregunta, String> {
  const TipoDePreguntaConverter();
  @override
  TipoDePregunta? mapToDart(fromDb) {
    if (fromDb == null) {
      return null;
    }

    return EnumToString.fromString(TipoDePregunta.values, fromDb);
  }

  @override
  String? mapToSql(value) {
    if (value == null) {
      return null;
    }
    return EnumToString.convertToString(value);
  }
}*/

class _EnumToStringConverter<T extends Enum> extends TypeConverter<T, String> {
  final List<T> enumValues;
  const _EnumToStringConverter(this.enumValues);

  @override
  T? mapToDart(fromDb) {
    if (fromDb == null) {
      return null;
    }

    return EnumToString.fromString(enumValues, fromDb);
  }

  @override
  String? mapToSql(value) {
    if (value == null) {
      return null;
    }
    return EnumToString.convertToString(value);
  }
}
