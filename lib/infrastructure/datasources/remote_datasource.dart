import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:inspecciones/application/auth/usuario.dart';
import 'package:path/path.dart' as path;
import 'package:injectable/injectable.dart';
import 'package:inspecciones/core/error/exceptions.dart';

abstract class InspeccionesRemoteDataSource {
  Future<Map<String, dynamic>> getToken(Map<String, dynamic> user);
  Future<Map<String, dynamic>> getRecurso(String recursoEndpoint);
  Future<Map<String, dynamic>> postRecurso(
      String recursoEndpoint, Map<String, dynamic> data);
  Future<Map<String, dynamic>> putRecurso(
      String recursoEndpoint, Map<String, dynamic> data);
  Future subirFotos(
      Iterable<File> fotos, String iddocumento, String tipodocumento);
  void descargaFlutterDownloader(
      String recurso, String savedir, String filename);
}

@LazySingleton(as: InspeccionesRemoteDataSource)
class DjangoJsonAPI implements InspeccionesRemoteDataSource {
  static const _server = 'http://pruebainsgomac.duckdns.org:8000';
  //static const _server = 'http://10.0.2.2:8000';
  //TODO: opcion para modificar el servidor desde la app
  static const _apiBase = '/inspecciones/api/v1';
  static const _timeLimit = Duration(seconds: 5); //TODO: ajustar el timelimit
  final Usuario _usuario;
  String get token => _usuario.token;

  DjangoJsonAPI(this._usuario);

  @factoryMethod
  DjangoJsonAPI.anon() : this(null);

  @override
  Future<Map<String, dynamic>> getToken(Map<String, dynamic> user) async {
    final url = _server + _apiBase + '/api-token-auth/';
    print("req: $url\n${jsonEncode(user)}");
    final http.Response response = await http
        .post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(user),
        )
        .timeout(_timeLimit);
    print("res: ${response.statusCode}\n${response.body}");
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
  Future<Map<String, dynamic>> getRecurso(String recursoEndpoint) async {
    final url = _server + _apiBase + recursoEndpoint;
    print("req: $url\ntoken:$token");
    final http.Response response = await http.get(
      url,
      headers: {
        if (token != null) HttpHeaders.authorizationHeader: "Token $token"
      },
    ).timeout(_timeLimit);
    print("res: ${response.statusCode}\n${response.body}");
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
      String recursoEndpoint, Map<String, dynamic> data) async {
    final url = _server + _apiBase + recursoEndpoint;
    print("req: $url\n${jsonEncode(data)}");
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
    print("res: ${response.statusCode}\n${response.body}");
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
  // ignore: missing_return
  Future<Map<String, dynamic>> putRecurso(
      String recursoEndpoint, Map<String, dynamic> data) async {
    final url = _server + _apiBase + recursoEndpoint;
    print(url);
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
  }

  @override
  Future subirFotos(
      Iterable<File> fotos, String idDocumento, String tipoDocumento) async {
    const uriRecurso = '/subir-fotos/';
    final uri = Uri.parse(_server + _apiBase + uriRecurso);
    final request = http.MultipartRequest("POST", uri);

    request.headers[HttpHeaders.authorizationHeader] = "Token $token";

    request.fields['iddocumento'] = idDocumento;
    request.fields['tipodocumento'] = tipoDocumento;

    for (final file in fotos) {
      final fileName = path.basename(file.path);
      //final fileName = file.path.split("/").last;
      //final stream = http.ByteStream(file.openRead());

      final length = await file.length();

      final multipartFileSign = http.MultipartFile(
          'fotos', file.openRead(), length,
          filename: fileName);

      request.files.add(multipartFileSign);
    }
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    log(response.body);
    if (response.statusCode > 299) {
      throw Exception("error del servidor");
    }

    //<input type="file" id="files" name="file_fields" multiple>
  }

  @override
  void descargaFlutterDownloader(
      String recurso, String savedir, String filename) {
    final url = _server + _apiBase + recurso;
    print(url);
    FlutterDownloader.enqueue(
        url: url,
        headers: <String, String>{
          HttpHeaders.authorizationHeader: "Token $token"
        },
        savedDir: savedir,
        fileName: filename,
        showNotification: false);
  }
}
