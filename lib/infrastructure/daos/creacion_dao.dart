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
  Condicionales,
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

  Future crearCuestionario(Map<String, AbstractControl> form) {
    return transaction(() async {
      final String tipoDeInspeccion = form["tipoDeInspeccion"].value == "otra"
          ? form["nuevoTipoDeInspeccion"].value as String
          : form["tipoDeInspeccion"].value as String;

      final int cid = await into(cuestionarios).insert(
          CuestionariosCompanion.insert(tipoDeInspeccion: tipoDeInspeccion));

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
              Map<dynamic, dynamic> e,) async {
             await into(condicionales).insert(
              CondicionalesCompanion.insert(
                preguntaId: pid,
                opcionDeRespuesta:Value(e['texto'] as String) ,
                seccion: int.parse(
                    (e['seccion'] as String).replaceAll('Ir a bloque ', '')) -1 ,
              ),
            );
          }

          Future<int> insertarOpcion(Map<dynamic, dynamic> e) async {
            final opid = await into(opcionesDeRespuesta).insert(
                OpcionesDeRespuestaCompanion.insert(
                  preguntaId: Value(pid),
                    criticidad: e['criticidad'].round() as int,
                    texto: e['texto'] as String));
            return opid;
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
  }
}
