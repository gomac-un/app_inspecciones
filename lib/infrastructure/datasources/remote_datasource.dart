import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:inspecciones/application/auth/usuario.dart';
import 'package:inspecciones/core/error/exceptions.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/infrastructure/repositories/api_model.dart';

abstract class InspeccionesRemoteDataSource {
  Future<String> getToken(UserLogin userLogin);
  Future<List<Sistema>> getSistemas(/* Usuario usuario */);
  Future<List<Contratista>> getContratistas();
  Future<List<Activo>> getActivos();
  Future<List<SubSistema>> getSubSistemas();
  Future<List<CuestionarioDeModelo>> getCuestionarioDeModelo();
  Future<List<Cuestionario>> getCuestionarios();
  Future<List<Inspeccion>> getInspecciones();
  Future<List<Bloque>> getBloques();
  Future<List<Pregunta>> getPreguntas();
  Future<List<OpcionDeRespuesta>> getOpcionesDeRespuesta();
  Future<List<Respuesta>> getRespuestas();
  Future<List<RespuestasXOpcionesDeRespuestaData>> getRespuestaXOpcionesDeRespuesta();
  //syncDatabase
}

@LazySingleton(as: InspeccionesRemoteDataSource)
class DjangoAPI implements InspeccionesRemoteDataSource {
  static const _server =
      'http://10.0.2.2:8000'; //TODO: opcion para modificar el servidor desde la app
  static const _apiBase = '/inspecciones/api/v1';
  static const _tokenEndpoint = "/api-token-auth/";
  static const _sistema = '/sistemas/';
  static const _contratista = '/contratistas/';
  static const _activo = '/activos/';
  static const _subSistema = '/subsistemas/';
  static const _cuestionariodeModelo = '/cuestionariodemodelo/';
  static const _cuestionario = '/cuestionarios/';

  // TODO implementar esto en datos de prueba
  static const _bloque = '/bloques/';
  static const _titulo = '/titulos/';
  static const _pregunta = '/preguntas/';
  static const _cuadriculaDePregunta = '/cuadriculadepreguntas/';
  static const _opcionesDeRespuesta = '/opcionesderespuesta/';
  static const _inspeccion = '/inspecciones/';
  static const _respuesta = '/respuestas/';
  static const _respuestaPorOpcionesDeRespuesta = '/respuestaporopciones/';

  DjangoAPI();

  @override
  Future<String> getToken(UserLogin userLogin) async {
    const _tokenURL = _server + _apiBase + _tokenEndpoint;
    final http.Response response = await http
        .post(
          _tokenURL,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(userLogin.toJson()),
        )
        .timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      return (json.decode(response.body) as Map<String, dynamic>)['token']
          as String;
    } else {
      //TODO: mirar los tipos de errores que pueden venir de la api
      throw ServerException(response.body);
    }
  }

  @override
  Future<List<Sistema>> getSistemas(/* Usuario usuario */) async {
    /* usuario = Usuario(token: "sutoken"); */
    const _sistemaURL = _server + _apiBase + _sistema;
    final response = await http.get(
      _sistemaURL,
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader:
            'Token 03adf27071d9d48804879e414fe1d5caf6dcbf2b' /* "Token ${usuario.token}" */
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse =
          json.decode(response.body) as List<dynamic>;
      return jsonResponse
          .where((e) => e != null)
          .map((job) => Sistema.fromJson(job as Map<String, dynamic>))
          .toList();
    } else {
      throw ServerException(json.decode(response.body).toString());
    }
  }

  @override
  Future<List<Contratista>> getContratistas() async {
    const _contratistaURL = _server + _apiBase + _contratista;
    final response = await http.get(
      _contratistaURL,
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader:
            'Token 03adf27071d9d48804879e414fe1d5caf6dcbf2b' /* "Token ${usuario.token}" */
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse =
          json.decode(response.body) as List<dynamic>;
      return jsonResponse
          .where((e) => e != null)
          .map((job) => Contratista.fromJson(job as Map<String, dynamic>))
          .toList();
    } else {
      throw ServerException(json.decode(response.body).toString());
    }
  }

  @override
  Future<List<Activo>> getActivos() async {
    const _activoURL = _server + _apiBase + _activo;
    final response = await http.get(
      _activoURL,
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader:
            'Token 03adf27071d9d48804879e414fe1d5caf6dcbf2b' /* "Token ${usuario.token}" */
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse =
          json.decode(response.body) as List<dynamic>;
      return jsonResponse
          .where((e) => e != null)
          .map((job) => Activo.fromJson(job as Map<String, dynamic>))
          .toList();
    } else {
      throw ServerException(json.decode(response.body).toString());
    }
  }

  @override
  Future<List<SubSistema>> getSubSistemas() async {
    const _subSistemaURL = _server + _apiBase + _subSistema;
    final response = await http.get(
      _subSistemaURL,
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader:
            'Token 03adf27071d9d48804879e414fe1d5caf6dcbf2b' /* "Token ${usuario.token}" */
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse =
          json.decode(response.body) as List<dynamic>;
      return jsonResponse
          .where((e) => e != null)
          .map((job) => SubSistema.fromJson(job as Map<String, dynamic>))
          .toList();
    } else {
      throw ServerException(json.decode(response.body).toString());
    }
  }

  @override
  Future<List<CuestionarioDeModelo>> getCuestionarioDeModelo() async {
    const _cuestionariodeModeloURL = _server + _apiBase + _cuestionariodeModelo;
    final response = await http.get(
      _cuestionariodeModeloURL,
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader:
            'Token 03adf27071d9d48804879e414fe1d5caf6dcbf2b' /* "Token ${usuario.token}" */
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse =
          json.decode(response.body) as List<dynamic>;
      return jsonResponse
          .where((e) => e != null)
          .map((job) =>
              CuestionarioDeModelo.fromJson(job as Map<String, dynamic>))
          .toList();
    } else {
      throw ServerException(json.decode(response.body).toString());
    }
  }

  @override
  Future<List<Cuestionario>> getCuestionarios() async {
    const _cuestionarioURL = _server + _apiBase + _cuestionario;
    final response = await http.get(
      _cuestionarioURL,
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader:
            'Token 03adf27071d9d48804879e414fe1d5caf6dcbf2b' /* "Token ${usuario.token}" */
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse =
          json.decode(response.body) as List<dynamic>;
      return jsonResponse
          .where((e) => e != null)
          .map((job) => Cuestionario.fromJson(job as Map<String, dynamic>))
          .toList();
    } else {
      throw ServerException(json.decode(response.body).toString());
    }
  }

  @override
  Future<List<Inspeccion>> getInspecciones() async {
    const _inspeccionURL = _server + _apiBase + _inspeccion;
    final response = await http.get(
      _inspeccionURL,
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader:
            'Token 03adf27071d9d48804879e414fe1d5caf6dcbf2b' /* "Token ${usuario.token}" */
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse =
          json.decode(response.body) as List<dynamic>;
      return jsonResponse
          .where((e) => e != null)
          .map((job) => Inspeccion.fromJson(job as Map<String, dynamic>))
          .toList();
    } else {
      throw ServerException(json.decode(response.body).toString());
    }
  }

  @override
  Future<List<Bloque>> getBloques() async {
    const _bloqueURL = _server + _apiBase + _bloque;
    final response = await http.get(
      _bloqueURL,
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader:
            'Token 03adf27071d9d48804879e414fe1d5caf6dcbf2b' /* "Token ${usuario.token}" */
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse =
          json.decode(response.body) as List<dynamic>;
      return jsonResponse
          .where((e) => e != null)
          .map((job) => Bloque.fromJson(job as Map<String, dynamic>))
          .toList();
    } else {
      throw ServerException(json.decode(response.body).toString());
    }
  }

  @override
  Future<List<Pregunta>> getPreguntas() async {
    const _preguntaURL = _server + _apiBase + _pregunta;
    final response = await http.get(
      _preguntaURL,
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader:
            'Token 03adf27071d9d48804879e414fe1d5caf6dcbf2b' /* "Token ${usuario.token}" */
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse =
          json.decode(response.body) as List<dynamic>;
      return jsonResponse
          .where((e) => e != null)
          .map((job) => Pregunta.fromJson(job as Map<String, dynamic>))
          .toList();
    } else {
      throw ServerException(json.decode(response.body).toString());
    }
  }

  @override
  Future<List<OpcionDeRespuesta>> getOpcionesDeRespuesta() async {
    const _opcionesURL = _server + _apiBase + _opcionesDeRespuesta;
    final response = await http.get(
      _opcionesURL,
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader:
            'Token 03adf27071d9d48804879e414fe1d5caf6dcbf2b' /* "Token ${usuario.token}" */
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse =
          json.decode(response.body) as List<dynamic>;
      return jsonResponse
          .where((e) => e != null)
          .map((job) => OpcionDeRespuesta.fromJson(job as Map<String, dynamic>))
          .toList();
    } else {
      throw ServerException(json.decode(response.body).toString());
    }
  }

  @override
  Future<List<Respuesta>> getRespuestas() async {
    const _respuestasURL = _server + _apiBase + _respuesta;
    final response = await http.get(
      _respuestasURL,
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader:
            'Token 03adf27071d9d48804879e414fe1d5caf6dcbf2b' /* "Token ${usuario.token}" */
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse =
          json.decode(response.body) as List<dynamic>;
      return jsonResponse
          .where((e) => e != null)
          .map((job) => Respuesta.fromJson(job as Map<String, dynamic>))
          .toList();
    } else {
      throw ServerException(json.decode(response.body).toString());
    }
  }

  @override
  Future<List<RespuestasXOpcionesDeRespuestaData>> getRespuestaXOpcionesDeRespuesta() async {
    const _respuestasXOpcionesDeRespuestaURL = _server + _apiBase + _respuestaPorOpcionesDeRespuesta;
    final response = await http.get(
      _respuestasXOpcionesDeRespuestaURL,
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader:
            'Token 03adf27071d9d48804879e414fe1d5caf6dcbf2b' /* "Token ${usuario.token}" */
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse =
          json.decode(response.body) as List<dynamic>;
      return jsonResponse
          .where((e) => e != null)
          .map((job) => RespuestasXOpcionesDeRespuestaData.fromJson(job as Map<String, dynamic>))
          .toList();
    } else {
      throw ServerException(json.decode(response.body).toString());
    }
  }
}
