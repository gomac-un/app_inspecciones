import 'dart:async';

import 'package:collection/collection.dart';
import 'package:cross_file/cross_file.dart';
import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart' hide DataClass;
import 'package:enum_to_string/enum_to_string.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/core/entities/app_image.dart';
import 'package:inspecciones/core/error/errors.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/features/creacion_cuestionarios/tablas_unidas.dart';
import 'package:path/path.dart' as path;

import '../core/typedefs.dart';
import '../datasources/cuestionarios_remote_datasource.dart';
import '../datasources/providers.dart';
import '../drift_database.dart';
import '../utils/transformador_excepciones_api.dart';

class CuestionariosRepository {
  final Reader _read;
  CuestionariosRemoteDataSource get _api =>
      _read(cuestionariosRemoteDataSourceProvider);
  Database get _db => _read(driftDatabaseProvider);

  CuestionariosRepository(this._read);

  Future<Either<ApiFailure, List<Cuestionario>>>
      getListaDeCuestionariosServer() => apiExceptionToApiFailure(
            () => _api.getCuestionarios().then((l) => l
                .map((c) => Cuestionario(
                      id: c["id"],
                      tipoDeInspeccion: c["tipo_de_inspeccion"],
                      version: c["version"],
                      periodicidadDias: c["periodicidad_dias"],
                      estado: EnumToString.fromString(
                          EstadoDeCuestionario.values, c["estado"])!,
                      subido: true,
                    ))
                .toList()),
          );

  Future<Either<ApiFailure, Unit>> descargarCuestionario(
      {required String cuestionarioId}) async {
    //TODO: implementar de manera funcional
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
      estado:
          EnumToString.fromString(EstadoDeCuestionario.values, json['estado'])!,
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

  PreguntaDeSeleccionCompanion _deserializarPreguntaConOpcionesDeRespuesta(
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
        id: Value(pregunta['id']),
        titulo: pregunta['titulo'],
        descripcion: pregunta['descripcion'],
        criticidad: pregunta['criticidad'],
        fotosGuia: _deserializarFotos(pregunta['fotos_guia_urls']),
        tipoDePregunta: tipoDePregunta,
        tipoDeCuadricula: Value(tipoDeCuadricula),
        unidades: Value(pregunta['unidades']),
      );

  List<OpcionesDeRespuestaCompanion> _deserializarOpcionesDeRespuesta(
          JsonList opciones) =>
      opciones
          .map((o) => OpcionesDeRespuestaCompanion.insert(
                id: Value(o["id"]),
                titulo: o["titulo"],
                descripcion: o["descripcion"],
                criticidad: o["criticidad"],
                requiereCriticidadDelInspector:
                    o["requiere_criticidad_del_inspector"],
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
      fotos.map((f) => AppImage.remote(id: f["id"], url: f["foto"])).toList();

  /// Envia [cuestionario] al server.
  Future<Either<ApiFailure, Unit>> subirCuestionario(
      String cuestionarioId) async {
    final cuestionario = await getCuestionarioCompleto(cuestionarioId);
    final idFotosSubidas = await _subirFotos(cuestionario);
    final serializador = CuestionarioSerializer(cuestionario, idFotosSubidas);
    final cuestionarioSerializado = serializador.serializarCuestionario();
    if (cuestionario.cuestionario.subido) {
      return apiExceptionToApiFailure(
        () => _api
            .actualizarCuestionario(
                cuestionario.cuestionario.id, cuestionarioSerializado)
            .then((_) => unit),
      );
    } else {
      return apiExceptionToApiFailure(
        () => _api
            .subirCuestionario(cuestionarioSerializado)
            .then((_) =>
                _db.sincronizacionDao.marcarCuestionarioSubido(cuestionarioId))
            .then((_) => unit),
      );
    }
  }

  Future<Map<AppImage, String>> _subirFotos(
      CuestionarioCompleto cuestionarioCompleto) async {
    final fotos = <AppImage>[];
    for (final bloque in cuestionarioCompleto.bloques) {
      if (bloque is TituloD) {
        fotos.addAll(bloque.titulo.fotos);
      } else if (bloque is PreguntaDeSeleccion) {
        fotos.addAll(bloque.pregunta.fotosGuia);
      } else if (bloque is PreguntaNumerica) {
        fotos.addAll(bloque.pregunta.fotosGuia);
      } else if (bloque is CuadriculaConPreguntasYConOpcionesDeRespuesta) {
        fotos.addAll(bloque.cuadricula.pregunta.fotosGuia);
        for (final pregunta in bloque.preguntas) {
          fotos.addAll(pregunta.pregunta.fotosGuia);
        }
      } else {
        throw TaggedUnionError(bloque);
      }
    }

    final fotosPorSubir = fotos.where((f) => f is! RemoteImage).toList();

    final JsonMap resServer = fotosPorSubir.isEmpty
        ? {}
        : await _api.subirFotosCuestionario(fotosPorSubir); // nombre: id
    final res = <AppImage, String>{};
    for (final foto in fotos) {
      getIdFromServer() {
        final id = resServer[_getName(foto)];
        if (id == null) {
          throw Exception("no se encontro el id de la foto");
        }
        res[foto] = id;
      }

      foto.when(
        remote: (id, url) {
          res[foto] = id;
        },
        mobile: (_) => getIdFromServer(),
        web: (_) => getIdFromServer(),
      );
    }
    return res;
  }

  String _getName(AppImage foto) {
    var res = path.basename(_getFile(foto).path);
    //MACHETAZO MONUMENTAL para que funcione en web
    if (!res.contains(".")) res = "$res.jpg";
    return res;
  }

  XFile _getFile(AppImage foto) => foto.when(
      remote: (_, __) => throw Error(), //Esto no pasa
      mobile: (p) => XFile(p),
      web: (p) => XFile(p));

  Stream<List<Cuestionario>> getCuestionariosLocales() =>
      _db.cargaDeCuestionarioDao.watchCuestionarios();

  Future<void> eliminarCuestionario(Cuestionario cuestionario) =>
      _db.cargaDeCuestionarioDao.eliminarCuestionario(cuestionario);

  Future<void> duplicarCuestionario(Cuestionario cuestionario) async {
    final cuestionarioCompleto = await getCuestionarioCompleto(cuestionario.id);
    final cuestionarioCompletoCompanion =
        _db.cargaDeCuestionarioDao.duplicarCuestionario(cuestionarioCompleto);
    await guardarCuestionario(cuestionarioCompletoCompanion);
  }

  Future<CuestionarioCompleto> getCuestionarioCompleto(String cuestionarioId) =>
      _db.cargaDeCuestionarioDao.getCuestionarioCompleto(cuestionarioId);

  Future<List<String>> getTiposDeInspecciones() =>
      _db.cargaDeCuestionarioDao.getTiposDeInspecciones();

  Future<List<EtiquetaDeActivo>> getEtiquetas() =>
      _db.cargaDeCuestionarioDao.getEtiquetas();

  Future<void> guardarCuestionario(
          CuestionarioCompletoCompanion cuestionario) =>
      _db.guardadoDeCuestionarioDao.guardarCuestionario(cuestionario);

  Future<void> insertarDatosDePrueba() async {
    //TODO: insertar datos de prueba
  }
}

class CuestionarioSerializer {
  final CuestionarioCompleto cuestionarioCompleto;
  final Map<AppImage, String> idFotosSubidas;

  CuestionarioSerializer(this.cuestionarioCompleto, this.idFotosSubidas);

  JsonMap serializarCuestionario() {
    final JsonMap res = {};
    final cuestionario = cuestionarioCompleto.cuestionario;
    res['id'] = cuestionario.id;
    res['tipo_de_inspeccion'] = cuestionario.tipoDeInspeccion;
    res['version'] = cuestionario.version;
    res['estado'] = EnumToString.convertToString(cuestionario.estado);
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
        'fotos': _serializarFotos(titulo.fotos),
      };
    } else if (bloque is PreguntaDeSeleccion) {
      final res = _serializarPregunta(bloque);
      res['etiquetas'] = _serializarEtiquetasDePregunta(bloque.etiquetas);
      res['fotos_guia'] = _serializarFotos(bloque.pregunta.fotosGuia);
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
        'fotos_guia': _serializarFotos(pregunta.fotosGuia),
        'unidades': pregunta.unidades!,
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
        'fotos_guia': _serializarFotos(cuadricula.fotosGuia),
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

  JsonList _serializarFotos(List<AppImage> fotos) =>
      fotos.map((a) => idFotosSubidas[a]).toList();

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
                'criticidad': opcion.criticidad,
                'requiere_criticidad_del_inspector':
                    opcion.requiereCriticidadDelInspector,
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
}
