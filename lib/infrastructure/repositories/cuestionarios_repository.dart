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
import 'package:inspecciones/utils/future_either_x.dart';

class CuestionariosRepository {
  final Reader _read;
  CuestionariosRemoteDataSource get _api =>
      _read(cuestionariosRemoteDataSourceProvider);
  FotosRemoteDataSource get _apiFotos => _read(fotosRemoteDataSourceProvider);
  Database get _db => _read(driftDatabaseProvider);
  FotosRepository get _fotosRepository => _read(fotosRepositoryProvider);

  CuestionariosRepository(this._read);

  Future<Either<ApiFailure, Unit>> descargarCuestionario(
      {required String cuestionarioId}) async {
    final json = await _api.descargarCuestionario(cuestionarioId);
    final parsed = _parseCuestionario(json);
    await _db.guardadoDeCuestionarioDao
        .guardarCuestionario(parsed.value1, parsed.value2, parsed.value3);
    return const Right(unit);
  }

  Tuple3<CuestionariosCompanion, List<EtiquetasDeActivoCompanion>, List<Object>>
      _parseCuestionario(JsonMap json) {
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
    final bloques =
        (json['bloques'] as JsonList).map((b) => _parseBloque(b)).toList();
    return Tuple3(cuestionario, etiquetas, bloques);
  }

  List<AppImage> _buildFotos(JsonList fotos) =>
      fotos.map((f) => AppImage.remote(f["foto"])).toList();

  List<OpcionesDeRespuestaCompanion> _buildOpcionesDeRespuesta(
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

  List<CriticidadesNumericasCompanion> _buildCriticidades(
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

  PreguntasCompanion _buildPregunta(
          Map<String, dynamic> pregunta, TipoDePregunta tipoDePregunta,
          {TipoDeCuadricula? tipoDeCuadricula}) =>
      PreguntasCompanion.insert(
        titulo: pregunta['titulo'],
        descripcion: pregunta['descripcion'],
        criticidad: pregunta['criticidad'],
        fotosGuia: _buildFotos(pregunta['fotos_guia_urls']),
        tipoDePregunta: tipoDePregunta,
        tipoDeCuadricula: Value(tipoDeCuadricula),
      );

  PreguntaConOpcionesDeRespuestaCompanion _buildPreguntaConOpcionesDeRespuesta(
          Map<String, dynamic> pregunta, TipoDePregunta tipoDePregunta,
          {TipoDeCuadricula? tipoDeCuadricula}) =>
      PreguntaConOpcionesDeRespuestaCompanion(
        _buildPregunta(pregunta, tipoDePregunta,
            tipoDeCuadricula: tipoDeCuadricula),
        _buildOpcionesDeRespuesta(pregunta['opciones_de_respuesta']),
        _buildEtiquetasDePregunta(pregunta['etiquetas']),
      );

  Object _parseBloque(JsonMap json) {
    if (json['titulo'] != null) {
      final titulo = json['titulo'] as JsonMap;
      return TitulosCompanion.insert(
        id: Value(titulo['id']),
        bloqueId: "", // el metodo de guardado agrega el bloqueId adecuado
        titulo: titulo['titulo'],
        descripcion: titulo['descripcion'],
        fotos: _buildFotos(titulo['fotos_urls']),
      );
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
          return _buildPreguntaConOpcionesDeRespuesta(pregunta, tipoDePregunta);
        case TipoDePregunta.numerica:
          return PreguntaNumericaCompanion(
            _buildPregunta(pregunta, tipoDePregunta),
            _buildCriticidades(pregunta['criticidades_numericas']),
            _buildEtiquetasDePregunta(pregunta['etiquetas']),
          );
        case TipoDePregunta.cuadricula:
          final tipoDeCuadricula = EnumToString.fromString(
              TipoDeCuadricula.values,
              (pregunta["tipo_de_cuadricula"] as String).replaceAll("_", " "),
              camelCase: true);
          return CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion(
            _buildPreguntaConOpcionesDeRespuesta(pregunta, tipoDePregunta,
                tipoDeCuadricula: tipoDeCuadricula),
            (pregunta["preguntas"] as JsonList)
                .map((p) => _buildPreguntaConOpcionesDeRespuesta(
                    p, TipoDePregunta.parteDeCuadricula))
                .toList(),
          );
        case TipoDePregunta.parteDeCuadricula:
          throw StateError("no permitido como padre de jerarquia");
      }
    }
    throw Exception("un bloque debe tener un titulo o una pregunta");
  }

  Future<Either<ApiFailure, Unit>> subirCuestionariosPendientes() async {
    //TODO: subir cada uno, o todos a la vez para mas eficiencia
    throw UnimplementedError();
  }

  Future<void> insertarDatosDePrueba() async {
    //TODO: insertar datos de prueba
  }

  /// Envia [cuestionario] al server.
  Future<Either<ApiFailure, Unit>> subirCuestionario(
      Cuestionario cuestionario) async {
    /// Json con info de [cuestionario] y sus respectivos bloques.
    final cuestionarioMap = await _generarJsonCuestionario(cuestionario);

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
        );
    //TODO: mirar como procesar los json de las respuestas intermedias
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

  Future eliminarCuestionario(Cuestionario cuestionario) =>
      _db.cargaDeCuestionarioDao.eliminarCuestionario(cuestionario);

  Future<CuestionarioConEtiquetas> getCuestionarioYEtiquetas(
          String cuestionarioId) =>
      _db.cargaDeCuestionarioDao.getCuestionarioYEtiquetas(cuestionarioId);

  Future<List<Object>> cargarCuestionario(String cuestionarioId) =>
      _db.cargaDeCuestionarioDao.cargarCuestionario(cuestionarioId);

  /*Future<List<Cuestionario>> getCuestionarios(
          String tipoDeInspeccion, List<EtiquetaDeActivo> etiquetas) =>
      _db.cargaDeCuestionarioDao.getCuestionarios(tipoDeInspeccion, modelos);*/

  Future<List<String>> getTiposDeInspecciones() =>
      _db.cargaDeCuestionarioDao.getTiposDeInspecciones();

  Future<List<EtiquetaDeActivo>> getEtiquetas() =>
      _db.cargaDeCuestionarioDao.getEtiquetas();

  Future<void> guardarCuestionario(
    CuestionariosCompanion cuestionario,
    List<EtiquetasDeActivoCompanion> etiquetas,
    List<Object> bloquesForm,
  ) =>
      _db.guardadoDeCuestionarioDao.guardarCuestionario(
        cuestionario,
        etiquetas,
        bloquesForm,
      );
}
