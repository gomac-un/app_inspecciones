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
  TextColumn get pk => text().clientDefault(() => _uuid.v4())();
  TextColumn get id => text()();

  @override
  Set<Column> get primaryKey => {pk};
  @override
  List<String> get customConstraints => ["UNIQUE (id)"];
}

@DataClassName('ActivoXEtiqueta')
class ActivosXEtiquetas extends Table {
  TextColumn get activoId =>
      text().references(Activos, #id, onDelete: KeyAction.cascade)();
  IntColumn get etiquetaId => integer()
      .references(EtiquetasDeActivo, #id, onDelete: KeyAction.restrict)();

  @override
  Set<Column> get primaryKey => {activoId, etiquetaId};
}

enum EstadoDeCuestionario {
  borrador,
  finalizado,
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
  TextColumn get cuestionarioId =>
      text().references(Cuestionarios, #id, onDelete: KeyAction.cascade)();
  IntColumn get etiquetaId => integer()
      .references(EtiquetasDeActivo, #id, onDelete: KeyAction.restrict)();
}

class Bloques extends Table {
  TextColumn get id => text().clientDefault(() => _uuid.v4())();
  IntColumn get nOrden => integer()();
  TextColumn get cuestionarioId =>
      text().references(Cuestionarios, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {id};
}

class Titulos extends Table {
  TextColumn get id => text().clientDefault(() => _uuid.v4())();
  TextColumn get bloqueId =>
      text().references(Bloques, #id, onDelete: KeyAction.cascade)();
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

  TextColumn get bloqueId =>
      text().nullable().references(Bloques, #id, onDelete: KeyAction.cascade)();
  TextColumn get cuadriculaId => text()
      .nullable()
      .references(Preguntas, #id, onDelete: KeyAction.cascade)();

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
  TextColumn get preguntaId =>
      text().references(Preguntas, #id, onDelete: KeyAction.cascade)();
  IntColumn get etiquetaId => integer()
      .references(EtiquetasDePregunta, #id, onDelete: KeyAction.restrict)();

  @override
  Set<Column> get primaryKey => {preguntaId, etiquetaId};
}

@DataClassName('OpcionDeRespuesta')
class OpcionesDeRespuesta extends Table {
  TextColumn get id => text().clientDefault(() => _uuid.v4())();
  TextColumn get titulo => text()();
  TextColumn get descripcion => text()();
  IntColumn get criticidad => integer()();

  /// Si el inspector puede asignar un nivel de criticidad a la respuesta
  BoolColumn get requiereCriticidadDelInspector => boolean()();

  TextColumn get preguntaId =>
      text().references(Preguntas, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CriticidadNumerica')
class CriticidadesNumericas extends Table {
  TextColumn get id => text().clientDefault(() => _uuid.v4())();
  RealColumn get valorMinimo => real()();
  RealColumn get valorMaximo => real()();
  IntColumn get criticidad => integer()();
  TextColumn get preguntaId =>
      text().references(Preguntas, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('Inspeccion')
class Inspecciones extends Table {
  TextColumn get id => text()();

  TextColumn get cuestionarioId =>
      text().references(Cuestionarios, #id, onDelete: KeyAction.noAction)();
  TextColumn get activoId =>
      text().references(Activos, #pk, onDelete: KeyAction.noAction)();

  DateTimeColumn get momentoInicio => dateTime()();
  DateTimeColumn get momentoBorradorGuardado => dateTime().nullable()();
  DateTimeColumn get momentoFinalizacion => dateTime().nullable()();
  DateTimeColumn get momentoEnvio => dateTime().nullable()();

  TextColumn get estado =>
      text().map(const _EnumToStringConverter<EstadoDeInspeccion>(
          EstadoDeInspeccion.values))();

  /// caché de la criticidad calculada usando campos de la respuesta y de la pregunta,
  /// la fórmula se encuentra en [ControladorLlenadoInspeccion.criticidadCalculada]
  IntColumn get criticidadCalculada => integer()();
  IntColumn get criticidadCalculadaConReparaciones => integer()();

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

  /// No null solo si la opcion seleccionada u opcion respondida requiereCriticidadDelInspector
  IntColumn get criticidadDelInspector => integer().nullable()();

  /// caché de la criticidad calculada usando campos de la respuesta y de la pregunta,
  /// la fórmula se encuentra en [ControladorDePregunta.criticidadCalculada]
  IntColumn get criticidadCalculada => integer()();
  IntColumn get criticidadCalculadaConReparaciones => integer()();

  TextColumn get preguntaId => text()
      .nullable()
      .references(Preguntas, #id, onDelete: KeyAction.cascade)();

  TextColumn get respuestaCuadriculaId => text()
      .nullable()
      .references(Respuestas, #id, onDelete: KeyAction.cascade)();

  TextColumn get respuestaMultipleId => text()
      .nullable()
      .references(Respuestas, #id, onDelete: KeyAction.cascade)();

  TextColumn get inspeccionId => text()
      .nullable()
      .references(Inspecciones, #id, onDelete: KeyAction.cascade)();

  TextColumn get opcionSeleccionadaId => text()
      .nullable()
      .references(OpcionesDeRespuesta, #id, onDelete: KeyAction.noAction)();

  TextColumn get opcionRespondidaId => text()
      .nullable()
      .references(OpcionesDeRespuesta, #id, onDelete: KeyAction.noAction)();

  BoolColumn get opcionRespondidaEstaSeleccionada => boolean().nullable()();

  RealColumn get valorNumerico => real().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class _ListImagesToTextConverter
    extends NullAwareTypeConverter<List<AppImage>, String> {
  const _ListImagesToTextConverter();
  @override
  List<AppImage> requireMapToDart(fromDb) {
    return (json.decode(fromDb) as List)
        .cast<String>()
        .map((p) => p.startsWith("http")
            ? AppImage.remote(id: p.split("#").last, url: p.split("#").first)
            : p.startsWith("blob")
                ? AppImage.web(p)
                : AppImage.mobile(p))
        .toList();
  }

  @override
  String requireMapToSql(value) {
    return json.encode(value
        .map((i) => i.when(
              remote: (id, url) => url + "#" + id,
              mobile: (p) => p,
              web: (p) => p,
            ))
        .toList());
  }
}

class _JsonToTextConverter extends NullAwareTypeConverter<dynamic, String> {
  const _JsonToTextConverter();
  @override
  dynamic requireMapToDart(fromDb) => json.decode(fromDb);

  @override
  String requireMapToSql(value) => json.encode(value);
}

class _EnumToStringConverter<T extends Enum>
    extends NullAwareTypeConverter<T, String> {
  final List<T> enumValues;
  const _EnumToStringConverter(this.enumValues);

  @override
  T requireMapToDart(fromDb) => EnumToString.fromString(enumValues, fromDb)!;

  @override
  String requireMapToSql(value) => EnumToString.convertToString(value);
}
