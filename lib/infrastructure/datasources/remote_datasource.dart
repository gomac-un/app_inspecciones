import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
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
  Future subirFotos(
      Iterable<File> fotos, String iddocumento, String tipodocumento);
  void descargaFlutterDownloader(
      String recurso, String savedir, String filename);
}

@LazySingleton(as: InspeccionesRemoteDataSource)
class DjangoJsonAPI implements InspeccionesRemoteDataSource {
  static const _server =
      'https://inspeccion.herokuapp.com'; //TODO: opcion para modificar el servidor desde la app
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

  @override
  Future subirFotos(
      Iterable<File> fotos, String idDocumento, String tipoDocumento) async {
    const uriRecurso = '/subir-fotos/';
    final uri = Uri.parse(_server + _apiBase + uriRecurso);
    final request = http.MultipartRequest("POST", uri);

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
    request.send();
    //<input type="file" id="files" name="file_fields" multiple>
  }

  @override
  void descargaFlutterDownloader(
      String recurso, String savedir, String filename) {
    FlutterDownloader.enqueue(
        url: _server + _apiBase + recurso,
        savedDir: savedir,
        fileName: filename,
        showNotification: false);
  }
}
