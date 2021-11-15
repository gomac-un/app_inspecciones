import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart' hide DataClass;
import 'package:inspecciones/features/creacion_cuestionarios/tablas_unidas.dart';
import 'package:inspecciones/infrastructure/drift_database.dart';

part 'carga_cuestionario_dao.drift.dart';

@DriftAccessor(tables: [
  EtiquetasDeActivo,
  Activos,
  Cuestionarios,
  CuestionariosXEtiquetas,
  Bloques,
  Titulos,
  Preguntas,
  CriticidadesNumericas,
  OpcionesDeRespuesta,
  EtiquetasDePregunta,
  PreguntasXEtiquetas,
])
class CargaDeCuestionarioDao extends DatabaseAccessor<Database>
    with _$CargaDeCuestionarioDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  CargaDeCuestionarioDao(Database db) : super(db);

  /// Devuelve todos los bloques que pertenecen al cuestionario con id=[cuestionarioId]
  Future<List<DataClass>> _cargarCuestionario(String cuestionarioId) async {
    ///  Titulos del cuestionario
    final List<Tuple2<int, TituloD>> titulos =
        await _getTitulos(cuestionarioId);

    /// Preguntas numericas con sus rangos de criticidad
    final List<Tuple2<int, PreguntaNumerica>> numericas =
        await _getPreguntasNumericas(cuestionarioId);

    /// Preguntas de selección multiple y unica del cuestionario, con sus opciones de respuesta
    final List<Tuple2<int, PreguntaDeSeleccion>> preguntasSimples =
        await _getPreguntasSimples(cuestionarioId);

    /// Cuadriculas del cuestionario con sus preguntas y opciones de respuesta
    final List<Tuple2<int, CuadriculaConPreguntasYConOpcionesDeRespuesta>>
        cuadriculas = await _getCuadriculas(cuestionarioId);

    return (<Tuple2<int, DataClass>>[
      ...titulos,
      ...numericas,
      ...preguntasSimples,
      ...cuadriculas,
    ]..sort(
            (a, b) => a.value1.compareTo(b.value1),
          ))
        .map((e) => e.value2)
        .toList();
  }

  /// Los titulos, preguntas y cuadriculas son reunidas con el bloque, así
  /// podemos saber el orden en el que aparecerán en la UI.
  /// Los métodos que lo hacen son: [_getTitulos], [_getPreguntasNumericas],
  /// [_getPreguntasSimples], [_getCuadriculas] y [getCuadriculasSinPreguntas].
  /// Estos métodos son usados para cargar la edición o visualización de
  /// cuestionarios ya creados.

  /// Devuelve todos los titulos del cuestionario con id=[cuestionarioId]
  Future<List<Tuple2<int, TituloD>>> _getTitulos(String cuestionarioId) {
    final query = select(titulos).join([
      innerJoin(bloques, bloques.id.equalsExp(titulos.bloqueId)),
    ])
      ..where(bloques.cuestionarioId.equals(cuestionarioId));
    return query
        .map((row) => Tuple2(
              row.readTable(bloques).nOrden,
              TituloD(row.readTable(titulos)),
            ))
        .get();
  }

  /// Devuelve todos las preguntas numéricas del cuestionario con id=[cuestionarioId]
  Future<List<Tuple2<int, PreguntaNumerica>>> _getPreguntasNumericas(
      String cuestionarioId) async {
    final query = select(preguntas).join([
      innerJoin(
        bloques,
        bloques.id.equalsExp(preguntas.bloqueId),
      ),
    ])
      ..where(bloques.cuestionarioId.equals(cuestionarioId) &
          preguntas.tipoDePregunta.equalsValue(TipoDePregunta.numerica));

    final res = await query
        .map((row) => Tuple2(row.readTable(bloques), row.readTable(preguntas)))
        .get();

    return Future.wait(res.map((c) async {
      final bloque = c.value1;
      final pregunta = c.value2;

      final criticidades = await _getCriticidades(pregunta.id);
      final etiquetas = await _getEtiquetasDePregunta(pregunta.id);

      return Tuple2(
        bloque.nOrden,
        PreguntaNumerica(
          pregunta,
          criticidades,
          etiquetas,
        ),
      );
    }));
  }

  /// Devuelve todas las preguntas de selección única o múltiple del cuestionario con id=[cuestionarioId]
  Future<List<Tuple2<int, PreguntaDeSeleccion>>> _getPreguntasSimples(
      String cuestionarioId) async {
    final query = select(preguntas).join([
      innerJoin(bloques, bloques.id.equalsExp(preguntas.bloqueId)),
    ])
      ..where(bloques.cuestionarioId.equals(cuestionarioId) &
          (preguntas.tipoDePregunta.equalsValue(TipoDePregunta.seleccionUnica) |
              preguntas.tipoDePregunta
                  .equalsValue(TipoDePregunta.seleccionMultiple)));
    final res = await query
        .map((row) => Tuple2(row.readTable(bloques), row.readTable(preguntas)))
        .get();

    return Future.wait(res.map((c) async {
      final bloque = c.value1;
      final pregunta = c.value2;

      final opciones = await _getOpciones(pregunta.id);
      final etiquetas = await _getEtiquetasDePregunta(pregunta.id);

      return Tuple2(
        bloque.nOrden,
        PreguntaDeSeleccion(
          pregunta,
          opciones,
          etiquetas,
        ),
      );
    }));
  }

  /// Devuelve todas las cuadriculas  del cuestionario con id=[cuestionarioId]
  /// con sus respectivas preguntas y opciones de respuesta
  Future<List<Tuple2<int, CuadriculaConPreguntasYConOpcionesDeRespuesta>>>
      _getCuadriculas(String cuestionarioId) async {
    final query = select(preguntas).join([
      innerJoin(bloques, bloques.id.equalsExp(preguntas.bloqueId)),
    ])
      ..where(bloques.cuestionarioId.equals(cuestionarioId) &
          preguntas.tipoDePregunta.equalsValue(TipoDePregunta.cuadricula));

    final cuadriculas = await query
        .map((row) => Tuple2(row.readTable(bloques), row.readTable(preguntas)))
        .get();

    return Future.wait(cuadriculas.map((c) async {
      final bloque = c.value1;
      final cuadricula = c.value2;

      final opciones = await _getOpciones(cuadricula.id);
      final etiquetas = await _getEtiquetasDePregunta(cuadricula.id);
      final subPreguntas = await _getSubPreguntas(cuadricula.id);

      return Tuple2(
        bloque.nOrden,
        CuadriculaConPreguntasYConOpcionesDeRespuesta(
          PreguntaDeSeleccion(
            cuadricula,
            opciones,
            etiquetas,
          ),
          subPreguntas
              .map((p) => PreguntaDeSeleccion(p, const [], const []))
              .toList(),
        ),
      );
    }));
  }

  Future<List<OpcionDeRespuesta>> _getOpciones(String preguntaId) =>
      (select(opcionesDeRespuesta)
            ..where((o) => o.preguntaId.equals(preguntaId)))
          .get();

  Future<List<EtiquetaDePregunta>> _getEtiquetasDePregunta(String preguntaId) =>
      (select(etiquetasDePregunta).join(
        [
          innerJoin(preguntasXEtiquetas,
              preguntasXEtiquetas.etiquetaId.equalsExp(etiquetasDePregunta.id))
        ],
      )..where(preguntasXEtiquetas.preguntaId.equals(preguntaId)))
          .map((row) => row.readTable(etiquetasDePregunta))
          .get();

  Future<List<EtiquetaDeActivo>> _getEtiquetasDeActivos(
          String cuestionarioId) =>
      (select(etiquetasDeActivo).join(
        [
          innerJoin(
              cuestionariosXEtiquetas,
              cuestionariosXEtiquetas.etiquetaId
                  .equalsExp(etiquetasDeActivo.id))
        ],
      )..where(cuestionariosXEtiquetas.cuestionarioId.equals(cuestionarioId)))
          .map((row) => row.readTable(etiquetasDeActivo))
          .get();

  Future<List<CriticidadNumerica>> _getCriticidades(String preguntaId) =>
      (select(criticidadesNumericas)
            ..where((c) => c.preguntaId.equals(preguntaId)))
          .get();

  Future<List<Pregunta>> _getSubPreguntas(String cuadriculaId) =>
      (select(preguntas)..where((p) => p.cuadriculaId.equals(cuadriculaId)))
          .get();

  Future<CuestionarioCompleto> getCuestionarioCompleto(
      String cuestionarioId) async {
    final cuestionario = await _getCuestionario(cuestionarioId);
    final etiquetas = await _getEtiquetasDeActivos(cuestionarioId);
    final bloques = await _cargarCuestionario(cuestionarioId);

    return CuestionarioCompleto(cuestionario, etiquetas, bloques);
  }

  Future<Cuestionario> _getCuestionario(String cuestionarioId) =>
      (select(cuestionarios)..where((c) => c.id.equals(cuestionarioId)))
          .getSingle();

  /// Devuelve todos los tipos de inspección existentes para la creación y edición.
  Future<List<String>> getTiposDeInspecciones() {
    final query = selectOnly(cuestionarios, distinct: true)
      ..where(cuestionarios.tipoDeInspeccion.isNotNull())
      ..addColumns([cuestionarios.tipoDeInspeccion]);

    return query.map((row) => row.read(cuestionarios.tipoDeInspeccion)!).get();
  }

  Stream<List<Cuestionario>> watchCuestionarios() =>
      select(cuestionarios).watch();

  Future<Cuestionario> getCuestionario(String cuestionarioId) {
    final query = select(cuestionarios)
      ..where((u) => u.id.equals(cuestionarioId));

    return query.getSingle();
  }

  /// Elimina el cuestionario con id=[cuestionario.id] y en cascada los bloques,
  ///  titulos y preguntas asociadas
  Future<void> eliminarCuestionario(Cuestionario cuestionario) async {
    await (delete(cuestionarios)..where((c) => c.id.equals(cuestionario.id)))
        .go();
  }

  Future<List<EtiquetaDeActivo>> getEtiquetas() =>
      select(etiquetasDeActivo).get();
/*
/// Devuelve los cuestionarios cuyo tipoDeInspeccion=[tipoDeInspeccion] y que
  ///  sean aplicables a [etiquetas].
  /// Es usado para hacer la validación de que no se cree un nuevo cuestionario
  ///  con un [tipoDeInspeccion] que ya existe
  /// y que está aplicada a las mismas [etiquetas].
  Future<List<Cuestionario>> getCuestionarios(
      String tipoDeInspeccion, List<EtiquetaDeActivo> etiquetas) {
    final query = select(cuestionarioDeModelos).join([
      innerJoin(cuestionarios,
          cuestionarios.id.equalsExp(cuestionarioDeModelos.cuestionarioId))
    ])
      ..where(cuestionarios.tipoDeInspeccion.equals(tipoDeInspeccion) &
          cuestionarioDeModelos.modelo.isIn(modelos));

    return query.map((row) => row.readTable(cuestionarios)).get();
  }*/
}
