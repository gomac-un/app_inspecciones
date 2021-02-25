import 'dart:io';

import 'package:inspecciones/infrastructure/fotos_manager.dart';
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

  Future<List<OpcionDeRespuesta>> respuestasDeCuadricula(int cuadriculaId) {
    final query = select(opcionesDeRespuesta)
      ..where((or) => or.cuadriculaId.equals(cuadriculaId));
    return query.get();
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

  /* Future crearCuestionario(Map<String, AbstractControl> form, EstadoDeCuestionario estado) {
    return transaction(() async {
      final String tipoDeInspeccion = form["tipoDeInspeccion"].value == "otra"
          ? form["nuevoTipoDeInspeccion"].value as String
          : form["tipoDeInspeccion"].value as String;

      final int cid = await into(cuestionarios).insert(
          CuestionariosCompanion.insert(tipoDeInspeccion: tipoDeInspeccion, estado: estado));

      await batch((batch) {
        // asociar a cada modelo con este cuestionario
        batch.insertAll(
            cuestionarioDeModelos,
            (form["modelos"].value as List<String>)
                .map((String modelo) => CuestionarioDeModelosCompanion.insert(
                    modelo: modelo,
                    periodicidad:
                        (form["periodicidad"].value as double).round(),
                    contratistaId:
                        Value((form["contratista"].value as Contratista).id),
                    cuestionarioId: cid))
                .toList()); //TODO: distintas periodicidades y contratistas por cuestionarioDeModelo
      });
      //procesamiento de cada bloque ya sea titulo, pregunta o cuadricula
      await Future.forEach(
          (form["bloques"] as FormArray).controls.asMap().entries,
          (entry) async {
        final i = entry.key as int;
        final control = entry.value;
        final bid = await into(bloques)
            .insert(BloquesCompanion.insert(cuestionarioId: cid, nOrden: i));

        //TODO: guardar inserts de cada tipo en listas para luego insertarlos en batch
        //TODO: usar los metodos toDataClass de los formGroups para obtener los datos de cada bloque
        if (control is CreadorTituloFormGroup) {
          await into(titulos).insert(TitulosCompanion.insert(
            bloqueId: bid,
            titulo: control.value["titulo"] as String,
            descripcion: control.value["descripcion"] as String,
          ));
        }
        if (control is CreadorPreguntaFormGroup) {
          //Mover las fotos a una carpeta unica para cada cuestionario
          final fotosGuiaProcesadas = await FotosManager.organizarFotos(
            (control.value["fotosGuia"] as List<File>)
                .map((e) => e.path)
                .toImmutableList(),
            tipoDocumento: "cuestionarios",
            idDocumento: cid.toString(),
          );

          final pid = await into(preguntas).insert(
            PreguntasCompanion.insert(
              bloqueId: bid,
              titulo: control.value["titulo"] as String,
              descripcion: control.value["descripcion"] as String,
              sistemaId: Value(control.value["sistema"].id as int),
              subSistemaId: Value(control.value["subSistema"].id as int),
              posicion: Value(control.value["posicion"] as String),
              tipo: control.value["tipoDePregunta"] as TipoDePregunta,
              criticidad: control.value["criticidad"].round() as int,
              fotosGuia: Value(fotosGuiaProcesadas.toImmutableList()),
              esCondicional: Value(control.value['condicional'] as bool),
            ),
          );

          Future<void> insertarCondicion(
            Map<dynamic, dynamic> e,
          ) async {
            final numero = int.parse(
                    (e['seccion'] as String).replaceAll('Ir a bloque ', '')) -
                1;
            await into(preguntasCondicional).insert(
              PreguntasCondicionalCompanion.insert(
                preguntaId: pid,
                opcionDeRespuesta: e['texto'] as String,
                seccion: numero,
              ),
            );
          }

          // Asociacion de los bloques a los que se dirige la pregunta condicional

          if (control.value['condicional'] as bool) {
            (control.value["respuestas"] as List<Map>)
                .map((e) async => {
                      await insertarCondicion(e),
                    })
                .toList();
          }
          await batch((batch) {
            batch.insertAll(
              opcionesDeRespuesta,
              (control.value["respuestas"] as List<Map>)
                  .map((e) => OpcionesDeRespuestaCompanion.insert(
                        preguntaId: Value(pid),
                        texto: e["texto"] as String,
                        criticidad: e["criticidad"].round() as int,
                      ))
                  .toList(),
            );
          });
        }
        if (control is CreadorPreguntaNumericaFormGroup) {
          //Mover las fotos a una carpeta unica para cada cuestionario
          final fotosGuiaProcesadas = await FotosManager.organizarFotos(
            (control.value["fotosGuia"] as List<File>)
                .map((e) => e.path)
                .toImmutableList(),
            tipoDocumento: "cuestionarios",
            idDocumento: cid.toString(),
          );

          final pid = await into(preguntas).insert(
            PreguntasCompanion.insert(
              bloqueId: bid,
              titulo: control.value["titulo"] as String,
              descripcion: control.value["descripcion"] as String,
              sistemaId: Value(control.value["sistema"].id as int),
              subSistemaId: Value(control.value["subSistema"].id as int),
              posicion: Value(control.value["posicion"] as String),
              tipo: TipoDePregunta.numerica,
              criticidad: control.value["criticidad"].round() as int,
              fotosGuia: Value(fotosGuiaProcesadas.toImmutableList()),
            ),
          );
          // Asociacion de las criticidades con esta pregunta
          await batch((batch) {
            batch.insertAll(
              criticidadesNumericas,
              (control.value["criticidadRespuesta"] as List<Map>)
                  .map((e) => CriticidadesNumericasCompanion.insert(
                        preguntaId: pid,
                        valorMinimo: e["minimo"] as double,
                        valorMaximo: e['maximo'] as double,
                        criticidad: e["criticidad"].round() as int,
                      ))
                  .toList(),
            );
          });
        }
        if (control is CreadorPreguntaCuadriculaFormGroup) {
          final cuadrId = await into(cuadriculasDePreguntas).insert(
              CuadriculasDePreguntasCompanion.insert(
                  bloqueId: bid,
                  titulo: control.value["titulo"] as String,
                  descripcion: control.value["descripcion"] as String));

          //Asociacion de las preguntas con esta cuadricula
          await batch((batch) {
            batch.insertAll(
              preguntas,
              (control.value["preguntas"] as List<Map>)
                  .map((e) => PreguntasCompanion.insert(
                        bloqueId: bid,
                        titulo: e["titulo"] as String,
                        descripcion: e["descripcion"] as String,
                        sistemaId: Value(e["sistema"].id as int),
                        subSistemaId: Value(e["subSistema"].id as int),
                        posicion: Value(e["posicion"] as String),
                        tipo: TipoDePregunta
                            .parteDeCuadriculaUnica, //TODO: multiple respuesta para cuadriculas
                        criticidad: e["criticidad"].round() as int,
                        //TODO: fotos para cada pregunta
                      ))
                  .toList(),
            );
          });
          // Asociacion de las opciones de respuesta de esta cuadricula
          await batch((batch) {
            batch.insertAll(
              opcionesDeRespuesta,
              (control.value["respuestas"] as List<Map>)
                  .map((e) => OpcionesDeRespuestaCompanion.insert(
                        cuadriculaId: Value(cuadrId),
                        texto: e["texto"] as String,
                        criticidad: e["criticidad"].round() as int,
                      ))
                  .toList(),
            );
          });
        }
      });
    });
  } */

  Future guardarCuestionario(
      Cuestionario cuestionario,
      List<CuestionarioDeModelo> cuestionariosDeModelo,
      List<IBloqueOrdenable> bloquesAGuardar) async {
    return transaction(
      () async {
        Cuestionario cuesti =
            await getCuestionarioToSave(cuestionario, cuestionariosDeModelo);
        cuesti ??= await crearCuestionarioToSave(cuestionario);

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
              if (opcion.id.present) {
                final x = await into(opcionesDeRespuesta)
                    .insertOnConflictUpdate(opcion);
                opcionesId.add(x);
              } else {
                opcionesId.add(await into(opcionesDeRespuesta).insert(opcion));
              }
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
            await Future.forEach<OpcionDeRespuesta>(
                e?.pregunta?.opcionesDeRespuesta, (or) async {
              //Mover las fotos a una carpeta unica para cada inspeccion
              final opcion =
                  or.toCompanion(true).copyWith(preguntaId: Value(preguntaId));
              if (opcion.id.present) {
                final x = await into(opcionesDeRespuesta)
                    .insertOnConflictUpdate(opcion);
                opcionesId.add(x);
              } else {
                opcionesId.add(await into(opcionesDeRespuesta).insert(opcion));
              }
            });

            final List<int> condicionesId = [];
            await Future.forEach<PreguntasCondicionalData>(e?.condiciones,
                (con) async {
              //Mover las fotos a una carpeta unica para cada inspeccion
              final condicion =
                  con.toCompanion(true).copyWith(preguntaId: Value(preguntaId));
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
                  bloqueId: Value(bloqueId),
                  tipo: const Value(TipoDePregunta.parteDeCuadriculaUnica));
              if (pregunta.id.present) {
                final x =
                    await into(preguntas).insertOnConflictUpdate(pregunta);
                preguntasId.add(x);
              } else {
                preguntasId.add(await into(preguntas).insert(pregunta));
              }
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
              if (opcion.id.present) {
                final x = await into(opcionesDeRespuesta)
                    .insertOnConflictUpdate(opcion);
                opcionesId.add(x);
              } else {
                opcionesId.add(await into(opcionesDeRespuesta).insert(opcion));
              }
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
            final criticidades = e.pregunta.criticidades
                .map((e) =>
                    e.toCompanion(true).copyWith(preguntaId: Value(preguntaId)))
                .toList();
            await batch((batch) {
              batch.insertAll(
                criticidadesNumericas,
                criticidades,
                mode: InsertMode.insertOrReplace,
              );
            });
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
