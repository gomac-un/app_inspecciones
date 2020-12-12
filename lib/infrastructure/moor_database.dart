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
    if (sistema == null) return Future.value([]);
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

  Future crearCuestionarioFromReactiveForm(Map<String, AbstractControl> form) {
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
          final fotosGuia =
              (control.value["fotosGuia"] as List<File>).map((image) async {
            if (path.isWithin(appDir.path, image.path)) {
              // la imagen ya esta en la carpeta de datos
              return image.path;
            } else {
              //mover la foto a la carpeta de datos
              final fileName = path.basename(image.path);
              final newPath = path.join(appDir.path, 'fotos', "cuestionario",
                  cid.toString(), fileName);
              await File(newPath).create(recursive: true);
              final savedImage = await image.copy(newPath);
              return savedImage.path;
            }
          }).toList();
          final fotosGuiaProcesadas = await Future.wait(fotosGuia);
          final pid = await into(preguntas).insert(PreguntasCompanion.insert(
            bloqueId: bid,
            titulo: control.value["titulo"],
            descripcion: control.value["descripcion"],
            sistemaId: control.value["sistema"].id,
            subSistemaId: control.value["subSistema"].id,
            posicion: control.value["posicion"],
            tipo: control.value["tipoDePregunta"],
            criticidad: control.value["criticidad"].round(),
            fotosGuia: Value(fotosGuiaProcesadas.toImmutableList()),
          ));
          // Asociacion de las opciones de respuesta de esta pregunta
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

  Future<List<BloqueConPreguntaSimple>> getPreguntasSimples(
      int cuestionarioId) async {
    final opcionesPregunta = alias(opcionesDeRespuesta, 'op');
    final opcionesRespuesta = alias(opcionesDeRespuesta, 'or');

    final query = select(preguntas).join([
      innerJoin(bloques, bloques.id.equalsExp(preguntas.bloqueId)),
      leftOuterJoin(opcionesPregunta,
          opcionesPregunta.preguntaId.equalsExp(preguntas.id)),
      /*leftOuterJoin(respuestas, respuestas.preguntaId.equalsExp(preguntas.id)),
      leftOuterJoin(respuestasXOpcionesDeRespuesta,
          respuestasXOpcionesDeRespuesta.respuestaId.equalsExp(respuestas.id)),
      leftOuterJoin(
          opcionesRespuesta,
          opcionesRespuesta.id
              .equalsExp(respuestasXOpcionesDeRespuesta.opcionDeRespuestaId)),*/
    ])
      ..where(bloques.cuestionarioId.equals(cuestionarioId) &
              preguntas.tipo.equals(0) //seleccion unica
          );
    final res = await query
        .map((row) => [
              row.readTable(bloques),
              row.readTable(preguntas),
              row.readTable(opcionesPregunta)
            ])
        .get();

    final res1 = groupBy(res, (e) => e[1])
        .entries
        .map((entry) => BloqueConPreguntaSimple(
            entry.value.first[0],
            PreguntaConOpcionesDeRespuesta(
              entry.key,
              entry.value.map((item) => item[2] as OpcionDeRespuesta).toList(),
            ),
            RespuestaConOpcionesDeRespuesta(null, null)))
        //TODO: obtener el bloque y las respuestas
        .toList();

    //iterar las preguntas para obtener las opciones de respuesta seleccionadas

    return res1;
  }

  Future<List<BloqueConCuadricula>> getCuadriculas(int cuestionarioId) async {
    //TODO: implementar
    return null;
  }

  Future<List<IBloqueOrdenable>> cargarCuestionario(int cuestionarioId) async {
    final List<BloqueConTitulo> titulos = await getTitulos(cuestionarioId);

    final List<BloqueConPreguntaSimple> preguntasSimples =
        await getPreguntasSimples(cuestionarioId);

    final List<BloqueConCuadricula> cuadriculas = [];
    //await getCuadriculas(cuestionarioId);

    return [...titulos, ...preguntasSimples, ...cuadriculas];
  }

  Future<List<BloqueConPreguntaRespondida>> cargarInspeccionOld(
      int cuestionarioId, String vehiculo) async {
    //revisar si hay una inspeccion de ese cuestionario empezada

    Inspeccion borrador = await getInspeccion(vehiculo, cuestionarioId);

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
