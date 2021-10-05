import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:inspecciones/infrastructure/core/errors.dart';

class DjangoJsonApi {
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
  Future<JsonObject> getToken(JsonObject credenciales) async {
    return _ejecutarRequest(() => _client
        .post(_apiUri.appendSegment('api-token-auth'), body: credenciales));
  }

  Future<JsonObject> getInspeccion(int id) async {
    return _ejecutarRequest(() => _client.get(_apiUri
        .appendSegment("inspecciones", addTrailingSlash: false)
        .appendSegment("$id")));
  }

  //Otras acciones

  Future<JsonObject> _ejecutarRequest(
      Future<http.Response> Function() request) async {
    final http.Response response;

    try {
      response = await request();
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
}

typedef JsonObject = Map<String, dynamic>;

/// cliente http que agrega el [_token] a todas las peticiones enviadas
/// funciona con la TokenAuthentication de django rest framework
class DjangoJsonApiAuthenticatedClient extends http.BaseClient {
  final String _token;
  final http.Client _inner;

  DjangoJsonApiAuthenticatedClient(this._token, this._inner);

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
