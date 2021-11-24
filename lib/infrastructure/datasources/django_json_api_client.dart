import 'dart:convert';
import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:inspecciones/core/entities/app_image.dart';
import 'package:path/path.dart' as path;

import '../core/api_exceptions.dart';
import '../core/typedefs.dart';
import '../repositories/providers.dart';

//TODO: implementar el dispose
final djangoJsonApiClientProvider =
    Provider((ref) => DjangoJsonApiClient(ref.read));

class DjangoJsonApiClient {
  final Reader _read;
  String? get _token => _read(appRepositoryProvider).getToken();
  final http.Client _inner;

  DjangoJsonApiClient(this._read, [http.Client? inner])
      : _inner = inner ?? http.Client();

  Future<T> request<T>(String method, Uri url,
          {JsonMap? body,
          String format = "json",
          Map<String, String>? headers}) =>
      _ejecutarRequest<T>(
          () => _sendUnstreamed(method, url, headers, body, format));

  void close() => _inner.close();

  /// Sends a non-streaming [Request] and returns a non-streaming [Response].
  Future<http.Response> _sendUnstreamed(String method, Uri url,
      Map<String, String>? headers, JsonMap? body, String format) async {
    final http.BaseRequest request;

    if (format == "json") {
      request = _buildJsonRequest(method, url, body);
    } else if (format == "multipart") {
      request = await _buildMultipartRequest(method, url, body);
    } else {
      throw ArgumentError("format must be either 'json' or 'multipart'");
    }

    if (headers != null) request.headers.addAll(headers);
    if (_token != null) {
      request.headers[HttpHeaders.authorizationHeader] = "Token $_token";
    }
    request.headers[HttpHeaders.acceptHeader] =
        "application/json; charset=utf-8"; // Pedimos que todo venga como json

    return http.Response.fromStream(await _inner.send(request));
  }

  http.BaseRequest _buildJsonRequest(String method, Uri url, JsonMap? body) {
    final request = http.Request(method, url);
    request.headers[HttpHeaders.contentTypeHeader] =
        "application/json; charset=utf-8";
    request.body = json.encode(body);
    return request;
  }

  Future<http.BaseRequest> _buildMultipartRequest(
      String method, Uri url, JsonMap? body) async {
    final request = http.MultipartRequest(method, url);
    if (body == null) {
      throw ArgumentError('if format="multipart", body is required');
    }
    for (final entry in body.entries) {
      final field = entry.key;
      final value = entry.value;

      if (value == null) continue;

      if (value is String) {
        request.fields[field] = value;
      } else if (value is num) {
        request.fields[field] = value.toString();
      } else if (value is AppImage) {
        if (value is RemoteImage) continue;
        final file = value.when(
            remote: (_) => XFile(''), //Esto no pasa
            mobile: (f) => XFile(f),
            web: (f) => XFile(f));

        final multipartFile = await _buildMultipartFile(file, field);
        request.files.add(multipartFile);
      } else if (value is XFile) {
        final multipartFile = await _buildMultipartFile(value, field);
        request.files.add(multipartFile);
      } else if (value is List<AppImage>) {
        for (final image in value) {
          final file = image.when(
              remote: (_) => XFile(''), //Esto no pasa
              mobile: (f) => XFile(f),
              web: (f) => XFile(f));

          final multipartFile = await _buildMultipartFile(file, field);
          request.files.add(multipartFile);
        }
      } else {
        throw UnimplementedError(
            "value of type ${value.runtimeType} is not supported for multipart request");
      }
    }
    return request;
  }

  Future<http.MultipartFile> _buildMultipartFile(
      XFile value, String field) async {
    final fileName = path.basename(value.path);
    final stream = http.ByteStream(value.openRead());
    final length = await value.length();
    final multipartFile = http.MultipartFile(
      field,
      stream,
      length,
      filename: fileName,
    );
    return multipartFile;
  }

  /// ejecuta [request] y devuelve el body parseado como json, ademas lanza los
  /// distintos errores definidos en [../core/api_exceptions.dart]
  Future<T> _ejecutarRequest<T>(
      Future<http.Response> Function() request) async {
    final http.Response response;

    try {
      response = await request().timeout(const Duration(seconds: 5));
    } on SocketException catch (e) {
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
            response.jsonDecoded["non_field_errors"].toString());
      }
      throw ErrorEnLaComunicacionConLaApi(response.jsonDecoded
          .toString()); //TODO considerar guardar el json parseado
    }
    if ([405, 415].contains(statusCode)) {
      throw ErrorEnLaComunicacionConLaApi(response.jsonDecoded["detail"]);
    }
    if (statusCode == 204) return Future.value();

    if (statusCode == 200 || statusCode == 201) {
      return response.jsonDecoded;
    } else {
      throw ErrorInesperadoDelServidor(response.body);
    }
  }

  bool _esErrorDeLogin(http.Response response) =>
      response.jsonDecoded.containsKey("non_field_errors") &&
      (response.jsonDecoded["non_field_errors"] as List)
          .any((e) => (e is String) && e.startsWith("No puede iniciar"));
}

extension JsonDecoded<T> on http.Response {
  T get jsonDecoded {
    try {
      return json.decode(utf8.decode(bodyBytes)) as T;
    } catch (e) {
      throw ErrorDecodificandoLaRespuesta(body);
    }
  }
}
