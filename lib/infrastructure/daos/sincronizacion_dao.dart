import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:inspecciones/core/entities/app_image.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/identificador_inspeccion.dart';

// import 'daos/borradores_dao.dart';
// import 'daos/carga_cuestionario_dao.dart';
// import 'daos/carga_inspeccion_dao.dart';
// import 'daos/guardado_cuestionario_dao.dart';
// import 'daos/guardado_inspeccion_dao.dart';
import '../drift_database.dart';

export '../database/shared.dart';

part 'sincronizacion_dao.drift.dart';

@DriftAccessor(tables: [
  Activos,
  ActivosXEtiquetas,
  EtiquetasDeActivo,
  Cuestionarios,
  Bloques,
  Titulos,
  Preguntas,
  OpcionesDeRespuesta,
  Inspecciones,
  Respuestas,
  CriticidadesNumericas,
])
class SincronizacionDao extends DatabaseAccessor<Database>
    with _$SincronizacionDaoMixin {
  SincronizacionDao(Database db) : super(db);

  /// marca [cuestionario.subido] = true cuando [cuestionario] es subido al server
  Future<void> marcarCuestionarioSubido(Cuestionario cuestionario) =>
      (update(cuestionarios)..where((c) => c.id.equals(cuestionario.id)))
          .write(const CuestionariosCompanion(subido: Value(true)));

  Future<IdentificadorDeInspeccion> guardarInspeccionBD(
      Map<String, dynamic> json) async {
    throw UnimplementedError();
  }

  Future<Map<String, dynamic>> getInspeccionConRespuestas(
      Inspeccion inspeccion) async {
    throw UnimplementedError();
  }
/*
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
        final pregunta = p.copyWith(
          fotosGuia: p.fotosGuia.map(_soloBasename),
        );
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

  

  /// Devuelve json con [inspeccion] y sus respectivas respuestas
  Future<Map<String, dynamic>> getInspeccionConRespuestas(
      Inspeccion inspeccion) async {
    final jsonIns = inspeccion.toJson(serializer: const CustomSerializer());
    //get respuestas
    final queryRes = select(respuestas).join([
      leftOuterJoin(opcionesDeRespuesta,
          respuestas.opcionDeRespuestaId.equalsExp(opcionesDeRespuesta.id)),
    ])
      ..where(respuestas.inspeccionId.equals(inspeccion.id));
    final res = await queryRes
        .map((row) => Tuple2(row.readTable(respuestas),
            row.readTableOrNull(opcionesDeRespuesta)?.id))
        .get();

    final resAgrupadas =
        groupBy<Tuple2<Respuesta, int?>, Respuesta>(res, (e) => e.value1)
            .entries
            .map((entry) {
      //solo enviar el filename al server
      final respuesta = entry.key.copyWith(
          fotosBase: entry.key.fotosBase.map(_soloBasename),
          fotosReparacion: entry.key.fotosReparacion.map(_soloBasename));

      final respuestaJson =
          respuesta.toJson(serializer: const CustomSerializer());

      return respuestaJson;
    }).toList();

    jsonIns['respuestas'] = resAgrupadas;

    return jsonIns;
  }

  /// Método usado para cuando se descarga una inspección desde el servidor se guarde en la bd y se pueda seguir el curso normal
  Future<IdentificadorDeInspeccion> guardarInspeccionBD(
      Map<String, dynamic> json) async {
    final respuestasParseadas = (json["respuestas"] as List).map((p) {
      final respuesta = Respuesta.fromJson(
        p as Map<String, dynamic>,
        serializer: const CustomSerializer(),
      );

      return respuesta.copyWith(
        /// se hace este proceso para agregarle el path completo a las fotos
        fotosBase: respuesta.fotosBase.map(
          (e) => fotosRepository.convertirAUbicacionAbsolutaAppImage(
            e,
            Categoria.inspeccion,
            identificador: (json['id'] as int).toString(),
          ),
        ),
        fotosReparacion: respuesta.fotosReparacion.map(
          (e) => fotosRepository.convertirAUbicacionAbsolutaAppImage(
            e,
            Categoria.inspeccion,
            identificador: (json['id'] as int).toString(),
          ),
        ),
      );
    }).toList();

    /// Así queda solo los campos de la inspección y se puede dar [inspeccionParseadas]
    json.remove('respuestas');

    final inspeccionParseadas = Inspeccion.fromJson(
      json,
      serializer: const CustomSerializer(),
    ).copyWith(
        //Se actualiza con momentoEnvio nulo para que no aparezca en el historial de enviadas
        momentoEnvio: null,
        esNueva: false);

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
    return IdentificadorDeInspeccion(
        activo: inspeccionParseadas.activoId.toString(),
        cuestionarioId: inspeccionParseadas.cuestionarioId);
  }

  /// Cuando se sincroniza con GOMAC, se insertan todos los datos a la bd.
  Future<void> instalarBD(Map<String, dynamic> json) async {
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
        .map((e) => Cuestionario.fromJson(
            (e as Map<String, dynamic>)..["esLocal"] = false,
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
        fotosGuia: pregunta.fotosGuia.map(
          (e) => fotosRepository.convertirAUbicacionAbsolutaAppImage(
            e,
            Categoria.cuestionario,
            identificador: (p['cuestionario'] as int).toString(),
          ),
        ),
      );
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
      });
    });
    await customStatement('PRAGMA foreign_keys = ON');
  }

  /// Esta funcion deberá exportar TODAS las inspecciones llenadas de manera
  /// local al servidor
  Future exportarInspeccion() async {
    // TODO: Implementar
  }*/
}

