import 'dart:async';

import 'package:cross_file/cross_file.dart';
import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/core/entities/app_image.dart';
import 'package:inspecciones/core/error/errors.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/domain.dart';
import 'package:path/path.dart' as path;

import '../core/typedefs.dart';
import '../datasources/inspecciones_remote_datasource.dart';
import '../datasources/providers.dart';
import '../drift_database.dart' as drift;
import '../utils/transformador_excepciones_api.dart';

class InspeccionesRemoteRepository {
  final Reader _read;
  InspeccionesRemoteDataSource get _api =>
      _read(inspeccionesRemoteDataSourceProvider);
  drift.Database get _db => _read(drift.driftDatabaseProvider);

  InspeccionesRemoteRepository(this._read);

  /// Descarga desde el servidor una inspección identificadada con [id] para
  ///  poder continuarla en la app.
  /// retorna Right(unit) si se decargó exitosamente, de ser así, posteriormente
  /// se puede iniciar la inspeccion desde la pantalla de borradores
  Future<Either<ApiFailure, IdentificadorDeInspeccion>> descargarInspeccion(
          String id) =>
      apiExceptionToApiFailure(
        () => _api.descargarInspeccion(id).then((json) async {
          final deserializador = DeserializadorInspeccion(
            json,
            _read,
          );
          final identificadorInspeccion =
              await deserializador._deserializarInspeccionCompleta();
          return identificadorInspeccion;
        }),
      );

  /// Envia [inspeccion] al server
  Future<Either<ApiFailure, Unit>> subirInspeccion(
      IdentificadorDeInspeccion id) async {
    //TODO: mostrar el progreso en la ui
    final inspeccionCompleta = await _db.cargaDeInspeccionDao.cargarInspeccion(
      cuestionarioId: id.cuestionarioId,
      activoId: id.activo,
    );

    final idFotosSubidas = await _subirFotos(
        inspeccionCompleta.bloques.whereType<Pregunta>().toList());
    final serializador =
        InspeccionSerializer(inspeccionCompleta, idFotosSubidas);
    final inspeccionSerializada = serializador.serializarInspeccion();
    if (inspeccionCompleta.inspeccion.esNueva) {
      return apiExceptionToApiFailure(
        () => _api
            .subirInspeccion(inspeccionSerializada)
            .then((_) => _db.sincronizacionDao.marcarInspeccionSubida(id))
            .then((_) => unit),
      );
    } else {
      return apiExceptionToApiFailure(
        () => _api
            .actualizarInspeccion(
                inspeccionCompleta.inspeccion.id!, inspeccionSerializada)
            .then((_) => _db.sincronizacionDao.marcarInspeccionSubida(id))
            .then((_) => unit),
      );
    }
  }

  Future<Map<AppImage, String>> _subirFotos(List<Pregunta> preguntas) async {
    final fotos = <AppImage>[];
    // TODO: usar visitor para hacer este recorrido
    for (final pregunta in preguntas) {
      fotos.addAll(pregunta.respuesta?.metaRespuesta.fotosBase ?? []);
      fotos.addAll(pregunta.respuesta?.metaRespuesta.fotosReparacion ?? []);

      if (pregunta is CuadriculaDeSeleccionUnica) {
        for (final subpregunta in pregunta.preguntas) {
          fotos.addAll(subpregunta.respuesta?.metaRespuesta.fotosBase ?? []);
          fotos.addAll(
              subpregunta.respuesta?.metaRespuesta.fotosReparacion ?? []);
        }
      } else if (pregunta is CuadriculaDeSeleccionMultiple) {
        for (final subPregunta in pregunta.preguntas) {
          fotos.addAll(subPregunta.respuesta?.metaRespuesta.fotosBase ?? []);
          fotos.addAll(
              subPregunta.respuesta?.metaRespuesta.fotosReparacion ?? []);
          for (final opcionDeRespuesta in subPregunta.respuestas) {
            fotos.addAll(
                opcionDeRespuesta.respuesta?.metaRespuesta.fotosBase ?? []);
            fotos.addAll(
                opcionDeRespuesta.respuesta?.metaRespuesta.fotosReparacion ??
                    []);
          }
        }
      } else if (pregunta is PreguntaDeSeleccionMultiple) {
        for (final opcionDeRespuesta in pregunta.respuestas) {
          fotos.addAll(
              opcionDeRespuesta.respuesta?.metaRespuesta.fotosBase ?? []);
          fotos.addAll(
              opcionDeRespuesta.respuesta?.metaRespuesta.fotosReparacion ?? []);
        }
      } else if (pregunta is PreguntaDeSeleccionUnica ||
          pregunta is PreguntaNumerica) {
        // no tienen subpreguntas
      } else {
        throw TaggedUnionError(pregunta);
      }
    }

    final fotosPorSubir = fotos.where((f) => f is! RemoteImage).toList();

    final JsonMap resServer = fotosPorSubir.isEmpty
        ? {}
        : await _api.subirFotosInspeccion(fotosPorSubir); // nombre: id
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
    //MACHETAZO MONUMENTAL
    if (!res.contains(".")) res = "$res.jpg";
    return res;
  }

  XFile _getFile(AppImage foto) => foto.when(
      remote: (_, __) => throw Error(),
      mobile: (f) => XFile(f),
      web: (f) => XFile(f));
}

class DeserializadorInspeccion {
  final JsonMap json;
  final Reader _read;
  drift.Database get _db => _read(drift.driftDatabaseProvider);

  DeserializadorInspeccion(this.json, this._read);
  Future<IdentificadorDeInspeccion> _deserializarInspeccionCompleta() async {
    final inspeccion = _deserializarInspeccion();
    final List<drift.RespuestasCompanion> preguntas =
        _deserializarRespuestas(json['respuestas'], false);
    await _db.guardadoDeInspeccionDao.guardarInspeccionRemota(
      inspeccion,
      preguntas,
    );
    return IdentificadorDeInspeccion(
        activo: json['activo'], cuestionarioId: json['cuestionario']);
  }

  drift.InspeccionesCompanion _deserializarInspeccion() {
    final estado =
        EnumToString.fromString(EstadoDeInspeccion.values, json['estado']) ??
            EstadoDeInspeccion.borrador;
    final inspeccion = drift.InspeccionesCompanion(
      id: Value(json['id']),
      estado: Value(estado),
      momentoBorradorGuardado: Value(DateTime.now()),
      momentoFinalizacion: json['momento_finalizacion'] == null
          ? const Value.absent()
          : Value(DateTime.tryParse(json['momento_finalizacion'])),
      momentoEnvio: const Value.absent(),
      momentoInicio: Value(DateTime.parse(json['momento_inicio'])),
      avance: Value(json['avance']),
      criticidadCalculada: Value(json['criticidad_calculada']),
      criticidadCalculadaConReparaciones:
          Value(json['criticidad_calculada_con_reparaciones']),
      activoId: Value(json['activo']),
      cuestionarioId: Value(json['cuestionario']),
      esNueva: const Value(false),
    );
    return inspeccion;
  }

  List<drift.RespuestasCompanion> _deserializarRespuestas(
      JsonList jsonRespuestas, bool isSubRespuesta) {
    final subRespuestas = <drift.RespuestasCompanion>[];
    final respuestas =
        jsonRespuestas.map<drift.RespuestasCompanion>((respuesta) {
      final tipo = respuesta['tipo_de_respuesta'];
      switch (tipo) {
        case "seleccion_unica":
          return _deserializarRespuesta(
              respuesta, drift.TipoDeRespuesta.seleccionUnica, isSubRespuesta);
        case "numerica":
          return _deserializarRespuesta(
              respuesta, drift.TipoDeRespuesta.numerica, isSubRespuesta);
        case "seleccion_multiple":
          subRespuestas.addAll(_deserializarSubRespuestasMultiple(
              respuesta['subrespuestas_multiple'],
              drift.TipoDeRespuesta.parteDeSeleccionMultiple));
          return _deserializarRespuesta(respuesta,
              drift.TipoDeRespuesta.seleccionMultiple, isSubRespuesta);
        case "cuadricula":
          subRespuestas.addAll(_deserializarRespuestas(
              respuesta['subrespuestas_cuadricula'], true));
          return _deserializarRespuesta(
              respuesta, drift.TipoDeRespuesta.cuadricula, false);
        default:
          throw Exception("tipo de respuesta desconocido: $tipo");
      }
    }).toList();
    print(respuestas);
    respuestas.addAll(subRespuestas);
    /* final tipo =
        EnumToString.fromString(drift.TipoDeRespuesta.values, json['tipo']); */
    return respuestas;
  }

  List<drift.RespuestasCompanion> _deserializarSubRespuestasMultiple(
      JsonList jsonSubRespuestas, drift.TipoDeRespuesta tipoDeSubRespuesta) {
    return jsonSubRespuestas
        .map<drift.RespuestasCompanion>((subRespuesta) =>
            _deserializarRespuesta(subRespuesta, tipoDeSubRespuesta, true))
        .toList();
  }

  drift.RespuestasCompanion _deserializarRespuesta(JsonMap jsonRespuesta,
      drift.TipoDeRespuesta tipoDeRespuesta, bool isSub) {
    return drift.RespuestasCompanion(
      id: Value(jsonRespuesta['id']),
      observacion: Value(jsonRespuesta['observacion']),
      reparado: Value(jsonRespuesta['reparado']),
      observacionReparacion: Value(jsonRespuesta['observacion_reparacion']),
      momentoRespuesta: jsonRespuesta['momento_respuesta'] == null
          ? const Value.absent()
          : Value(DateTime.parse(jsonRespuesta['momento_respuesta'])),
      fotosBase: Value(
        _deserializarFotos(jsonRespuesta['fotos_base_url']),
      ),
      fotosReparacion:
          Value(_deserializarFotos(jsonRespuesta['fotos_reparacion_url'])),
      tipoDeRespuesta: Value(tipoDeRespuesta),
      criticidadDelInspector: Value(jsonRespuesta['criticidad_del_inspector']),
      criticidadCalculada: Value(jsonRespuesta['criticidad_calculada']),
      criticidadCalculadaConReparaciones:
          Value(jsonRespuesta['criticidad_calculada_con_reparaciones']),
      preguntaId: Value(jsonRespuesta['pregunta']),
      respuestaCuadriculaId: Value(jsonRespuesta['respuesta_cuadricula']),
      respuestaMultipleId: Value(jsonRespuesta['respuesta_multiple']),
      inspeccionId: Value(json['id']),
      opcionSeleccionadaId: Value(jsonRespuesta['opcion_seleccionada']),
      opcionRespondidaId: Value(jsonRespuesta['opcion_respondida']),
      opcionRespondidaEstaSeleccionada:
          Value(jsonRespuesta['opcion_respondida_esta_seleccionada']),
      valorNumerico: Value(jsonRespuesta['valor_numerico']),
    );
  }

  List<AppImage> _deserializarFotos(JsonList fotos) =>
      fotos.map((f) => AppImage.remote(id: f["id"], url: f["foto"])).toList();
}

class InspeccionSerializer {
  final CuestionarioInspeccionado inspeccionCompleta;
  late final Inspeccion inspeccion = inspeccionCompleta.inspeccion;
  late final List<Pregunta> preguntas =
      inspeccionCompleta.bloques.whereType<Pregunta>().toList();
  late final Cuestionario cuestionario = inspeccionCompleta.cuestionario;
  final Map<AppImage, String> idFotosSubidas;

  InspeccionSerializer(this.inspeccionCompleta, this.idFotosSubidas);

  JsonMap serializarInspeccion() => {
        'id': inspeccion.id,
        'cuestionario': cuestionario.id,
        'activo': inspeccion.activo.pk,
        'momento_inicio': inspeccion.momentoInicio.toString(),
        'momento_finalizacion': inspeccion.momentoFinalizacion?.toString(),
        'estado': _serializarEnum(inspeccion.estado),
        'criticidad_calculada': inspeccion.criticidadCalculada,
        'criticidad_calculada_con_reparaciones':
            inspeccion.criticidadCalculadaConReparaciones,
        'avance': inspeccion.avance,
        'respuestas': preguntas.map(_serializarPregunta).toList(),
      };

  JsonMap _serializarPregunta(Pregunta pregunta) {
    final respuesta = pregunta.respuesta;
    final metaRespuesta = respuesta!.metaRespuesta;
    final res = _serializarMetaRespuesta(metaRespuesta);
    res['pregunta'] = pregunta.id;
//TODO: preguntas de selección unica no permiten enviar si no está respondida
    if (pregunta is PreguntaDeSeleccionUnica) {
      res.addAll(_serializarRespuestaDeSeleccionUnica(pregunta.respuesta!));
    } else if (pregunta is PreguntaNumerica) {
      final respuesta = pregunta.respuesta!;
      res['tipo_de_respuesta'] = "numerica";
      res['valor_numerico'] = respuesta.respuestaNumerica;
    } else if (pregunta is PreguntaDeSeleccionMultiple) {
      res.addAll(_serializarRespuestaDeSeleccionMultiple(pregunta.respuestas));
    } else if (pregunta is SubPreguntaDeSeleccionMultiple) {
      final respuesta = pregunta.respuesta!;
      res['pregunta'] = null;
      res['tipo_de_respuesta'] = 'parte_de_seleccion_multiple';
      res['opcion_respondida'] = pregunta.opcion.id;
      res['opcion_respondida_esta_seleccionada'] = respuesta.estaSeleccionada;
    } else if (pregunta is CuadriculaDeSeleccionUnica) {
      final respuesta = pregunta.respuesta!;
      res['tipo_de_respuesta'] = "cuadricula";
      res['subrespuestas_cuadricula'] =
          pregunta.preguntas.map((sub) => _serializarPregunta(sub)).toList();
    } else if (pregunta is CuadriculaDeSeleccionMultiple) {
      final respuesta = pregunta.respuesta!;
      res['tipo_de_respuesta'] = "cuadricula";
      res['subrespuestas_cuadricula'] =
          pregunta.preguntas.map((sub) => _serializarPregunta(sub)).toList();
    } else {
      throw TaggedUnionError(pregunta);
    }
    return res;
  }

  //TODO: revisar
  JsonMap _serializarRespuestaDeSeleccionMultiple(
          List<SubPreguntaDeSeleccionMultiple> respuesta) =>
      {
        'tipo_de_respuesta': 'seleccion_multiple',
        'subrespuestas_multiple':
            respuesta.map((sub) => _serializarPregunta(sub)).toList(),
      };

  JsonMap _serializarRespuestaDeSeleccionUnica(
      RespuestaDeSeleccionUnica respuesta) {
    return {
      'tipo_de_respuesta': 'seleccion_unica',
      'opcion_seleccionada': respuesta.opcionSeleccionada?.id,
    };
  }

  JsonMap _serializarMetaRespuesta(MetaRespuesta metaRespuesta) => {
        'reparado': metaRespuesta.reparada,
        'observacion': metaRespuesta.observaciones,
        'observacion_reparacion': metaRespuesta.observacionesReparacion,
        'momento_respuesta':
            metaRespuesta.momentoRespuesta?.toUtc().toIso8601String(),
        'fotos_base': _serializarFotos(metaRespuesta.fotosBase),
        'fotos_reparacion': _serializarFotos(metaRespuesta.fotosReparacion),
        'criticidad_del_inspector': metaRespuesta.criticidadDelInspector,
        'criticidad_calculada': metaRespuesta.criticidadCalculada,
        'criticidad_calculada_con_reparaciones':
            metaRespuesta.criticidadCalculadaConReparaciones,
      };

  JsonList _serializarFotos(List<AppImage> fotos) =>
      fotos.map((a) => idFotosSubidas[a]).toList();

  String _serializarEnum(dynamic e) =>
      EnumToString.convertToString(e, camelCase: true)
          .toLowerCase()
          .replaceAll(" ", "_");

/*
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
          .toList();*/
}
