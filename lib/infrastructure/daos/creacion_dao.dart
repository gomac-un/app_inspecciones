import 'dart:io';

import 'package:kt_dart/kt.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/mvvc/creacion_controls.dart';
import 'package:moor/moor.dart';
import 'package:path_provider/path_provider.dart';
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
      final int cid =
          await into(cuestionarios).insert(CuestionariosCompanion.insert());

      final String tipoDeInspeccion = form["tipoDeInspeccion"].value == "otra"
          ? form["nuevoTipoDeInspeccion"].value as String
          : form["tipoDeInspeccion"].value as String;

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
        final i = entry.key as int;
        final control = entry.value;
        final bid = await into(bloques)
            .insert(BloquesCompanion.insert(cuestionarioId: cid, nOrden: i));

        //TODO: guardar inserts de cada tipo en listas para luego insertarlos en batch
        //TODO: usar los metodos toDataClass para obtener los datos de cada bloque
        if (control is CreadorTituloFormGroup) {
          await into(titulos).insert(TitulosCompanion.insert(
            bloqueId: bid,
            titulo: control.value["titulo"] as String,
            descripcion: control.value["descripcion"] as String,
          ));
        }
        if (control is CreadorPreguntaFormGroup) {
          final appDir = await getApplicationDocumentsDirectory();
          //Mover las fotos a una carpeta unica para cada cuestionario
          final fotosGuiaProcesadas = await Future.wait(
            db.organizarFotos(
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
              titulo: control.value["titulo"] as String,
              descripcion: control.value["descripcion"] as String,
              sistemaId: control.value["sistema"].id as int,
              subSistemaId: control.value["subSistema"].id as int,
              posicion: control.value["posicion"] as String,
              tipo: control.value["tipoDePregunta"] as TipoDePregunta,
              criticidad: control.value["criticidad"].round() as int,
              fotosGuia: Value(fotosGuiaProcesadas.toImmutableList()),
              parteDeCuadricula: false,
            ),
          );
          // Asociacion de las opciones de respuesta con esta pregunta
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
                        sistemaId: control.value["sistema"].id
                            as int, //TODO: sistema/subsistema/posicion diferente para cada pregunta
                        subSistemaId: control.value["subSistema"].id as int,
                        posicion: control.value["posicion"] as String,
                        tipo: TipoDePregunta
                            .unicaRespuesta, //TODO: multiple respuesta para cuadriculas
                        criticidad: e["criticidad"].round() as int,
                        parteDeCuadricula:
                            true, //TODO: fotos para cada pregunta
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
  }
}
