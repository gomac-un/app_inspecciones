import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart' as http_test;
import 'package:inspecciones/infrastructure/core/errors.dart';
import 'package:inspecciones/infrastructure/datasources/django_json_api.dart';
import 'package:test/test.dart';

void main() {
  final apiUri = Uri.parse("http://127.0.0.1:8000/inspecciones/api/v1");
  group("DjangoJsonApiClient", () {
    test('una peticion GET deberia usar el token asignado en el header',
        () async {
      final DjangoJsonApiAuthenticatedClient client =
          DjangoJsonApiAuthenticatedClient(
        "123",
        http_test.MockClient((request) async {
          expect(request.headers[HttpHeaders.authorizationHeader], "Token 123");
          return http.Response("", 404);
        }),
      );

      await client.get(apiUri);
    });
    test("debería lanzar las excepciones generadas por el cliente interno",
        () async {
      final DjangoJsonApiAuthenticatedClient client =
          DjangoJsonApiAuthenticatedClient(
        "123",
        http_test.MockClient((request) => throw const SocketException("")),
      );
      await expectLater(
          () => client.get(apiUri), throwsA(isA<SocketException>()));
    });
  });

  /// la funcion que se esta probando realmente al invocar [descargarInspeccionRemota]
  /// es [_ejecutarRequest] pero como es privada se debe probar desde esta otra
  group("django json api", () {
    DjangoJsonApi _mockDJA(http_test.MockClientHandler fn) => DjangoJsonApi(
          DjangoJsonApiAuthenticatedClient("123", http_test.MockClient(fn)),
          apiUri,
        );

    test(
        "descargarInspeccionRemota debería lanzar ErrorDeConexion cuando hay un SocketException",
        () async {
      //TODO: mirar como se pueden ejecutar los tests en flutter web para ver si los errores cambian
      final api = _mockDJA((request) => throw const SocketException(""));
      await expectLater(() => api.getInspeccion(1),
          throwsA(isA<ErrorDeConexion>()));
    });
    test(
        'descargarInspeccionRemota debería lanzar ErrorInesperadoDelServidor cuando el status es 500',
        () async {
      final api = _mockDJA((request) async => http.Response("no json", 500));
      await expectLater(() => api.getInspeccion(1),
          throwsA(isA<ErrorInesperadoDelServidor>()));
    });
    test(
        'descargarInspeccionRemota debería lanzar ErrorDecodificandoLaRespuesta cuando la respuesta no es json valido',
        () async {
      final api = _mockDJA((request) async => http.Response("boo", 200));
      await expectLater(() => api.getInspeccion(1),
          throwsA(isA<ErrorDecodificandoLaRespuesta>()));
    });
    test(
        'descargarInspeccionRemota debería lanzar ErrorDeCredenciales cuando el estatus es 401',
        () async {
      final api =
          _mockDJA((request) async => http.Response(r'{"detail":""}', 401));

      await expectLater(() => api.getInspeccion(1),
          throwsA(isA<ErrorDeCredenciales>()));
    });
    test(
        'descargarInspeccionRemota debería lanzar ErrorEnLaComunicacionConLaApi cuando el estatus es 404',
        () async {
      final api = _mockDJA((request) async => http.Response('404', 404));

      await expectLater(() => api.getInspeccion(-1),
          throwsA(isA<ErrorEnLaComunicacionConLaApi>()));
    });
    test(
        'descargarInspeccionRemota debería lanzar ErrorEnLaComunicacionConLaApi cuando el estatus es 400',
        () async {
      final api = _mockDJA((request) async => http.Response(
          r'{"id":["Este campo es requerido."],"clase":["Este campo es requerido."]}',
          400));

      await expectLater(() => api.getInspeccion(1),
          throwsA(isA<ErrorEnLaComunicacionConLaApi>()));
    });
    test(
        'descargarInspeccionRemota debería lanzar ErrorEnLaComunicacionConLaApi cuando el estatus es 405',
        () async {
      final api = _mockDJA((request) async => http.Response.bytes(
          utf8.encode(r'{"detail":"Método \"DELETE\" no permitido."}'), 405));

      await expectLater(() => api.getInspeccion(1),
          throwsA(isA<ErrorEnLaComunicacionConLaApi>()));
    });
    test(
        'descargarInspeccionRemota debería lanzar ErrorEnLaComunicacionConLaApi cuando el estatus es 415',
        () async {
      final api = _mockDJA((request) async => http.Response.bytes(
          utf8.encode(
              r'{"detail":"Tipo de medio \"text/plain; charset=utf-8\" incompatible en la solicitud."}'),
          415));

      await expectLater(() => api.getInspeccion(1),
          throwsA(isA<ErrorEnLaComunicacionConLaApi>()));
    });
    test(
        'descargarInspeccionRemota debería lanzar ErrorInesperadoDelServidor cuando el estatus es uno no considerado',
        () async {
      final api = _mockDJA((request) async => http.Response("", 485));

      await expectLater(() => api.getInspeccion(1),
          throwsA(isA<ErrorInesperadoDelServidor>()));
    });
  });
}
