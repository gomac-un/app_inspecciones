import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';
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
  // En el caso de que la db crezca mucho y las consultas empiecen a relentizar
  //la UI se debe considerar el uso de los isolates https://moor.simonbinder.eu/docs/advanced-features/isolates/
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
      // Inicializa todos los autoincrement con el prefijo del deviceid desde el digito 14
      await customStatement(
          "insert into SQLITE_SEQUENCE (name,seq) values('${table.actualTableName}',${deviceId}00000000000000);"); //1e14

    }

    await customStatement('PRAGMA foreign_keys = ON');

    //await batch(initialize(this));
  }

  Future<Map<String, dynamic>> getInspeccionConRespuestas(
      int inspeccionId) async {
    //get inspeccion
    final queryIns = select(inspecciones)
      ..where((i) => i.id.equals(inspeccionId));
    final ins = await queryIns.getSingle();
    final jsonIns = ins.toJson(serializer: const CustomSerializer());

    //get respuestas
    final queryRes = select(respuestas).join([
      leftOuterJoin(respuestasXOpcionesDeRespuesta,
          respuestasXOpcionesDeRespuesta.respuestaId.equalsExp(respuestas.id)),
    ])
      ..where(respuestas.inspeccionId.equals(inspeccionId));

    final res = await queryRes
        .map((row) => RespuestaconOpcionDeRespuestaId(row.readTable(respuestas),
            row.readTable(respuestasXOpcionesDeRespuesta).opcionDeRespuestaId))
        .get();

    final resAgrupadas = groupBy<RespuestaconOpcionDeRespuestaId, Respuesta>(
        res, (e) => e.respuesta).entries.map((entry) {
      final respuesta = entry.key.toJson(serializer: const CustomSerializer());
      respuesta['respuestas'] =
          entry.value.map((e) => e.opcionDeRespuestaId).toList();
      return respuesta;
    }).toList();

    jsonIns['respuestas'] = resAgrupadas;

    return jsonIns;
  }

  Future instalarBD(Map<String, dynamic> json) async {
    /*TODO: hacer este proceso sin repetir tanto codigo, por ejemplo usando una estructura asi:
    final tablasPorActualizar = [
      InstaladorHelper("Activo", Activo, activos),
    ];
    pero no se puede hasta que se implemente esto https://github.com/dart-lang/language/issues/216
    */

    final activosParseados = (json["Activo"] as List)
        .map((e) => Activo.fromJson(e as Map<String, dynamic>))
        .toList();

    final contratistasParseados = (json["Contratista"] as List)
        .map((e) => Contratista.fromJson(e as Map<String, dynamic>))
        .toList();

    final sistemasParseados = (json["Sistema"] as List)
        .map((e) => Sistema.fromJson(e as Map<String, dynamic>))
        .toList();

    final subSistemasParseados = (json["Subsistema"] as List)
        .map((e) => SubSistema.fromJson(e as Map<String, dynamic>))
        .toList();

    final cuestionariosParseados = (json["Cuestionario"] as List)
        .map((e) => Cuestionario.fromJson(e as Map<String, dynamic>))
        .toList();

    final cuestionariosDeModelosParseados = (json["CuestionarioDeModelo"]
            as List)
        .map((e) => CuestionarioDeModelo.fromJson(e as Map<String, dynamic>))
        .toList();

    final bloquesParseados = (json["Bloque"] as List)
        .map((e) => Bloque.fromJson(e as Map<String, dynamic>))
        .toList();

    final titulosParseados = (json["Titulo"] as List)
        .map((e) => Titulo.fromJson(e as Map<String, dynamic>))
        .toList();

    final cuadriculasDePreguntasParseados = (json["CuadriculaDePreguntas"]
            as List)
        .map((e) => CuadriculaDePreguntas.fromJson(e as Map<String, dynamic>))
        .toList();

    final preguntasParseados = (json["Pregunta"] as List)
        .map((e) => Pregunta.fromJson(e as Map<String, dynamic>,
            serializer: const CustomSerializer()))
        .toList();

    final opcionesDeRespuestaParseados = (json["OpcionDeRespuesta"] as List)
        .map((e) => OpcionDeRespuesta.fromJson(e as Map<String, dynamic>))
        .toList();
    await customStatement('PRAGMA foreign_keys = OFF');
    await transaction(() async {
      final deletes = [
        delete(activos).go(),
        delete(contratistas).go(),
        delete(sistemas).go(),
        delete(subSistemas).go(),
        delete(cuestionarios).go(),
        delete(cuestionarioDeModelos).go(),
        delete(bloques).go(),
        delete(titulos).go(),
        delete(cuadriculasDePreguntas).go(),
        delete(preguntas).go(),
        delete(opcionesDeRespuesta).go(),
      ];
      await Future.wait(deletes);
      await batch((b) {
        b.insertAll(activos, activosParseados);
        b.insertAll(contratistas, contratistasParseados);
        b.insertAll(sistemas, sistemasParseados);
        b.insertAll(subSistemas, subSistemasParseados);
        b.insertAll(cuestionarios, cuestionariosParseados);
        b.insertAll(cuestionarioDeModelos, cuestionariosDeModelosParseados);
        b.insertAll(bloques, bloquesParseados);
        b.insertAll(titulos, titulosParseados);
        b.insertAll(cuadriculasDePreguntas, cuadriculasDePreguntasParseados);
        b.insertAll(preguntas, preguntasParseados);
        b.insertAll(opcionesDeRespuesta, opcionesDeRespuestaParseados);
      });
    });
    await customStatement('PRAGMA foreign_keys = ON');
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

class CustomSerializer extends ValueSerializer {
  const CustomSerializer();
  static const tipoPreguntaConverter =
      EnumIndexConverter<TipoDePregunta>(TipoDePregunta.values);
  static const estadoDeInspeccionConverter =
      EnumIndexConverter<EstadoDeInspeccion>(EstadoDeInspeccion.values);

  //static const Type ktstring = KtList<String>;

  @override
  T fromJson<T>(dynamic json) {
    if (json == null) {
      return null;
    }

    // nuevo
    /*if (T == KtList) {
      return (json as List<String>).toImmutableList() as T;
    }*/
    if (json is List) {
      // https://stackoverflow.com/questions/50188729/checking-what-type-is-passed-into-a-generic-method
      // machetazo que convierte todas las listas a KtList<String> dado que no
      // se puede preguntar por T == KtList<String>, puede que se pueda arreglar
      // cuando los de dart implementen los alias de tipos https://github.com/dart-lang/language/issues/65
      return json.cast<String>().toImmutableList() as T;
    }

    if (T == TipoDePregunta) {
      return tipoPreguntaConverter.mapToDart(json as int) as T;
    }

    if (T == EstadoDeInspeccion) {
      return estadoDeInspeccionConverter.mapToDart(json as int) as T;
    }

    if (T == DateTime) {
      return DateTime.parse(json as String) as T;
    }

    if (T == double && json is int) {
      return json.toDouble() as T;
    }

    // blobs are encoded as a regular json array, so we manually convert that to
    // a Uint8List
    if (T == Uint8List && json is! Uint8List) {
      final asList = (json as List).cast<int>();
      return Uint8List.fromList(asList) as T;
    }

    return json as T;
  }

  @override
  dynamic toJson<T>(T value) {
    if (value is DateTime) {
      return value.toIso8601String();
    }

    if (value is TipoDePregunta) {
      return tipoPreguntaConverter.mapToSql(value);
    }

    if (value is EstadoDeInspeccion) {
      return estadoDeInspeccionConverter.mapToSql(value);
    }

    if (value is KtList) {
      return value.iter.toList();
    }

    return value;
  }
}
