import 'package:collection/collection.dart';
import 'package:inspecciones/infrastructure/fotos_manager.dart';
import 'package:intl/intl.dart';
import 'package:kt_dart/kt.dart';
import 'package:moor/moor.dart';

import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';

part 'llenado_dao.g.dart';

@UseDao(tables: [
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
class LlenadoDao extends DatabaseAccessor<Database> with _$LlenadoDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  LlenadoDao(Database db) : super(db);

  /// Trae una lista con todos los cuestionarios disponibles para un activo,
  /// incluyendo los cuestionarios que son asignados a todos los activos
  Future<List<Cuestionario>> cuestionariosParaActivo(int activo) async {
    if (activo == null) return [];
    /*
    final query = select(activos).join([
      innerJoin(cuestionarioDeModelos,
          cuestionarioDeModelos.modelo.equalsExp(activos.modelo)),
      innerJoin(cuestionarios,
          cuestionarios.id.equalsExp(cuestionarioDeModelos.cuestionarioId))
    ])
      ..where(activos.identificador.equals(vehiculo));

    return query.map((row) {
      return row.readTable(cuestionarios);
    }).get();*/

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

  Future<Inspeccion> getInspeccion(int activoId, int cuestionarioId) {
    //revisar si hay una inspeccion de ese cuestionario empezada
    if (cuestionarioId == null || activoId == null) return Future.value();
    final query = select(inspecciones)
      ..where(
        (ins) =>
            ins.cuestionarioId.equals(cuestionarioId) &
            ins.activoId.equals(activoId),
      );

    return query.getSingle();
  }

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

  Future<List<BloqueConPreguntaNumerica>> getPreguntaNumerica(
      int cuestionarioId,
      [int inspeccionId]) async {
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
        .map((row) => {
              'bloque': row.readTable(bloques),
              'pregunta': row.readTable(preguntas),
              'respuesta': row.readTable(respuestas),
              'criticidades': row.readTable(criticidadesNumericas)
            })
        .get();

    final m = Future.wait(
      groupBy(res, (e) => e['pregunta']).entries.map((entry) async {
        return BloqueConPreguntaNumerica(
          entry.value.first['bloque'] as Bloque,
          PreguntaNumerica(
            entry.key as Pregunta,
            entry.value
                .map((item) => item['criticidades'] as CriticidadesNumerica)
                .toList(),
          ),
          respuesta: await getRespuestaDePreguntaNumerica(
              entry.key as Pregunta, inspeccionId),
        );
      }),
    );
    return m;
  }

  Future<RespuestasCompanion> getRespuestaDePreguntaNumerica(
      Pregunta pregunta, int inspeccionId) async {
    if (inspeccionId == null) {
      return const RespuestasCompanion(
        fotosBase: null,
        id: null,
        reparado: null,
        observacion: null,
        fotosReparacion: null,
        inspeccionId: null,
        observacionReparacion: null,
        preguntaId: null,
      );
    }
    final query = select(respuestas)
      ..where(
        (u) =>
            u.preguntaId.equals(pregunta.id) &
            u.inspeccionId.equals(inspeccionId), //seleccion multiple
      );
    final res = await query.get();
    //si la inspeccion es nueva entonces no existe una respuesta y se envia nulo
    //para que el control cree una por defecto
    if (res.isEmpty) {
      return const RespuestasCompanion(
        fotosBase: null,
        id: null,
        reparado: null,
        observacion: null,
        fotosReparacion: null,
        inspeccionId: null,
        observacionReparacion: null,
        preguntaId: null,
      );
    }

    final respuesta = res.last;
    return respuesta.toCompanion(true);
  }

  Future<List<BloqueConPreguntaSimple>> getPreguntasSimples(int cuestionarioId,
      [int inspeccionId]) async {
    final opcionesPregunta = alias(opcionesDeRespuesta, 'op');

    final query = select(preguntas).join([
      innerJoin(bloques, bloques.id.equalsExp(preguntas.bloqueId)),
      leftOuterJoin(opcionesPregunta,
          opcionesPregunta.preguntaId.equalsExp(preguntas.id)),
    ])
      ..where(bloques.cuestionarioId.equals(cuestionarioId) &
          (preguntas.tipo.equals(0) | preguntas.tipo.equals(1)) &
          preguntas.esCondicional.equals(false));
    //unicaRespuesta/multipleRespuesta
    final res = await query
        .map((row) => {
              'bloque': row.readTable(bloques),
              'pregunta': row.readTable(preguntas),
              'opcionesDePregunta': row.readTable(opcionesPregunta)
            })
        .get();

    return Future.wait(
      groupBy(res, (e) => e['pregunta']).entries.map((entry) async {
        return BloqueConPreguntaSimple(
          entry.value.first['bloque'] as Bloque,
          PreguntaConOpcionesDeRespuesta(
            entry.key as Pregunta,
            entry.value
                .map((item) => item['opcionesDePregunta'] as OpcionDeRespuesta)
                .toList(),
          ),
          respuesta:
              await getRespuestaDePregunta(entry.key as Pregunta, inspeccionId),
          //TODO: mirar si se puede optimizar para no realizar subconsulta por cada pregunta
        );
      }),
    );
  }

  /*  Future<List<BloqueConCondicional>> getPreguntasCondicionales(
      int cuestionarioId,
      [int inspeccionId]) async {
    final opcionesPregunta = alias(opcionesDeRespuesta, 'op');

    final query = select(preguntas).join([
      innerJoin(bloques, bloques.id.equalsExp(preguntas.bloqueId)),
      innerJoin(preguntasCondicional,
          preguntasCondicional.preguntaId.equalsExp(preguntas.id)),
      leftOuterJoin(opcionesPregunta,
          opcionesPregunta.preguntaId.equalsExp(preguntas.id)),
    ])
      ..where(bloques.cuestionarioId.equals(cuestionarioId) &
          (preguntas.tipo.equals(0) | preguntas.tipo.equals(1)) &
          preguntas.esCondicional.equals(true));
    //unicaRespuesta/multipleRespuesta
    final res = await query
        .map((row) => {
              'bloque': row.readTable(bloques),
              'pregunta': row.readTable(preguntas),
              'opcionesDePregunta': row.readTable(opcionesPregunta),
              'condiciones': row.readTable(preguntasCondicional),
            })
        .get();

    final x = Future.wait(
      groupBy(res, (e) => e['pregunta']).entries.map((entry) async {
        return BloqueConCondicional(
          entry.value.first['bloque'] as Bloque,
          PreguntaConOpcionesDeRespuesta(
            entry.key as Pregunta,
            entry.value
                .map((item) => item['opcionesDePregunta'] as OpcionDeRespuesta)
                .toList(),
          ),
          entry.value
              .map((e) => e['condiciones'] as PreguntasCondicionalData)
              .toList(),
          respuesta:
              await getRespuestaDePregunta(entry.key as Pregunta, inspeccionId),

          //TODO: mirar si se puede optimizar para no realizar subconsulta por cada pregunta
        );
      }),
    ); //TODO: mirar si se puede optimizar para no realizar subconsulta por cada pregunta
    return x;
  } */

  Future<List<RespuestaConOpcionesDeRespuesta>> getRespuestaDePregunta(
      Pregunta pregunta, int inspeccionId) async {
    //TODO: mirar el caso donde se presenten varias respuestas a una preguntaXinspeccion
    if (inspeccionId == null) {
      return [RespuestaConOpcionesDeRespuesta(null, null)];
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
        .map((row) =>
            [row.readTable(respuestas), row.readTable(opcionesDeRespuesta)])
        .get();

    //si la inspeccion es nueva entonces no existe una respuesta y se envia nulo
    //para que el control cree una por defecto
    if (res.isEmpty) return [RespuestaConOpcionesDeRespuesta(null, null)];
    final lo = res
        .map(
          (e) => RespuestaConOpcionesDeRespuesta(
            (e[0] as Respuesta).toCompanion(true),
            e[1] as OpcionDeRespuesta,
          ),
        )
        .toList();
    return lo;
  }

  Future<List<BloqueConCuadricula>> getCuadriculas(int cuestionarioId,
      [int inspeccionId]) async {
    final query = select(preguntas).join([
      innerJoin(bloques, bloques.id.equalsExp(preguntas.bloqueId)),
      innerJoin(cuadriculasDePreguntas,
          cuadriculasDePreguntas.bloqueId.equalsExp(bloques.id)),
    ])
      ..where(bloques.cuestionarioId.equals(cuestionarioId) &
          (preguntas.tipo.equals(2) | preguntas.tipo.equals(3)));

    //parteDeCuadriculaUnica

    final res = await query
        .map((row) => {
              'pregunta': row.readTable(preguntas),
              'bloque': row.readTable(bloques),
              'cuadricula': row.readTable(cuadriculasDePreguntas),
            })
        .get();

    return Future.wait(
      groupBy(res, (e) => e['bloque'] as Bloque).entries.map((entry) async {
        return BloqueConCuadricula(
          entry.key,
          CuadriculaDePreguntasConOpcionesDeRespuesta(
            entry.value.first['cuadricula'] as CuadriculaDePreguntas,
            await respuestasDeCuadricula(
                (entry.value.first['cuadricula'] as CuadriculaDePreguntas).id),
          ),
          preguntasRespondidas: await Future.wait(entry.value.map(
            (item) async => PreguntaConRespuestaConOpcionesDeRespuesta(
                item['pregunta'] as Pregunta,
                await getRespuestaDePregunta(
                    item['pregunta'] as Pregunta, inspeccionId)),
          )),
        );
      }),
    );
  }

  Future<List<OpcionDeRespuesta>> respuestasDeCuadricula(int cuadriculaId) {
    final query = select(opcionesDeRespuesta)
      ..where((or) => or.cuadriculaId.equals(cuadriculaId));
    return query.get();
  }

  Future<List<IBloqueOrdenable>> cargarCuestionario(
      int cuestionarioId, int activoId) async {
    final inspeccion = await (select(inspecciones)
          ..where((tbl) =>
              tbl.cuestionarioId.equals(cuestionarioId) &
              tbl.activoId.equals(activoId)))
        .getSingle();

    final inspeccionId = inspeccion?.id;

    final List<BloqueConTitulo> titulos = await getTitulos(cuestionarioId);

    /* final List<BloqueConCondicional> preguntasCondicionales =
        await getPreguntasCondicionales(cuestionarioId, inspeccionId); */

    final List<BloqueConPreguntaSimple> preguntasSimples =
        await getPreguntasSimples(cuestionarioId, inspeccionId);

    final List<BloqueConCuadricula> cuadriculas =
        await getCuadriculas(cuestionarioId, inspeccionId);

    final List<BloqueConPreguntaNumerica> numerica =
        await getPreguntaNumerica(cuestionarioId, inspeccionId);

    return [
      ...titulos,
      ...preguntasSimples,
      ...cuadriculas,
      ...numerica,
      /* ...preguntasCondicionales */
    ];
  }

  int generarId(int activo) {
    final fechaFormateada = DateFormat("yyMMddHHmm").format(DateTime.now());
    return int.parse('$fechaFormateada$activo');
  }

  Future<Inspeccion> crearInspeccion(
      int cuestionarioId,
      int activo,
      EstadoDeInspeccion estado,
      int criticidad,
      int criticidadReparacion) async {
    if (activo == null) throw Exception("activo nulo");
    final ins = InspeccionesCompanion.insert(
      id: Value(generarId(activo)),
      cuestionarioId: cuestionarioId,
      estado: estado,
      criticidadTotal: criticidad,
      criticidadReparacion: criticidadReparacion,
      activoId: activo,
      momentoInicio: Value(DateTime.now()),
    );
    final id = await into(inspecciones).insert(ins);
    return (select(inspecciones)..where((i) => i.id.equals(id))).getSingle();
  }

  Future guardarInspeccion(
      List<List<RespuestaConOpcionesDeRespuesta>> respuestasForm,
      int cuestionarioId,
      int activoId,
      EstadoDeInspeccion estado,
      int criticidad,
      int criticidadReparacion) async {
    return transaction(() async {
      Inspeccion ins = await getInspeccion(activoId, cuestionarioId);
      ins ??= await crearInspeccion(
          cuestionarioId, activoId, estado, criticidad, criticidadReparacion);

      await (update(inspecciones)..where((i) => i.id.equals(ins.id))).write(
        estado == EstadoDeInspeccion.finalizada
            ? InspeccionesCompanion(
                momentoEnvio: Value(DateTime.now()),
                estado: Value(estado),
                criticidadTotal: Value(criticidad),
                criticidadReparacion: Value(criticidadReparacion))
            : InspeccionesCompanion(
                momentoBorradorGuardado: Value(DateTime.now()),
                estado: Value(estado),
                criticidadTotal: Value(criticidad),
                criticidadReparacion: Value(criticidadReparacion),
              ),
      );
      final List<int> respuestasId = [];
      await Future.forEach<List<RespuestaConOpcionesDeRespuesta>>(
          respuestasForm, (resp) async {
        //Mover las fotos a una carpeta unica para cada inspeccion
        for (final rf in resp) {
          if (rf != null) {
            rf.respuesta = rf?.respuesta?.copyWith(inspeccionId: Value(ins.id));
          }
        }
        final respuesta = respuestasForm.firstWhere((resp) => resp.isNotEmpty,
            orElse: () => null);

        final idform =
            respuesta?.first?.respuesta?.inspeccionId?.value?.toString();

        await Future.forEach<RespuestaConOpcionesDeRespuesta>(resp, (e) async {
          if (e != null) {
            final fotosBaseProc = idform != null
                ? await FotosManager.organizarFotos(e.respuesta.fotosBase.value,
                    tipoDocumento: "inspecciones", idDocumento: idform)
                : null;

            final fotosRepProc = idform != null
                ? await FotosManager.organizarFotos(
                    e.respuesta.fotosReparacion.value,
                    tipoDocumento: "inspecciones",
                    idDocumento: idform)
                : null;
            e.respuesta = e.respuesta.copyWith(
              fotosBase: Value(fotosBaseProc.toImmutableList()),
              fotosReparacion: Value(fotosRepProc.toImmutableList()),
            );

            int res;
            if (e.respuesta.id.present) {
              await into(respuestas).insertOnConflictUpdate(e.respuesta);
              res = e.respuesta.id.value;
              respuestasId.add(res);
            } else {
              res = await into(respuestas).insert(e.respuesta);
              respuestasId.add(res);
            }
          }
        });
      });
      await (delete(respuestas)
            ..where((resp) =>
                resp.id.isNotIn(respuestasId) &
                resp.inspeccionId.equals(ins.id)))
          .go();
    });
  }

  // funciones para subir al server
  Future<List<RespuestaConOpcionesDeRespuesta2>> getRespuestasDeInspeccion(
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
  }
}
