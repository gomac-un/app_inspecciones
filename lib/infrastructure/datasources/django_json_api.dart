import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:inspecciones/core/entities/app_image.dart';
import 'package:inspecciones/infrastructure/core/api_exceptions.dart';
import 'package:inspecciones/infrastructure/core/typedefs.dart';
import 'package:inspecciones/infrastructure/datasources/fotos_remote_datasource.dart';
import 'package:inspecciones/infrastructure/repositories/fotos_repository.dart';
import 'package:inspecciones/infrastructure/repositories/providers.dart';
import 'package:path/path.dart' as path;

import 'auth_remote_datasource.dart';
import 'cuestionarios_remote_datasource.dart';
import 'flutter_downloader/flutter_downloader_as_future.dart';
import 'inspecciones_remote_datasource.dart';

//TODO: implementar el dispose
final _httpClientProvider =
    Provider<http.Client>((ref) => DjangoJsonApiClient(ref.read));

class DjangoJsonApi
    implements
        AuthRemoteDataSource,
        CuestionariosRemoteDataSource,
        FotosRemoteDataSource,
        InspeccionesRemoteDataSource {
  final Reader _read;
  http.Client get _client => _read(_httpClientProvider);
  final Uri _apiUri;

  /// Repositorio que se comunica con la api de inspecciones en la uri [_apiUri].
  ///  La dependencia [_client] es la encargada de autenticar las peticiones,
  /// ver [DjangoJsonApiClient]
  /// Las excepciones lanzadas por todos los métodos de esta clase deberían ser
  /// unicamente los definidos en [core/errors.dart], aunque podrían pasar algunos
  /// otros inesperadamente.
  /// Es importante llamar [dispose] para cerrar las conexiones al final.
  DjangoJsonApi(this._read, this._apiUri);

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
  Future<JsonObject> getPermisos(String username) =>
      _ejecutarRequest(() => _client
          .post(_apiUri.appendSegment('groups'), body: {"username": username}));

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
  Future<JsonObject> subirFotos(Iterable<AppImage> fotos, String idDocumento,
      Categoria tipoDocumento) async {
    final uri = _apiUri.appendSegment('subir-fotos');

    final request = http.MultipartRequest("POST", uri);

    request.fields['iddocumento'] = idDocumento;
    request.fields['tipodocumento'] =
        EnumToString.convertToString(tipoDocumento);

    Future<void> agregarFoto(String f) async {
      final fileName = path.basename(f);
      //final stream = http.ByteStream(file.openRead());
      final file = XFile(f);
      final length = await file.length();
      final multipartFileSign = http.MultipartFile(
        'fotos',
        file.openRead(),
        length,
        filename: fileName,
      );
      request.files.add(multipartFileSign);
    }

    for (final foto in fotos) {
      await foto.when(
        remote: (_) async {},
        mobile: agregarFoto,
        web: agregarFoto,
      );
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
    final uri = _apiUri
        .appendSegment('media', addTrailingSlash: false)
        .appendSegment('fotos-app-inspecciones', addTrailingSlash: false)
        .appendSegment('cuestionarios.zip', addTrailingSlash: false);
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

  /// ejecuta [request] y devuelve el body parseado como json, ademas lanza los
  /// distintos errores definidos en [../core/api_exceptions.dart]
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
class DjangoJsonApiClient extends http.BaseClient {
  final Reader _read;
  String? get _token => _read(appRepositoryProvider).getToken();
  final http.Client _inner;

  DjangoJsonApiClient(this._read, [http.Client? inner])
      : _inner = inner ?? http.Client();

  static const sendJsonHeader = {
    HttpHeaders.contentTypeHeader: "application/json; charset=utf-8"
  };
  // se deben sobreescribir los metodos que retornan
  @override
  Future<http.Response> post(Uri url,
          {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
      _sendUnstreamed('POST', url, {...sendJsonHeader}..addAll(headers ?? {}),
          body, encoding);

  @override
  Future<http.Response> put(Uri url,
          {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
      _sendUnstreamed('PUT', url, {...sendJsonHeader}..addAll(headers ?? {}),
          body, encoding);

  @override
  Future<http.Response> patch(Uri url,
          {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
      _sendUnstreamed('PATCH', url, {...sendJsonHeader}..addAll(headers ?? {}),
          body, encoding);

  @override
  Future<http.Response> delete(Uri url,
          {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
      _sendUnstreamed('DELETE', url, {...sendJsonHeader}..addAll(headers ?? {}),
          body, encoding);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    if (_token != null) {
      request.headers[HttpHeaders.authorizationHeader] = "Token $_token";
    }
    request.headers[HttpHeaders.acceptHeader] =
        "application/json; charset=utf-8";

    return _inner.send(request);
  }

  /// Sends a non-streaming [Request] and returns a non-streaming [Response].
  Future<http.Response> _sendUnstreamed(
      String method, Uri url, Map<String, String>? headers,
      [body, Encoding? encoding]) async {
    var request = http.Request(method, url);

    if (headers != null) request.headers.addAll(headers);
    if (encoding != null) request.encoding = encoding;
    if (body != null) {
      if (request.headers.containsKey(HttpHeaders.contentTypeHeader) &&
          request.headers[HttpHeaders.contentTypeHeader] ==
              "application/json; charset=utf-8") {
        body = json.encode(body as JsonObject);
      }
      if (body is String) {
        request.body = body;
      } else {
        if (body is List) {
          request.bodyBytes = body.cast<int>();
        } else if (body is Map) {
          request.bodyFields = body.cast<String, String>();
        } else {
          throw ArgumentError('Invalid request body "$body".');
        }
      }
    }

    return http.Response.fromStream(await send(request));
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
