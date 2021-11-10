import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inspecciones/infrastructure/drift_database.dart';
import 'package:inspecciones/infrastructure/tablas_unidas.dart';
import 'package:inspecciones/utils/iterable_x.dart';

part 'carga_cuestionario_dao.drift.dart';

@DriftAccessor(tables: [
  Activos,
  Cuestionarios,
  Bloques,
  Titulos,
  Preguntas,
  CriticidadesNumericas,
  OpcionesDeRespuesta,
])
class CargaDeCuestionarioDao extends DatabaseAccessor<Database>
    with _$CargaDeCuestionarioDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  CargaDeCuestionarioDao(Database db) : super(db);

  /// Devuelve todos los bloques que pertenecen al cuestionario con id=[cuestionarioId]
  Future<List<IBloqueOrdenable>> cargarCuestionario(
      String cuestionarioId) async {
    ///  Titulos del cuestionario
    final List<BloqueConTitulo> titulos = await _getTitulos(cuestionarioId);

    /// Preguntas numericas con sus rangos de criticidad
    final List<BloqueConPreguntaNumerica> numericas =
        await _getPreguntasNumericas(cuestionarioId);

    /// Preguntas de selección multiple y unica del cuestionario, con sus opciones de respuesta
    final List<BloqueConPreguntaSimple> preguntasSimples =
        await _getPreguntasSimples(cuestionarioId);

    /// Cuadriculas del cuestionario con sus preguntas y opciones de respuesta
    final List<BloqueConCuadricula> cuadriculas =
        await _getCuadriculas(cuestionarioId);

    return [
      ...titulos,
      ...numericas,
      ...preguntasSimples,
      ...cuadriculas,
    ];
  }

  /// Los titulos, preguntas y cuadriculas son reunidas con el bloque, así
  /// podemos saber el orden en el que aparecerán en la UI.
  /// Los métodos que lo hacen son: [_getTitulos], [_getPreguntasNumericas],
  /// [_getPreguntasSimples], [_getCuadriculas] y [getCuadriculasSinPreguntas].
  /// Estos métodos son usados para cargar la edición o visualización de
  /// cuestionarios ya creados.

  /// Devuelve todos los titulos del cuestionario con id=[cuestionarioId]
  Future<List<BloqueConTitulo>> _getTitulos(String cuestionarioId) {
    final query = select(titulos).join([
      innerJoin(bloques, bloques.id.equalsExp(titulos.bloqueId)),
    ])
      ..where(bloques.cuestionarioId.equals(cuestionarioId));
    return query
        .map((row) => BloqueConTitulo(
              row.readTable(bloques),
              row.readTable(titulos),
            ))
        .get();
  }

  /// Devuelve todos las preguntas numéricas del cuestionario con id=[cuestionarioId]
  Future<List<BloqueConPreguntaNumerica>> _getPreguntasNumericas(
      String cuestionarioId) async {
    final query = select(preguntas).join([
      innerJoin(
        bloques,
        bloques.id.equalsExp(preguntas.bloqueId),
      ),

      /// Para que carguen también las numéricas a las que no se le han asignado lass criticidades
      leftOuterJoin(criticidadesNumericas,
          criticidadesNumericas.preguntaId.equalsExp(preguntas.id)),
    ])
      ..where(bloques.cuestionarioId.equals(cuestionarioId) &
          preguntas.tipoDePregunta.equalsValue(TipoDePregunta.numerica));

    final res = await query
        .map((row) => Tuple3(
              row.readTable(bloques),
              row.readTable(preguntas),
              row.readTableOrNull(criticidadesNumericas),
            ))
        .get();

    return groupBy<Tuple3<Bloque, Pregunta, CriticidadNumerica?>, Pregunta>(
            res, (e) => e.value2)
        .entries
        .map((entry) => BloqueConPreguntaNumerica(
              entry.value.first.value1,
              PreguntaNumerica(
                entry.key,
                entry.value.map((e) => e.value3).allNullToEmpty().toList(),
              ),
            ))
        .toList();
  }

  /// Devuelve todas las preguntas de selección única o múltiple del cuestionario con id=[cuestionarioId]
  Future<List<BloqueConPreguntaSimple>> _getPreguntasSimples(
      String cuestionarioId) async {
    final query = select(preguntas).join([
      innerJoin(bloques, bloques.id.equalsExp(preguntas.bloqueId)),

      /// Para que carguen las preguntas a las que no se les ha asociado una opción de respuesta
      leftOuterJoin(opcionesDeRespuesta,
          opcionesDeRespuesta.preguntaId.equalsExp(preguntas.id)),
    ])
      ..where(bloques.cuestionarioId.equals(cuestionarioId) &
          (preguntas.tipoDePregunta.equalsValue(TipoDePregunta.seleccionUnica) |
              preguntas.tipoDePregunta
                  .equalsValue(TipoDePregunta.seleccionMultiple)));
    final res = await query
        .map((row) => Tuple3(row.readTable(bloques), row.readTable(preguntas),
            row.readTableOrNull(opcionesDeRespuesta)))
        .get();

    return groupBy<Tuple3<Bloque, Pregunta, OpcionDeRespuesta?>, Pregunta>(
        res, (e) => e.value2).entries.map(
      (entry) {
        return BloqueConPreguntaSimple(
          entry.value.first.value1,
          PreguntaConOpcionesDeRespuesta(
            entry.key,
            entry.value.map((e) => e.value3).allNullToEmpty().toList(),
          ),
        );
      },
    ).toList();
  }

  /// Devuelve todas las cuadriculas  del cuestionario con id=[cuestionarioId] con sus respectivas preguntas y opciones de respuesta
  Future<List<BloqueConCuadricula>> _getCuadriculas(
      String cuestionarioId) async {
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

      final opciones = await (select(opcionesDeRespuesta)
            ..where((o) => o.preguntaId.equals(cuadricula.id)))
          .get();
      final subPreguntas = await (select(preguntas)
            ..where((p) => p.cuadriculaId.equals(cuadricula.id)))
          .get();

      return BloqueConCuadricula(
        bloque,
        CuadriculaDePreguntasConOpcionesDeRespuesta(
          cuadricula,
          opciones,
        ),
        subPreguntas
            .map((p) => PreguntaConOpcionesDeRespuesta(p, const []))
            .toList(),
      );
    }));
  }

  /// Devuelve todos los tipos de inspección existentes para la creación y edición.
  Future<List<String>> getTiposDeInspecciones() {
    final query = selectOnly(cuestionarios, distinct: true)
      ..where(cuestionarios.tipoDeInspeccion.isNotNull())
      ..addColumns([cuestionarios.tipoDeInspeccion]);

    return query.map((row) => row.read(cuestionarios.tipoDeInspeccion)!).get();
  }

  /// Devuelve Stream con los cuestionarios creados que se usa en cuestionarios_screen.dart
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

  /*
  /// Devuelve los cuestionarios cuyo tipoDeInspeccion=[tipoDeInspeccion] y que sean aplicables a [modelos].
  /// Es usado para hacer la validación de que no se cree un nuevo cuestionario con un [tipoDeInspeccion] que ya existe
  /// y que está aplicada a los mismos [modelos].
  Future<List<Cuestionario>> getCuestionarios(
      String tipoDeInspeccion, List<String> modelos) {
    final query = select(cuestionarioDeModelos).join([
      innerJoin(cuestionarios,
          cuestionarios.id.equalsExp(cuestionarioDeModelos.cuestionarioId))
    ])
      ..where(cuestionarios.tipoDeInspeccion.equals(tipoDeInspeccion) &
          cuestionarioDeModelos.modelo.isIn(modelos));

    return query.map((row) => row.readTable(cuestionarios)).get();
  }*/
}
