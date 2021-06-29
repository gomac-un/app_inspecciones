import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/infrastructure/daos/borradores_dao.dart';
import 'package:inspecciones/infrastructure/daos/creacion_dao.dart';
import 'package:inspecciones/infrastructure/daos/llenado_dao.dart';
import 'package:inspecciones/infrastructure/fotos_manager.dart';
import 'package:json_annotation/json_annotation.dart' show JsonSerializable;
import 'package:kt_dart/kt.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart' as path;

import 'daos/planeacion_dao.dart';

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
    Contratistas,
    Sistemas,
    SubSistemas,
    CriticidadesNumericas,
    GruposInspeccioness,
    ProgramacionSistemas,
    ProgramacionSistemasXActivo,
    TiposDeInspecciones,
  ],
  daos: [LlenadoDao, CreacionDao, BorradoresDao, PlaneacionDao],
)
class Database extends _$Database {
  final int _appId;
  // En el caso de que la db crezca mucho y las consultas empiecen a relentizar
  //la UI se debe considerar el uso de los isolates https://moor.simonbinder.eu/docs/advanced-features/isolates/
  Database(QueryExecutor e, this._appId) : super(e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        for (final table in allTables) {
          // Inicializa todos los autoincrement con el prefijo del appId desde el digito 14
          await customStatement(
              "insert into SQLITE_SEQUENCE (name,seq) values('${table.actualTableName}',${_appId}00000000000000);"); //1e14

        }
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

  Future limpiezaBD() async {
    final m = createMigrator();
    await customStatement('PRAGMA foreign_keys = OFF');

    for (final table in allTables) {
      await m.deleteTable(table.actualTableName);
      await m.createTable(table);
      await customStatement(
          "insert into SQLITE_SEQUENCE (name,seq) values('${table.actualTableName}',${_appId}00000000000000);"); //1e14
    }

    await customStatement('PRAGMA foreign_keys = ON');

    //await batch(initialize(this));
  }

  Future<Map<String, dynamic>> getCuestionarioCompleto(
      Cuestionario cuestionario) async {
    final modelosCuest = await (select(cuestionarioDeModelos)
          ..where((cm) => cm.cuestionarioId.equals(cuestionario.id)))
        .get();

    // Este es un ejemplo de consultas complejas si el agrupador de collections
    // puede ser mas lenta porque se multiplica la cantidad de consultas
    // pero es mas limpia y entendible y consume un poco menos de memoria
    //Tradeof de ineficiencia vs entendibilidad
    final bloquesCuest = await (select(bloques)
          ..where((b) => b.cuestionarioId.equals(cuestionario.id)))
        .get();

    final bloquesExtJson = await Future.wait(bloquesCuest.map((b) async {
      //a cada bloque buscarle los titulos, las cuadriculas y las preguntas, TERRIBLE
      final tituloBloque = await (select(titulos)
            ..where((t) => t.bloqueId.equals(b.id)))
          .getSingle();
      //el titulo está listo
      final cuadriculaBloque = await (select(cuadriculasDePreguntas)
            ..where((c) => c.bloqueId.equals(b.id)))
          .getSingle();

      List<OpcionDeRespuesta> opcionesDeLaCuadricula;

      final preguntasBloque = await (select(preguntas)
            ..where((p) => p.bloqueId.equals(b.id)))
          .get();

      //extender las cuadriculas y las preguntas con sus respectivas opciones
      if (cuadriculaBloque != null) {
        opcionesDeLaCuadricula = await (select(opcionesDeRespuesta)
              ..where((op) => op.cuadriculaId.equals(cuadriculaBloque.id)))
            .get();
      }

      final preguntasConOpciones =
          await Future.wait(preguntasBloque?.map((p) async {
        final opcionesDeLaPregunta = await (select(opcionesDeRespuesta)
              ..where((op) => op.preguntaId.equals(p.id)))
            .get();
        final criticidadPregunta = await (select(criticidadesNumericas)
              ..where((cri) => cri.preguntaId.equals(p.id)))
            .get();

        //enviar solo el basename al server
        final pregunta =
            p.copyWith(fotosGuia: p.fotosGuia.map((f) => path.basename(f)));
        final preguntaJson =
            pregunta.toJson(serializer: const CustomSerializer());
        preguntaJson["opciones_de_respuesta"] =
            opcionesDeLaPregunta.map((op) => op.toJson()).toList();
        preguntaJson["criticidades"] =
            criticidadPregunta.map((cri) => cri.toJson()).toList();
        return preguntaJson;
      }));

      final bloqueJson = b.toJson(serializer: const CustomSerializer());
      bloqueJson['titulo'] =
          tituloBloque?.toJson(serializer: const CustomSerializer());
      final cuadriculaJson =
          cuadriculaBloque?.toJson(serializer: const CustomSerializer());
      if (cuadriculaJson != null) {
        cuadriculaJson['opciones_de_respuesta'] =
            opcionesDeLaCuadricula?.map((op) => op.toJson())?.toList();
      }

      bloqueJson['cuadricula'] = cuadriculaJson;
      bloqueJson['preguntas'] = preguntasConOpciones;
      return bloqueJson;
    }));
    final cuestionarioJson =
        cuestionario.toJson(serializer: const CustomSerializer());
    cuestionarioJson['modelos'] =
        modelosCuest.map((cm) => cm.toJson()).toList();
    cuestionarioJson['bloques'] = bloquesExtJson;
    return cuestionarioJson;
  }

  Future<Inspeccion> getInspeccionParaTerminar(int id) =>
      (select(inspecciones)..where((ins) => ins.id.equals(id))).getSingle();

  Future marcarCuestionarioSubido(Cuestionario cuestionario) =>
      (update(cuestionarios)..where((c) => c.id.equals(cuestionario.id)))
          .write(const CuestionariosCompanion(esLocal: Value(false)));

  Future<Map<String, dynamic>> getInspeccionConRespuestas(
      Inspeccion inspeccion) async {
    //get inspeccion
    final jsonIns = inspeccion.toJson(serializer: const CustomSerializer());
    //get respuestas
    final queryRes = select(respuestas).join([
      leftOuterJoin(opcionesDeRespuesta,
          respuestas.opcionDeRespuestaId.equalsExp(opcionesDeRespuesta.id)),
    ])
      ..where(respuestas.inspeccionId.equals(inspeccion.id));
    final res = await queryRes
        .map((row) => RespuestaconOpcionDeRespuestaId(
            row.readTable(respuestas), row.readTable(opcionesDeRespuesta)?.id))
        .get();

    final resAgrupadas = groupBy<RespuestaconOpcionDeRespuestaId, Respuesta>(
        res, (e) => e.respuesta).entries.map((entry) {
      //solo enviar el filename al server
      final respuesta = entry.key.copyWith(
          fotosBase: entry.key.fotosBase.map((s) => path.basename(s)),
          fotosReparacion:
              entry.key.fotosReparacion.map((s) => path.basename(s)));

      final respuestaJson =
          respuesta.toJson(serializer: const CustomSerializer());

      return respuestaJson;
    }).toList();

    jsonIns['respuestas'] = resAgrupadas;

    return jsonIns;
  }

  // Método usado para cuando se descarga una inspección desde el servidor se guarde en la bd y se pueda seguir el curso normal
  Future guardarInspeccionBD(Map<String, dynamic> json) async {
    final respuestasParseadas = (json["respuestas"] as List).map((p) {
      // se hace este proceso para agregarle el path completo a las fotos
      final respuesta = Respuesta.fromJson(
        p as Map<String, dynamic>,
        serializer: const CustomSerializer(),
      );
      return respuesta.copyWith(
          fotosBase: respuesta.fotosBase.map((e) =>
              FotosManager.convertirAUbicacionAbsoluta(
                  tipoDeDocumento: 'inspecciones',
                  idDocumento: (json['id'] as int).toString(),
                  basename: e)),
          fotosReparacion: respuesta?.fotosReparacion?.map((e) =>
              FotosManager.convertirAUbicacionAbsoluta(
                  tipoDeDocumento: 'inspecciones',
                  idDocumento: (json['id'] as int).toString(),
                  basename: e)));
    }).toList();
    json.remove('respuestas');
    final inspeccionParseadas = Inspeccion.fromJson(
      json,
      serializer: const CustomSerializer(),
    ).copyWith(esNueva: false);

    await customStatement('PRAGMA foreign_keys = OFF');
    await transaction(() async {
      await batch((b) {
        b.insert(inspecciones, inspeccionParseadas);
        b.insertAll(respuestas, respuestasParseadas);
      });
    });
    await customStatement('PRAGMA foreign_keys = ON');
  }

  Future instalarBD(Map<String, dynamic> json) async {
    print(json);
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

    final tipoInspeccionParseados = (json["TipoInspeccion"] as List)
        .map((e) => TiposDeInspeccione.fromJson(e as Map<String, dynamic>))
        .toList();

    final subSistemasParseados = (json["Subsistema"] as List)
        .map((e) => SubSistema.fromJson(e as Map<String, dynamic>))
        .toList();

    final cuestionariosParseados = (json["Cuestionario"] as List)
        .map((e) => Cuestionario.fromJson(e as Map<String, dynamic>,
            serializer: const CustomSerializer()))
        .map((c) => c.copyWith(esLocal: false))
        .toList();

    final cuestionariosDeModelosParseados = (json["CuestionarioDeModelo"]
            as List)
        .map((e) => CuestionarioDeModelo.fromJson(e as Map<String, dynamic>))
        .toList();

    final bloquesParseados = (json["Bloque"] as List)
        .map((e) => Bloque.fromJson(e as Map<String, dynamic>))
        .toList();

    final titulosParseados = (json["Titulo"] as List)
        .map((e) => Titulo.fromJson(
              e as Map<String, dynamic>,
              serializer: const CustomSerializer(),
            ))
        .toList();

    final cuadriculasDePreguntasParseados =
        (json["CuadriculaDePreguntas"] as List)
            .map((e) => CuadriculaDePreguntas.fromJson(
                  e as Map<String, dynamic>,
                  serializer: const CustomSerializer(),
                ))
            .toList();

    final preguntasParseados = (json["Pregunta"] as List).map((p) {
      // se hace este proceso para agregarle el path completo a las fotos
      final pregunta = Pregunta.fromJson(
        p as Map<String, dynamic>,
        serializer: const CustomSerializer(),
      );
      return pregunta.copyWith(
          fotosGuia: pregunta.fotosGuia.map((e) =>
              FotosManager.convertirAUbicacionAbsoluta(
                  tipoDeDocumento: 'cuestionarios',
                  idDocumento:
                      ((p as Map<String, dynamic>)['cuestionario'] as int)
                          .toString(),
                  basename: e)));
    }).toList();

    final opcionesDeRespuestaParseados = (json["OpcionDeRespuesta"] as List)
        .map((e) => OpcionDeRespuesta.fromJson(e as Map<String, dynamic>))
        .toList();

    final criticidadesNumericasParseadas = (json['CriticidadNumerica'] as List)
        .map((e) => CriticidadesNumerica.fromJson(e as Map<String, dynamic>))
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
        delete(criticidadesNumericas).go(),
        delete(tiposDeInspecciones).go(),
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
        b.insertAll(criticidadesNumericas, criticidadesNumericasParseadas);
        b.insertAll(tiposDeInspecciones, tipoInspeccionParseados);
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

  Future<Cuestionario> getCuestionario(Inspeccion inspeccion) {
    final query = select(cuestionarios)
      ..where((c) => c.id.equals(inspeccion.cuestionarioId));
    return query.getSingle();
  }

  Future<int> getTotalPreguntas(int id) async {
    final bloq = await (select(bloques)
          ..where((b) => b.cuestionarioId.equals(id)))
        .get();
    final bloquesId = bloq.map((e) => e.id).toList();
    final count = countAll(filter: preguntas.bloqueId.isIn(bloquesId));
    final res = (selectOnly(preguntas)..addColumns([count]))
        .map((row) => row.read(count))
        .getSingle();
    return res;
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
  }
}

class CustomSerializer extends ValueSerializer {
  const CustomSerializer();
  static const tipoPreguntaConverter =
      EnumIndexConverter<TipoDePregunta>(TipoDePregunta.values);
  static const estadoDeInspeccionConverter =
      EnumIndexConverter<EstadoDeInspeccion>(EstadoDeInspeccion.values);
  static const estadoDeCuestionarioConverter =
      EnumIndexConverter<EstadoDeCuestionario>(EstadoDeCuestionario.values);

  @override
  T fromJson<T>(dynamic json) {
    if (json == null) {
      return null;
    }

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

    if (T == EstadoDeCuestionario) {
      return estadoDeCuestionarioConverter.mapToDart(json as int) as T;
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

    if (value is EstadoDeCuestionario) {
      return estadoDeCuestionarioConverter.mapToSql(value);
    }

    if (value is KtList) {
      return value.iter.toList();
    }

    return value;
  }
}
