import 'dart:convert';
import 'dart:io';
import 'package:inspecciones/application/auth/usuario.dart';
import 'package:inspecciones/infrastructure/datasources/remote_datasource.dart'
    as ap;
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/infrastructure/daos/borradores_dao.dart';
import 'package:inspecciones/infrastructure/daos/creacion_dao.dart';
import 'package:inspecciones/infrastructure/daos/llenado_dao.dart';
import 'package:json_annotation/json_annotation.dart' show JsonSerializable;
import 'package:kt_dart/kt.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart' as path;

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
      onCreate: (Migrator m) async {
        await m.createAll();
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

      /*await customStatement(
          "UPDATE SQLITE_SEQUENCE SET SEQ=100000000000000 WHERE NAME='${table.actualTableName}';"); //1e14*/
      //TODO: pedirle el deviceId al servidor para coordinar las BDs
      const deviceId = 1;
      await customStatement(
          "insert into SQLITE_SEQUENCE (name,seq) values('${table.actualTableName}',${deviceId}00000000000000);"); //1e14

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

  Future<Cuestionario> getCuestionario(Inspeccion inspeccion) {
    final query = select(cuestionarios)
      ..where((c) => c.id.equals(inspeccion.cuestionarioId));
    return query.getSingle();
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
