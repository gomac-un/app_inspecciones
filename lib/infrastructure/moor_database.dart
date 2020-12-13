export 'package:moor_flutter/moor_flutter.dart' show Value;

import 'dart:convert';
import 'dart:io';

import 'package:inspecciones/mvvc/creacion_controls.dart';
import 'package:kt_dart/kt.dart';
import 'package:moor/moor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import "package:collection/collection.dart";

import 'package:inspecciones/domain/core/enums.dart';
import 'package:reactive_forms/reactive_forms.dart';
export 'database/shared.dart';

part 'moor_database.g.dart';
part 'bdDePrueba.dart';
part 'tablas.dart';
part 'tablas_unidas.dart';

@UseMoor(
  tables: [
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
  ],
)
class Database extends _$Database {
  Database(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) {
        return m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from == 1) {
          //await m.addColumn(todos, todos.targetDate);
        }
      },
      beforeOpen: (details) async {
        if (details.wasCreated) {
          // create default data

          /*await into(inspecciones).insert(InspeccionesCompanion(
            fechaDeInicio: Value(DateTime.now()),
          ));*/
        }
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  //Llenado de bd con datos de prueba
  Future dbdePrueba() async {
    /*final dataDir = await paths.getApplicationDocumentsDirectory();
    final dbFile = File(path.join(dataDir.path, 'db.sqlite'));
    dbFile.deleteSync();*/
    final m = this.createMigrator();
    await customStatement('PRAGMA foreign_keys = OFF');

    for (final table in allTables) {
      await m.deleteTable(table.actualTableName);

      await m.createTable(table);
    }
    await customStatement('PRAGMA foreign_keys = ON');

    await batch(initialize(this));
  }

  //datos para la creacion de cuestionarios
  Future<List<String>> getModelos() {
    final query = selectOnly(activos, distinct: true)
      ..addColumns([activos.modelo]);

    return query.map((row) => row.read(activos.modelo)).get();
  }

  Future<List<String>> getTiposDeInspecciones() {
    final query = selectOnly(cuestionarioDeModelos, distinct: true)
      ..addColumns([cuestionarioDeModelos.tipoDeInspeccion]);

    return query
        .map((row) => row.read(cuestionarioDeModelos.tipoDeInspeccion))
        .get();
  }

  Future<List<Contratista>> getContratistas() => select(contratistas).get();

  Future<List<Sistema>> getSistemas() => select(sistemas).get();

  Future<List<SubSistema>> getSubSistemas(Sistema sistema) {
    if (sistema == null) return Future.value([]);

    final query = select(subSistemas)
      ..where((u) => u.sistemaId.equals(sistema.id));

    return query.get();
  }

  Future<List<CuestionarioDeModelo>> getCuestionarios(
      String tipoDeInspeccion, List<String> modelos) {
    final query = select(cuestionarioDeModelos)
      ..where((cm) =>
          cm.tipoDeInspeccion.equals(tipoDeInspeccion) &
          cm.modelo.isIn(modelos));

    return query.get();
  }

  Future crearCuestionario(Map<String, AbstractControl> form) {
    return transaction(() async {
      int cid =
          await into(cuestionarios).insert(CuestionariosCompanion.insert());

      final String tipoDeInspeccion = form["tipoDeInspeccion"].value == "otra"
          ? form["nuevoTipoDeInspeccion"].value
          : form["tipoDeInspeccion"].value;

      await batch((batch) {
        // asociar a cada modelo con este cuestionario
        batch.insertAll(
            cuestionarioDeModelos,
            (form["modelos"].value as List<String>)
                .map((String modelo) => CuestionarioDeModelosCompanion.insert(
                    modelo: modelo,
                    tipoDeInspeccion: tipoDeInspeccion,
                    periodicidad:
                        (form["periodicidad"].value as double).round(),
                    contratistaId:
                        (form["contratista"].value as Contratista).id,
                    cuestionarioId: cid))
                .toList()); //TODO: distintas periodicidades y contratistas por cuestionarioDeModelo
      });
      //procesamiento de cada bloque ya sea titulo, pregunta o cuadricula
      await Future.forEach(
          (form["bloques"] as FormArray).controls.asMap().entries,
          (entry) async {
        final i = entry.key;
        final control = entry.value;
        final bid = await into(bloques)
            .insert(BloquesCompanion.insert(cuestionarioId: cid, nOrden: i));

        //TODO: guardar inserts de cada tipo en listas para luego insertarlos en batch
        if (control is CreadorTituloFormGroup) {
          await into(titulos).insert(TitulosCompanion.insert(
            bloqueId: bid,
            titulo: control.value["titulo"],
            descripcion: control.value["descripcion"],
          ));
        }
        if (control is CreadorPreguntaSeleccionSimpleFormGroup) {
          final appDir = await getApplicationDocumentsDirectory();
          //Mover las fotos a una carpeta unica para cada cuestionario
          final fotosGuiaProcesadas = await Future.wait(
            organizarFotos(
              (control.value["fotosGuia"] as List<File>)
                  .map((e) => e.path)
                  .toImmutableList(),
              appDir.path,
              "fotosCuestionarios",
              cid.toString(),
            ),
          );

          final pid = await into(preguntas).insert(
            PreguntasCompanion.insert(
              bloqueId: bid,
              titulo: control.value["titulo"],
              descripcion: control.value["descripcion"],
              sistemaId: control.value["sistema"].id,
              subSistemaId: control.value["subSistema"].id,
              posicion: control.value["posicion"],
              tipo: control.value["tipoDePregunta"],
              criticidad: control.value["criticidad"].round(),
              fotosGuia: Value(fotosGuiaProcesadas.toImmutableList()),
            ),
          );
          // Asociacion de las opciones de respuesta con esta pregunta
          await batch((batch) {
            batch.insertAll(
              opcionesDeRespuesta,
              (control.value["respuestas"] as List<Map>)
                  .map((e) => OpcionesDeRespuestaCompanion.insert(
                        preguntaId: Value(pid),
                        texto: e["texto"],
                        criticidad: e["criticidad"].round(),
                      ))
                  .toList(),
            );
          });
        }
        if (control is CreadorPreguntaCuadriculaFormGroup) {
          final cuadrId = await into(cuadriculasDePreguntas).insert(
              CuadriculasDePreguntasCompanion.insert(
                  bloqueId: bid,
                  titulo: control.value["titulo"],
                  descripcion: control.value["descripcion"]));

          //Asociacion de las preguntas con esta cuadricula
          await batch((batch) {
            batch.insertAll(
              preguntas,
              (control.value["preguntas"] as List<Map>)
                  .map((e) => PreguntasCompanion.insert(
                        bloqueId: bid,
                        titulo: e["titulo"],
                        descripcion: e["descripcion"],
                        sistemaId: control.value["sistema"]
                            .id, //TODO: sistema/subsistema/posicion diferente para cada pregunta
                        subSistemaId: control.value["subSistema"].id,
                        posicion: control.value["posicion"],
                        tipo: TipoDePregunta.parteDeCuadricula,
                        criticidad: e["criticidad"]
                            .round(), //TODO: fotos para cada pregunta
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
                        texto: e["texto"],
                        criticidad: e["criticidad"].round(),
                      ))
                  .toList(),
            );
          });
        }
      });
    });
  }

  //datos para el llenado de inspecciones

  Future<List<CuestionarioDeModelo>> cuestionariosParaVehiculo(
      String vehiculo) {
    final query = select(activos).join([
      leftOuterJoin(cuestionarioDeModelos,
          cuestionarioDeModelos.modelo.equalsExp(activos.modelo)),
    ])
      ..where(activos.identificador.equals(vehiculo));

    return query.map((row) {
      return row.readTable(cuestionarioDeModelos);
    }).get();
  }

  Future<Inspeccion> getInspeccion(String vehiculo, int cuestionarioId) {
    //revisar si hay una inspeccion de ese cuestionario empezada
    if (cuestionarioId == null || vehiculo == null) return null;
    final query = select(inspecciones)
      ..where(
        (ins) =>
            ins.cuestionarioId.equals(cuestionarioId) &
            ins.identificadorActivo.equals(vehiculo),
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
      ..where(
        bloques.cuestionarioId.equals(cuestionarioId) &
            (preguntas.tipo.equals(0) //seleccion unica
                |
                preguntas.tipo.equals(1)), //seleccion multiple
      );
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
        respuestasXOpcionesDeRespuesta,
        respuestasXOpcionesDeRespuesta.respuestaId.equalsExp(respuestas.id),
      ),
      innerJoin(
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
      ..where(bloques.cuestionarioId.equals(cuestionarioId) &
              preguntas.tipo.equals(2) //parteDeCuadricula
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

  Future<Inspeccion> crearInspeccion(
      int cuestionarioId, String activo, bool esBorrador) async {
    final ins = InspeccionesCompanion.insert(
      cuestionarioId: cuestionarioId,
      estado: esBorrador
          ? EstadoDeInspeccion.enBorrador
          : EstadoDeInspeccion.enviada,
      identificadorActivo: activo,
      momentoInicio: Value(DateTime.now()),
    );
    final id = await into(inspecciones).insert(ins);
    return (select(inspecciones)..where((i) => i.id.equals(id))).getSingle();
  }

  Future guardarInspeccion(List<RespuestaConOpcionesDeRespuesta> respuestasForm,
      int cuestionarioId, String activo, bool esBorrador) async {
    if (respuestasForm.first.respuesta.inspeccionId.value == null) {
      //si la primera respuesta no tiene inspeccion asociada, asocia todas a una nueva inspeccion
      final ins = await crearInspeccion(cuestionarioId, activo, esBorrador);
      respuestasForm.forEach((rf) {
        rf.respuesta = rf.respuesta.copyWith(inspeccionId: Value(ins.id));
      });
    }
    return transaction(() async {
      await (update(inspecciones)
            ..where((i) =>
                i.id.equals(respuestasForm.first.respuesta.inspeccionId.value)))
          .write(
        esBorrador
            ? InspeccionesCompanion(
                momentoBorradorGuardado: Value(DateTime.now()),
              )
            : InspeccionesCompanion(
                momentoEnvio: Value(DateTime.now()),
              ),
      );
      await Future.forEach<RespuestaConOpcionesDeRespuesta>(respuestasForm,
          (e) async {
        //Mover las fotos a una carpeta unica para cada inspeccion
        final appDir = await getApplicationDocumentsDirectory();
        final idform =
            respuestasForm.first.respuesta.inspeccionId.value.toString();
        final fotosBaseProc = await Future.wait(organizarFotos(
            e.respuesta.fotosBase.value,
            appDir.path,
            "fotosInspecciones",
            idform));
        final fotosRepProc = await Future.wait(organizarFotos(
            e.respuesta.fotosBase.value,
            appDir.path,
            "fotosInspecciones",
            idform));
        e.respuesta.copyWith(
          fotosBase: Value(fotosBaseProc.toImmutableList()),
          fotosReparacion: Value(fotosRepProc.toImmutableList()),
        );

        int res;
        if (e.respuesta.id.present) {
          await into(respuestas).insertOnConflictUpdate(e.respuesta);
          res = e.respuesta.id.value;
        } else {
          res = await into(respuestas).insert(e.respuesta);
        }

        await (delete(respuestasXOpcionesDeRespuesta)
              ..where((rxor) => rxor.respuestaId.equals(res)))
            .go();
        await Future.forEach<OpcionDeRespuesta>(e.opcionesDeRespuesta,
            (opres) async {
          await into(respuestasXOpcionesDeRespuesta).insert(
              RespuestasXOpcionesDeRespuestaCompanion.insert(
                  respuestaId: res, opcionDeRespuestaId: opres.id));
        });
      });
    });
  }

  Iterable<Future<String>> organizarFotos(
      KtList<String> fotos,
      String appDir,
      String subDir, //fotosInspecciones
      String idform) {
    return fotos.iter.toList().map((pathFoto) async {
      final dir = path.join(appDir, subDir, idform);
      if (path.isWithin(dir, pathFoto)) {
        // la imagen ya esta en la carpeta de datos
        return pathFoto;
      } else {
        //mover la foto a la carpeta de datos
        final fileName = path.basename(pathFoto);
        final newPath = path.join(dir, fileName);
        await File(newPath).create(recursive: true);
        final savedImage = await File(pathFoto).copy(newPath);
        return savedImage.path;
      }
    });
  }

  Stream<List<Borrador>> borradores() {
    final query = select(inspecciones).join([
      //TODO: eliminar la inspeccion de los borradores porque solo se necesita el activo y el cm, ya que la inspeccion se consulta con base a estos
      innerJoin(activos,
          activos.identificador.equalsExp(inspecciones.identificadorActivo)),
    ]);

    return query
        .map(
          (row) => Borrador(
            row.readTable(inspecciones),
            row.readTable(activos),
          ),
        )
        .watch();
  }

  Future eliminarBorrador(Borrador borrador) async {
    await (delete(inspecciones)
          ..where((ins) => ins.id.equals(borrador.inspeccion.id)))
        .go();
  }

  // Esta funcion deberá exportar las inspecciones llenadas de manera
  // local al servidor
  Future exportarInspeccion() async {
    // TODO: WIP
    final ins = await (select(inspecciones)
          ..where(
            (e) => e.id.equals(1),
          ))
        .get();
    print(ins.map((e) => e.toJson()).toList());
  }
}
