import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/infrastructure/daos/borradores_dao.dart';
import 'package:inspecciones/infrastructure/daos/creacion_dao.dart';
import 'package:inspecciones/infrastructure/daos/llenado_dao.dart';
import 'package:inspecciones/infrastructure/fotos_manager.dart';
import 'package:inspecciones/infrastructure/tablas_unidas.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart' as path;

import 'daos/planeacion_dao.dart';

export 'database/shared.dart';

part 'datos_de_prueba.dart';
part 'moor_database.g.dart';
part 'tablas.dart';

///  Métodos de Database e inicialización de la DB
@UseMoor(
  tables: [
    /// Tablas necesarias para el CRUD
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

  /// Elimina todos los datos de la BD
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

  /// Obtiene el [cuestionario] completo con sus bloques para subir al server
  Future<Map<String, dynamic>> getCuestionarioCompletoAsJson(
      Cuestionario cuestionario) async {
    /// Modelos a los que aplica
    final modelosCuest = await (select(cuestionarioDeModelos)
          ..where((cm) => cm.cuestionarioId.equals(cuestionario.id)))
        .get();

    // Este es un ejemplo de consultas complejas sin el agrupador de collections
    // puede ser mas lenta porque se multiplica la cantidad de consultas
    // pero es mas limpia y entendible y consume un poco menos de memoria
    // Tradeof de ineficiencia vs entendibilidad
    final bloquesCuest = await (select(bloques)
          ..where((b) => b.cuestionarioId.equals(cuestionario.id)))
        .get();

    final bloquesExtJson = await Future.wait(bloquesCuest.map((b) async {
      ///A cada bloque buscarle los titulos, las cuadriculas y las preguntas, TERRIBLE
      ///
      /// La cosa es que no pueden haber preguntas, cuadricula y titulos para un mismo bloque al tiempo, entonces
      /// no tiene sentido hacer la consulta de los 3 cuando se sabe que va a existir solo uno. Hay que reestructurarlo
      //TODO: ¿No se puede más bien buscar cada pregunta, titulo y cuadricula del cuestionario y procesarla?
      final tituloBloque = await (select(titulos)
            ..where((t) => t.bloqueId.equals(b.id)))
          .getSingleOrNull();
      //el titulo está listo
      final cuadriculaBloque = await (select(cuadriculasDePreguntas)
            ..where((c) => c.bloqueId.equals(b.id)))
          .getSingleOrNull();

      final preguntasBloque = await (select(preguntas)
            ..where((p) => p.bloqueId.equals(b.id)))
          .get();

      /// En caso de que sea un bloque de cuadricula extender las cuadriculas y las preguntas con sus respectivas opciones
      final opcionesDeLaCuadricula = cuadriculaBloque != null
          ? await (select(opcionesDeRespuesta)
                ..where((op) => op.cuadriculaId.equals(cuadriculaBloque.id)))
              .get()
          : <OpcionDeRespuesta>[];

      /// En caso de que sea un bloque de pregunta
      final preguntasConOpciones =
          await Future.wait(preguntasBloque.map((p) async {
        final opcionesDeLaPregunta = await (select(opcionesDeRespuesta)
              ..where((op) => op.preguntaId.equals(p.id)))
            .get();

        /// En caso de que sea numérica.
        final criticidadPregunta = await (select(criticidadesNumericas)
              ..where((cri) => cri.preguntaId.equals(p.id)))
            .get();

        //enviar solo el basename al server
        /// Se usa [CustomSerializer] para que no genere error por las fotos y las fechas.
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
            opcionesDeLaCuadricula.map((op) => op.toJson()).toList();
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

    /// El Json final es de la forma {infoCues______
    /// modelos:[modelosCuest],
    /// bloques:[bloquesExtJson]}
    return cuestionarioJson;
  }

  /// Devuelve inspección con id = [id] cuando se descargó del server y se va a llenar desde la app
  Future<Inspeccion> getInspeccionParaTerminar(int id) {
    /// Se elimina momentoEnvio para que aparezca como borrador y no en el historial.
    (update(inspecciones)..where((c) => c.id.equals(id))).write(
        const InspeccionesCompanion(
            momentoEnvio: Value(null), esNueva: Value(false)));
    return (select(inspecciones)..where((ins) => ins.id.equals(id)))
        .getSingle();
  }

  /// marca [cuestionario.esLocal] = false cuando [cuestionario] es subido al server
  Future marcarCuestionarioSubido(Cuestionario cuestionario) =>
      (update(cuestionarios)..where((c) => c.id.equals(cuestionario.id)))
          .write(const CuestionariosCompanion(esLocal: Value(false)));

  /// Devuelve json con [inspeccion] y sus respectivas respuestas
  Future<Map<String, dynamic>> getInspeccionConRespuestas(
      Inspeccion inspeccion) async {
    ///Se usa [copyWith] porque el cambio que se hizo en las lineas anteriores no se ve reflejado en inspecciones
    final jsonIns = inspeccion
        .copyWith(momentoEnvio: DateTime.now())
        .toJson(serializer: const CustomSerializer());
    //get respuestas
    final queryRes = select(respuestas).join([
      leftOuterJoin(opcionesDeRespuesta,
          respuestas.opcionDeRespuestaId.equalsExp(opcionesDeRespuesta.id)),
    ])
      ..where(respuestas.inspeccionId.equals(inspeccion.id));
    final res = await queryRes
        .map((row) => Tuple2(
            row.readTable(respuestas), row.readTable(opcionesDeRespuesta).id))
        .get();

    final resAgrupadas =
        groupBy<Tuple2<Respuesta, int>, Respuesta>(res, (e) => e.value1)
            .entries
            .map((entry) {
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

  /// Método usado para cuando se descarga una inspección desde el servidor se guarde en la bd y se pueda seguir el curso normal
  Future guardarInspeccionBD(Map<String, dynamic> json) async {
    final respuestasParseadas = (json["respuestas"] as List).map((p) {
      final respuesta = Respuesta.fromJson(
        p as Map<String, dynamic>,
        serializer: const CustomSerializer(),
      );
      return respuesta.copyWith(

          /// se hace este proceso para agregarle el path completo a las fotos
          fotosBase: respuesta.fotosBase.map((e) =>
              FotosManager.convertirAUbicacionAbsoluta(
                  tipoDeDocumento: 'inspecciones',
                  idDocumento: (json['id'] as int).toString(),
                  basename: e)),
          fotosReparacion: respuesta.fotosReparacion.map((e) =>
              FotosManager.convertirAUbicacionAbsoluta(
                  tipoDeDocumento: 'inspecciones',
                  idDocumento: (json['id'] as int).toString(),
                  basename: e)));
    }).toList();

    /// Así queda solo los campos de la inspección y se puede dar [inspeccionParseadas]
    json.remove('respuestas');

    final inspeccionParseadas = Inspeccion.fromJson(
      json,
      serializer: const CustomSerializer(),
      // ignore: avoid_redundant_argument_values
    );

    await customStatement('PRAGMA foreign_keys = OFF');

    /// Inicia transacción para asegurar que se puedan insertar tanto la inspección como sus respuestas.
    await transaction(() async {
      /// Puede que la insp ya exista en la bd, por el historial, así que si existe se actualiza, si no se inserta.
      await into(inspecciones).insertOnConflictUpdate(inspeccionParseadas);
      await batch((b) {
        b.insertAll(respuestas, respuestasParseadas);
      });
    });
    await customStatement('PRAGMA foreign_keys = ON');
  }

  /// Cuando se sincroniza con GOMAC, se insertan todos los datos a la bd.
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

    /// Primero se eliminan todos los datos que hayan en las tablas que descarga el server y luego se inserta toda la info
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

  /// Se usa en [BorradoresDao.borradores()]
  ///
  /// Al cargar todas las inspecciones, se consulta cual es el cuestionario asociado a [inspeccion]
  Future<Cuestionario> getCuestionario(Inspeccion inspeccion) {
    final query = select(cuestionarios)
      ..where((c) => c.id.equals(inspeccion.cuestionarioId));
    return query.getSingle();
  }

  /// Devuelve la cantidad total de preguntas que tiene el cuestionario con id=[id]
  Future<int> getTotalPreguntas(int id) async {
    final bloq = await (select(bloques)
          ..where((b) => b.cuestionarioId.equals(id)))
        .get();
    final bloquesId = bloq.map((e) => e.id).toList();

    /// Va a contar las preguntas cuyos bloques estan en [bloquesId] que son los bloques del cuestionario
    final count = countAll(filter: preguntas.bloqueId.isIn(bloquesId));
    final res = (selectOnly(preguntas)..addColumns([count]))
        .map((row) => row.read(count))
        .getSingle();
    return res;
  }

  /// Esta funcion deberá exportar TODAS las inspecciones llenadas de manera
  /// local al servidor
  Future exportarInspeccion() async {
    // TODO: WIP

    final ins = await (select(inspecciones)
          ..where(
            (e) => e.id.equals(1),
          ))
        .get();
  }
}

/// Serializer usado al invocar [.toJson()] o [fromJson()] que maneja los enum de tipoPregunta y estado de inspeccion y cuestionario.
/// También maneja las fechas y las fotos.
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
      return null as T;
    }

    if (T == ListPathFotos) {
      return IList.from(json as List<String>) as T;
    } /*
    if (json is List) {
      // https://stackoverflow.com/questions/50188729/checking-what-type-is-passed-into-a-generic-method
      // machetazo que convierte todas las listas a IListString dado que no
      // se puede preguntar por T == IListString, puede que se pueda arreglar
      // cuando los de dart implementen los alias de tipos https://github.com/dart-lang/language/issues/65
      return IList.from(json.cast<String>()) as T;
    }*/

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

    if (value is IList) {
      return value.toList();
    }

    return value;
  }
}

// extension method usado para obtener el valor de un atributo de un companion
extension DefaultGetter<T> on Value<T> {
  T valueOrDefault(T def) {
    return present ? value : def;
  }
  // ···
}

typedef ListPathFotos = IList<String>;
