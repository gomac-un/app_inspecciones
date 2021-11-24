part of 'drift_database.dart';

// Definición de todas las tablas usadas en la Bd

const _uuid = Uuid();

class EtiquetasJerarquicas extends Table {
  // identificador de la jerarquía, por ahora es el primer nivel
  TextColumn get nombre => text()();

  TextColumn get json => text().map(const _JsonToTextConverter())();

  /// indica que esta etiqueta se creó en el dispositivo y no ha sido sincronizada o descargada desde el server
  BoolColumn get esLocal => boolean()();

  @override
  Set<Column> get primaryKey => {nombre};
}

@DataClassName('EtiquetaJerarquicaDeActivo')
class EtiquetasJerarquicasDeActivo extends EtiquetasJerarquicas {}

@DataClassName('EtiquetaJerarquicaDePregunta')
class EtiquetasJerarquicasDePregunta extends EtiquetasJerarquicas {}

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
  TextColumn get estado =>
      text().map(const _EnumToStringConverter<EstadoDeCuestionario>(
          EstadoDeCuestionario.values))();
  BoolColumn get subido => boolean()();

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
  TextColumn get activoId => text().customConstraint(
      'NOT NULL REFERENCES activos(id) ON DELETE NO ACTION')();
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
/*
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
*/
class _ListImagesToTextConverter extends TypeConverter<List<AppImage>, String> {
  const _ListImagesToTextConverter();
  @override
  List<AppImage>? mapToDart(fromDb) {
    if (fromDb == null) {
      return null;
    }
    return (json.decode(fromDb) as List)
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
    return json.encode(value
        .map((i) => i.when(
            remote: (p) => p,
            mobile: (p) => p,
            web: (_) =>
                throw UnsupportedError("No se puede guardar una imagen web")))
        .toList());
  }
}

class _JsonToTextConverter extends TypeConverter<dynamic, String> {
  const _JsonToTextConverter();
  @override
  dynamic mapToDart(fromDb) => fromDb == null ? null : json.decode(fromDb);

  @override
  String? mapToSql(value) => value == null ? null : json.encode(value);
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
