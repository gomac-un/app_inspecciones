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
  Future<List<tit_dom.Titulo>> getTitulos(int cuestionarioId) {
    final query = select(titulos).join([
      innerJoin(bloques, bloques.id.equalsExp(titulos.bloqueId)),
    ])
      ..where(bloques.cuestionarioId.equals(cuestionarioId));
    return query
        .map((row) => tit_dom.Titulo(
              titulo: row.readTable(titulos).titulo,
              descripcion: row.readTable(titulos).descripcion,
              nOrden: row.readTable(bloques).nOrden,
            ))
        .get();
  }

  MetaRespuesta getMetaRespuesta(Respuesta respuesta) => MetaRespuesta(
        criticidadInspector: respuesta.calificacion,
        observaciones: respuesta.observacion,
        reparada: respuesta.reparado,
        observacionesReparacion: respuesta.observacionReparacion,
        fotosBase: respuesta.fotosBase.toList(),
        fotosReparacion: respuesta.fotosReparacion.toList(),
      );

  pr_dom.OpcionDeRespuesta createOpcionDeRespuesta(OpcionDeRespuesta opcion) =>
      pr_dom.OpcionDeRespuesta(
          id: opcion.id,
          titulo: opcion.texto,
          descripcion: "",
          criticidad: opcion.criticidad);

  /// Devuelve las preguntas numericas de la inspección, con la respuesta que
  /// se haya insertado y las criticidadesNumericas (rangos de criticidad)
  Future<List<bl_dom.PreguntaNumerica>> getPreguntaNumerica(int cuestionarioId,

      /// Usada para obtener las respuestas del inspector a la pregunta
      [int? inspeccionId]) async {
    final respuesta = alias(respuestas, 'res');
    final query = select(preguntas).join([
      innerJoin(
        bloques,
        bloques.id.equalsExp(preguntas.bloqueId),
      ),
      innerJoin(criticidadesNumericas,
          criticidadesNumericas.preguntaId.equalsExp(preguntas.id)),
      leftOuterJoin(respuesta, respuesta.preguntaId.equalsExp(preguntas.id)),
    ])
      ..where(bloques.cuestionarioId.equals(cuestionarioId) &
          (preguntas.tipo.equals(4)));

    final res = await query
        .map((row) => Tuple4(
              row.readTable(bloques),
              row.readTable(preguntas),
              row.readTable(respuestas),
              row.readTable(criticidadesNumericas),
            ))
        .get();
    return Future.wait(
      groupBy<Tuple4<Bloque, Pregunta, Respuesta, CriticidadesNumerica>,
          Pregunta>(res, (e) => e.value2).entries.map((entry) async {
        return bl_dom.PreguntaNumerica(
            entry.value
                .map((item) => bl_dom.RangoDeCriticidad(item.value4.valorMinimo,
                    item.value4.valorMaximo, item.value4.criticidad))
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
            nOrden: entry.value.first.value1.nOrden,
            respuesta:
                await getRespuestaDePreguntaNumerica(entry.key, inspeccionId));
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
    return bl_dom.RespuestaNumerica(getMetaRespuesta(res),
          respuestaNumerica: res.valor);
    
  }

  /// Devuelve las preguntas de tipo selección asociadas al cuestionario con id=[cuestionarioId]
  /// Junto con sus opciones de respuesta y las respuestas que haya insertado el inspector.
  Future<List<pr_dom.PreguntaDeSeleccion>> getPreguntasSeleccionSimple(
      int cuestionarioId,
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
          return getPreguntaDeSeleccionMultiple(entry.key,
              entry.value.map((e) => e.value3).toList(), inspeccionId,
              nOrden: entry.value.first.value1.nOrden);
        }
        //TODO: OPCIÓN DE RESPUESTA NO TIENE DESCRIPCIÓN
        return await getPreguntaDeSeleccionUnica(
            entry.key, entry.value.map((e) => e.value3).toList(), inspeccionId,
            nOrden: entry.value.first.value1.nOrden);
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

    ///Si existe la inspeccion y no se ha contestado la pregunta, se envia nulo
    ///para que el control cree una por defecto

    return res;
  }

  Future<bl_dom.PreguntaDeSeleccionMultiple> getPreguntaDeSeleccionMultiple(
      Pregunta pregunta, List<OpcionDeRespuesta> opciones, int? inspeccionId,
      {required int nOrden}) async {
    final respuestas =
        await getRespuestaDePreguntaSimple(pregunta, inspeccionId);
    return bl_dom.PreguntaDeSeleccionMultiple(
      opciones.map((opcion) => createOpcionDeRespuesta(opcion)).toList(),
      opciones.map((op) {
        final respuesta = respuestas
            .firstWhereOrNull((element) => element.value2.id == op.id);
        return bl_dom.SubPreguntaDeSeleccionMultiple(
          createOpcionDeRespuesta(op),
          id: 3,
          titulo: pregunta.titulo,
          descripcion: pregunta.descripcion,
          criticidad: pregunta.criticidad,
          posicion:
              '${pregunta.eje} / ${pregunta.lado} / ${pregunta.posicionZ}',
          calificable: false,
          nOrden: nOrden,
          respuesta: respuesta == null
              ? bl_dom.SubRespuestaDeSeleccionMultiple(MetaRespuesta.vacia(),
                  estaSeleccionada: false)
              : bl_dom.SubRespuestaDeSeleccionMultiple(
                  getMetaRespuesta(respuesta.value1),
                  estaSeleccionada: true),
        );
      }).toList(),
      id: pregunta.id,
      nOrden: nOrden,
      calificable: pregunta.esCondicional,
      criticidad: pregunta.criticidad,
      posicion: '${pregunta.eje} / ${pregunta.lado} / ${pregunta.posicionZ}',
      titulo: pregunta.titulo,
      descripcion: '',
    );
  }

  Future<bl_dom.PreguntaDeSeleccionUnica> getPreguntaDeSeleccionUnica(
      Pregunta pregunta, List<OpcionDeRespuesta> opciones, int? inspeccionId,
      {required int nOrden}) async {
    final respuestas =
        await getRespuestaDePreguntaSimple(pregunta, inspeccionId);
    final respuesta = respuestas.first.value1;
    final opcion = respuestas.first.value2;
    final metaRespuesta = getMetaRespuesta(respuesta);
    return pr_dom.PreguntaDeSeleccionUnica(
      opciones.map((e) => createOpcionDeRespuesta(e)).toList(),
      id: pregunta.id,
      calificable: pregunta.esCondicional,
      criticidad: pregunta.criticidad,
      posicion: '${pregunta.eje} / ${pregunta.lado} / ${pregunta.posicionZ}',
      titulo: pregunta.titulo,
      descripcion: '', //TODO: añadir en la creación
      nOrden: nOrden,
      respuesta: respuestas.isEmpty
          ? null
          : //Se supone que para las unicas solo debe haber una respuesta.
          bl_dom.RespuestaDeSeleccionUnica(
              metaRespuesta,
              bl_dom.OpcionDeRespuesta(
                  id: opcion.id,
                  titulo: opcion.texto,
                  descripcion: '',
                  criticidad: opcion.criticidad),
            ),
    );
  }

  /// Devuelve las cuadriculas de la inspección con sus respectivas preguntas y opciones de respuesta.
  /// También incluye las respuestas que ha dado el inspector.
  Future<List<bl_dom.Cuadricula>> getCuadriculas(int cuestionarioId,
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
          return getCuadriculaDeSeleccionUnica(
              entry.value, respuestas, inspeccionId);
        }
        return getCuadriculaDeSeleccionMultiple(
            entry.value, respuestas, inspeccionId);
      }),
    );
  }

  Future<bl_dom.CuadriculaDeSeleccionUnica> getCuadriculaDeSeleccionUnica(
      List<Tuple3<Pregunta, Bloque, CuadriculaDePreguntas>> value,
      List<OpcionDeRespuesta> opciones,
      int? inspeccionId) async {
    return bl_dom.CuadriculaDeSeleccionUnica(
      await Future.wait(value
          .map((e) async => await getPreguntaDeSeleccionUnica(
              e.value1, opciones, inspeccionId,
              nOrden: value.first.value2.nOrden))
          .toList()),
      opciones.map((element) => createOpcionDeRespuesta(element)).toList(),
      id: value.first.value3.id,
      titulo: value.first.value3.titulo,
      descripcion: value.first.value3.descripcion,
      nOrden: value.first.value2.nOrden,
      criticidad: 0, //TODO: no tiene criticidad /* value.first.value3., */
      posicion: "arriba", // Todo: no tiene posición
      calificable: true, //Todo: no es calificable
    );
  }

  Future<bl_dom.CuadriculaDeSeleccionMultiple> getCuadriculaDeSeleccionMultiple(
      List<Tuple3<Pregunta, Bloque, CuadriculaDePreguntas>> value,
      List<OpcionDeRespuesta> opciones,
      int? inspeccionId) async {
    return bl_dom.CuadriculaDeSeleccionMultiple(
      await Future.wait(value
          .map((e) async => await getPreguntaDeSeleccionMultiple(
              e.value1, opciones, inspeccionId,
              nOrden: value.first.value2.nOrden))
          .toList()),
      opciones.map((element) => createOpcionDeRespuesta(element)).toList(),
      id: value.first.value3.id,
      titulo: value.first.value3.titulo,
      descripcion: value.first.value3.descripcion,
      nOrden: value.first.value2.nOrden,
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

    //Todas los metodos para cargarla aceptan inspecciónId nulo.
    //! if(inspeccion==null){???} //¿Crear una y devolver esa o qué?
    final inspeccion =
        inspeccionExistente ?? await crearInspeccion(cuestionarioId, activoId);
    final inspeccionId = inspeccion.id;

    final List<tit_dom.Titulo> titulos = await getTitulos(cuestionarioId);

    /// De selección multiple o unica
    final List<bl_dom.PreguntaDeSeleccion> preguntasSeleccion =
        await getPreguntasSeleccionSimple(cuestionarioId, inspeccionId);

    final List<bl_dom.Cuadricula> cuadriculas =
        await getCuadriculas(cuestionarioId, inspeccionId);

    final List<bl_dom.PreguntaNumerica> numerica =
        await getPreguntaNumerica(cuestionarioId, inspeccionId);
    return Tuple2(inspeccion, [
      ...titulos,
      ...preguntasSeleccion,
      ...cuadriculas,
      ...numerica,
    ]);
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
    if (activo == null) throw Exception("activo nulo");
    final ins = InspeccionesCompanion.insert(
      id: Value(generarId(activo)),
      cuestionarioId: cuestionarioId,
      estado: EstadoDeInspeccion.borrador,
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
    final fotosBaseProcesadas = await fotosManager.organizarFotos(
      respuesta.metaRespuesta.fotosBase,
      Categoria.inspeccion,
      identificador: inspeccionId.toString(),
    );
    final fotosReparacionProcesadas = await fotosManager.organizarFotos(
      respuesta.metaRespuesta.fotosReparacion,
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
            e.respuesta!, inspeccionId, e.id,
            fotosManager: fotosManager, opcion: e.opcion))
        .toList();
  }

  /// Realiza el guardado de la inspección al presionar el botón guardar o finalizar en el llenado.
  Future guardarInspeccion(
      List<bl_dom.Pregunta> respuestasForm, insp_dom.Inspeccion inspeccion,
      {int? activoId,
      Cuestionario? cuestionario,
      required FotosRepository fotosManager}) async {
    return transaction(() async {
      /*  /// Se redondea para evitar que se guarde en la bd un montón de decimales.
      final mod = pow(10.0, 2);
      final critiRound = (criticidad * mod).round().toDouble() / mod;
      final critiRepaRound =
          (criticidadReparacion * mod).round().toDouble() / mod;

      /// Se consulta si ya existe una inspección para [activoId] y si no existe se crea.
      Inspeccion ins = await getInspeccion(activoId, cuestionarioId);
      ins ??= await crearInspeccion(
          cuestionarioId, activoId, estado, critiRound, critiRepaRound);
      await (update(inspecciones)..where((i) => i.id.equals(ins.id))).write(
        estado == EstadoDeInspeccion.finalizada
            ? InspeccionesCompanion(
                momentoFinalizacion: Value(DateTime.now()),
                estado: Value(estado),
                criticidadTotal: Value(critiRound),
                criticidadReparacion: Value(critiRepaRound))
            : InspeccionesCompanion(
                momentoBorradorGuardado: Value(DateTime.now()),
                estado: Value(estado),
                criticidadTotal: Value(critiRound),
                criticidadReparacion: Value(critiRepaRound),
              ),
      ); */
      final estado = inspeccion.estado;
      await (update(inspecciones)..where((i) => i.id.equals(inspeccion.id)))
          .write(
        InspeccionesCompanion(
          momentoFinalizacion: estado == insp_dom.EstadoDeInspeccion.finalizada
              ? Value(DateTime.now())
              : const Value.absent(),
          estado: Value(EstadoDeInspeccion.values.firstWhere(
              (element) => element.index == inspeccion.estado.index)),
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
      await Future.forEach<bl_dom.Pregunta>(respuestasForm, (resp) async {
        if (resp is bl_dom.PreguntaDeSeleccionUnica) {
          await guardarRespuesta(resp.respuesta!, inspeccionId, resp.id,
              opcion: resp.respuesta!.opcionSeleccionada,
              fotosManager: fotosManager);
        } else if (resp is bl_dom.PreguntaNumerica) {
          await guardarRespuesta(resp.respuesta!, inspeccionId, resp.id,
              valor: resp.respuesta!.respuestaNumerica,
              fotosManager: fotosManager);
        } else if (resp is bl_dom.PreguntaDeSeleccionMultiple) {
          await procesarRespuestaMultiple(
              resp.respuestas, inspeccionId, resp.id,
              fotosManager: fotosManager);
        } else if (resp is bl_dom.CuadriculaDeSeleccionUnica) {
          resp.preguntas.map((e) async => e.respuesta != null
              ? await guardarRespuesta(e.respuesta!, inspeccionId, e.id,
                  opcion: e.respuesta!.opcionSeleccionada,
                  fotosManager: fotosManager)
              : null);
        } else if (resp is bl_dom.CuadriculaDeSeleccionMultiple) {
          resp.preguntas.map((e) async => await procesarRespuestaMultiple(
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
