export 'package:moor_flutter/moor_flutter.dart' show Value;

import 'dart:convert';
import 'dart:io';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:json_annotation/json_annotation.dart' as j;
import 'package:moor/moor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import 'package:inspecciones/domain/core/enums.dart';
export 'database/shared.dart';

part 'moor_database.g.dart';
part 'bdDePrueba.dart';
part 'tablas.dart';

class BloqueConPregunta {
  final Bloque bloque;
  final Pregunta pregunta;

  BloqueConPregunta({
    @required this.bloque,
    @required this.pregunta,
  });
}

class PreguntaConOpcionesDeRespuesta {
  final Pregunta pregunta;
  final List<OpcionDeRespuesta> opcionesDeRespuesta;

  PreguntaConOpcionesDeRespuesta(this.pregunta, this.opcionesDeRespuesta);
}

class RespuestaConOpcionesDeRespuesta {
  RespuestasCompanion respuesta;
  List<OpcionDeRespuesta> opcionesDeRespuesta;

  RespuestaConOpcionesDeRespuesta(this.respuesta, this.opcionesDeRespuesta);
}

class CuadriculaDePreguntasConOpcionesDeRespuesta {
  final CuadriculaDePreguntas cuadricula;
  final List<OpcionDeRespuesta> opcionesDeRespuesta;

  CuadriculaDePreguntasConOpcionesDeRespuesta(
      this.cuadricula, this.opcionesDeRespuesta);
}

class PreguntaConRespuestaConOpcionesDeRespuesta {
  final Pregunta pregunta;
  RespuestaConOpcionesDeRespuesta respuesta;

  PreguntaConRespuestaConOpcionesDeRespuesta(this.pregunta, this.respuesta);
}

class BloqueConPreguntaRespondida {
  Bloque bloque;
  Pregunta pregunta;
  RespuestasCompanion respuesta;

  BloqueConPreguntaRespondida({
    @required this.bloque,
    @required this.pregunta,
    @required this.respuesta,
  });
}

class Borrador {
  Inspeccion inspeccion;
  CuestionarioDeModelo cuestionarioDeModelo;
  Activo activo;
  Borrador(this.inspeccion, this.cuestionarioDeModelo, this.activo);
}

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
  ],
)
class Database extends _$Database {
  Database(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 2;

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
    // changed to this
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

  Future<List<Contratista>> getContratistas() {
    return select(contratistas).get();
  }

  Future<List<Sistema>> getSistemas() {
    return select(sistemas).get();
  }

  Future<List<SubSistema>> getSubSistemas(Sistema sistema) {
    //return (select(subSistemas)..where(subSistemas.sistemaId.equals(1))).get();
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

  Future crearCuestionario(Map<String, dynamic> f) async {
    return transaction(() async {
      final ins1 = CuestionariosCompanion.insert();
      int cid = await into(cuestionarios).insert(ins1);

      String tipoDeInspeccion = f["tipoDeInspeccion"] == "otra"
          ? f["nuevoTipoDeInspeccion"]
          : f["tipoDeInspeccion"];

      await batch((batch) {
        // asociar a cada modelo con este cuestionario
        batch.insertAll(
            cuestionarioDeModelos,
            (f["modelos"] as List<String>)
                .map((String modelo) => CuestionarioDeModelosCompanion.insert(
                    modelo: modelo,
                    tipoDeInspeccion: tipoDeInspeccion,
                    periodicidad: int.parse(f["periodicidad"]),
                    contratistaId: f["contratista"].id,
                    cuestionarioId: cid))
                .toList()); //TODO: distintas periodicidades y contratistas por cuestionarioDeModelo
      });

      int i = -1;
      for (var b in f["bloques"]) {
        i++;
        var bfi = BloquesCompanion.insert(
          cuestionarioId: cid,
          nOrden: i,
          /*titulo: b["titulo"],
          descripcion: b["descripcion"],*/
        );
        int bid = await into(bloques).insert(bfi);

        if (b["criticidad"] == null)
          continue; //si es null entonces es un titulo entonces siga al siguiente bloque

        //construccion de las opciones de respuesta
        List<OpcionDeRespuesta> l = [];
        for (var r in b["respuestas"]) {
          l.add(OpcionDeRespuesta.fromJson(r));
        }

        final appDir = await getApplicationDocumentsDirectory();

        final List<Future<String>> fotosGuia =
            b["imagenes"].map<Future<String>>((imageURl) async {
          final image = File(imageURl);
          if (path.isWithin(appDir.path, image.path)) {
            // la imagen ya esta en la carpeta de datos
            return image.path;
          } else {
            //mover la foto a la carpeta de datos
            final fileName = path.basename(image.path);
            final newPath = path.join(
                appDir.path, 'fotos', "cuestionario", cid.toString(), fileName);
            await File(newPath).create(recursive: true);
            final savedImage = await image.copy(newPath);
            return savedImage.path;
          }
        }).toList();
        final fotosGuiaProcesadas = await Future.wait(fotosGuia);

        var pfi = PreguntasCompanion.insert(
          bloqueId: bid,
          sistemaId: b["sistema"].id,
          subSistemaId: b["subsistema"].id,
          posicion: b["posicion"],
          tipo: EnumToString.fromString(
              TipoDePregunta.values, b["tipoDePregunta"]),
          fotosGuia: Value(fotosGuiaProcesadas.toList()),
          criticidad: b["criticidad"],
          //opcionesDeRespuesta: Value(l),
        );
        await into(preguntas).insert(pfi);
      }
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

  Future<List<BloqueConPreguntaRespondida>> cargarInspeccion(
      int cuestionarioId, String vehiculo) async {
    //revisar si hay una inspeccion de ese cuestionario empezada
    if (cuestionarioId == null || vehiculo == null) return null;
    final query1 = select(inspecciones)
      ..where(
        (ins) =>
            ins.cuestionarioId.equals(cuestionarioId) &
            ins.identificadorActivo.equals(vehiculo),
      );

    final res = await query1.get();

    Inspeccion borrador;
    if (res.length > 0) borrador = res.first;

    //carga los bloques y si tiene preguntas y respuestas las agrega
    final query2 = select(bloques).join([
      leftOuterJoin(preguntas, preguntas.bloqueId.equalsExp(bloques.id)),
      leftOuterJoin(
          respuestas,
          respuestas.preguntaId.equalsExp(preguntas.id) &
              respuestas.inspeccionId.equals(borrador?.id)),
    ])
      ..where(bloques.cuestionarioId.equals(cuestionarioId))
      ..orderBy([OrderingTerm(expression: bloques.nOrden)]);

    return query2
        .map(
          (row) => BloqueConPreguntaRespondida(
            bloque: row.readTable(bloques),
            pregunta: row.readTable(preguntas),
            respuesta: row.readTable(respuestas)?.toCompanion(
                    true) ?? //si no hay respuesta devuelve una vacía con inspeccion nula que se debe llenar despues
                RespuestasCompanion.insert(
                    inspeccionId: null,
                    preguntaId: row.readTable(preguntas)?.id),
          ),
        )
        .get();
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
    return Inspeccion(
      id: id,
      cuestionarioId: cuestionarioId,
      estado: esBorrador
          ? EstadoDeInspeccion.enBorrador
          : EstadoDeInspeccion.enviada,
      identificadorActivo: activo,
    );
  }

  //esta funcion para actualizar primero borra todo lo anterior y lo reemplaza con datos actualizados, no es lo mas eficiente
  //TODO: Actualizar en lugar de borrar y recrear
  Future guardarInspeccion(List<RespuestasCompanion> respuestasForm,
      int cuestionarioId, String activo, bool esBorrador) async {
    if (respuestasForm.first.inspeccionId.value == null) {
      //si la primera respuesta no tiene inspeccion asociada, asocia todas a una nueva inspeccion
      Inspeccion i = await crearInspeccion(cuestionarioId, activo, esBorrador);
      respuestasForm = respuestasForm
          .map((r) => r.copyWith(inspeccionId: Value(i.id)))
          .toList();
    }

    return transaction(() async {
      await (update(inspecciones)
            ..where(
                (i) => i.id.equals(respuestasForm.first.inspeccionId.value)))
          .write(
        esBorrador
            ? InspeccionesCompanion(
                momentoBorradorGuardado: Value(DateTime.now()),
              )
            : InspeccionesCompanion(
                momentoEnvio: Value(DateTime.now()),
              ),
      );
      // borrar todas las respuestas anteriores
      await (delete(respuestas)
            ..where((r) =>
                r.inspeccionId.equals(respuestasForm.first.inspeccionId.value)))
          .go();

      //agregar las nuevas
      await batch((batch) {
        // functions in a batch don't have to be awaited - just
        // await the whole batch afterwards.
        batch.insertAll(respuestas, respuestasForm);
      });
    });
  }

  Stream<List<Borrador>> borradores() {
    final query = select(inspecciones).join([
      //TODO: eliminar la inspeccion de los borradores porque solo se necesita el activo y el cm, ya que la inspeccion se consulta con base a estos
      innerJoin(activos,
          activos.identificador.equalsExp(inspecciones.identificadorActivo)),
      innerJoin(cuestionarios,
          cuestionarios.id.equalsExp(inspecciones.cuestionarioId)),
      innerJoin(cuestionarioDeModelos,
          cuestionarioDeModelos.cuestionarioId.equalsExp(cuestionarios.id)),
    ]);

    return query
        .map(
          (row) => Borrador(
            row.readTable(inspecciones),
            row.readTable(cuestionarioDeModelos),
            row.readTable(activos),
          ),
        )
        .watch();
  }

  Future eliminarBorrador(Borrador borrador) async {
    await (delete(inspecciones)
          ..where((r) => r.id.equals(borrador.inspeccion.id)))
        .go();
  }

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

/////////////////converters

class ListInColumnConverter extends TypeConverter<List<String>, String> {
  const ListInColumnConverter();
  @override
  List<String> mapToDart(String fromDb) {
    if (fromDb == null) {
      return null;
    }
    return (jsonDecode(fromDb) as List).map((e) => e as String).toList();
  }

  @override
  String mapToSql(List<String> value) {
    if (value == null) {
      return null;
    }

    return jsonEncode(value);
  }
}
/*
class OpcionDeRespuestaConverter
    extends TypeConverter<List<OpcionDeRespuesta>, String> {
  const OpcionDeRespuestaConverter();
  @override
  List<OpcionDeRespuesta> mapToDart(String fromDb) {
    if (fromDb == null) {
      return null;
    }
    return (jsonDecode(fromDb) as List)
        .map((e) => OpcionDeRespuesta.fromJson(e))
        .toList();
  }

  @override
  String mapToSql(List<OpcionDeRespuesta> value) {
    if (value == null) {
      return null;
    }

    return jsonEncode(value);
  }
}*/
