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
  Future<List<Sistema>> getSistemas(Usuario usuario);
  //syncDatabase
}

@LazySingleton(as: InspeccionesRemoteDataSource)
class DjangoAPI implements InspeccionesRemoteDataSource {
  static const _server =
      'http://10.0.2.2:8000'; //TODO: opcion para modificar el servidor desde la app
  static const _apiBase = '/inspecciones/api/v1';
  static const _tokenEndpoint = "/api-token-auth/";
  static const _sistema = '/sistemas/';
  final Database _db;

  DjangoAPI(this._db);

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
}
