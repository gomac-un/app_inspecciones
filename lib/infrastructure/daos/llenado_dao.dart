import 'package:collection/collection.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:moor/moor.dart';

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
  RespuestasXOpcionesDeRespuesta,
  Contratistas,
  Sistemas,
  SubSistemas,
])
class LlenadoDao extends DatabaseAccessor<Database> with _$LlenadoDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  LlenadoDao(Database db) : super(db);

  Future<List<CuestionarioDeModelo>> cuestionariosParaVehiculo(
      String vehiculo) {
    final query = select(activos).join([
      innerJoin(cuestionarioDeModelos,
          cuestionarioDeModelos.modelo.equalsExp(activos.modelo)),
    ])
      ..where(activos.identificador.equals(vehiculo));

    return query.map((row) {
      return row.readTable(cuestionarioDeModelos);
    }).get();
  }

  Future<Inspeccion> getInspeccion(String activo, int cuestionarioId) {
    //revisar si hay una inspeccion de ese cuestionario empezada
    if (cuestionarioId == null || activo == null) return null;
    final query = select(inspecciones)
      ..where(
        (ins) =>
            ins.cuestionarioId.equals(cuestionarioId) &
            ins.identificadorActivo.equals(activo),
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

  Future<List<BloqueConPreguntaSimple>> getPreguntasSimples(int cuestionarioId,
      [int inspeccionId]) async {
    final opcionesPregunta = alias(opcionesDeRespuesta, 'op');

    final query = select(preguntas).join([
      innerJoin(bloques, bloques.id.equalsExp(preguntas.bloqueId)),
      leftOuterJoin(opcionesPregunta,
          opcionesPregunta.preguntaId.equalsExp(preguntas.id)),
    ])
      ..where(bloques.cuestionarioId.equals(cuestionarioId) &
          /*((preguntas.tipo.equals(0) //seleccion unica
                    |
                    preguntas.tipo.equals(1)) //seleccion multiple
                &*/
          preguntas.parteDeCuadricula.equals(false));
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
          entry.value.first['bloque'],
          PreguntaConOpcionesDeRespuesta(
            entry.key,
            entry.value
                .map((item) => item['opcionesDePregunta'] as OpcionDeRespuesta)
                .toList(),
          ),
          await getRespuestas(entry.key.id, inspeccionId),
          //TODO: mirar si se puede optimizar para no realizar subconsulta por cada pregunta
        );
      }),
    );
  }

  Future<RespuestaConOpcionesDeRespuesta> getRespuestas(int preguntaId,
      [int inspeccionId]) async {
    //TODO: mirar el caso donde se presenten varias respuestas a una preguntaXinspeccion
    if (inspeccionId == null)
      return RespuestaConOpcionesDeRespuesta(null, null);
    final query = select(respuestas).join([
      leftOuterJoin(
        //left outer join para que carguen las respuestas sin opciones seleccionadas
        respuestasXOpcionesDeRespuesta,
        respuestasXOpcionesDeRespuesta.respuestaId.equalsExp(respuestas.id),
      ),
      leftOuterJoin(
        opcionesDeRespuesta,
        opcionesDeRespuesta.id
            .equalsExp(respuestasXOpcionesDeRespuesta.opcionDeRespuestaId),
      ),
    ])
      ..where(
        respuestas.preguntaId.equals(preguntaId) &
            respuestas.inspeccionId.equals(inspeccionId), //seleccion multiple
      );
    final res = await query
        .map((row) =>
            [row.readTable(respuestas), row.readTable(opcionesDeRespuesta)])
        .get();
    //si la inspeccion es nueva entonces no existe una respuesta y se envia nulo
    //para que el control cree una por defecto
    if (res.length == 0) return RespuestaConOpcionesDeRespuesta(null, null);

    return RespuestaConOpcionesDeRespuesta(
        (res.first[0] as Respuesta)
            .toCompanion(true), //TODO: si se necesita companion?
        res.map((item) => item[1] as OpcionDeRespuesta).toList());
  }

  Future<List<BloqueConCuadricula>> getCuadriculas(int cuestionarioId,
      [int inspeccionId]) async {
    final query = select(preguntas).join([
      innerJoin(bloques, bloques.id.equalsExp(preguntas.bloqueId)),
      innerJoin(cuadriculasDePreguntas,
          cuadriculasDePreguntas.bloqueId.equalsExp(bloques.id)),
    ])
      ..where(bloques.cuestionarioId.equals(cuestionarioId)
          // & preguntas.tipo.equals(2) //parteDeCuadricula

          );

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
            entry.value.first['cuadricula'],
            await respuestasDeCuadricula(
                (entry.value.first['cuadricula'] as CuadriculaDePreguntas).id),
          ),
          await Future.wait(entry.value.map(
            (item) async => PreguntaConRespuestaConOpcionesDeRespuesta(
                item['pregunta'] as Pregunta,
                await getRespuestas(
                    (item['pregunta'] as Pregunta).id, inspeccionId)),
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
      int cuestionarioId, String activo) async {
    final inspeccion = await (select(inspecciones)
          ..where((tbl) =>
              tbl.cuestionarioId.equals(cuestionarioId) &
              tbl.identificadorActivo.equals(activo)))
        .getSingle();

    final inspeccionId = inspeccion?.id;

    final List<BloqueConTitulo> titulos = await getTitulos(cuestionarioId);

    final List<BloqueConPreguntaSimple> preguntasSimples =
        await getPreguntasSimples(cuestionarioId, inspeccionId);

    final List<BloqueConCuadricula> cuadriculas =
        await getCuadriculas(cuestionarioId, inspeccionId);

    return [...titulos, ...preguntasSimples, ...cuadriculas];
  }
}