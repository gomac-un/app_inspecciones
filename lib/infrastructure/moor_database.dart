import 'dart:convert';
import 'dart:io';

import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/infrastructure/daos/borradores_dao.dart';
import 'package:inspecciones/infrastructure/daos/creacion_dao.dart';
import 'package:inspecciones/infrastructure/daos/llenado_dao.dart';
import 'package:kt_dart/kt.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

export 'package:moor_flutter/moor_flutter.dart' show Value;

export 'database/shared.dart';

part 'datos_de_prueba.dart';
part 'moor_database.g.dart';
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
  daos: [LlenadoDao, CreacionDao, BorradoresDao],
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
    final m = createMigrator();
    await customStatement('PRAGMA foreign_keys = OFF');

    for (final table in allTables) {
      await m.deleteTable(table.actualTableName);

      await m.createTable(table);
    }
    await customStatement('PRAGMA foreign_keys = ON');

    await batch(initialize(this));
  }

  //datos para la creacion de cuestionarios
  Future<Sistema> getSistemaPorId(int id) async {
    if (id == null) return null;
    final query = select(sistemas)..where((s) => s.id.equals(id));
    return query.getSingle();
  }

  Future<SubSistema> getSubSistemaPorId(int id) async {
    if (id == null) return null;
    final query = select(subSistemas)..where((s) => s.id.equals(id));
    return query.getSingle();
  }
  //datos para el llenado de inspecciones

  Future<Inspeccion> crearInspeccion(
      int cuestionarioId, String activo, EstadoDeInspeccion estado) async {
    final ins = InspeccionesCompanion.insert(
      cuestionarioId: cuestionarioId,
      estado: estado,
      identificadorActivo: activo,
      momentoInicio: Value(DateTime.now()),
    );
    final id = await into(inspecciones).insert(ins);
    return (select(inspecciones)..where((i) => i.id.equals(id))).getSingle();
  }

  Future guardarInspeccion(List<RespuestaConOpcionesDeRespuesta> respuestasForm,
      int cuestionarioId, String activo, EstadoDeInspeccion estado) async {
    Inspeccion ins = await llenadoDao.getInspeccion(activo, cuestionarioId);
    ins ??= await crearInspeccion(cuestionarioId, activo, estado);
    for (final rf in respuestasForm) {
      rf.respuesta = rf.respuesta.copyWith(inspeccionId: Value(ins.id));
    }
    return transaction(() async {
      await (update(inspecciones)..where((i) => i.id.equals(ins.id))).write(
        estado == EstadoDeInspeccion.enviada
            ? InspeccionesCompanion(
                momentoEnvio: Value(DateTime.now()),
                estado: Value(estado),
              )
            : InspeccionesCompanion(
                momentoBorradorGuardado: Value(DateTime.now()),
                estado: Value(estado),
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
        await Future.forEach<OpcionDeRespuesta>(
            e.opcionesDeRespuesta.where((e) => e != null), (opres) async {
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

  Future<CuestionarioDeModelo> getCuestionarioDeModelo(Inspeccion inspeccion) {
    final query = select(cuestionarios).join([
      innerJoin(cuestionarioDeModelos,
          cuestionarioDeModelos.cuestionarioId.equalsExp(cuestionarios.id))
    ])
      ..where(cuestionarios.id.equals(inspeccion.cuestionarioId));
    return query.map((row) => row.readTable(cuestionarioDeModelos)).getSingle();
  }

  // Esta funcion deberá exportar las inspecciones llenadas de manera
  // local al servidor
  Future exportarInspeccion() async {
    // TODO: WIP
    // ignore: unused_local_variable
    final ins = await (select(inspecciones)
          ..where(
            (e) => e.id.equals(1),
          ))
        .get();
    //print(ins.map((e) => e.toJson()).toList());
  }
}
