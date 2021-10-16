import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/core/error/errors.dart';
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
import 'package:inspecciones/infrastructure/drift_database.dart';
import 'package:inspecciones/utils/iterable_x.dart';
import 'package:intl/intl.dart';

part 'carga_inspeccion_dao.drift.dart';

@DriftAccessor(tables: [
  Cuestionarios,
  Inspecciones,
  Bloques,
  Titulos,
  CuadriculasDePreguntas,
  Preguntas,
  CriticidadesNumericas,
  OpcionesDeRespuesta,
  Respuestas,
])
class CargaDeInspeccionDao extends DatabaseAccessor<Database>
    with _$CargaDeInspeccionDaoMixin {
  CargaDeInspeccionDao(Database db) : super(db);

  /// Trae una lista con todos los cuestionarios disponibles para un activo,
  /// incluyendo los cuestionarios que son asignados a todos los activos
  Future<List<Cuestionario>> getCuestionariosDisponiblesParaActivo(
      int activoId) async {
    return customSelect(
      '''
      SELECT cuestionarios.* FROM activos
      INNER JOIN cuestionario_de_modelos ON cuestionario_de_modelos.modelo = activos.modelo
      INNER JOIN cuestionarios ON cuestionarios.id = cuestionario_de_modelos.cuestionario_id
      WHERE activos.id = $activoId
      UNION
      SELECT cuestionarios.* FROM cuestionarios
      INNER JOIN cuestionario_de_modelos ON cuestionario_de_modelos.cuestionario_id = cuestionarios.id
      WHERE (cuestionario_de_modelos.modelo = 'Todos' OR cuestionario_de_modelos.modelo = 'todos') AND 
        EXISTS (SELECT * FROM activos WHERE activos.id = $activoId)
      ;''',
    ).map((row) => Cuestionario.fromData(row.data)).get();
  }

  /// Devuelve todos los bloques de la inspeccion del cuestionario con id=[cuestionarioId] para [activoId]
  ///
  /// Incluye los titulos y las preguntas con sus respectivas opciones de respuesta y respuestas seleccionadas
  Future<Tuple2<Inspeccion, List<bloque_dom.Bloque>>> cargarInspeccion(
      {required int cuestionarioId, required int activoId}) async {
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
        inspeccionExistente ?? await _crearInspeccion(cuestionarioId, activoId);
    final inspeccionId = inspeccion.id;

    final List<Tuple2<int, tit_dom.Titulo>> titulos =
        await _getTitulos(cuestionarioId);

    /// De selección multiple o unica
    final List<Tuple2<int, bl_dom.PreguntaDeSeleccion>> preguntasSeleccion =
        await _getPreguntasSeleccionSimple(cuestionarioId, inspeccionId);

    final List<Tuple2<int, bl_dom.Cuadricula>> cuadriculas =
        await _getCuadriculas(cuestionarioId, inspeccionId);

    final List<Tuple2<int, bl_dom.PreguntaNumerica>> numerica =
        await _getPreguntasNumericas(cuestionarioId, inspeccionId);

    final bloques = [
      ...titulos,
      ...preguntasSeleccion,
      ...cuadriculas,
      ...numerica,
    ];
    bloques.sort((a, b) => a.value1.compareTo(b.value1));
    return Tuple2(inspeccion, bloques.map((e) => e.value2).toList());
  }

  /// Devuelve la inspección creada al guardarla por primera vez.
  Future<Inspeccion> _crearInspeccion(
    int cuestionarioId,

    /// Activo al cual se le está realizando la inspección.
    int activo,
  ) async {
    final ins = InspeccionesCompanion.insert(
      id: Value(_generarInspeccionId(activo)),
      cuestionarioId: cuestionarioId,
      estado: insp_dom.EstadoDeInspeccion.borrador,
      criticidadTotal: 0,
      criticidadReparacion: 0,
      activoId: activo,
      momentoInicio: Value(DateTime.now()),
      momentoBorradorGuardado: Value(DateTime.now()),
    );
    return into(inspecciones).insertReturning(ins);
  }

  /// Crea id para una inspección con el formato 'yyMMddHHmmss[activo]'
  int _generarInspeccionId(int activo) {
    final fechaFormateada = DateFormat("yyMMddHHmmss").format(DateTime.now());
    return int.parse('$fechaFormateada$activo');
  }

  /// Devuelve los titulos que pertenecen al cuestionario
  Future<List<Tuple2<int, tit_dom.Titulo>>> _getTitulos(
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

  /// Devuelve las preguntas numericas de la inspección, con la respuesta que
  /// se haya insertado y las criticidadesNumericas (rangos de criticidad)
  Future<List<Tuple2<int, bl_dom.PreguntaNumerica>>> _getPreguntasNumericas(
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
                calificable: true, //TODO: solucionar #19
                criticidad: entry.key.criticidad,
                posicion:
                    '${entry.key.eje} / ${entry.key.lado} / ${entry.key.posicionZ}',
                titulo: entry.key.titulo,
                unidades: '', //TODO: añadir en la creación
                descripcion: '',
                respuesta: await _getRespuestaDePreguntaNumerica(
                    entry.key, inspeccionId)));
      }),
    );
  }

  /// Devuelve la respuesta a [pregunta] de tipo numerica.
  Future<bl_dom.RespuestaNumerica?> _getRespuestaDePreguntaNumerica(
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
    return bl_dom.RespuestaNumerica(_buildMetaRespuesta(res),
        respuestaNumerica: res.valor);
  }

  /// Devuelve las preguntas de tipo selección asociadas al cuestionario con id=[cuestionarioId]
  /// Junto con sus opciones de respuesta y las respuestas que haya insertado el inspector.
  Future<List<Tuple2<int, pr_dom.PreguntaDeSeleccion>>>
      _getPreguntasSeleccionSimple(
    int cuestionarioId,
    int inspeccionId,
  ) async {
    final opcionesPregunta = alias(opcionesDeRespuesta, 'op');

    final query = select(preguntas).join([
      innerJoin(bloques, bloques.id.equalsExp(preguntas.bloqueId)),
      leftOuterJoin(opcionesPregunta,
          opcionesPregunta.preguntaId.equalsExp(preguntas.id)),
    ])
      ..where(bloques.cuestionarioId.equals(cuestionarioId) &

          /// Carga solo las preguntas unicaRespuesta/multipleRespuesta
          (preguntas.tipo.equals(0) | preguntas.tipo.equals(1)));
    final res = await query
        .map((row) => Tuple3(
              row.readTable(bloques),
              row.readTable(preguntas),
              row.readTableOrNull(opcionesPregunta),
            ))
        .get();

    return Future.wait(
      groupBy<Tuple3<Bloque, Pregunta, OpcionDeRespuesta?>, Pregunta>(
          res, (e) => e.value2).entries.map((entry) async {
        final pregunta = entry.key;
        final opciones = entry.value;
        if (pregunta.tipo == TipoDePregunta.multipleRespuesta) {
          return Tuple2(
              opciones.first.value1.nOrden,
              await _buildPreguntaDeSeleccionMultiple(
                pregunta,
                opciones.map((o) => o.value3).allNullToEmpty().toList(),
                inspeccionId,
              ));
        }
        //TODO: OPCIÓN DE RESPUESTA NO TIENE DESCRIPCIÓN
        return Tuple2(
            opciones.first.value1.nOrden,
            await _buildPreguntaDeSeleccionUnica(
              pregunta,
              opciones.map((o) => o.value3).allNullToEmpty().toList(),
              inspeccionId,
            ));
      }),
    );
  }

  Future<bl_dom.PreguntaDeSeleccionMultiple> _buildPreguntaDeSeleccionMultiple(
    Pregunta pregunta,
    List<OpcionDeRespuesta> opciones,
    int inspeccionId,
  ) async {
    final respuestas =
        await _getRespuestaDePreguntaSimple(pregunta, inspeccionId);
    return bl_dom.PreguntaDeSeleccionMultiple(
      opciones.map((opcion) => _buildOpcionDeRespuesta(opcion)).toList(),
      opciones.map((op) {
        final respuesta =
            respuestas.firstWhereOrNull((ryo) => op.id == ryo.value2?.id);
        return bl_dom.SubPreguntaDeSeleccionMultiple(
          _buildOpcionDeRespuesta(op),
          id: 3,
          titulo: op.texto,
          descripcion: '', //TODO: descripción de la opción de respuesta
          criticidad: op.criticidad,
          posicion:
              '${pregunta.eje} / ${pregunta.lado} / ${pregunta.posicionZ}',
          calificable: false,
          respuesta: respuesta == null
              ? bl_dom.SubRespuestaDeSeleccionMultiple(MetaRespuesta.vacia(),
                  estaSeleccionada: false)
              : bl_dom.SubRespuestaDeSeleccionMultiple(
                  _buildMetaRespuesta(respuesta.value1),
                  estaSeleccionada: true),
        );
      }).toList(),
      id: pregunta.id,
      calificable: true, //TODO: solucionar #19
      criticidad: pregunta.criticidad,
      posicion: '${pregunta.eje} / ${pregunta.lado} / ${pregunta.posicionZ}',
      titulo: pregunta.titulo,
      descripcion: '',
    );
  }

  Future<bl_dom.PreguntaDeSeleccionUnica> _buildPreguntaDeSeleccionUnica(
    Pregunta pregunta,
    List<OpcionDeRespuesta> opciones,
    int inspeccionId,
  ) async {
    final respuestas =
        await _getRespuestaDePreguntaSimple(pregunta, inspeccionId);
    if (respuestas.length > 1) {
      throw DatabaseInconsistencyError(
          "hay mas de una respuesta asociada a una pregunta de seleccion unica");
    }
    final respuesta = respuestas.isNotEmpty ? respuestas.first : null;
    final listaOpciones =
        opciones.map((e) => _buildOpcionDeRespuesta(e)).toList();
    return pr_dom.PreguntaDeSeleccionUnica(
      listaOpciones,
      id: pregunta.id,
      calificable: true, //TODO: solucionar #19
      criticidad: pregunta.criticidad,
      posicion: '${pregunta.eje} / ${pregunta.lado} / ${pregunta.posicionZ}',
      titulo: pregunta.titulo,
      descripcion: '', //TODO: añadir en la creación
      respuesta: respuesta == null
          ? null
          : bl_dom.RespuestaDeSeleccionUnica(
              _buildMetaRespuesta(respuesta.value1),
              listaOpciones.firstWhereOrNull(
                  (opcion) => opcion.id == respuesta.value2?.id),
            ),
    );
  }

  /// Devuelve las respuestas que haya dado el inspector a [pregunta], es List
  /// porque en el caso de las preguntas multiples, en la bd puede haber más de
  /// una respuesta por pregunta
  Future<List<Tuple2<Respuesta, OpcionDeRespuesta?>>>
      _getRespuestaDePreguntaSimple(Pregunta pregunta, int inspeccionId) async {
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
              row.readTableOrNull(opcionesDeRespuesta),
            ))
        .get();

    return res;
  }

  /// Devuelve las cuadriculas de la inspección con sus respectivas preguntas y opciones de respuesta.
  /// También incluye las respuestas que ha dado el inspector.
  Future<List<Tuple2<int, bl_dom.Cuadricula>>> _getCuadriculas(
      int cuestionarioId, int inspeccionId) async {
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
            await _getRespuestasDeCuadricula(entry.value.first.value3.id);
        if (tipo == TipoDePregunta.parteDeCuadriculaUnica) {
          return Tuple2(
              entry.value.first.value2.nOrden,
              await _buildCuadriculaDeSeleccionUnica(
                  entry.value, respuestas, inspeccionId));
        }
        return Tuple2(
            entry.key.nOrden,
            await _buildCuadriculaDeSeleccionMultiple(
                entry.value, respuestas, inspeccionId));
      }),
    );
  }

  /// Devuelve las respuestas de la cuadricula con id=[cuadriculaId], es una lista para el caso de las cuadriculas
  /// con respuesta multiple
  Future<List<OpcionDeRespuesta>> _getRespuestasDeCuadricula(int cuadriculaId) {
    final query = select(opcionesDeRespuesta)
      ..where((or) => or.cuadriculaId.equals(cuadriculaId));
    return query.get();
  }

  Future<bl_dom.CuadriculaDeSeleccionUnica> _buildCuadriculaDeSeleccionUnica(
      List<Tuple3<Pregunta, Bloque, CuadriculaDePreguntas>> value,
      List<OpcionDeRespuesta> opciones,
      int inspeccionId) async {
    return bl_dom.CuadriculaDeSeleccionUnica(
      await Future.wait(value
          .map((e) async => await _buildPreguntaDeSeleccionUnica(
                e.value1,
                opciones,
                inspeccionId,
              ))
          .toList()),
      opciones.map((element) => _buildOpcionDeRespuesta(element)).toList(),
      id: value.first.value3.id,
      titulo: value.first.value3.titulo,
      descripcion: value.first.value3.descripcion,
      criticidad: 0, //TODO: no tiene criticidad /* value.first.value3., */
      posicion: "arriba", // Todo: no tiene posición
      calificable: true, //Todo: no es calificable
    );
  }

  Future<bl_dom.CuadriculaDeSeleccionMultiple>
      _buildCuadriculaDeSeleccionMultiple(
          List<Tuple3<Pregunta, Bloque, CuadriculaDePreguntas>> value,
          List<OpcionDeRespuesta> opciones,
          int inspeccionId) async {
    return bl_dom.CuadriculaDeSeleccionMultiple(
      await Future.wait(value
          .map((e) async => await _buildPreguntaDeSeleccionMultiple(
                e.value1,
                opciones,
                inspeccionId,
              ))
          .toList()),
      opciones.map((element) => _buildOpcionDeRespuesta(element)).toList(),
      id: value.first.value3.id,
      titulo: value.first.value3.titulo,
      descripcion: value.first.value3.descripcion,
      criticidad: 0, //TODO: no tiene criticidad /* value.first.value3., */
      posicion: "arriba", // Todo: no tiene posición
      calificable: true, //Todo: no es calificable
    );
  }

  MetaRespuesta _buildMetaRespuesta(Respuesta respuesta) => MetaRespuesta(
        criticidadInspector: respuesta.calificacion ?? 0,
        observaciones: respuesta.observacion,
        reparada: respuesta.reparado,
        observacionesReparacion: respuesta.observacionReparacion,
        fotosBase: respuesta.fotosBase.toList(),
        fotosReparacion: respuesta.fotosReparacion.toList(),
      );

  pr_dom.OpcionDeRespuesta _buildOpcionDeRespuesta(OpcionDeRespuesta opcion) =>
      pr_dom.OpcionDeRespuesta(
          id: opcion.id,
          titulo: opcion.texto,
          descripcion: "",
          criticidad: opcion.criticidad);
}
