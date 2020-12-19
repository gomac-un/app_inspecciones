import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;


import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/infrastructure/repositories/api_model.dart';

import 'package:inspecciones/core/error/exceptions.dart';
import 'package:inspecciones/infrastructure/tablas_api.dart' as tab_api;
import 'package:moor/moor.dart';

abstract class InspeccionesRemoteDataSource {
  Future<Token> getToken(UserLogin userLogin);
  Future<List<Sistema>> tablaSistema();
  //syncDatabase
}

@LazySingleton(as: InspeccionesRemoteDataSource)
class DjangoAPI implements InspeccionesRemoteDataSource {
  static const _server = 'http://127.0.0.1:8000';
  static const _apiBase = '/inspecciones/api/v1';
  static const _tokenEndpoint = "/api-token-auth/";
  static const _sistema ='/sistemas/';
  List<Sistema> _listaSistema =new List<Sistema>();
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
      print(response.body);
      return Token.fromServerJson(json.decode(response.body));
    } else {
      print(json.decode(response.body).toString());
      throw ServerException(json.decode(response.body));
    }
  }

  Future<List<Sistema>> tablaSistema() async {
    final _sistemaURL =  _server + _apiBase + _sistema; 
    final response = await 
    http.get(
    'http://10.0.2.2:8000/inspecciones/api/v1/sistemas/',
    // Send authorization headers to the backend.
    headers: {HttpHeaders.authorizationHeader: "Token 03adf27071d9d48804879e414fe1d5caf6dcbf2b"}, 
  );

    if (response.statusCode == 200) {
      deleteSistema();
      List<dynamic> values=new List<dynamic>();
      values = json.decode(response.body);
      if(values.length>0){
        for(int i=0;i<values.length;i++){
          if(values[i]!=null){
            Map<String,dynamic> map=values[i];
            _listaSistema.add(Sistema.fromJson(map));
          }
        }
      }
      return _listaSistema;
    } else {
      throw ServerException(json.decode(response.body));
    }
  }

  List<Sistema> getSistema(){
    tablaSistema();
    return _listaSistema;
  }

  void deleteSistema(){
    _listaSistema.clear();
  }

  Function initialize(Database db) {
  return (batch) {
    return _initialize0(batch, db);
  };
}

void _initialize0(Batch batch, Database db) {

  batch.insertAll(db.sistemas, [
    SistemasCompanion.insert(id: Value(1), nombre: "Estructura"),
    SistemasCompanion.insert(id: Value(2), nombre: "Transmisión"),
    SistemasCompanion.insert(id: Value(3), nombre: "Eléctrico"),
    SistemasCompanion.insert(id: Value(4), nombre: "Frenos"),
    SistemasCompanion.insert(id: Value(5), nombre: "Hidráulico"),
    SistemasCompanion.insert(id: Value(6), nombre: "Motor"),
    SistemasCompanion.insert(id: Value(7), nombre: "No aplica"),
  ]);
}




}