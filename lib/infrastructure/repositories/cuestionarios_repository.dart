import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/core/entities/app_image.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/features/creacion_cuestionarios/tablas_unidas.dart';
import 'package:inspecciones/infrastructure/core/typedefs.dart';
import 'package:inspecciones/infrastructure/datasources/cuestionarios_remote_datasource.dart';
import 'package:inspecciones/infrastructure/datasources/flutter_downloader/errors.dart';
import 'package:inspecciones/infrastructure/datasources/fotos_remote_datasource.dart';
import 'package:inspecciones/infrastructure/datasources/providers.dart';
import 'package:inspecciones/infrastructure/drift_database.dart';
import 'package:inspecciones/infrastructure/repositories/fotos_repository.dart';
import 'package:inspecciones/infrastructure/utils/transformador_excepciones_api.dart';

class CuestionariosRepository {
  final Reader _read;
  CuestionariosRemoteDataSource get _api =>
      _read(cuestionariosRemoteDataSourceProvider);
  //FotosRemoteDataSource get _apiFotos => _read(fotosRemoteDataSourceProvider);
  Database get _db => _read(driftDatabaseProvider);
  //FotosRepository get _fotosRepository => _read(fotosRepositoryProvider);

  CuestionariosRepository(this._read);

  Future<Either<ApiFailure, List<Cuestionario>>>
      getListaDeCuestionariosServer() => apiExceptionToApiFailure(
            () => _api.getCuestionarios().then((l) => l
                .map((c) => Cuestionario(
                      id: c["id"],
                      tipoDeInspeccion: c["tipo_de_inspeccion"],
                      version: c["version"],
                      periodicidadDias: c["periodicidad_dias"],
                      estado: EstadoDeCuestionario.finalizado,
                      subido: true,
                    ))
                .toList()),
          );

  Future<Either<ApiFailure, Unit>> descargarCuestionario(
      {required String cuestionarioId}) async {
    final json = await _api.descargarCuestionario(cuestionarioId);
    final parsed = _deserializarCuestionario(json);
    await _db.guardadoDeCuestionarioDao.guardarCuestionario(parsed);
    return const Right(unit);
  }

  CuestionarioCompletoCompanion _deserializarCuestionario(JsonMap json) {
    final cuestionario = CuestionariosCompanion.insert(
      id: Value(json['id']),
      tipoDeInspeccion: json['tipo_de_inspeccion'],
      version: json['version'],
      periodicidadDias: json['periodicidad_dias'],
      estado: EstadoDeCuestionario
          .finalizado, // si viene del server suponemos que esta finalizado
      subido: true,
    );
    final etiquetas = (json['etiquetas_aplicables'] as JsonList)
        .map((e) => EtiquetasDeActivoCompanion.insert(
            clave: e['clave'], valor: e['valor']))
        .toList();
    final bloques = (json['bloques'] as JsonList)
        .map((b) => _deserializarBloque(b))
        .toList();

    return CuestionarioCompletoCompanion(cuestionario, etiquetas, bloques);
  }

  Companion _deserializarBloque(JsonMap json) {
    if (json['titulo'] != null) {
      final titulo = json['titulo'] as JsonMap;
      return TituloDCompanion(TitulosCompanion.insert(
        id: Value(titulo['id']),
        bloqueId: "", // el metodo de guardado agrega el bloqueId adecuado
        titulo: titulo['titulo'],
        descripcion: titulo['descripcion'],
        fotos: _deserializarFotos(titulo['fotos_urls']),
      ));
    }
    if (json['pregunta'] != null) {
      final pregunta = json['pregunta'] as JsonMap;
      final tipoDePregunta = EnumToString.fromString(TipoDePregunta.values,
          (pregunta["tipo_de_pregunta"] as String).replaceAll("_", " "),
          camelCase: true);
      if (tipoDePregunta == null) {
        throw Exception(
            "Tipo de pregunta no reconocido: ${pregunta["tipo_de_pregunta"]}");
      }
      switch (tipoDePregunta) {
        case TipoDePregunta.seleccionUnica:
        case TipoDePregunta.seleccionMultiple:
          return _deserializarPreguntaConOpcionesDeRespuesta(
              pregunta, tipoDePregunta);
        case TipoDePregunta.numerica:
          return PreguntaNumericaCompanion(
            _deserializarPregunta(pregunta, tipoDePregunta),
            _deserializarCriticidades(pregunta['criticidades_numericas']),
            _buildEtiquetasDePregunta(pregunta['etiquetas']),
          );
        case TipoDePregunta.cuadricula:
          final tipoDeCuadricula = EnumToString.fromString(
              TipoDeCuadricula.values,
              (pregunta["tipo_de_cuadricula"] as String).replaceAll("_", " "),
              camelCase: true);
          return CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion(
            _deserializarPreguntaConOpcionesDeRespuesta(
                pregunta, tipoDePregunta,
                tipoDeCuadricula: tipoDeCuadricula),
            (pregunta["preguntas"] as JsonList)
                .map((p) => _deserializarPreguntaConOpcionesDeRespuesta(
                    p, TipoDePregunta.parteDeCuadricula))
                .toList(),
          );
        case TipoDePregunta.parteDeCuadricula:
          throw StateError("no permitido como padre de jerarquia");
      }
    }
    throw Exception("un bloque debe tener un titulo o una pregunta");
  }

  PreguntaConOpcionesDeRespuestaCompanion
      _deserializarPreguntaConOpcionesDeRespuesta(
              Map<String, dynamic> pregunta, TipoDePregunta tipoDePregunta,
              {TipoDeCuadricula? tipoDeCuadricula}) =>
          PreguntaConOpcionesDeRespuestaCompanion(
            _deserializarPregunta(pregunta, tipoDePregunta,
                tipoDeCuadricula: tipoDeCuadricula),
            _deserializarOpcionesDeRespuesta(pregunta['opciones_de_respuesta']),
            _buildEtiquetasDePregunta(pregunta['etiquetas']),
          );

  PreguntasCompanion _deserializarPregunta(
          Map<String, dynamic> pregunta, TipoDePregunta tipoDePregunta,
          {TipoDeCuadricula? tipoDeCuadricula}) =>
      PreguntasCompanion.insert(
        titulo: pregunta['titulo'],
        descripcion: pregunta['descripcion'],
        criticidad: pregunta['criticidad'],
        fotosGuia: _deserializarFotos(pregunta['fotos_guia_urls']),
        tipoDePregunta: tipoDePregunta,
        tipoDeCuadricula: Value(tipoDeCuadricula),
      );

  List<OpcionesDeRespuestaCompanion> _deserializarOpcionesDeRespuesta(
          JsonList opciones) =>
      opciones
          .map((o) => OpcionesDeRespuestaCompanion.insert(
                id: Value(o["id"]),
                titulo: o["titulo"],
                descripcion: o["descripcion"],
                criticidad: o["criticidad"],
                // el metodo de guardado agrega la preguntaId adecuada
                preguntaId: "",
              ))
          .toList();

  List<CriticidadesNumericasCompanion> _deserializarCriticidades(
          JsonList criticidades) =>
      criticidades
          .map((c) => CriticidadesNumericasCompanion.insert(
                id: Value(c["id"]),
                valorMinimo: c["valor_minimo"] is int
                    ? c["valor_minimo"].toDouble()
                    : c["valor_minimo"],
                valorMaximo: c["valor_maximo"] is int
                    ? c["valor_maximo"].toDouble()
                    : c["valor_maximo"],
                criticidad: c["criticidad"],
                // el metodo de guardado agrega la preguntaId adecuada
                preguntaId: "",
              ))
          .toList();

  List<EtiquetasDePreguntaCompanion> _buildEtiquetasDePregunta(
          JsonList etiquetas) =>
      etiquetas
          .map((e) => EtiquetasDePreguntaCompanion.insert(
                clave: e["clave"],
                valor: e["valor"],
              ))
          .toList();

  List<AppImage> _deserializarFotos(JsonList fotos) =>
      fotos.map((f) => AppImage.remote(f["foto"])).toList();

  /// Envia [cuestionario] al server.
  Future<Either<ApiFailure, Unit>> subirCuestionario(
      Cuestionario cuestionario) async {
    throw UnimplementedError();

    /// Json con info de [cuestionario] y sus respectivos bloques.
    final cuestionarioCompleto = await getCuestionarioCompleto(cuestionario.id);

/*
    Future<void> subirFotos() async {
      /// Usado para el nombre de la carpeta de las fotos
      final idDocumento = cuestionarioMap['id'].toString();

      final fotos = await _fotosRepository.getFotosDeDocumento(
        Categoria.cuestionario,
        identificador: idDocumento,
      );
      await _apiFotos.subirFotos(fotos, idDocumento, Categoria.cuestionario);
    }

    return apiExceptionToApiFailure(
            () => _api.crearCuestionario(cuestionarioMap))
        .nestedEvaluatedMap(
          /// Como los cuestionarios quedan en el celular, se marca como subidos
          /// para que no se envíe al server un cuestionario que ya existe.
          /// cambia [cuestionario.esLocal] = false.
          (_) => _db.sincronizacionDao.marcarCuestionarioSubido(cuestionario),
        )
        .flatMap(
          (_) => apiExceptionToApiFailure(
            () => subirFotos().then((_) => unit),
          ),
        );*/
  }

  Future<JsonMap> _generarJsonCuestionario(Cuestionario cuestionario) async {
    throw UnimplementedError();
  }

  /// Descarga los cuestionarios y todo lo necesario para tratarlos:
  /// activos, sistemas, contratistas y subsistemas
  /// En caso de que ya exista el archivo, lo borra y lo descarga de nuevo

  Future<Either<ApiFailure, File>> descargarTodosLosCuestionarios(
      String token) async {
    try {
      return Right(await _api.descargarTodosLosCuestionarios(token));
    } on ErrorDeDescargaFlutterDownloader {
      return const Left(ApiFailure.errorDeComunicacionConLaApi(
          "FlutterDownloader no pudo descargar los cuestionarios"));
    } catch (e) {
      return Left(ApiFailure.errorDeProgramacion(e.toString()));
    }
  }

  /// Descarga todas las fotos de todos los cuestionarios
  Future<Either<ApiFailure, Unit>> descargarFotos(String token) async {
    try {
      await _api.descargarTodasLasFotos(token);
      return const Right(unit);
    } on ErrorDeDescargaFlutterDownloader {
      return const Left(ApiFailure.errorDeComunicacionConLaApi(
          "FlutterDownloader no pudo descargar las fotos"));
    } catch (e) {
      return Left(ApiFailure.errorDeProgramacion(e.toString()));
    }
  }

  Stream<List<Cuestionario>> getCuestionariosLocales() =>
      _db.cargaDeCuestionarioDao.watchCuestionarios();

  Future<void> eliminarCuestionario(Cuestionario cuestionario) =>
      _db.cargaDeCuestionarioDao.eliminarCuestionario(cuestionario);

  Future<CuestionarioCompleto> getCuestionarioCompleto(String cuestionarioId) =>
      _db.cargaDeCuestionarioDao.getCuestionarioCompleto(cuestionarioId);

  /*Future<List<Cuestionario>> getCuestionarios(
          String tipoDeInspeccion, List<EtiquetaDeActivo> etiquetas) =>
      _db.cargaDeCuestionarioDao.getCuestionarios(tipoDeInspeccion, modelos);*/

  Future<List<String>> getTiposDeInspecciones() =>
      _db.cargaDeCuestionarioDao.getTiposDeInspecciones();

  Future<List<EtiquetaDeActivo>> getEtiquetas() =>
      _db.cargaDeCuestionarioDao.getEtiquetas();

  Future<void> guardarCuestionario(
          CuestionarioCompletoCompanion cuestionario) =>
      _db.guardadoDeCuestionarioDao.guardarCuestionario(cuestionario);

  Future<Either<ApiFailure, Unit>> subirCuestionariosPendientes() async {
    //TODO: subir cada uno, o todos a la vez para mas eficiencia
    throw UnimplementedError();
  }

  Future<void> insertarDatosDePrueba() async {
    //TODO: insertar datos de prueba
  }
}
