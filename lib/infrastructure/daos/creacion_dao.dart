import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inspecciones/infrastructure/fotos_manager.dart';
import 'package:inspecciones/mvvc/creacion_form_view_model.dart';
import 'package:kt_dart/kt.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/mvvc/creacion_controls.dart';
import 'package:moor/moor.dart';
import 'package:reactive_forms/reactive_forms.dart';

part 'creacion_dao.g.dart';

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
  CriticidadesNumericas,
  PreguntasCondicional,
])
class CreacionDao extends DatabaseAccessor<Database> with _$CreacionDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  CreacionDao(Database db) : super(db);

  Future<List<String>> getModelos() {
    final query = selectOnly(activos, distinct: true)
      ..addColumns([activos.modelo]);

    return query.map((row) => row.read(activos.modelo)).get();
  }

  Future<List<String>> getTiposDeInspecciones() {
    final query = selectOnly(cuestionarios, distinct: true)
      ..addColumns([cuestionarios.tipoDeInspeccion]);

    return query.map((row) => row.read(cuestionarios.tipoDeInspeccion)).get();
  }

  Future<List<Contratista>> getContratistas() => select(contratistas).get();

  Future<List<Sistema>> getSistemas() => select(sistemas).get();

  Future<List<SubSistema>> getSubSistemas(Sistema sistema) {
    if (sistema == null) return Future.value([]);

    final query = select(subSistemas)
      ..where((u) => u.sistemaId.equals(sistema.id));

    return query.get();
  }

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

  Future<CuadriculaConPreguntasYConOpcionesDeRespuesta> getCuadricula(
      int cuadriculaId, int cuestionarioId, int bloqueId) async {
    final query = select(preguntas).join([
      innerJoin(cuadriculasDePreguntas,
          cuadriculasDePreguntas.bloqueId.equals(bloqueId)),
    ])
      ..where(bloques.cuestionarioId.equals(cuestionarioId) &
          preguntas.tipo.equals(2) &
          cuadriculasDePreguntas.id.equals(cuadriculaId));

    final res = await query
        .map((row) =>
            [row.readTable(preguntas), row.readTable(cuadriculasDePreguntas)])
        .get();

    final resultado = CuadriculaConPreguntasYConOpcionesDeRespuesta(
      res.first[1] as CuadriculaDePreguntas,
      await Future.wait(res
          .map((item) async => PreguntaConOpcionesDeRespuesta(
                item[0] as Pregunta,
                await respuestasDeCuadricula(
                    (res.first[1] as CuadriculaDePreguntas).id),
              ))
          .toList()),
      await respuestasDeCuadricula((res.first[1] as CuadriculaDePreguntas).id),
    );
    return resultado;
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
      int cuestionarioId) async {
    final query = select(preguntas).join([
      innerJoin(
        bloques,
        bloques.id.equalsExp(preguntas.bloqueId),
      ),
      leftOuterJoin(criticidadesNumericas,
          criticidadesNumericas.preguntaId.equalsExp(preguntas.id)),
    ])
      ..where(bloques.cuestionarioId.equals(cuestionarioId) &
          (preguntas.tipo.equals(4)));

    final res = await query
        .map((row) => {
              'bloque': row.readTable(bloques),
              'pregunta': row.readTable(preguntas),
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
        );
      }),
    );
    return m;
  }

  Future<List<BloqueConPreguntaSimple>> getPreguntasSimples(
      int cuestionarioId) async {
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
                .map((e) => e['opcionesDePregunta'] as OpcionDeRespuesta)
                .toList(),
            opcionesDeRespuestaConCondicional: entry.value
                .map(
                  (e) => OpcionDeRespuestaConCondicional(
                    e['opcionesDePregunta'] as OpcionDeRespuesta,
                  ),
                )
                .toList(),
          ),
        );
      }),
    );
  }

  Future<List<BloqueConCondicional>> getPreguntasCondicionales(
      int cuestionarioId) async {
    final opcionesPregunta = alias(opcionesDeRespuesta, 'op');

    final query = select(preguntas).join([
      innerJoin(bloques, bloques.id.equalsExp(preguntas.bloqueId)),
      innerJoin(opcionesPregunta,
          opcionesPregunta.preguntaId.equalsExp(preguntas.id)),
      /* innerJoin(preguntasCondicional,
          preguntasCondicional.preguntaId.equalsExp(preguntas.id)) */
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
            })
        .get();

    final x = Future.wait(
      groupBy(res, (e) => e['pregunta']).entries.map((entry) async {
        return BloqueConCondicional(
          entry.value.first['bloque'] as Bloque,
          PreguntaConOpcionesDeRespuesta(
            entry.key as Pregunta,
            entry.value
                .map((e) => e['opcionesDePregunta'] as OpcionDeRespuesta)
                .toList(),
            opcionesDeRespuestaConCondicional: entry.value
                .map(
                  (e) => OpcionDeRespuestaConCondicional(
                    e['opcionesDePregunta'] as OpcionDeRespuesta,
                  ),
                )
                .toList(),
          ),
          await getCondiciones(cuestionarioId),
        );
      }),
    ); //TODO: mirar si se puede optimizar para no realizar subconsulta por cada pregunta
    return x;
  }

  Future<List<PreguntasCondicionalData>> getCondiciones(
      int cuestionarioId) async {
    final query = select(preguntas).join([
      innerJoin(bloques, bloques.id.equalsExp(preguntas.bloqueId)),
      leftOuterJoin(preguntasCondicional,
          preguntasCondicional.preguntaId.equalsExp(preguntas.id)),
    ])
      ..where(bloques.cuestionarioId.equals(cuestionarioId) &
          (preguntas.tipo.equals(0) | preguntas.tipo.equals(1)) &
          preguntas.esCondicional.equals(true));

    final res = await query
        .map((row) => {
              'pregunta': row.readTable(preguntas),
              'condiciones': row.readTable(preguntasCondicional),
            })
        .get();

    final List<PreguntasCondicionalData> condiciones = [];
    Future.wait(
      groupBy(res, (e) => e['pregunta']).entries.map((entry) async {
        entry.value
            .map((e) =>
                condiciones.add(e['condiciones'] as PreguntasCondicionalData))
            .toList();
      }),
    );

    return condiciones;
  }

  Future<List<BloqueConCuadricula>> getCuadriculasSinPreguntas(
      int cuestionarioId) async {
    final query1 = select(cuadriculasDePreguntas).join([
      innerJoin(bloques, bloques.id.equalsExp(cuadriculasDePreguntas.bloqueId)),
    ])
      ..where(bloques.cuestionarioId.equals(cuestionarioId));
    //parteDeCuadriculaUnica

    final res = await query1
        .map((row) => {
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
            await respuestasDeCuadricula1(
                (entry.value.first['cuadricula'] as CuadriculaDePreguntas).id),
          ),
        );
      }),
    );
  }

  Future<List<BloqueConCuadricula>> getCuadriculas(int cuestionarioId,
      [int inspeccionId]) async {
    final query1 = select(cuadriculasDePreguntas).join([
      innerJoin(bloques, bloques.id.equalsExp(cuadriculasDePreguntas.bloqueId)),
      leftOuterJoin(preguntas, preguntas.bloqueId.equalsExp(bloques.id))
    ])
      ..where(bloques.cuestionarioId.equals(cuestionarioId) &
          (preguntas.tipo.equals(2) | preguntas.tipo.equals(3)));
    //parteDeCuadriculaUnica

    final res = await query1
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
            await respuestasDeCuadricula1(
                (entry.value.first['cuadricula'] as CuadriculaDePreguntas).id),
          ),
          preguntas: await Future.wait(entry.value.map(
            (item) async => PreguntaConOpcionesDeRespuesta(
                item['pregunta'] as Pregunta, []),
          )),
        );
      }),
    );
  }

  Future<List<OpcionDeRespuesta>> respuestasDeCuadricula1(int cuadriculaId) {
    final query = select(opcionesDeRespuesta)
      ..where((or) => or.cuadriculaId.equals(cuadriculaId));
    return query.get();
  }

  Future<List<OpcionDeRespuestaConCondicional>> respuestasDeCuadricula(
      int cuadriculaId) async {
    final query = select(opcionesDeRespuesta)
      ..where((or) => or.cuadriculaId.equals(cuadriculaId));
    final res = await query.get();
    final opcionesDeCuadricula =
        res.map((e) => OpcionDeRespuestaConCondicional(e)).toList();
    return opcionesDeCuadricula;
  }

  Future<List<IBloqueOrdenable>> cargarCuestionario(int cuestionarioId,
      {int activoId}) async {
    final inspeccion = await (select(inspecciones)
          ..where((tbl) =>
              tbl.cuestionarioId.equals(cuestionarioId) &
              tbl.activoId.equals(activoId)))
        .getSingle();

    final inspeccionId = inspeccion?.id;

    final List<BloqueConTitulo> titulos = await getTitulos(cuestionarioId);

    final List<BloqueConCondicional> preguntasCondicionales =
        await getPreguntasCondicionales(cuestionarioId);

    final List<BloqueConPreguntaSimple> preguntasSimples =
        await getPreguntasSimples(cuestionarioId);

    final List<BloqueConCuadricula> cuadriculasDeApoyo =
        await getCuadriculas(cuestionarioId, inspeccionId);

    final List<BloqueConCuadricula> cuadriculas = cuadriculasDeApoyo.isEmpty
        ? await getCuadriculasSinPreguntas(cuestionarioId)
        : cuadriculasDeApoyo;

    final List<BloqueConPreguntaNumerica> numerica =
        await getPreguntaNumerica(cuestionarioId);

    return [
      ...titulos,
      ...preguntasSimples,
      ...cuadriculas,
      ...numerica,
      ...preguntasCondicionales
    ];
  }

  Future<Cuestionario> getCuestionarioToSave(
    Cuestionario cuestionario,
    List<CuestionarioDeModelo> cuestionariosDeModelo,
  ) async {
    //revisar si hay una inspeccion de ese cuestionario empezada
    if (cuestionario.id == null) return Future.value();
    final query = select(cuestionarios)
      ..where((cues) => cues.id.equals(cuestionario.id));

    await (update(cuestionarios)..where((i) => i.id.equals(cuestionario.id)))
        .write(
      CuestionariosCompanion(
          tipoDeInspeccion: Value(cuestionario.tipoDeInspeccion),
          estado: Value(cuestionario.estado)),
    );

    /* cuestionariosDeModelo.map((e) async => {
      await(update(cuestionarioDeModelos)..where((cues) => cues.cuestionarioId))
    }); */

    return query.getSingle();
  }

  Future<Cuestionario> crearCuestionarioToSave(
      Cuestionario cuestionario) async {
    final int cid = await into(cuestionarios).insert(
        CuestionariosCompanion.insert(
            tipoDeInspeccion: cuestionario.tipoDeInspeccion,
            estado: cuestionario.estado));
    return (select(cuestionarios)..where((i) => i.id.equals(cid))).getSingle();
  }

  Future guardarCuestionario(
      Cuestionario cuestionario,
      List<CuestionarioDeModelo> cuestionariosDeModelo,
      List<IBloqueOrdenable> bloquesAGuardar,
      CreacionFormViewModel form) async {
    return transaction(
      () async {
        Cuestionario cuesti =
            await getCuestionarioToSave(cuestionario, cuestionariosDeModelo);
        cuesti ??= await crearCuestionarioToSave(cuestionario);

        form.cuestionario = cuesti;

        final List<int> mo = [];
        await Future.forEach<CuestionarioDeModelo>(cuestionariosDeModelo,
            (e) async {
          //Mover las fotos a una carpeta unica para cada inspeccion
          final id = Value(e.id).present;
          e = e.copyWith(cuestionarioId: cuesti.id);
          if (id) {
            final x =
                await into(cuestionarioDeModelos).insertOnConflictUpdate(e);
            mo.add(x);
          } else {
            mo.add(await into(cuestionarioDeModelos).insert(e));
          }
        });

        await (delete(cuestionarioDeModelos)
              ..where((rxor) =>
                  rxor.id.isNotIn(mo) & rxor.cuestionarioId.equals(cuesti.id)))
            .go();

        final List<int> bloquesId = [];

        await Future.forEach<IBloqueOrdenable>(bloquesAGuardar, (e) async {
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

            final List<int> opcionesId = [];
            await Future.forEach<OpcionDeRespuesta>(
                e?.pregunta?.opcionesDeRespuesta, (or) async {
              //Mover las fotos a una carpeta unica para cada inspeccion
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

            await (delete(opcionesDeRespuesta)
                  ..where((rxor) =>
                      rxor.id.isNotIn(opcionesId) &
                      rxor.preguntaId.equals(preguntaId)))
                .go();
          }

          if (e is BloqueConCondicional) {
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

            final List<int> opcionesId = [];
            final List<int> condicionesId = [];
            await Future.forEach<OpcionDeRespuestaConCondicional>(
                e?.pregunta?.opcionesDeRespuestaConCondicional, (or) async {
              //Mover las fotos a una carpeta unica para cada inspeccion
              final opcion = or.opcionRespuesta
                  .toCompanion(true)
                  .copyWith(preguntaId: Value(preguntaId));
              int opcionId;
              if (opcion.id.present) {
                await into(opcionesDeRespuesta).insertOnConflictUpdate(opcion);
                opcionId = opcion.id.value;
              } else {
                opcionId = await into(opcionesDeRespuesta).insert(opcion);
              }
              opcionesId.add(opcionId);

              final condicion = or.condiciones.toCompanion(true).copyWith(
                  preguntaId: Value(preguntaId),
                  seccion: Value(or.condiciones.seccion - 1));
              if (condicion.id.present) {
                final x = await into(preguntasCondicional)
                    .insertOnConflictUpdate(condicion);
                condicionesId.add(x);
              } else {
                condicionesId
                    .add(await into(preguntasCondicional).insert(condicion));
              }
            });
            await (delete(opcionesDeRespuesta)
                  ..where((rxor) =>
                      rxor.id.isNotIn(opcionesId) &
                      rxor.preguntaId.equals(preguntaId)))
                .go();

            await (delete(preguntasCondicional)
                  ..where((con) =>
                      con.id.isNotIn(condicionesId) &
                      con.preguntaId.equals(preguntaId)))
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
            await Future.forEach<PreguntaConOpcionesDeRespuesta>(e?.preguntas,
                (or) async {
              //Mover las fotos a una carpeta unica para cada inspeccion
              final pregunta = or.pregunta.toCompanion(true).copyWith(
                  bloqueId: Value(bloqueId));
              int preguntaId;
              if (pregunta.id.present) {
                await into(preguntas).insertOnConflictUpdate(pregunta);
                preguntaId = or.pregunta.id;
              } else {
                preguntaId = await into(preguntas).insert(pregunta);
              }
              preguntasId.add(preguntaId);
            });
            await (delete(preguntas)
                  ..where((rxor) =>
                      rxor.id.isNotIn(preguntasId) &
                      rxor.bloqueId.equals(bloqueId)))
                .go();
            final List<int> opcionesId = [];
            await Future.forEach<OpcionDeRespuesta>(
                e?.cuadricula?.opcionesDeRespuesta, (or) async {
              //Mover las fotos a una carpeta unica para cada inspeccion
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
            await Future.forEach<CriticidadesNumerica>(
                e?.pregunta?.criticidades, (cri) async {
              //Mover las fotos a una carpeta unica para cada inspeccion
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
            await (delete(criticidadesNumericas)
                  ..where((cri) =>
                      cri.id.isNotIn(criticidadesId) &
                      cri.preguntaId.equals(preguntaId)))
                .go();
          }
        });
        await (delete(bloques)
              ..where((bloque) =>
                  bloque.id.isNotIn(bloquesId) &
                  bloque.cuestionarioId.equals(cuesti.id)))
            .go();
      },
    );
  }
}
