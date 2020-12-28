import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:inspecciones/core/error/exceptions.dart';

abstract class InspeccionesRemoteDataSource {
  Future<Map<String, dynamic>> getRecurso(String recursoEndpoint,
      {@required String token});
  Future<Map<String, dynamic>> postRecurso(
      String recursoEndpoint, Map<String, dynamic> data,
      {@required String token});
  Future<Map<String, dynamic>> putRecurso(
      String recursoEndpoint, Map<String, dynamic> data,
      {@required String token});
}

@LazySingleton(as: InspeccionesRemoteDataSource)
class DjangoJsonAPI implements InspeccionesRemoteDataSource {
  static const _server =
      'http://10.0.2.2:8000'; //TODO: opcion para modificar el servidor desde la app
  static const _apiBase = '/inspecciones/api/v1';
  static const _timeLimit = Duration(seconds: 5); //TODO: ajustar el timelimit

  DjangoJsonAPI();

  @override
  Future<Map<String, dynamic>> getRecurso(String recursoEndpoint,
      {@required String token}) async {
    final url = _server + _apiBase + recursoEndpoint;
    final http.Response response = await http.get(
      url,
      headers: {
        if (token != null) HttpHeaders.authorizationHeader: "Token $token"
      },
    ).timeout(_timeLimit);

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 400) {
      //TODO: verificar que el 400 pasa sii las credenciales estan mal
      throw CredencialesException(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      //TODO: mirar los tipos de errores que pueden venir de la api
      throw ServerException(jsonDecode(response.body) as Map<String, dynamic>);
    }
  }

  @override
  Future<Map<String, dynamic>> postRecurso(
      String recursoEndpoint, Map<String, dynamic> data,
      {String token}) async {
    final url = _server + _apiBase + recursoEndpoint;
    final http.Response response = await http
        .post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            if (token != null) HttpHeaders.authorizationHeader: "Token $token"
          },
          body: jsonEncode(data),
        )
        .timeout(_timeLimit);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 400) {
      throw ServerException(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      //TODO: mirar los tipos de errores que pueden venir de la api
      log(response.body);
      throw ServerException(jsonDecode(response.body) as Map<String, dynamic>);
    }
  }

  @override
  Future<Map<String, dynamic>> putRecurso(
      String recursoEndpoint, Map<String, dynamic> data,
      {@required String token}) async {
    final url = _server + _apiBase + recursoEndpoint;
    final http.Response response = await http
        .put(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            if (token != null) HttpHeaders.authorizationHeader: "Token $token"
          },
          body: jsonEncode(data),
        )
        .timeout(_timeLimit);

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 400) {
      throw CredencialesException(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      //TODO: mirar los tipos de errores que pueden venir de la api
      throw ServerException(jsonDecode(response.body) as Map<String, dynamic>);
    }
  }

/*
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
  Future<List<Sistema>> getSistemas(Usuario usuario) async {
    usuario = Usuario(token: "sutoken");
    const _sistemaURL = _server + _apiBase + _sistema;
    final response = await http.get(
      _sistemaURL,
      // Send authorization headers to the backend.
      headers: {HttpHeaders.authorizationHeader: "Token ${usuario.token}"},
    );

    if (response.statusCode == 200) {
      final values = json.decode(response.body) as List<Map<String, dynamic>>;

      final listaSistema = values
          .where((e) => e != null)
          .map((e) => Sistema.fromJson(e))
          .toList();

      return listaSistema;
    } else {
      throw ServerException(json.decode(response.body).toString());
    }
  }

  Future subirInspeccion(Inspeccion inspeccion) async {
    const endpointSubirInspeccion = '/inspecciones/';
    const url = _server + _apiBase + endpointSubirInspeccion;

    final respuestas =
        await _db.llenadoDao.getRespuestasDeInspeccion(inspeccion);
    final body = {'inspeccion': inspeccion, 'respuestas': respuestas};

    final response = await http.put(
      '$url${inspeccion.id}',
      body: json.encode(body),
      // Send authorization headers to the backend.
      //headers: {HttpHeaders.authorizationHeader: "Token ${usuario.token}"},
    );
    print(json.decode(response.body));
/*
    if (response.statusCode == 200) {
      final values = json.decode(response.body) as List<Map<String, dynamic>>;

      final listaSistema = values
          .where((e) => e != null)
          .map((e) => Sistema.fromJson(e))
          .toList();

      return listaSistema;
    } else {
      throw ServerException(json.decode(response.body).toString());
    }*/
  }
*/

}
