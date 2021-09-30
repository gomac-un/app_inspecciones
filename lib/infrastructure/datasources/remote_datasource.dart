import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:file/file.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:inspecciones/core/entities/usuario.dart';
import 'package:inspecciones/core/error/exceptions.dart';
import 'package:inspecciones/infrastructure/repositories/fotos_repository.dart';
import 'package:path/path.dart' as path;

//TODO eliminar la duplicacion de código
class AuthRemoteDatasource {
  static const _serverScheme = 'https';
  static const _serverHost = 'gomac.medellin.unal.edu.co';
  static const _apiBase = 'inspecciones/api/v1';
  static const _timeLimit = Duration(seconds: 5);
  String token = "";

  Future<ConnectivityResult> _hayInternet() async =>
      await (Connectivity().checkConnectivity());

  /// Devuelve el token del usuario
  ///
  /// Con las credenciales ingresadas al momento de iniciar sesión, se hace
  /// la petición a la Api para que devuelva el token de autenticación
  /// (https://www.django-rest-framework.org/api-guide/authentication/#tokenauthentication)
  Future<Map<String, dynamic>> getToken(Map<String, dynamic> user) async {
    const tokenEndpoint = 'api-token-auth';
    final uri = Uri(
        scheme: _serverScheme,
        host: _serverHost,
        pathSegments: [_apiBase, tokenEndpoint]);

    final http.Response response = await http
        .post(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(user),
        )
        .timeout(_timeLimit);
    print("res: ${response.statusCode}\n${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 401 ||
        response.statusCode == 403 ||
        response.statusCode == 400) {
      throw CredencialesException(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else if (response.statusCode == 404) {
      throw PageNotFoundException();
    } else {
      //TODO: mirar los tipos de errores que pueden venir de la api. Hasta el momento se han manejado
      //los del lado cliente 401, 403 y 404. Los de tipo servidor se manejan en uno solo
      // que es cuando se lanza el serverError
      log(response.body);
      throw ServerException(jsonDecode(response.body) as Map<String, dynamic>);
    }
  }

  /// Devuelve json que permite saber si [user] es admin, es decir, si puede
  /// o no crear cuestionarios-
  Future<Map<String, dynamic>> getPermisos(
      Map<String, dynamic> user, String tokenUsuario) async {
    final uri = Uri(
        scheme: _serverScheme,
        host: _serverHost,
        pathSegments: [_apiBase, '/groups/']);
    print("req: ${uri.path}\n${jsonEncode(user)}");
    final http.Response response = await http
        .post(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            if (tokenUsuario != null)
              HttpHeaders.authorizationHeader: "Token $tokenUsuario"
          },
          body: jsonEncode(user),
        )
        .timeout(_timeLimit);
    print("res: ${response.statusCode}\n${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw CredencialesException(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else if (response.statusCode == 404) {
      throw PageNotFoundException();
    } else {
      //TODO: mirar los tipos de errores que pueden venir de la api
      log(response.body);
      throw ServerException(jsonDecode(response.body) as Map<String, dynamic>);
    }
  }

  Future<Map<String, dynamic>> postRecurso(
      String recursoEndpoint, Map<String, dynamic> data) async {
    final uri = Uri(
        scheme: _serverScheme,
        host: _serverHost,
        pathSegments: [_apiBase, recursoEndpoint]);
    print("req: ${uri.path}\n${jsonEncode(data)}");
    http.Response response;

    final hayInternet = await _hayInternet();

    if (hayInternet == ConnectivityResult.none) {
      throw InternetException();
    }
    response = await http
        .post(
          uri,
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
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw CredencialesException(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else if (response.statusCode == 404) {
      throw PageNotFoundException();
    } else {
      //TODO: mirar los tipos de errores que pueden venir de la api
      log(response.body);
      throw ServerException(jsonDecode(response.body) as Map<String, dynamic>);
    }
  }
}

///Permite la comunicación de la app con el server (consume Api)
abstract class InspeccionesRemoteDataSource {
  Future<Map<String, dynamic>> getRecurso(String recursoEndpoint);
  Future<Map<String, dynamic>> postRecurso(
      String recursoEndpoint, Map<String, dynamic> data);
  Future<Map<String, dynamic>> putRecurso(
      String recursoEndpoint, Map<String, dynamic> data);

  Future subirFotos(
      Iterable<File> fotos, String iddocumento, Categoria tipodocumento);
  void descargaFlutterDownloader(
      String recurso, String savedir, String filename);
}

class DjangoJsonAPI implements InspeccionesRemoteDataSource {
  /// Ruta base del serer.
  static const _serverScheme = 'https';
  static const _serverHost = 'gomac.medellin.unal.edu.co';
  /* 'https://gomac.medellin.unal.edu.co' ; */
  /* http://pruebainsgomac.duckdns.org:8000' */
  //static const _server = 'http://10.0.2.2:8000';

  static const _apiBase = 'inspecciones/api/v1';

  static const _timeLimit = Duration(seconds: 5); //TODO: ajustar el timelimit
  final UsuarioOnline _usuario;
  String get token => _usuario.token;

  DjangoJsonAPI(this._usuario);

  /// Realiza la petición  get a la api a la [url]
  @override
  Future<Map<String, dynamic>> getRecurso(String recursoEndpoint) async {
    final uri = Uri(
        scheme: _serverScheme,
        host: _serverHost,
        pathSegments: [_apiBase, recursoEndpoint]);
    final hayInternet = await _hayInternet();
    if (hayInternet == ConnectivityResult.none) {
      throw InternetException();
    }
    print("req: ${uri.path}\ntoken:$token");
    final http.Response response = await http.get(
      uri,
      headers: {
        if (token != null) HttpHeaders.authorizationHeader: "Token $token"
      },
    ).timeout(_timeLimit);
    print("res: ${response.statusCode}\n${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw CredencialesException(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else if (response.statusCode == 404) {
      throw PageNotFoundException();
    } else {
      //TODO: mirar los tipos de errores que pueden venir de la api
      log(response.body);
      throw ServerException(jsonDecode(response.body) as Map<String, dynamic>);
    }
  }

  Future<ConnectivityResult> _hayInternet() async =>
      await (Connectivity().checkConnectivity());

  /// Realiza la petición  post a la api a la [url], enviando como body [data]
  @override
  Future<Map<String, dynamic>> postRecurso(
      String recursoEndpoint, Map<String, dynamic> data) async {
    final uri = Uri(
        scheme: _serverScheme,
        host: _serverHost,
        pathSegments: [_apiBase, recursoEndpoint]);
    print("req: ${uri.path}\n${jsonEncode(data)}");
    http.Response response;

    final hayInternet = await _hayInternet();

    if (hayInternet == ConnectivityResult.none) {
      throw InternetException();
    }
    response = await http
        .post(
          uri,
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
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw CredencialesException(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else if (response.statusCode == 404) {
      throw PageNotFoundException();
    } else {
      //TODO: mirar los tipos de errores que pueden venir de la api
      log(response.body);
      throw ServerException(jsonDecode(response.body) as Map<String, dynamic>);
    }
  }

  /// Realiza la petición  put a la api a la [url] con body [data].
  @override
  Future<Map<String, dynamic>> putRecurso(
      String recursoEndpoint, Map<String, dynamic> data) async {
    final uri = Uri(
        scheme: _serverScheme,
        host: _serverHost,
        pathSegments: [_apiBase, recursoEndpoint]);
    final http.Response response = await http
        .put(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            if (token != null) HttpHeaders.authorizationHeader: "Token $token"
          },
          body: jsonEncode(data),
        )
        .timeout(_timeLimit);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw CredencialesException(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else if (response.statusCode == 404) {
      throw PageNotFoundException();
    } else {
      //TODO: mirar los tipos de errores que pueden venir de la api
      log(response.body);
      throw ServerException(jsonDecode(response.body) as Map<String, dynamic>);
    }
  }

  /// Permite la subida de fotos de los cuestionarios o inspecciones al server
  @override
  Future subirFotos(
      Iterable<File> fotos, String idDocumento, Categoria tipoDocumento) async {
    const uriRecurso = '/subir-fotos/';
    final uri = Uri(
        scheme: _serverScheme,
        host: _serverHost,
        pathSegments: [_apiBase, uriRecurso]);
    final request = http.MultipartRequest("POST", uri);

    request.headers[HttpHeaders.authorizationHeader] = "Token $token";

    request.fields['iddocumento'] = idDocumento;
    request.fields['tipodocumento'] =
        EnumToString.convertToString(tipoDocumento);

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

  /// Descarga el [recurso] desde el server, es como un get sencillo, pero permite mostrar el progreso en la Ui (ver sincronizacion_cubit.dart)
  @override
  void descargaFlutterDownloader(
      String recurso, String savedir, String filename) {
    final url = _serverScheme + '://' + _serverHost + _apiBase + recurso;
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
