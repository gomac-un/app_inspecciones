import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/infrastructure/repositories/fotos_repository.dart';
import 'package:inspecciones/infrastructure/tablas_unidas.dart';
import 'package:moor/moor.dart';

part 'creacion_dao.moor.dart';

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
class CreacionDao extends DatabaseAccessor<MoorDatabase>
    with _$CreacionDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  CreacionDao(MoorDatabase db) : super(db);

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
            await getRespuestasDeCuadricula(entry.value.first.value3.id),
          ),
          entry.value
              .map(
                (item) =>

                    /// Envia lista vacia en las opciones de respuesta, porque ya van en [CuadriculaDePreguntasConOpcionesDeRespuesta]
                    PreguntaConOpcionesDeRespuesta(item.value1, const []),
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

  /// crea o actualiza un cuestionario
  /// Si el companion viene con id TIENE que estar ya en la db entonces se actualiza, sino se inserta
  Future<Cuestionario> upsertCuestionario(
      CuestionariosCompanion cuestionarioForm) async {
    if (cuestionarioForm.id.present) {
      await update(cuestionarios).replace(cuestionarioForm);
      return await getCuestionario(cuestionarioForm.id.value);
    } else {
      return await into(cuestionarios).insertReturning(cuestionarioForm);
    }
  }

  /// crea o actualiza una pregunta
  /// Si el companion viene con id TIENE que estar ya en la db entonces se actualiza, sino se inserta
  Future<Pregunta> upsertPregunta(PreguntasCompanion preguntaForm) async {
    if (preguntaForm.id.present) {
      await update(preguntas).replace(preguntaForm);

      final query = select(preguntas)
        ..where((p) => p.id.equals(preguntaForm.id.value));

      return query.getSingle();
    } else {
      return await into(preguntas).insertReturning(preguntaForm);
    }
  }

  /// crea o actualiza una cuadricula
  /// Si el companion viene con id TIENE que estar ya en la db entonces se actualiza, sino se inserta
  Future<CuadriculaDePreguntas> upsertCuadricula(
      CuadriculasDePreguntasCompanion cuadriculaForm) async {
    if (cuadriculaForm.id.present) {
      await update(cuadriculasDePreguntas).replace(cuadriculaForm);

      final query = select(cuadriculasDePreguntas)
        ..where((c) => c.id.equals(cuadriculaForm.id.value));

      return query.getSingle();
    } else {
      return await into(cuadriculasDePreguntas).insertReturning(cuadriculaForm);
    }
  }

  /// Actualiza los modelos asociados a [cuestionario]
  Future<void> upsertModelos(
    List<CuestionarioDeModelosCompanion> cuestionariosDeModelosForm,
    Cuestionario cuestionario,
  ) async {
    /// Lista de los ids de cuestionarioDeModelos que se insertarán en la actualización

    final ids = await Future.wait<int>(
        cuestionariosDeModelosForm.map((cuestionarioDeModelosForm) async {
      /// Se le asigna [cuestionario] como cuestionario asociado
      cuestionarioDeModelosForm = cuestionarioDeModelosForm.copyWith(
          cuestionarioId: Value(cuestionario.id));
      if (cuestionarioDeModelosForm.id.present) {
        await into(cuestionarioDeModelos)
            .insertOnConflictUpdate(cuestionarioDeModelosForm);
        return cuestionarioDeModelosForm.id.value;
      } else {
        return into(cuestionarioDeModelos).insert(cuestionarioDeModelosForm);
      }
    }));

    /// En caso de que se haya deseleccionado un modelo para [cuestionario], se elimina de la bd
    await (delete(cuestionarioDeModelos)
          ..where((rxor) =>
              rxor.id.isNotIn(ids) &
              rxor.cuestionarioId.equals(cuestionario.id)))
        .go();
  }

  Future<void> upsertOpcionesDeRespuesta(
    List<OpcionesDeRespuestaCompanion> opcionesDeRespuestaForm, {
    Pregunta? pregunta,
    CuadriculaDePreguntas? cuadricula,
  }) async {
    if (pregunta == null && cuadricula == null) {
      throw Exception("debe enviar ya sea una pregunta o una cuadricula");
    }

    /// Inserción de la opciones de respuesta de la pregunta
    final opcionesId =
        await Future.wait<int>(opcionesDeRespuestaForm.map((opcionForm) async {
      /// Asociación de cada opción con [preguntaId o cuadriculaId]
      //final OpcionesDeRespuestaCompanion opcionForm;
      if (pregunta != null) {
        opcionForm = opcionForm.copyWith(preguntaId: Value(pregunta.id));
      } else if (cuadricula != null) {
        opcionForm = opcionForm.copyWith(cuadriculaId: Value(cuadricula.id));
      }

      if (opcionForm.id.present) {
        //actualiza con la nueva info
        await into(opcionesDeRespuesta).insertOnConflictUpdate(opcionForm);
        return opcionForm.id.value;
      } else {
        return into(opcionesDeRespuesta).insert(opcionForm);
      }
    }));

    final Expression<bool> Function(dynamic rxor) asociada;
    if (pregunta != null) {
      asociada = (rxor) => rxor.preguntaId.equals(pregunta.id);
    } else if (cuadricula != null) {
      asociada = (rxor) => rxor.cuadriculaId.equals(cuadricula.id);
    } else {
      throw Exception("debe enviar ya sea una pregunta o una cuadricula");
    }

    /// Se eliminan de la bd las opciones de respuesta que fueron eliminadas desde el form
    await (delete(opcionesDeRespuesta)
          ..where((rxor) => rxor.id.isNotIn(opcionesId) & asociada(rxor)))
        .go();
  }

  Future<void> upsertCriticidades(
    List<CriticidadesNumericasCompanion> criticidadesForm,
    Pregunta pregunta,
  ) async {
    /// Inserción de la opciones de respuesta de la pregunta
    final criticidadesId =
        await Future.wait<int>(criticidadesForm.map((criticidadForm) async {
      /// Asociación de cada opción con [preguntaId o cuadriculaId]
      //final OpcionesDeRespuestaCompanion opcionForm;

      criticidadForm = criticidadForm.copyWith(preguntaId: Value(pregunta.id));

      if (criticidadForm.id.present) {
        //actualiza con la nueva info
        await into(criticidadesNumericas)
            .insertOnConflictUpdate(criticidadForm);
        return criticidadForm.id.value;
      } else {
        return into(criticidadesNumericas).insert(criticidadForm);
      }
    }));

    /// Se eliminan de la bd las opciones de respuesta que fueron eliminadas desde el form
    await (delete(criticidadesNumericas)
          ..where((rxor) =>
              rxor.id.isNotIn(criticidadesId) &
              rxor.preguntaId.equals(pregunta.id)))
        .go();
  }

  Future<Pregunta> procesarPregunta(
    PreguntasCompanion preguntaCompanion,
    Cuestionario cuestionario,
    Bloque bloque, {
    List<OpcionesDeRespuestaCompanion>? opcionesDeRespuesta,
    List<CriticidadesNumericasCompanion>? criticidades,
  }) async {
    final fotosManager =
        db.fotosRepository; //TODO: eliminar la dependencia a fotosRepository
    final fotosGuiaProcesadas = await fotosManager.organizarFotos(
      preguntaCompanion.fotosGuia.valueOrDefault(const Nil()).toList(),
      Categoria.cuestionario,
      identificador: cuestionario.id.toString(),
    );

    final preguntaAInsertar = preguntaCompanion.copyWith(
      bloqueId: Value(bloque.id),
      fotosGuia: Value(fotosGuiaProcesadas),
    );

    final pregunta = await upsertPregunta(preguntaAInsertar);
    if (opcionesDeRespuesta != null) {
      await upsertOpcionesDeRespuesta(opcionesDeRespuesta, pregunta: pregunta);
    } else if (criticidades != null) {
      await upsertCriticidades(criticidades, pregunta);
    } else {
      throw Exception("debe enviar opcionesDeRespuesta o criticidades");
    }

    return pregunta;
  }

  /// Guarda o crea un cuestionario con sus respectivas preguntas.
  Future<void> guardarCuestionario(
    CuestionariosCompanion cuestionarioForm,

    /// Información sobre los modelos a los que aplica [cuestionario], periodicidad y contratista
    List<CuestionarioDeModelosCompanion> cuestionariosDeModelosForm,
    List<Object> bloquesForm,
  ) async {
    /// Como es una transaccion si algo falla, ningun cambio queda en la DB
    return transaction(
      () async {
        final Cuestionario cuestionario =
            await upsertCuestionario(cuestionarioForm);
        await upsertModelos(cuestionariosDeModelosForm, cuestionario);

        /// Dado que no guardamos los bloques en el controller de la creacion,
        /// no tenemos los ids entonces hay que borrarlos todos y volverlos a crear,
        /// TODO: actualizar los bloques en lugar de borrarlos, de la misma manera
        ///  que se hace en [upsertModelos].
        await (delete(bloques)
              ..where(
                  (bloque) => bloque.cuestionarioId.equals(cuestionario.id)))
            .go();

        /// Procesamiento de cada object del formulario de acuerdo a si es
        /// titulo, pregunta de selección o numerica y cuadricula.
        /// En los condicionales, se mira de que tipo especifico es el [element],
        /// Hay que tener especial cuidado en tratar todo tipo posible que
        /// venga desde el formulario creacion (metodos toDB), ya que si llega
        /// uno de distinto tipo, va a fallar, esto se debería evitar usando
        /// algun tipo de tagged union pero dart no lo soporta actualmente
        ///
        /// Se le asigna a cada pregunta o titulo [bloqueId]
        await Future.forEach<MapEntry<int, Object>>(bloquesForm.asMap().entries,
            (entry) async {
          final i = entry.key;
          final element = entry.value;
          final bloque = await into(bloques).insertReturning(
            BloquesCompanion.insert(nOrden: i, cuestionarioId: cuestionario.id),
          );

          /// ! OJO: procesar cada posible tipo de objeto
          if (element is TitulosCompanion) {
            final titulo = element.copyWith(bloqueId: Value(bloque.id));
            await into(titulos).insertOnConflictUpdate(titulo);
          }

          if (element is PreguntaConOpcionesDeRespuestaCompanion) {
            await procesarPregunta(element.pregunta, cuestionario, bloque,
                opcionesDeRespuesta: element.opcionesDeRespuesta);
          }
          if (element
              is CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion) {
            final cuadricula = await upsertCuadricula(
                element.cuadricula.copyWith(bloqueId: Value(bloque.id)));

            final preguntasInsertadas = await Future.wait(element.preguntas.map(
                (e) => procesarPregunta(e.pregunta, cuestionario, bloque,
                    opcionesDeRespuesta: [])));

            await (delete(preguntas)
                  ..where((rxor) =>
                      rxor.id.isNotIn(preguntasInsertadas.map((e) => e.id)) &
                      rxor.bloqueId.equals(bloque.id)))
                .go();
            await upsertOpcionesDeRespuesta(
              element.opcionesDeRespuesta,
              cuadricula: cuadricula,
            );
          }
          if (element is PreguntaNumericaCompanion) {
            await procesarPregunta(
              element.pregunta,
              cuestionario,
              bloque,
              criticidades: element.criticidades,
            );
          }

          throw UnimplementedError("Tipo de elemento no reconocido: $element");
        });
      },
    );
  }
}
