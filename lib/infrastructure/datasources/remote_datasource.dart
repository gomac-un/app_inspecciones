import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:inspecciones/infrastructure/repositories/api_model.dart';

import 'package:inspecciones/core/error/exceptions.dart';

abstract class InspeccionesRemoteDataSource {
  Future<String> getToken(UserLogin userLogin);
  //syncDatabase
}

@LazySingleton(as: InspeccionesRemoteDataSource)
class DjangoAPI implements InspeccionesRemoteDataSource {
  static const _server =
      'http://10.0.2.2:8000'; //TODO: opcion para modificar el servidor desde la app
  static const _apiBase = '/inspecciones/api/v1';
  static const _tokenEndpoint = "/api-token-auth/";

  DjangoAPI();

  @override
  Future<String> getToken(UserLogin userLogin) async {
    const _tokenURL = _server + _apiBase + _tokenEndpoint;
    final http.Response response = await http.post(
      _tokenURL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userLogin.toDatabaseJson()),
    );
    if (response.statusCode == 200) {
      return (json.decode(response.body) as Map<String, dynamic>)['token']
          as String;
    } else {
      //TODO: mirar los tipos de errores que pueden ocurrir
      throw ServerException();
    }
  }
}
