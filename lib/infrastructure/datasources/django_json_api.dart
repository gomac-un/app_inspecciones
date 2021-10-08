import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:http/http.dart' as http;
import 'package:inspecciones/infrastructure/core/api_exceptions.dart';
import 'package:inspecciones/infrastructure/core/typedefs.dart';
import 'package:inspecciones/infrastructure/datasources/fotos_remote_datasource.dart';
import 'package:inspecciones/infrastructure/repositories/fotos_repository.dart';
import 'package:path/path.dart' as path;

import 'auth_remote_datasource.dart';
import 'cuestionarios_remote_datasource.dart';
import 'flutter_downloader/flutter_downloader_as_future.dart';
import 'inspecciones_remote_datasource.dart';

class DjangoJsonApi
    implements
        AuthRemoteDataSource,
        CuestionariosRemoteDataSource,
        FotosRemoteDataSource,
        InspeccionesRemoteDataSource {
  final http.Client _client;
  final Uri _apiUri;

  /// Repositorio que se comunica con la api de inspecciones en la uri [_apiUri].
  ///  La dependencia [_client] es la encargada de autenticar las peticiones,
  /// ver [DjangoJsonApiAuthenticatedClient]
  /// Las excepciones lanzadas por todos los métodos de esta clase deberían ser
  /// unicamente los definidos en [core/errors.dart], aunque podrían pasar algunos
  /// otros inesperadamente.
  /// Es importante llamar [dispose] para cerrar las conexiones al final.
  DjangoJsonApi(this._client, this._apiUri);

  void dispose() => _client.close();

  /// Devuelve el token del usuario
  ///
  /// Con las credenciales ingresadas al momento de iniciar sesión, se hace
  /// la petición a la Api para que devuelva el token de autenticación
  /// (https://www.django-rest-framework.org/api-guide/authentication/#tokenauthentication)
  /// Este es el unico método de este repositorio que no require un [_client] autenticado
  @override
  Future<JsonObject> getToken(JsonObject credenciales) =>
      _ejecutarRequest(() => _client
          .post(_apiUri.appendSegment('api-token-auth'), body: credenciales));

  /// Devuelve json que permite saber si [user] es admin, es decir, si puede
  /// o no crear cuestionarios-
  @override
  Future<JsonObject> getPermisos(String username, String token) =>
      _ejecutarRequest(() {
        return _client.post(_apiUri.appendSegment('groups'),
            body: {"username": username});
      });

  /// Le informa al servidor que debe registrar un nuevo cliente y el servidor
  /// retorna una id, esta id es unica por cada peticion y será usada para generar
  /// las ids de los objetos generados localmente de tal manera que al subirlos,
  /// no hayan choques de ids
  @override
  Future<JsonObject> registrarApp() => _ejecutarRequest(
      () => _client.post(_apiUri.appendSegment('registro-app')));

  @override
  Future<JsonObject> getInspeccion(int id) =>
      _ejecutarRequest(() => _client.get(_apiUri
          .appendSegment("inspecciones", addTrailingSlash: false)
          .appendSegment("$id")));

  @override
  Future<JsonObject> crearInspeccion(JsonObject inspeccion) =>
      _ejecutarRequest(() => _client.post(_apiUri.appendSegment("inspecciones"),
          body: inspeccion));

  @override
  Future<JsonObject> actualizarInspeccion(
          int inspeccionId, JsonObject inspeccion) =>
      _ejecutarRequest(() => _client.put(
          _apiUri
              .appendSegment("inspecciones", addTrailingSlash: false)
              .appendSegment("$inspeccionId"),
          body: inspeccion));

  @override
  Future<JsonObject> subirFotos(
      Iterable<File> fotos, String idDocumento, Categoria tipoDocumento) async {
    final uri = _apiUri.appendSegment('subir-fotos');

    final request = http.MultipartRequest("POST", uri);

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

    return _ejecutarRequest(
        () async => http.Response.fromStream(await _client.send(request)));
  }

  @override
  Future<JsonObject> crearCuestionario(JsonObject cuestionario) =>
      _ejecutarRequest(() => _client.post(
          _apiUri.appendSegment("cuestionarios-completos"),
          body: cuestionario));

  /// TODO: mirar como hacer para no tener el token como parámetro
  @override
  Future<File> descargarTodosLosCuestionarios(String token) async {
    final uri = _apiUri.appendSegment('server');
    return flutterDownloaderAsFuture(
      uri,
      'server.json',
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );
  }

  /// TODO: mirar como hacer para no tener el token como parámetro
  /// Descarga todas las fotos de todos los cuestionarios
  @override
  Future<void> descargarTodasLasFotos(String token) async {
    final uri = _apiUri.appendSegment(
      '/media/fotos-app-inspecciones/cuestionarios.zip',
      addTrailingSlash: false,
    );
    final zipFotos = await flutterDownloaderAsFuture(
      uri,
      'cuestionarios.zip',
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    //descompresion
    final destinationDir =
        Directory(path.join(await directorioDeDescarga(), 'cuestionarios'));

    await ZipFile.extractToDirectory(
        zipFile: zipFotos, destinationDir: destinationDir);
  }

  Future<JsonObject> _ejecutarRequest(
      Future<http.Response> Function() request) async {
    final http.Response response;

    try {
      response = await request().timeout(const Duration(seconds: 5));
    } catch (e) {
      throw ErrorDeConexion("$e");
    }
    //NOTE: este es un buen lugar para poner breakpoints en el debug de peticiones

    final statusCode = response.statusCode;

    if (statusCode == 500) {
      throw ErrorInesperadoDelServidor(response.body);
    }
    if ([404].contains(statusCode)) {
      throw ErrorEnLaComunicacionConLaApi(
          "No se encuentra la ruta ${response.request?.url.toString()}");
    }

    if (statusCode == 401) {
      throw ErrorDeCredenciales(response.jsonDecoded["detail"]);
    }
    if (statusCode == 403) {
      throw ErrorDePermisos(response
          .jsonDecoded["detail"]); // TODO: mirar si el servidor si responde asi
    }
    if ([400].contains(statusCode)) {
      if (_esErrorDeLogin(response)) {
        throw ErrorDeCredenciales(
            response.jsonDecoded[_loginMesageKey].toString());
      }
      throw ErrorEnLaComunicacionConLaApi(response.jsonDecoded
          .toString()); //TODO considerar guardar el json parseado
    }
    if ([405, 415].contains(statusCode)) {
      throw ErrorEnLaComunicacionConLaApi(response.jsonDecoded["detail"]);
    }
    if (statusCode == 200 || statusCode == 201) {
      return response.jsonDecoded;
    } else {
      throw ErrorInesperadoDelServidor(response.body);
    }
  }

  bool _esErrorDeLogin(http.Response response) =>
      response.jsonDecoded.containsKey(_loginMesageKey) &&
      (response.jsonDecoded[_loginMesageKey] as List)
          .any((e) => (e is String) && e.startsWith("No puede iniciar"));

  static const _loginMesageKey = "non_field_errors";
}

/// cliente http que agrega el [_token] a todas las peticiones enviadas
/// funciona con la TokenAuthentication de django rest framework
class DjangoJsonApiAuthenticatedClient extends http.BaseClient {
  final String _token;
  final http.Client _inner;

  DjangoJsonApiAuthenticatedClient(this._token, [http.Client? inner])
      : _inner = inner ?? http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers[HttpHeaders.authorizationHeader] = "Token $_token";
    request.headers[HttpHeaders.acceptHeader] = "application/json";
    return _inner.send(request);
  }
}

extension ManipulacionesUri on Uri {
  Uri appendSegment(String segment, {bool addTrailingSlash = true}) => replace(
      pathSegments: [...pathSegments, segment, if (addTrailingSlash) '']);
}

extension JsonDecoded on http.Response {
  JsonObject get jsonDecoded {
    try {
      return json.decode(utf8.decode(bodyBytes)) as Map<String, dynamic>;
    } catch (e) {
      throw ErrorDecodificandoLaRespuesta(body);
    }
  }
}
