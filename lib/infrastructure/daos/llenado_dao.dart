import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/bloque.dart'
    as bloque_dom;
import 'package:inspecciones/features/llenado_inspecciones/domain/bloques/bloques.dart'
    as bl_dom;
import 'package:inspecciones/features/llenado_inspecciones/domain/bloques/preguntas/preguntas.dart'
    as pr_dom;
import 'package:inspecciones/features/llenado_inspecciones/domain/bloques/titulo.dart'
    as tit_dom;
import 'package:inspecciones/features/llenado_inspecciones/domain/inspeccion.dart'
    as insp_dom;
import 'package:inspecciones/features/llenado_inspecciones/domain/metarespuesta.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/infrastructure/repositories/fotos_repository.dart';
import 'package:intl/intl.dart';
import 'package:moor/moor.dart';

part 'llenado_dao.moor.dart';

/// Acceso a los datos de la Bd.
///
/// Incluye los métodos necesarios para  insertar, actualizar, borrar y consultar la información
/// relacionada con el llenado de inspecciones.
@UseDao(tables: [
  /// Definición de las tablas necesarias para obtener la información
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
class LlenadoDao extends DatabaseAccessor<MoorDatabase> with _$LlenadoDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  LlenadoDao(MoorDatabase db) : super(db);

  /// Trae una lista con todos los cuestionarios disponibles para un activo,
  /// incluyendo los cuestionarios que son asignados a todos los activos
  Future<List<Cuestionario>> cuestionariosParaActivo(int activo) async {
    return customSelect(
      '''
      SELECT cuestionarios.* FROM activos
      INNER JOIN cuestionario_de_modelos ON cuestionario_de_modelos.modelo = activos.modelo
      INNER JOIN cuestionarios ON cuestionarios.id = cuestionario_de_modelos.cuestionario_id
      WHERE activos.id = $activo
      UNION
      SELECT cuestionarios.* FROM cuestionarios
      INNER JOIN cuestionario_de_modelos ON cuestionario_de_modelos.cuestionario_id = cuestionarios.id
      WHERE (cuestionario_de_modelos.modelo = 'Todos' OR cuestionario_de_modelos.modelo = 'todos') AND 
        EXISTS (SELECT * FROM activos WHERE activos.id = $activo)
      ;''',
    ).map((row) => Cuestionario.fromData(row.data, db)).get();
  }

  /// Devuelve la inspeccion empezada que no haya sido enviada para un activo
  /// en un cuestionario. Si no existe, devuelve null
  Future<Inspeccion?> getInspeccion(int activoId, int cuestionarioId) {
    final query = select(inspecciones)
      ..where(
        (ins) =>
            ins.cuestionarioId.equals(cuestionarioId) &
            ins.activoId.equals(activoId) &

            /// Pueden haber muchas inspecciones del mismo cuestionario para el mismo activo en la bd, pero aparecen solo en el historial
            /// así que se filtra solo las que no hayan sido enviadas.
            ins.momentoEnvio.isNull(),
      );

    return query.getSingleOrNull();
  }

  /// Devuelve los titulos que pertenecen al cuestionario
  Future<List<Tuple2<int, tit_dom.Titulo>>> getTitulos(
      int cuestionarioId) async {
    final query = select(titulos).join([
      innerJoin(bloques, bloques.id.equalsExp(titulos.bloqueId)),
    ])
      ..where(bloques.cuestionarioId.equals(cuestionarioId));
    final res = await query
        .map((row) => Tuple2<int, tit_dom.Titulo>(
            row.readTable(bloques).nOrden,
            tit_dom.Titulo(
              titulo: row.readTable(titulos).titulo,
              descripcion: row.readTable(titulos).descripcion,
            )))
        .get();
    return res;
  }

  MetaRespuesta buildMetaRespuesta(Respuesta respuesta) => MetaRespuesta(
        criticidadInspector: respuesta.calificacion ?? 0,
        observaciones: respuesta.observacion,
        reparada: respuesta.reparado,
        observacionesReparacion: respuesta.observacionReparacion,
        fotosBase: respuesta.fotosBase.toList(),
        fotosReparacion: respuesta.fotosReparacion.toList(),
      );

  pr_dom.OpcionDeRespuesta buildOpcionDeRespuesta(OpcionDeRespuesta opcion) =>
      pr_dom.OpcionDeRespuesta(
          id: opcion.id,
          titulo: opcion.texto,
          descripcion: "",
          criticidad: opcion.criticidad);

  /// Devuelve las preguntas numericas de la inspección, con la respuesta que
  /// se haya insertado y las criticidadesNumericas (rangos de criticidad)
  Future<List<Tuple2<int, bl_dom.PreguntaNumerica>>> getPreguntasNumerica(
      int cuestionarioId,

      /// Usada para obtener las respuestas del inspector a la pregunta
      [int? inspeccionId]) async {
    final query = select(preguntas).join([
      innerJoin(
        bloques,
        bloques.id.equalsExp(preguntas.bloqueId),
      ),
      innerJoin(criticidadesNumericas,
          criticidadesNumericas.preguntaId.equalsExp(preguntas.id)),
    ])
      ..where(bloques.cuestionarioId.equals(cuestionarioId) &
          (preguntas.tipo.equals(4)));

    final res = await query
        .map((row) => Tuple3(
              row.readTable(bloques),
              row.readTable(preguntas),
              row.readTable(criticidadesNumericas),
            ))
        .get();
    return Future.wait(
      groupBy<Tuple3<Bloque, Pregunta, CriticidadesNumerica>, Pregunta>(
          res, (e) => e.value2).entries.map((entry) async {
        return Tuple2(
            entry.value.first.value1.nOrden,
            bl_dom.PreguntaNumerica(
                entry.value
                    .map((item) => bl_dom.RangoDeCriticidad(
                        item.value3.valorMinimo,
                        item.value3.valorMaximo,
                        item.value3.criticidad))
                    .toList(),
                id: entry.key.id,
                //Todo: modificar la bd para que sean calificables.
                calificable: entry.key.esCondicional,
                criticidad: entry.key.criticidad,
                posicion:
                    '${entry.key.eje} / ${entry.key.lado} / ${entry.key.posicionZ}',
                titulo: entry.key.titulo,
                unidades: '', //TODO: añadir en la creación
                descripcion: '',
                respuesta: await getRespuestaDePreguntaNumerica(
                    entry.key, inspeccionId)));
      }),
    );
  }

  /// Devuelve la respuesta a [pregunta] de tipo numerica.
  Future<bl_dom.RespuestaNumerica?> getRespuestaDePreguntaNumerica(
      Pregunta pregunta, int? inspeccionId) async {
    ///Si la inspeccion es nueva entonces no existe una respuesta y se envia nulo
    ///para que el control cree una por defecto
    if (inspeccionId == null) return null;
    final query = select(respuestas)
      ..where(
        (u) =>
            u.preguntaId.equals(pregunta.id) &
            u.inspeccionId.equals(inspeccionId),
      );
    //Se supone que solo debe haber una respuesta por [pregunta] numerica para [inspeccionId]
    final res = await query.getSingleOrNull();
    if (res == null) return null;
    return bl_dom.RespuestaNumerica(buildMetaRespuesta(res),
        respuestaNumerica: res.valor);
  }

  /// Devuelve las preguntas de tipo selección asociadas al cuestionario con id=[cuestionarioId]
  /// Junto con sus opciones de respuesta y las respuestas que haya insertado el inspector.
  Future<List<Tuple2<int, pr_dom.PreguntaDeSeleccion>>>
      getPreguntasSeleccionSimple(int cuestionarioId,
          [int? inspeccionId]) async {
    final opcionesPregunta = alias(opcionesDeRespuesta, 'op');

    final query = select(preguntas).join([
      innerJoin(bloques, bloques.id.equalsExp(preguntas.bloqueId)),
      leftOuterJoin(opcionesPregunta,
          opcionesPregunta.preguntaId.equalsExp(preguntas.id)),
    ])
      ..where(bloques.cuestionarioId.equals(cuestionarioId) &
          preguntas.esCondicional.equals(false) &

          /// Carga solo las preguntas unicaRespuesta/multipleRespuesta
          (preguntas.tipo.equals(0) | preguntas.tipo.equals(1)));
    final res = await query
        .map((row) => Tuple3(
              row.readTable(bloques),
              row.readTable(preguntas),
              row.readTable(opcionesPregunta),
            ))
        .get();

    return Future.wait(
      groupBy<Tuple3<Bloque, Pregunta, OpcionDeRespuesta>, Pregunta>(
          res, (e) => e.value2).entries.map((entry) async {
        if (entry.key.tipo == TipoDePregunta.multipleRespuesta) {
          return Tuple2(
              entry.value.first.value1.nOrden,
              await buildPreguntaDeSeleccionMultiple(
                entry.key,
                entry.value.map((e) => e.value3).toList(),
                inspeccionId,
              ));
        }
        //TODO: OPCIÓN DE RESPUESTA NO TIENE DESCRIPCIÓN
        return Tuple2(
            entry.value.first.value1.nOrden,
            await buildPreguntaDeSeleccionUnica(
              entry.key,
              entry.value.map((e) => e.value3).toList(),
              inspeccionId,
            ));
      }),
    );
  }

  /// Devuelve las respuestas que haya dado el inspector a [pregunta], es List
  /// porque en el caso de las preguntas multiples, en la bd puede haber más d euna respuesta por pregunta
  Future<List<Tuple2<Respuesta, OpcionDeRespuesta>>>
      getRespuestaDePreguntaSimple(Pregunta pregunta, int? inspeccionId) async {
    if (inspeccionId == null) {
      return [];
    }
    final query = select(respuestas).join([
      leftOuterJoin(
        opcionesDeRespuesta,
        opcionesDeRespuesta.id.equalsExp(respuestas.opcionDeRespuestaId),
      ),
    ])
      ..where(
        respuestas.preguntaId.equals(pregunta.id) &
            respuestas.inspeccionId.equals(inspeccionId), //seleccion multiple
      );
    final res = await query
        .map((row) => Tuple2(
              row.readTable(respuestas),
              row.readTable(opcionesDeRespuesta),
            ))
        .get();

    return res;
  }

  Future<bl_dom.PreguntaDeSeleccionMultiple> buildPreguntaDeSeleccionMultiple(
    Pregunta pregunta,
    List<OpcionDeRespuesta> opciones,
    int? inspeccionId,
  ) async {
    final respuestas =
        await getRespuestaDePreguntaSimple(pregunta, inspeccionId);
    return bl_dom.PreguntaDeSeleccionMultiple(
      opciones.map((opcion) => buildOpcionDeRespuesta(opcion)).toList(),
      opciones.map((op) {
        final respuesta = respuestas
            .firstWhereOrNull((element) => element.value2.id == op.id);
        return bl_dom.SubPreguntaDeSeleccionMultiple(
          buildOpcionDeRespuesta(op),
          id: 3,
          titulo: op.texto,
          descripcion: '', //Todo: descripción de la opción de respuesta
          criticidad: op.criticidad,
          posicion:
              '${pregunta.eje} / ${pregunta.lado} / ${pregunta.posicionZ}',
          calificable: false,
          respuesta: respuesta == null
              ? bl_dom.SubRespuestaDeSeleccionMultiple(MetaRespuesta.vacia(),
                  estaSeleccionada: false)
              : bl_dom.SubRespuestaDeSeleccionMultiple(
                  buildMetaRespuesta(respuesta.value1),
                  estaSeleccionada: true),
        );
      }).toList(),
      id: pregunta.id,
      calificable: pregunta.esCondicional,
      criticidad: pregunta.criticidad,
      posicion: '${pregunta.eje} / ${pregunta.lado} / ${pregunta.posicionZ}',
      titulo: pregunta.titulo,
      descripcion: '',
    );
  }

  Future<bl_dom.PreguntaDeSeleccionUnica> buildPreguntaDeSeleccionUnica(
    Pregunta pregunta,
    List<OpcionDeRespuesta> opciones,
    int? inspeccionId,
  ) async {
    final respuestas =
        await getRespuestaDePreguntaSimple(pregunta, inspeccionId);
    final listaOpciones =
        opciones.map((e) => buildOpcionDeRespuesta(e)).toList();
    return pr_dom.PreguntaDeSeleccionUnica(
      listaOpciones,
      id: pregunta.id,
      calificable: pregunta.esCondicional,
      criticidad: pregunta.criticidad,
      posicion: '${pregunta.eje} / ${pregunta.lado} / ${pregunta.posicionZ}',
      titulo: pregunta.titulo,
      descripcion: '', //TODO: añadir en la creación
      respuesta: respuestas.isEmpty
          ? null
          : //Se supone que para las unicas solo debe haber una respuesta.
          bl_dom.RespuestaDeSeleccionUnica(
              buildMetaRespuesta(respuestas.first.value1),
              listaOpciones.firstWhereOrNull(
                  (opcion) => opcion.id == respuestas.first.value2.id),
            ),
    );
  }

  /// Devuelve las cuadriculas de la inspección con sus respectivas preguntas y opciones de respuesta.
  /// También incluye las respuestas que ha dado el inspector.
  Future<List<Tuple2<int, bl_dom.Cuadricula>>> getCuadriculas(
      int cuestionarioId,
      [int? inspeccionId]) async {
    final query = select(preguntas).join([
      innerJoin(bloques, bloques.id.equalsExp(preguntas.bloqueId)),
      innerJoin(cuadriculasDePreguntas,
          cuadriculasDePreguntas.bloqueId.equalsExp(bloques.id)),
    ])
      ..where(bloques.cuestionarioId.equals(cuestionarioId) &
          (preguntas.tipo.equals(2) | preguntas.tipo.equals(3)));

    //parteDeCuadriculaUnica

    final res = await query
        .map((row) => Tuple3(row.readTable(preguntas), row.readTable(bloques),
            row.readTable(cuadriculasDePreguntas)))
        .get();
    return Future.wait(
      groupBy<Tuple3<Pregunta, Bloque, CuadriculaDePreguntas>, Bloque>(
          res, (e) => e.value2).entries.map((entry) async {
        // Todas las preguntas del bloque van a ser del mismo tipo.
        final tipo = entry.value.first.value1.tipo;
        final respuestas =
            await respuestasDeCuadricula(entry.value.first.value3.id);
        if (tipo == TipoDePregunta.parteDeCuadriculaUnica) {
          return Tuple2(
              entry.value.first.value2.nOrden,
              await buildCuadriculaDeSeleccionUnica(
                  entry.value, respuestas, inspeccionId));
        }
        return Tuple2(
            entry.key.nOrden,
            await buildCuadriculaDeSeleccionMultiple(
                entry.value, respuestas, inspeccionId));
      }),
    );
  }

  Future<bl_dom.CuadriculaDeSeleccionUnica> buildCuadriculaDeSeleccionUnica(
      List<Tuple3<Pregunta, Bloque, CuadriculaDePreguntas>> value,
      List<OpcionDeRespuesta> opciones,
      int? inspeccionId) async {
    return bl_dom.CuadriculaDeSeleccionUnica(
      await Future.wait(value
          .map((e) async => await buildPreguntaDeSeleccionUnica(
                e.value1,
                opciones,
                inspeccionId,
              ))
          .toList()),
      opciones.map((element) => buildOpcionDeRespuesta(element)).toList(),
      id: value.first.value3.id,
      titulo: value.first.value3.titulo,
      descripcion: value.first.value3.descripcion,
      criticidad: 0, //TODO: no tiene criticidad /* value.first.value3., */
      posicion: "arriba", // Todo: no tiene posición
      calificable: true, //Todo: no es calificable
    );
  }

  Future<bl_dom.CuadriculaDeSeleccionMultiple>
      buildCuadriculaDeSeleccionMultiple(
          List<Tuple3<Pregunta, Bloque, CuadriculaDePreguntas>> value,
          List<OpcionDeRespuesta> opciones,
          int? inspeccionId) async {
    return bl_dom.CuadriculaDeSeleccionMultiple(
      await Future.wait(value
          .map((e) async => await buildPreguntaDeSeleccionMultiple(
                e.value1,
                opciones,
                inspeccionId,
              ))
          .toList()),
      opciones.map((element) => buildOpcionDeRespuesta(element)).toList(),
      id: value.first.value3.id,
      titulo: value.first.value3.titulo,
      descripcion: value.first.value3.descripcion,
      criticidad: 0, //TODO: no tiene criticidad /* value.first.value3., */
      posicion: "arriba", // Todo: no tiene posición
      calificable: true, //Todo: no es calificable
    );
  }

  /// Devuelve las respuestas de la cuadricula con id=[cuadriculaId], es una lista para el caso de las cuadriculas
  /// con respuesta multiple
  Future<List<OpcionDeRespuesta>> respuestasDeCuadricula(int cuadriculaId) {
    final query = select(opcionesDeRespuesta)
      ..where((or) => or.cuadriculaId.equals(cuadriculaId));
    return query.get();
  }

  /// Devuelve todos los bloques de la inspeccion del cuestionario con id=[cuestionarioId] para [activoId]
  ///
  /// Incluye los titulos y las preguntas con sus respectivas opciones de respuesta y respuestas seleccionadas
  Future<Tuple2<Inspeccion, List<bloque_dom.Bloque>>> cargarInspeccion(
      int cuestionarioId, int activoId) async {
    final inspeccionExistente = await (select(inspecciones)
          ..where(
            (inspeccion) =>
                inspeccion.cuestionarioId.equals(cuestionarioId) &
                inspeccion.activoId.equals(activoId) &

                /// Para no cargar las que están en el historial
                inspeccion.momentoEnvio.isNull(),
          ))
        .getSingleOrNull();
    //Se crea la inspección si no existe.
    final inspeccion =
        inspeccionExistente ?? await crearInspeccion(cuestionarioId, activoId);
    final inspeccionId = inspeccion.id;

    final List<Tuple2<int, tit_dom.Titulo>> titulos =
        await getTitulos(cuestionarioId);

    /// De selección multiple o unica
    final List<Tuple2<int, bl_dom.PreguntaDeSeleccion>> preguntasSeleccion =
        await getPreguntasSeleccionSimple(cuestionarioId, inspeccionId);

    final List<Tuple2<int, bl_dom.Cuadricula>> cuadriculas =
        await getCuadriculas(cuestionarioId, inspeccionId);

    final List<Tuple2<int, bl_dom.PreguntaNumerica>> numerica =
        await getPreguntasNumerica(cuestionarioId, inspeccionId);

    final bloques = [
      ...titulos,
      ...preguntasSeleccion,
      ...cuadriculas,
      ...numerica,
    ];
    bloques.sort((a, b) => a.value1.compareTo(b.value1));
    return Tuple2(inspeccion, bloques.map((e) => e.value2).toList());
  }

  /// Crea id para una inspección con el formato 'yyMMddHHmmss[activo]'
  int generarId(int activo) {
    final fechaFormateada = DateFormat("yyMMddHHmmss").format(DateTime.now());
    return int.parse('$fechaFormateada$activo');
  }

  /// Devuelve la inspección creada al guardarla por primera vez.
  Future<Inspeccion> crearInspeccion(
    int cuestionarioId,

    /// Activo al cual se le está realizando la inspección.
    int activo,
  ) async {
    final ins = InspeccionesCompanion.insert(
      id: Value(generarId(activo)),
      cuestionarioId: cuestionarioId,
      estado: insp_dom.EstadoDeInspeccion.borrador,
      criticidadTotal: 0,
      criticidadReparacion: 0,
      activoId: activo,
      momentoInicio: Value(DateTime.now()),
      momentoBorradorGuardado: Value(DateTime.now()),
    );
    final inspeccion = await into(inspecciones).insertReturning(ins);
    return inspeccion;
  }

  Future guardarRespuesta(
    bl_dom.Respuesta respuesta,
    int inspeccionId,
    int preguntaId, {
    double? valor,
    bl_dom.OpcionDeRespuesta? opcion,
    required FotosRepository fotosManager,
  }) async {
    if (opcion != null || valor != null) {
      final fotosBaseProcesadas = await fotosManager.organizarFotos(
        IList.from(respuesta.metaRespuesta.fotosBase),
        Categoria.inspeccion,
        identificador: inspeccionId.toString(),
      );
      final fotosReparacionProcesadas = await fotosManager.organizarFotos(
        IList.from(respuesta.metaRespuesta.fotosReparacion),
        Categoria.inspeccion,
        identificador: inspeccionId.toString(),
      );
      const respuestaCompanion = RespuestasCompanion();
      final respuestaAInsertar = respuestaCompanion.copyWith(
        //TODO: forma de acceder al id de la pregunta.
        preguntaId: Value(preguntaId),
        opcionDeRespuestaId: opcion != null ? Value(opcion.id) : null,
        inspeccionId: Value(inspeccionId),
        fotosBase: Value(fotosBaseProcesadas),
        fotosReparacion: Value(fotosReparacionProcesadas),
        observacion: Value(respuesta.metaRespuesta.observaciones),
        observacionReparacion:
            Value(respuesta.metaRespuesta.observacionesReparacion),
        reparado: Value(respuesta.metaRespuesta.reparada),
        calificacion: Value(respuesta.metaRespuesta.criticidadInspector),
        valor: Value(valor),
      );

      await into(respuestas).insert(respuestaAInsertar);
    }
  }

  Future deleteRespuestas(int inspeccionId) async {
    await (delete(respuestas)
          ..where((resp) => resp.inspeccionId.equals(inspeccionId)))
        .go();
  }

  Future procesarRespuestaMultiple(
      List<bl_dom.SubPreguntaDeSeleccionMultiple> respuesta,
      int inspeccionId,
      int preguntaId,
      {required FotosRepository fotosManager}) async {
    respuesta
        .where((element) =>
            element.respuesta != null && element.respuesta!.estaSeleccionada)
        .map((e) async => await guardarRespuesta(
            e.respuesta!, inspeccionId, preguntaId,
            fotosManager: fotosManager, opcion: e.opcion))
        .toList();
  }

  /// Realiza el guardado de la inspección al presionar el botón guardar o finalizar en el llenado.
  Future guardarInspeccion(
      List<bl_dom.Pregunta> preguntasForm, insp_dom.Inspeccion inspeccion,
      {int? activoId,
      Cuestionario? cuestionario,
      required FotosRepository fotosManager}) async {
    return transaction(() async {
      await (update(inspecciones)..where((i) => i.id.equals(inspeccion.id)))
          .write(
        InspeccionesCompanion(
          momentoFinalizacion:
              inspeccion.estado == insp_dom.EstadoDeInspeccion.finalizada
                  ? Value(DateTime.now())
                  : const Value.absent(),
          estado: Value(inspeccion.estado),
          criticidadTotal: Value(inspeccion.criticidadTotal),
          criticidadReparacion: Value(inspeccion.criticidadReparacion),
          momentoBorradorGuardado:
              /*  estado == insp_dom.EstadoDeInspeccion.borrador
                  ? const Value.absent()
                  :  */
              //Todo: ¿El momento guardado se actualiza siempre?
              Value(DateTime.now()),
        ),
      );
      final inspeccionId = inspeccion.id;
      await deleteRespuestas(inspeccionId);

      /// Se comienza a procesar las respuestas a cada pregunta.
      await Future.forEach<bl_dom.Pregunta>(preguntasForm, (pregunta) async {
        if (pregunta is bl_dom.PreguntaDeSeleccionUnica) {
          await guardarRespuesta(pregunta.respuesta!, inspeccionId, pregunta.id,
              opcion: pregunta.respuesta!.opcionSeleccionada,
              fotosManager: fotosManager);
        } else if (pregunta is bl_dom.PreguntaNumerica) {
          await guardarRespuesta(pregunta.respuesta!, inspeccionId, pregunta.id,
              valor: pregunta.respuesta!.respuestaNumerica,
              fotosManager: fotosManager);
        } else if (pregunta is bl_dom.PreguntaDeSeleccionMultiple) {
          await procesarRespuestaMultiple(
              pregunta.respuestas, inspeccionId, pregunta.id,
              fotosManager: fotosManager);
        } else if (pregunta is bl_dom.CuadriculaDeSeleccionUnica) {
          await Future.forEach<pr_dom.PreguntaDeSeleccionUnica>(
              pregunta.preguntas,
              (element) async => element.respuesta != null
                  ? await guardarRespuesta(
                      element.respuesta!, inspeccionId, element.id,
                      opcion: element.respuesta!.opcionSeleccionada,
                      fotosManager: fotosManager)
                  : null);
        } else if (pregunta is bl_dom.CuadriculaDeSeleccionMultiple) {
          await Future.forEach<pr_dom.PreguntaDeSeleccionMultiple>(
              pregunta.preguntas,
              (e) async => await procesarRespuestaMultiple(
                  e.respuestas, inspeccionId, e.id,
                  fotosManager: fotosManager));
        } else {
          throw (Exception('Tipo de respuesta no reconocido'));
        }
      });
    });
  }

  // funciones para subir al server
  /// Método no usado por ahora
  /* Future<List<RespuestaConOpcionesDeRespuesta2>> getRespuestasDeInspeccion(
      Inspeccion inspeccion) async {
    final query = select(respuestas).join([
      leftOuterJoin(
        opcionesDeRespuesta,
        opcionesDeRespuesta.id.equalsExp(respuestas.opcionDeRespuestaId),
      ),
    ])
      ..where(
        respuestas.inspeccionId.equals(inspeccion.id), //seleccion multiple
      );
    final res = await query
        .map((row) => {
              'respuesta': row.readTable(respuestas),
              'opcionDeRespuesta': row.readTable(opcionesDeRespuesta)
            })
        .get();

    return groupBy(res, (e) => e['respuesta'] as Respuesta)
        .entries
        .map((entry) {
      return RespuestaConOpcionesDeRespuesta2(
        entry.key,
        entry.value
            .map((e) => e['opcionDeRespuesta'] as OpcionDeRespuesta)
            .toList(),
      );
    }).toList();
  } */
}
