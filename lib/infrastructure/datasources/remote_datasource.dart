import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:file/file.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:inspecciones/application/auth/auth_service.dart';
import 'package:inspecciones/core/error/exceptions.dart';
import 'package:inspecciones/infrastructure/repositories/fotos_repository.dart';
import 'package:path/path.dart' as path;

final apiUriProvider = Provider((ref) => Uri(
    scheme: 'https',
    host: 'gomac.medellin.unal.edu.co',
    pathSegments: ['inspecciones/api/v1']));

extension ManipulacionesUri on Uri {
  Uri appendSegment(String segment, {bool addTrailingSlash = true}) => replace(
      pathSegments: [...pathSegments, segment, if (addTrailingSlash) '']);
}

//TODO eliminar la duplicacion de código
class AuthRemoteDatasource {
  static const _timeLimit = Duration(seconds: 5);

  final Reader read;
  AuthRemoteDatasource(
    this.read,
  );

  Future<ConnectivityResult> _hayInternet() async =>
      await (Connectivity().checkConnectivity());

  /// Devuelve el token del usuario
  ///
  /// Con las credenciales ingresadas al momento de iniciar sesión, se hace
  /// la petición a la Api para que devuelva el token de autenticación
  /// (https://www.django-rest-framework.org/api-guide/authentication/#tokenauthentication)
  Future<Map<String, dynamic>> getToken(Map<String, dynamic> user) async {
    final uri = read(apiUriProvider).appendSegment('api-token-auth');

    final http.Response response = await http
        .post(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(user),
        )
        .timeout(_timeLimit);
    developer.log("res: ${response.statusCode}\n${response.body}");

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
      developer.log(response.body);
      throw ServerException(jsonDecode(response.body) as Map<String, dynamic>);
    }
  }

  /// Devuelve json que permite saber si [user] es admin, es decir, si puede
  /// o no crear cuestionarios-
  Future<Map<String, dynamic>> getPermisos(
      Map<String, dynamic> user, String token) async {
    final uri = read(apiUriProvider).appendSegment('groups');

    developer.log("req: ${uri.path}\n${jsonEncode(user)}");
    final http.Response response = await http
        .post(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            HttpHeaders.authorizationHeader: "Token $token"
          },
          body: jsonEncode(user),
        )
        .timeout(_timeLimit);
    developer.log("res: ${response.statusCode}\n${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw CredencialesException(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else if (response.statusCode == 404) {
      throw PageNotFoundException();
    } else {
      //TODO: mirar los tipos de errores que pueden venir de la api
      developer.log(response.body);
      throw ServerException(jsonDecode(response.body) as Map<String, dynamic>);
    }
  }

  Future<Map<String, dynamic>> registrarApp() async {
    final uri = read(apiUriProvider).appendSegment('registro-app');

    developer.log("req: ${uri.path}");
    http.Response response;

    final hayInternet = await _hayInternet();

    if (hayInternet == ConnectivityResult.none) {
      throw InternetException();
    }
    response = await http
        .post(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode({}),
        )
        .timeout(_timeLimit);
    developer.log("res: ${response.statusCode}\n${response.body}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw CredencialesException(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else if (response.statusCode == 404) {
      throw PageNotFoundException();
    } else {
      //TODO: mirar los tipos de errores que pueden venir de la api
      developer.log(response.body);
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
  Future<String?> descargaFlutterDownloader(
      String recurso, String savedir, String filename);
}

class DjangoJsonAPI implements InspeccionesRemoteDataSource {
  static const _timeLimit = Duration(seconds: 5); //TODO: ajustar el timelimit

  final Reader read;

  DjangoJsonAPI(this.read);

  /// Realiza la petición  get a la api a la [url]
  @override
  Future<Map<String, dynamic>> getRecurso(String recursoEndpoint) async {
    final uri = read(apiUriProvider).appendSegment(recursoEndpoint);

    final token = read(userProvider)?.map(
        offline: (_) => throw Exception("el usuario no esta online"),
        online: (u) => u.token);

    final hayInternet = await _hayInternet();
    if (hayInternet == ConnectivityResult.none) {
      throw InternetException();
    }
    developer.log("req: ${uri.path}\ntoken:$token");
    final http.Response response = await http.get(
      uri,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    ).timeout(_timeLimit);
    developer.log("res: ${response.statusCode}\n${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw CredencialesException(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else if (response.statusCode == 404) {
      throw PageNotFoundException();
    } else {
      //TODO: mirar los tipos de errores que pueden venir de la api
      developer.log(response.body);
      throw ServerException(jsonDecode(response.body) as Map<String, dynamic>);
    }
  }

  Future<ConnectivityResult> _hayInternet() async =>
      await (Connectivity().checkConnectivity());

  /// Realiza la petición  post a la api a la [url], enviando como body [data]
  @override
  Future<Map<String, dynamic>> postRecurso(
      String recursoEndpoint, Map<String, dynamic> data) async {
    final uri = read(apiUriProvider).appendSegment(recursoEndpoint);
    final token = read(userProvider)?.map(
        offline: (_) => throw Exception("el usuario no esta online"),
        online: (u) => u.token);
    developer.log("req: ${uri.path}\n${jsonEncode(data)}");
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
            HttpHeaders.authorizationHeader: "Token $token"
          },
          body: jsonEncode(data),
        )
        .timeout(_timeLimit);
    developer.log("res: ${response.statusCode}\n${response.body}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw CredencialesException(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else if (response.statusCode == 404) {
      throw PageNotFoundException();
    } else {
      //TODO: mirar los tipos de errores que pueden venir de la api
      developer.log(response.body);
      throw ServerException(jsonDecode(response.body) as Map<String, dynamic>);
    }
  }

  /// Realiza la petición  put a la api a la [url] con body [data].
  @override
  Future<Map<String, dynamic>> putRecurso(
      String recursoEndpoint, Map<String, dynamic> data) async {
    final uri = read(apiUriProvider).appendSegment(recursoEndpoint);
    final token = read(userProvider)?.map(
        offline: (_) => throw Exception("el usuario no esta online"),
        online: (u) => u.token);
    final http.Response response = await http
        .put(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            HttpHeaders.authorizationHeader: "Token $token"
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
      developer.log(response.body);
      throw ServerException(jsonDecode(response.body) as Map<String, dynamic>);
    }
  }

  /// Permite la subida de fotos de los cuestionarios o inspecciones al server
  @override
  Future subirFotos(
      Iterable<File> fotos, String idDocumento, Categoria tipoDocumento) async {
    final uri = read(apiUriProvider).appendSegment('subir-fotos');

    final token = read(userProvider)?.map(
        offline: (_) => throw Exception("el usuario no esta online"),
        online: (u) => u.token);
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

    developer.log(response.body);
    if (response.statusCode > 299) {
      throw Exception("error del servidor");
    }

    //<input type="file" id="files" name="file_fields" multiple>
  }

  /// Permite programar la descarga de un recurso usando [FlutterDownloader],
  /// para poder conocer el estado de la descarga se tiene que haber configurado
  /// previamente [FlutterDownloader], registrando un puerto y un callback
  /// ya que esta libreria funciona con isolates, ejemplo: [DescargaCuestionariosNotifier]
  @override
  Future<String?> descargaFlutterDownloader(
      String recurso, String savedir, String filename) {
    final url = read(apiUriProvider).appendSegment(recurso).toString();

    final token = read(userProvider)?.map(
        offline: (_) => throw Exception("el usuario no esta online"),
        online: (u) => u.token);

    return FlutterDownloader.enqueue(
        url: url,
        headers: <String, String>{
          HttpHeaders.authorizationHeader: "Token $token"
        },
        savedDir: savedir,
        fileName: filename,
        showNotification: false);
  }
}
