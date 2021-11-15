import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart' hide DataClass;
import 'package:enum_to_string/enum_to_string.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/core/entities/app_image.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/core/error/errors.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/features/creacion_cuestionarios/tablas_unidas.dart';
import 'package:inspecciones/infrastructure/core/typedefs.dart';
import 'package:inspecciones/infrastructure/datasources/cuestionarios_remote_datasource.dart';
import 'package:inspecciones/infrastructure/datasources/flutter_downloader/errors.dart';
import 'package:inspecciones/infrastructure/datasources/providers.dart';
import 'package:inspecciones/infrastructure/drift_database.dart';
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

  PreguntaDeSeleccionCompanion
      _deserializarPreguntaConOpcionesDeRespuesta(
              Map<String, dynamic> pregunta, TipoDePregunta tipoDePregunta,
              {TipoDeCuadricula? tipoDeCuadricula}) =>
          PreguntaDeSeleccionCompanion(
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
      String cuestionarioId) async {
    /// Json con info de [cuestionario] y sus respectivos bloques.
    final cuestionarioCompleto = await getCuestionarioCompleto(cuestionarioId);
    await _api.subirCuestionario(_serializarCuestionario(cuestionarioCompleto));
    return const Right(unit);

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

  JsonMap _serializarCuestionario(CuestionarioCompleto cuestionarioCompleto) {
    final JsonMap res = {};
    final cuestionario = cuestionarioCompleto.cuestionario;
    res['id'] = cuestionario.id;
    res['tipo_de_inspeccion'] = cuestionario.tipoDeInspeccion;
    res['version'] = cuestionario.version;
    res['periodicidad_dias'] = cuestionario.periodicidadDias;
    res['etiquetas_aplicables'] =
        _serializarEtiquetasDeCuestionario(cuestionarioCompleto.etiquetas);
    res['bloques'] =
        cuestionarioCompleto.bloques.mapIndexed(_serializarBloque).toList();
    return res;
  }

  JsonMap _serializarBloque(int index, DataClass bloque) {
    final JsonMap bloqueJson = {"n_orden": index};
    if (bloque is TituloD) {
      final titulo = bloque.titulo;
      bloqueJson['titulo'] = {
        'id': titulo.id,
        'titulo': titulo.titulo,
        'descripcion': titulo.descripcion,
        'fotos': [], //TODO: implementar fotos
      };
    } else if (bloque is PreguntaDeSeleccion) {
      final res = _serializarPregunta(bloque);
      res['etiquetas'] = _serializarEtiquetasDePregunta(bloque.etiquetas);
      res['fotos_guia'] = []; //TODO: implementar fotos
      res['opciones_de_respuesta'] =
          _serializarOpcionesDeRespuesta(bloque.opcionesDeRespuesta);
      bloqueJson['pregunta'] = res;
    } else if (bloque is PreguntaNumerica) {
      final pregunta = bloque.pregunta;

      bloqueJson['pregunta'] = {
        'id': pregunta.id,
        'titulo': pregunta.titulo,
        'descripcion': pregunta.descripcion,
        'criticidad': pregunta.criticidad,
        'tipo_de_pregunta': _serializarEnum(pregunta.tipoDePregunta),
        'criticidades_numericas': _serializarCriticidades(bloque.criticidades),
        'etiquetas': _serializarEtiquetasDePregunta(bloque.etiquetas),
        'fotos_guia': [], //TODO: implementar fotos
      };
    } else if (bloque is CuadriculaConPreguntasYConOpcionesDeRespuesta) {
      final cuadricula = bloque.cuadricula.pregunta;
      final etiquetas = bloque.cuadricula.etiquetas;
      final opcionesDeRespuesta = bloque.cuadricula.opcionesDeRespuesta;
      final preguntas = bloque.preguntas;
      bloqueJson['pregunta'] = {
        'id': cuadricula.id,
        'titulo': cuadricula.titulo,
        'descripcion': cuadricula.descripcion,
        'criticidad': cuadricula.criticidad,
        'etiquetas': _serializarEtiquetasDePregunta(etiquetas),
        'fotos_guia': [
          "8876414b-e018-4d40-bb86-9e31b96da560"
        ], //_serializarFotos(cuadricula.fotosGuia),
        'tipo_de_pregunta': _serializarEnum(cuadricula.tipoDePregunta),
        'tipo_de_cuadricula': _serializarEnum(cuadricula.tipoDeCuadricula),
        'opciones_de_respuesta':
            _serializarOpcionesDeRespuesta(opcionesDeRespuesta),
        'preguntas': preguntas.map(_serializarPregunta).toList(),
      };
    } else {
      throw TaggedUnionError(bloque);
    }
    return bloqueJson;
  }

  JsonMap _serializarPregunta(PreguntaDeSeleccion preguntaCR) {
    final pregunta = preguntaCR.pregunta;
    return {
      'id': pregunta.id,
      'titulo': pregunta.titulo,
      'descripcion': pregunta.descripcion,
      'criticidad': pregunta.criticidad,
      'tipo_de_pregunta': _serializarEnum(pregunta.tipoDePregunta),
    };
  }

  JsonList _serializarCriticidades(List<CriticidadNumerica> criticidades) =>
      criticidades
          .map((criticidad) => {
                'id': criticidad.id,
                'criticidad': criticidad.criticidad,
                'valor_minimo': criticidad.valorMinimo,
                'valor_maximo': criticidad.valorMaximo,
              })
          .toList();

  JsonList _serializarOpcionesDeRespuesta(
          List<OpcionDeRespuesta> opcionesDeRespuesta) =>
      opcionesDeRespuesta
          .map((opcion) => {
                'id': opcion.id,
                'titulo': opcion.titulo,
                'descripcion': opcion.descripcion,
                'criticidad': opcion.criticidad
              })
          .toList();

  String _serializarEnum(dynamic e) =>
      EnumToString.convertToString(e, camelCase: true)
          .toLowerCase()
          .replaceAll(" ", "_");

  JsonList _serializarEtiquetasDeCuestionario(
          List<EtiquetaDeActivo> etiquetas) =>
      etiquetas
          .map((e) => <String, dynamic>{
                'clave': e.clave,
                'valor': e.valor,
              })
          .toList();

  /// ._.
  JsonList _serializarEtiquetasDePregunta(List<EtiquetaDePregunta> etiquetas) =>
      etiquetas
          .map((e) => <String, dynamic>{
                'clave': e.clave,
                'valor': e.valor,
              })
          .toList();

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
