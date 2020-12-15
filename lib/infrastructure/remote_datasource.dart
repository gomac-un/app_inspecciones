import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:inspecciones/infrastructure/repositories/api_model.dart';

import 'package:inspecciones/core/error/exceptions.dart';

abstract class InspeccionesRemoteDataSource {
  Future<Token> getToken(UserLogin userLogin);
  //syncDatabase
}

@LazySingleton(as: InspeccionesRemoteDataSource)
class DjangoAPI implements InspeccionesRemoteDataSource {
  static const _server = 'http://127.0.0.1:8000';
  static const _apiBase = '/inspecciones/api/v1';
  static const _tokenEndpoint = "/api-token-auth/";

  DjangoAPI();

  Future<Token> getToken(UserLogin userLogin) async {
    final _tokenURL = _server + _apiBase + _tokenEndpoint;
    final http.Response response = await http.post(
      _tokenURL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userLogin.toDatabaseJson()),
    );
    if (response.statusCode == 200) {
      return Token.fromJson(json.decode(response.body));
    } else {
      print(json.decode(response.body).toString());
      throw ServerException(json.decode(response.body));
    }
  }
}
