import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inspecciones/infrastructure/drift_database.dart';
import 'package:inspecciones/infrastructure/tablas_unidas.dart';
import 'package:inspecciones/utils/iterable_x.dart';

part 'carga_cuestionario_dao.drift.dart';

@DriftAccessor(tables: [
  Sistemas,
  SubSistemas,
  CuestionarioDeModelos,
  Contratistas,
  Activos,
  Cuestionarios,
  Titulos,
  Bloques,
  Preguntas,
  CriticidadesNumericas,
  OpcionesDeRespuesta,
  CuadriculasDePreguntas,
])
class CargaDeCuestionarioDao extends DatabaseAccessor<Database>
    with _$CargaDeCuestionarioDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  CargaDeCuestionarioDao(Database db) : super(db);

  //datos para la creacion de cuestionarios
  /// El cuestionario trae el sistemaId [id], para poder mostrar el [Sistema] en el formulario de creación, se obtiene así
  Future<Sistema> getSistemaPorId(int id) async {
    final query = select(sistemas)..where((s) => s.id.equals(id));
    return query.getSingle();
  }

  /// Cada pregunta tiene el subsitemaId [id], para poder mostrar el [SubSistema] en el formulario de creación, se obtiene así
  Future<SubSistema> getSubSistemaPorId(int id) async {
    final query = select(subSistemas)..where((s) => s.id.equals(id));
    return query.getSingle();
  }

  /// Devuelve los modelos y el contratista asociado a [cuestionario]
  /// Se usa principalmente a la hora de cargar el borrador del cuestionario para edición
  Future<CuestionarioConContratistaYModelos> getModelosYContratista(
      int cuestionarioId) async {
    final query = select(cuestionarioDeModelos).join([
      leftOuterJoin(contratistas,
          contratistas.id.equalsExp(cuestionarioDeModelos.contratistaId)),
    ])
      ..where(cuestionarioDeModelos.cuestionarioId.equals(cuestionarioId));

    final res = await query
        .map((row) => Tuple2(
              row.readTable(cuestionarioDeModelos),
              row.readTableOrNull(contratistas),
            ))
        .get();
    final cuestionario = await getCuestionario(cuestionarioId);

    return CuestionarioConContratistaYModelos(
      cuestionario,
      res.map((cu) => cu.value1).toList(),
      //! se asume que es el mismo contratista para todos
      res.isEmpty ? null : res.first.value2,
    );
  }

  /// Devuelve los todos los modelos para la creación y edición de cuestionarios
  Future<List<String>> getModelos() {
    final query = selectOnly(activos, distinct: true)
      ..addColumns([activos.modelo]);

    return query.map((row) => row.read(activos.modelo)!).get();
  }

  /// Devuelve todos los tipos de inspección existentes para la creación y edición.
  Future<List<String>> getTiposDeInspecciones() {
    final query = selectOnly(cuestionarios, distinct: true)
      ..where(cuestionarios.tipoDeInspeccion.isNotNull())
      ..addColumns([cuestionarios.tipoDeInspeccion]);

    return query.map((row) => row.read(cuestionarios.tipoDeInspeccion)!).get();
  }

  /// Devuelve todos los contratistas usados para la creación y edición.
  Future<List<Contratista>> getContratistas() => select(contratistas).get();

  /// Devuelve todos los sistemas usados para la creación y edición.
  Future<List<Sistema>> getSistemas() => select(sistemas).get();

  /// Devuelve los subsistemas que están asociados con [sistema]
  Future<List<SubSistema>> getSubSistemas(Sistema sistema) {
    final query = select(subSistemas)
      ..where((u) => u.sistemaId.equals(sistema.id));

    return query.get();
  }

  /// Devuelve Stream con los cuestionarios creados que se usa en cuestionarios_screen.dart
  Stream<List<Cuestionario>> watchCuestionarios() =>
      select(cuestionarios).watch();

  Future<Cuestionario> getCuestionario(int cuestionarioId) {
    final query = select(cuestionarios)
      ..where((u) => u.id.equals(cuestionarioId));

    return query.getSingle();
  }

  /// Elimina el cuestionario con id=[cuestionario.id] y en cascada los bloques, titulos y preguntas asociadas
  Future eliminarCuestionario(Cuestionario cuestionario) async {
    await (delete(cuestionarios)..where((c) => c.id.equals(cuestionario.id)))
        .go();
  }

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
  }

  /// Los titulos, preguntas y cuadriculas son reunidas con el bloque, así podemos saber el orden en el que aparecerán en la UI.
  /// Los métodos que lo hacen son: [getTitulos], [getPreguntaNumerica],[getPreguntasSimples],
  /// [getCuadriculas] y [getCuadriculasSinPreguntas].
  /// Estos métodos son usados para cargar la edición o visualización de cuestionarios ya creados.

  /// Devuelve todos los titulos del cuestionario con id=[cuestionarioId]
  Future<List<BloqueConTitulo>> getTitulos(int cuestionarioId) {
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
  Future<List<BloqueConPreguntaNumerica>> getPreguntaNumerica(
      int cuestionarioId) async {
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

          /// Toma solo [TipoDePregunta.numerica]
          (preguntas.tipo.equals(4)));

    final res = await query
        .map((row) => Tuple3(
              row.readTable(bloques),
              row.readTable(preguntas),
              row.readTableOrNull(criticidadesNumericas),
            ))
        .get();

    return groupBy<Tuple3<Bloque, Pregunta, CriticidadesNumerica?>, Pregunta>(
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
  Future<List<BloqueConPreguntaSimple>> getPreguntasSimples(
      int cuestionarioId) async {
    final opcionesPregunta = alias(opcionesDeRespuesta, 'op');

    final query = select(preguntas).join([
      innerJoin(bloques, bloques.id.equalsExp(preguntas.bloqueId)),

      /// Para que carguen las preguntas a las que no se les ha asociado una opción de respuesta
      leftOuterJoin(opcionesPregunta,
          opcionesPregunta.preguntaId.equalsExp(preguntas.id)),
    ])
      ..where(bloques.cuestionarioId.equals(cuestionarioId) &

          /// Toma solo [TipoDePregunta.unicaRespuesta] o [TipoDePregunta.multipleRespuesta]
          (preguntas.tipo.equals(0) | preguntas.tipo.equals(1)));
    final res = await query
        .map((row) => Tuple3(row.readTable(bloques), row.readTable(preguntas),
            row.readTableOrNull(opcionesPregunta)))
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
  Future<List<BloqueConCuadricula>> getCuadriculas(
    int cuestionarioId,
  ) async {
    final query1 = select(cuadriculasDePreguntas).join([
      innerJoin(bloques, bloques.id.equalsExp(cuadriculasDePreguntas.bloqueId)),
      leftOuterJoin(preguntas, preguntas.bloqueId.equalsExp(bloques.id)),
    ])
      ..where(bloques.cuestionarioId.equals(cuestionarioId));
    //parteDeCuadriculaUnica

    final res = await query1
        .map((row) => Tuple3(
              row.readTableOrNull(preguntas),
              row.readTable(bloques),
              row.readTable(cuadriculasDePreguntas),
            ))
        .get();

    return Future.wait(
      groupBy<Tuple3<Pregunta?, Bloque, CuadriculaDePreguntas>, Bloque>(
          res, (e) => e.value2).entries.map((entry) async {
        return BloqueConCuadricula(
          entry.key,
          CuadriculaDePreguntasConOpcionesDeRespuesta(
            entry.value.first.value3,

            /// Lista de opciones de respuesta asociada a la cuadricula
            await getRespuestasDeCuadricula(entry.value.first.value3.id),
          ),
          entry.value
              .map((e) => e.value1)
              .allNullToEmpty()
              .map(
                (e) => PreguntaConOpcionesDeRespuesta(e,
                    const []), // Envia lista vacia en las opciones de respuesta, porque ya van en [CuadriculaDePreguntasConOpcionesDeRespuesta]
              )
              .toList(),
        );
      }),
    );
  }

  /// Devuelve las opciones de respuesta asociadas a la cuadricula con id = [cuadriculaId]
  Future<List<OpcionDeRespuesta>> getRespuestasDeCuadricula(
      int cuadriculaId) async {
    final query = select(opcionesDeRespuesta)
      ..where((or) => or.cuadriculaId.equals(cuadriculaId));
    return query.get();
  }

  /// Devuelve todos los bloques que pertenecen al cuestionario con id=[cuestionarioId]
  Future<List<IBloqueOrdenable>> cargarCuestionario(int cuestionarioId) async {
    ///  Titulos del cuestionario
    final List<BloqueConTitulo> titulos = await getTitulos(cuestionarioId);

    /// Preguntas de selección multiple y unica del cuestionario, con sus opciones de respuesta
    final List<BloqueConPreguntaSimple> preguntasSimples =
        await getPreguntasSimples(cuestionarioId);

    /// Cuadriculas del cuestionario con sus preguntas y opciones de respuesta
    final List<BloqueConCuadricula> cuadriculas =
        await getCuadriculas(cuestionarioId);

    /// Preguntas numericas con sus rangos de criticidad
    final List<BloqueConPreguntaNumerica> numerica =
        await getPreguntaNumerica(cuestionarioId);

    return [
      ...titulos,
      ...preguntasSimples,
      ...cuadriculas,
      ...numerica,
/*       ...preguntasCondicionales */
    ];
  }
}
