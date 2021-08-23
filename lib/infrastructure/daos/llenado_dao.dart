import 'dart:math';

import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:inspecciones/infrastructure/fotos_manager.dart';
import 'package:intl/intl.dart';
import 'package:kt_dart/kt.dart';
import 'package:moor/moor.dart';

import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';

part 'llenado_dao.g.dart';

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
class LlenadoDao extends DatabaseAccessor<Database> with _$LlenadoDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  LlenadoDao(Database db) : super(db);

  /// Trae una lista con todos los cuestionarios disponibles para un activo,
  /// incluyendo los cuestionarios que son asignados a todos los activos
  Future<List<Cuestionario>> cuestionariosParaActivo(int activo) async {
    //if (activo == null) return [];
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

  /// Devuelve las preguntas numericas de la inspección, con la respuesta que
  /// se haya insertado y las criticidadesNumericas (rangos de criticidad)
  Future<List<BloqueConPreguntaNumerica>> getPreguntaNumerica(
      int cuestionarioId,

      /// Usada para obtener las respuestas del inspector a la pregunta
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
        return BloqueConPreguntaNumerica(
          // todas deberian tener el mismo bloque, TODO: comprobar esto
          entry.value.first.value1,
          PreguntaNumerica(
            entry.key,

            /// Se cargan las criticidades para poder calcular la criticidad total de la pregunta de acuerdo a la respuesta.
            entry.value.map((item) => item.value4).toList(),
          ),
          await getRespuestaDePreguntaNumerica(entry.key, inspeccionId),
        );
      }),
    );
  }

  /// Devuelve la respuesta a [pregunta] de tipo numerica.
  Future<RespuestasCompanion> getRespuestaDePreguntaNumerica(
      Pregunta pregunta, int inspeccionId) async {
    ///Si la inspeccion es nueva entonces no existe una respuesta y se envia nulo
    ///para que el control cree una por defecto
    if (inspeccionId == null) return null;
    final query = select(respuestas)
      ..where(
        (u) =>
            u.preguntaId.equals(pregunta.id) &
            u.inspeccionId.equals(inspeccionId),
      );
    final res = await query.get();

    ///Si no han contestado la pregunta se envia nulo para que el control cree una por defecto
    if (res.isEmpty) return null;

    final respuesta = res.last;
    return respuesta.toCompanion(true);
  }

  /// Devuelve las preguntas de tipo selección asociadas al cuestionario con id=[cuestionarioId]
  /// Junto con sus opciones de respuesta y las respuestas que haya insertado el inspector.
  Future<List<BloqueConPreguntaSimple>> getPreguntasSimples(int cuestionarioId,
      [int inspeccionId]) async {
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

  /// Devuelve las respuestas que haya dado el inspector a [pregunta], es [List<RespuestaConOpcionesDeRespuesta>]
  /// porque en el caso de las preguntas multiples, en la bd puede haber más d euna respuesta por pregunta
  Future<List<RespuestaConOpcionesDeRespuesta>> getRespuestaDePregunta(
      Pregunta pregunta, int inspeccionId) async {
    //TODO: mirar el caso donde se presenten varias respuestas a una preguntaXinspeccion
    // Hasta el momento se está dando el caso para las preguntas de tipo multiple, en donde el par preguntaId-inspeccionId
    // No es único, hasta el momento no genera ningún problema, pero

    ///Si la inspeccion es nueva entonces no existe una respuesta y se envia nulo
    ///para que el control cree una por defecto
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

    ///Si existe la inspeccion y no se ha contestado la pregunta, se envia nulo
    ///para que el control cree una por defecto
    if (res.isEmpty) return [RespuestaConOpcionesDeRespuesta(null, null)];
    return res
        .map(
          (e) => RespuestaConOpcionesDeRespuesta(
            (e[0] as Respuesta).toCompanion(true),
            e[1] as OpcionDeRespuesta,
          ),
        )
        .toList();
  }

  /// Devuelve las cuadriculas de la inspección con sus respectivas preguntas y opciones de respuesta.
  /// También incluye las respuestas que ha dado el inspector.
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

          /// Carga todas las preguntas y opciones de respuesta de la cuadricula
          CuadriculaDePreguntasConOpcionesDeRespuesta(
            entry.value.first['cuadricula'] as CuadriculaDePreguntas,
            await respuestasDeCuadricula(
                (entry.value.first['cuadricula'] as CuadriculaDePreguntas).id),
          ),

          /// Estas son las respuestas que ha dado el inspector. Incluye la pregunta y la respuesta seleccionada
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
  Future<List<IBloqueOrdenable>> cargarInspeccion(
      int cuestionarioId, int activoId) async {
    final inspeccion = await (select(inspecciones)
          ..where((tbl) =>
              tbl.cuestionarioId.equals(cuestionarioId) &
              tbl.activoId.equals(activoId) &

              /// Para no cargar las que están en el historial
              isNull(tbl.momentoEnvio)))
        .getSingle();

    final inspeccionId = inspeccion?.id;

    final List<BloqueConTitulo> titulos = await getTitulos(cuestionarioId);

    /// De selección multiple o unica
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

  /// Crea id para una inspección con el formato 'yyMMddHHmm[activo]'
  int generarId(int activo) {
    final fechaFormateada = DateFormat("yyMMddHHmm").format(DateTime.now());
    return int.parse('$fechaFormateada$activo');
  }

  /// Devuelve la inspección creada al guardarla por primera vez.
  Future<Inspeccion> crearInspeccion(
      int cuestionarioId,

      /// Activo al cual se le está realizando la inspección.
      int activo,
      EstadoDeInspeccion estado,

      /// Criticidad de la inspección antes de reparaciones.
      double criticidad,

      /// Criticidad de la inspección después de reparaciones.
      double criticidadReparacion) async {
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

  /// Realiza el guardado de la inspección al presionar el botón guardar o finalizar en el llenado.
  Future guardarInspeccion(
      List<List<RespuestaConOpcionesDeRespuesta>> respuestasForm,
      int cuestionarioId,
      int activoId,
      EstadoDeInspeccion estado,

      /// Criticidad de la inspección antes de reparaciones.
      double criticidad,

      /// Criticidad de la inspección después de reparaciones.
      double criticidadReparacion) async {
    return transaction(() async {
      /// Se redondea para evitar que se guarde en la bd un montón de decimales.
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
      );

      /// Se comienza a procesar las respuestas a cada pregunta.
      final List<int> respuestasId = [];
      await Future.forEach<List<RespuestaConOpcionesDeRespuesta>>(
          respuestasForm, (resp) async {
        for (final rf in resp) {
          /// Asociación de cada respuesta con [ins].
          if (rf != null) {
            rf.respuesta = rf?.respuesta?.copyWith(inspeccionId: Value(ins.id));
          }
        }

        /// Se obtiene la primera respuesta que se haya hecho.
        ///
        /// En este caso no importa cual sea pues solo se necesita para obtener [idform] para dar el nombre de la carpeta de las fotos con [idform].
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

      /// Se eliminan de la bd las respuestas que hayan sido deseleccionadas.
      ///
      /// Pr ejemplo, en caso de las multiples, se puede elegir una opción en una ocasión y luego deseleccionarla, en este caso, la eliminamos también de la bd
      await (delete(respuestas)
            ..where((resp) =>
                resp.id.isNotIn(respuestasId) &
                resp.inspeccionId.equals(ins.id)))
          .go();
    });
  }

  // funciones para subir al server
  /// Método no usado por ahora
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
