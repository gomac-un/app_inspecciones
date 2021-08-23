import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/kt.dart';
import 'package:moor/moor.dart';

import 'package:inspecciones/infrastructure/fotos_manager.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/mvvc/creacion_form_controller.dart';

part 'creacion_dao.g.dart';

/// Acceso a los datos de la Bd.
///
/// Incluye los métodos necesarios para  insertar, actualizar, borrar y consultar la información
/// relacionada con la creación de cuestionarios.
@UseDao(tables: [
  /// Definición de las tablas a las que necesitamos acceder para obtener la información
  Activos,
  CuestionarioDeModelos,
  Cuestionarios,
  Bloques,
  Titulos,
  CuadriculasDePreguntas,
  Preguntas,
  OpcionesDeRespuesta,
  Inspecciones,
  Respuestas,
  Contratistas,
  Sistemas,
  SubSistemas,
  CriticidadesNumericas,
])
class CreacionDao extends DatabaseAccessor<Database> with _$CreacionDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  CreacionDao(Database db) : super(db);

  ///! prueba borrar
  Future<bool> updateTitulo(Titulo titulo) {
    // using replace will update all fields from the entry that are not marked as a primary key.
    // it will also make sure that only the entry with the same primary key will be updated.
    // Here, this means that the row that has the same id as entry will be updated to reflect
    // the entry's title, content and category. As its where clause is set automatically, it
    // cannot be used together with where.
    //update(titulos).write(titulo);
    return update(titulos).replace(titulo);
  }

  // returns the generated id
  Future<int> addTitulo(TitulosCompanion titulo) {
    // If a column is nullable or has a default value (this includes
    //auto-increments), the field can be omitted. All other fields must be set
    //and non-null. The insert method will throw otherwise.
    return into(titulos).insert(titulo);
  }

  Future<int> upsertTitulo(Titulo titulo) {
    return into(titulos).insertOnConflictUpdate(titulo);
  }

  ///! fin prueba

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
        .map((row) => Tuple2(row.readTable(cuestionarioDeModelos),
            row.readTableOrNull(contratistas)))
        .get();
    final cuestionario = await getCuestionario(cuestionarioId);

    return CuestionarioConContratistaYModelos(
      cuestionario,
      res.map((cu) => cu.value1).toList(),
      res.first.value2!, //! se asume que es el mismo contratista para todos
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
              row.readTable(criticidadesNumericas),
            ))
        .get();

    return groupBy<Tuple3<Bloque, Pregunta, CriticidadesNumerica>, Pregunta>(
            res, (e) => e.value2)
        .entries
        .map((entry) => BloqueConPreguntaNumerica(
              entry.value.first.value1,
              PreguntaNumerica(
                entry.key,
                entry.value.map((item) => item.value3).toList(),
              ),
              null,
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
          (preguntas.tipo.equals(0) | preguntas.tipo.equals(1)) &
          preguntas.esCondicional.equals(false));
    final res = await query
        .map((row) => Tuple3(row.readTable(bloques), row.readTable(preguntas),
            row.readTable(opcionesPregunta)))
        .get();

    return groupBy<Tuple3<Bloque, Pregunta, OpcionDeRespuesta>, Pregunta>(
        res, (e) => e.value2).entries.map(
      (entry) {
        return BloqueConPreguntaSimple(
          entry.value.first.value1,
          PreguntaConOpcionesDeRespuesta(
            entry.key,
            entry.value.map((e) => e.value3).toList(),
          ),
          null,
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
              row.readTable(preguntas),
              row.readTable(bloques),
              row.readTable(cuadriculasDePreguntas),
            ))
        .get();

    return Future.wait(
      groupBy<Tuple3<Pregunta, Bloque, CuadriculaDePreguntas>, Bloque>(
          res, (e) => e.value2).entries.map((entry) async {
        return BloqueConCuadricula(
          entry.key,
          CuadriculaDePreguntasConOpcionesDeRespuesta(
            entry.value.first.value3,

            /// Lista de opciones de respuesta asociada a la cuadricula
            await respuestasDeCuadricula(entry.value.first.value3.id),
          ),
          preguntas: entry.value
              .map(
                (item) =>

                    /// Envia lista vacia en las opciones de respuesta, porque ya van en [CuadriculaDePreguntasConOpcionesDeRespuesta]
                    PreguntaConOpcionesDeRespuesta(item.value1, []),
              )
              .toList(),
        );
      }),
    );
  }

  /// Devuelve las opciones de respuesta asociadas a la cuadricula con id = [cuadriculaId]
  Future<List<OpcionDeRespuesta>> respuestasDeCuadricula(
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

  /// Verifica si ya existe un cuestionario o se debe crear uno nuevo
  Future<Cuestionario> getAndUpdateOrCreateCuestionarioToSave(
    Cuestionario cuestionario,
  ) async {
    /// En caso de que [cuestionario] no esté guardado en la BD
    if (cuestionario.id == null)
      return crearCuestionarioToSave(
          cuestionario); //TODO: revisar la nulidad del id de las entidades sin guardar

    /// Si existe, se actualiza con los nuevos datos de [tipoDeInspeccion] y [estado]
    final query = select(cuestionarios)
      ..where((cues) => cues.id.equals(cuestionario.id));

    await (update(cuestionarios)..where((c) => c.id.equals(cuestionario.id)))
        .write(
      CuestionariosCompanion(
        tipoDeInspeccion: Value(cuestionario.tipoDeInspeccion),
        estado: Value(cuestionario.estado),
      ),
    );

    return query.getSingle();
  }

  /// Crea un cuestionario en el momento que el usuario presiona guardar y lo devuelve
  ///
  /// [cuestionario] trae la info de [tipoDeInspeccion] y [estado] que son los unicos datos que se pueden actualizar.
  Future<Cuestionario> crearCuestionarioToSave(
      Cuestionario cuestionario) async {
    ///Primero lo iserta en la bd
    final int cid = await into(cuestionarios).insert(
      CuestionariosCompanion.insert(
        tipoDeInspeccion: cuestionario.tipoDeInspeccion,
        estado: cuestionario.estado,
      ),
    );

    /// Luego lo consulta de la BD y lo devuelve
    return (select(cuestionarios)..where((i) => i.id.equals(cid))).getSingle();
  }

  /// Guarda o crea un cuestionario con sus respectivas preguntas.
  Future<void> guardarCuestionario(
      Cuestionario cuestionario,

      /// Información sobre los modelos a los que aplica [cuestionario], periodicidad y contratista
      List<CuestionarioDeModelo> cuestionariosDeModelo,
      List<IBloqueOrdenable> bloquesAGuardar) async {
    return transaction(
      () async {
        /// Obtiene el cuestionario existente o null si es nuevo
        Cuestionario cuesti = await getOrCreateCuestionarioToSave(cuestionario);

        form.cuestionario = cuesti;

        /// Lista de los ids de cuestionarioDeModelos que se insertarán en la actualización
        final List<int> mo = [];
        await Future.forEach<CuestionarioDeModelo>(cuestionariosDeModelo,
            (e) async {
          //Mover las fotos a una carpeta unica para cada cuestionario
          final id = Value(e.id).present;

          /// Se le asigna [cuesti] como cuestionario asociado
          e = e.copyWith(cuestionarioId: cuesti.id);
          if (id) {
            final x =
                await into(cuestionarioDeModelos).insertOnConflictUpdate(e);
            mo.add(x);
          } else {
            mo.add(await into(cuestionarioDeModelos).insert(e));
          }
        });

        /// En caso de que se haya deseleccionado un modelo para [cuestionario], se elimina de la bd
        await (delete(cuestionarioDeModelos)
              ..where((rxor) =>
                  rxor.id.isNotIn(mo) & rxor.cuestionarioId.equals(cuesti.id)))
            .go();

        /// Id de los bloques que se van a guardar, para saber cuales se deben borrar
        /// (Los que en una versión anterior del cuestionario existían y fueron borrados desde el form)
        final List<int> bloquesId = [];
        await Future.forEach<IBloqueOrdenable>(bloquesAGuardar, (e) async {
          /// Asignación de [cuesti] como cuestionario del bloque
          final bloque = e.bloque
              .toCompanion(true)
              .copyWith(cuestionarioId: Value(cuesti.id));
          int bloqueId;
          if (bloque.id.present) {
            bloqueId = await into(bloques).insertOnConflictUpdate(bloque);
          } else {
            bloqueId = await into(bloques).insert(bloque);
          }
          bloquesId.add(bloqueId);

          /// Empieza el procesamiento de cada bloque de acuerdo a si es titulo, pregunta de selección o
          /// numerica y cuadricula.
          /// En los condicionales, se mira de que tipo especifico es el IBloqueOrdenable [e], para er la definición de
          /// cada tipo especifico, ver [tablas_unidas.dart]
          /// Se le asigna a cada pregunta o titulo [bloqueId]
          if (e is BloqueConTitulo) {
            final titulo =
                e.titulo.toCompanion(true).copyWith(bloqueId: Value(bloqueId));
            if (titulo.id.present) {
              await into(titulos).insertOnConflictUpdate(titulo);
            } else {
              await into(titulos).insert(titulo);
            }
          }

          if (e is BloqueConPreguntaSimple) {
            final fotosGuiaProcesadas = await FotosManager.organizarFotos(
              e.pregunta.pregunta.fotosGuia,
              tipoDocumento: "cuestionarios",
              idDocumento: cuesti.id.toString(),
            );
            final pregunta = e.pregunta.pregunta.toCompanion(true).copyWith(
                  bloqueId: Value(bloqueId),
                  fotosGuia: Value(fotosGuiaProcesadas.toImmutableList()),
                );
            int preguntaId;
            if (pregunta.id.present) {
              await into(preguntas).insertOnConflictUpdate(pregunta);
              preguntaId = e.pregunta.pregunta.id;
            } else {
              preguntaId = await into(preguntas).insert(pregunta);
            }

            /// Inserción de la opciones de respuesta de la pregunta
            final List<int> opcionesId = [];
            await Future.forEach<OpcionDeRespuesta>(
                e?.pregunta?.opcionesDeRespuesta, (or) async {
              /// Asociación de cada opción con [preguntaId]
              final opcion =
                  or.toCompanion(true).copyWith(preguntaId: Value(preguntaId));

              int opcionId;
              if (opcion.id.present) {
                await into(opcionesDeRespuesta).insertOnConflictUpdate(opcion);
                opcionId = opcion.id.value;
              } else {
                opcionId = await into(opcionesDeRespuesta).insert(opcion);
              }
              opcionesId.add(opcionId);
            });

            /// Se eliminan de la bd las opciones de respuesta que fueron eliminadas desde el form
            await (delete(opcionesDeRespuesta)
                  ..where((rxor) =>
                      rxor.id.isNotIn(opcionesId) &
                      rxor.preguntaId.equals(preguntaId)))
                .go();
          }
          if (e is BloqueConCuadricula) {
            final cuadricula =
                e.cuadricula.cuadricula.toCompanion(true).copyWith(
                      bloqueId: Value(bloqueId),
                    );
            int cuadriculaId;
            if (cuadricula.id.present) {
              await into(cuadriculasDePreguntas)
                  .insertOnConflictUpdate(cuadricula);
              cuadriculaId = e.cuadricula.cuadricula.id;
            } else {
              cuadriculaId =
                  await into(cuadriculasDePreguntas).insert(cuadricula);
            }
            final List<int> preguntasId = [];

            /// Inserción de las preguntas de la cuadricula
            await Future.forEach<PreguntaConOpcionesDeRespuesta>(e?.preguntas,
                (or) async {
              //Mover las fotos a una carpeta unica para cada inspeccion
              /// En este caso, las preguntas se asocian a la cuadricula por medio del bloque
              final pregunta = or.pregunta
                  .toCompanion(true)
                  .copyWith(bloqueId: Value(bloqueId));
              int preguntaId;
              if (pregunta.id.present) {
                await into(preguntas).insertOnConflictUpdate(pregunta);
                preguntaId = or.pregunta.id;
              } else {
                preguntaId = await into(preguntas).insert(pregunta);
              }
              preguntasId.add(preguntaId);
            });

            /// Se eliminan de la bd las preguntas eliminadas desde el form.
            await (delete(preguntas)
                  ..where((rxor) =>
                      rxor.id.isNotIn(preguntasId) &
                      rxor.bloqueId.equals(bloqueId)))
                .go();
            final List<int> opcionesId = [];

            /// Inserción de las opciones de respuesta para la cuadricula.
            await Future.forEach<OpcionDeRespuesta>(
                e?.cuadricula?.opcionesDeRespuesta, (or) async {
              /// Las opciones se asocian directamente a la cuadricula y no a una pregunta.
              final opcion = or
                  .toCompanion(true)
                  .copyWith(cuadriculaId: Value(cuadriculaId));

              int opcionId;
              if (opcion.id.present) {
                await into(opcionesDeRespuesta).insertOnConflictUpdate(opcion);
                opcionId = opcion.id.value;
              } else {
                opcionId = await into(opcionesDeRespuesta).insert(opcion);
              }
              opcionesId.add(opcionId);
            });

            /// Se eliminan de la bd las opciones de respuesta que se eliminaron desde el form.
            await (delete(opcionesDeRespuesta)
                  ..where((rxor) =>
                      rxor.id.isNotIn(opcionesId) &
                      rxor.cuadriculaId.equals(cuadriculaId)))
                .go();
          }
          if (e is BloqueConPreguntaNumerica) {
            final fotosGuiaProcesadas = await FotosManager.organizarFotos(
              e.pregunta.pregunta.fotosGuia,
              tipoDocumento: "cuestionarios",
              idDocumento: cuesti.id.toString(),
            );
            final pregunta = e.pregunta.pregunta.toCompanion(true).copyWith(
                  bloqueId: Value(bloqueId),
                  fotosGuia: Value(fotosGuiaProcesadas.toImmutableList()),
                );
            int preguntaId;
            if (pregunta.id.present) {
              await into(preguntas).insertOnConflictUpdate(pregunta);
              preguntaId = e.pregunta.pregunta.id;
            } else {
              preguntaId = await into(preguntas).insert(pregunta);
            }
            final List<int> criticidadesId = [];

            /// Insercion de las criticidades (rangos) para la pregunta numérica.
            await Future.forEach<CriticidadesNumerica>(
                e?.pregunta?.criticidades, (cri) async {
              /// A sociación de cada rango de criticidad con la pregunta.
              final criticidad =
                  cri.toCompanion(true).copyWith(preguntaId: Value(preguntaId));

              int criticidadId;
              if (criticidad.id.present) {
                await into(criticidadesNumericas)
                    .insertOnConflictUpdate(criticidad);
                criticidadId = criticidad.id.value;
              } else {
                criticidadId =
                    await into(criticidadesNumericas).insert(criticidad);
              }
              criticidadesId.add(criticidadId);
            });

            /// Se eliminan de la bd los rangos de criticidad que fueron eliminados desde el form.
            await (delete(criticidadesNumericas)
                  ..where((cri) =>
                      cri.id.isNotIn(criticidadesId) &
                      cri.preguntaId.equals(preguntaId)))
                .go();
          }
        });

        /// Eliminación de todos los bloques que no se encuentran en [bloquesId] porque fueron eliminados desde el form.
        await (delete(bloques)
              ..where((bloque) =>
                  bloque.id.isNotIn(bloquesId) &
                  bloque.cuestionarioId.equals(cuesti.id)))
            .go();
      },
    );
  }
}
