import 'dart:convert';
import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart' as http_test;
import 'package:inspecciones/core/entities/app_image.dart';
import 'package:inspecciones/infrastructure/core/api_exceptions.dart';
import 'package:inspecciones/infrastructure/datasources/django_json_api.dart';
import 'package:inspecciones/infrastructure/datasources/django_json_api_client.dart';
import 'package:inspecciones/infrastructure/repositories/app_repository.dart';
import 'package:inspecciones/infrastructure/repositories/fotos_repository.dart';
import 'package:inspecciones/infrastructure/repositories/providers.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'django_json_api_test.mocks.dart';

@TestOn('vm') // Uses dart:io
//@TestOn('browser') // Uses web-only Flutter SDK

/// para probar en chrome se usa
/// `flutter test test/infrastructure/datasources/django_json_api_test.dart --platform chrome`
@GenerateMocks([AppRepository])
void main() {
  final apiUri = Uri.parse("http://127.0.0.1:8000/inspecciones/api/v1");
  test("appendSegment deberia agregar una nuevo segmento al final de la uri",
      () {
    final nuevaUri = apiUri.appendSegment('api-token-auth');
    expect(nuevaUri,
        Uri.parse("http://127.0.0.1:8000/inspecciones/api/v1/api-token-auth/"));
    expect(nuevaUri.toString(),
        "http://127.0.0.1:8000/inspecciones/api/v1/api-token-auth/");
  });

  test(
      "appendSegment deberia agregar un segmento sin trailing slash si addTrailingSlash es false",
      () {
    final nuevaUri =
        apiUri.appendSegment('api-token-auth', addTrailingSlash: false);
    expect(nuevaUri,
        Uri.parse("http://127.0.0.1:8000/inspecciones/api/v1/api-token-auth"));
    expect(nuevaUri.toString(),
        "http://127.0.0.1:8000/inspecciones/api/v1/api-token-auth");
  });

  test("appendSegment deberia agregar varios segmentos", () {
    final nuevaUri = apiUri
        .appendSegment('inspecciones', addTrailingSlash: false)
        .appendSegment("1");
    expect(nuevaUri,
        Uri.parse("http://127.0.0.1:8000/inspecciones/api/v1/inspecciones/1/"));
    expect(nuevaUri.toString(),
        "http://127.0.0.1:8000/inspecciones/api/v1/inspecciones/1/");
  });

  group("DjangoJsonApiClient", () {
    late AppRepository appRepository;
    late ProviderContainer container;

    setUp(() {
      appRepository = MockAppRepository();
      when(appRepository.getToken()).thenAnswer((_) => null);
      container = ProviderContainer(
          overrides: [appRepositoryProvider.overrideWithValue(appRepository)]);
    });
    test('una peticion GET deberia usar el token asignado en el header',
        () async {
      when(appRepository.getToken()).thenAnswer((_) => "123");

      final DjangoJsonApiClient client = DjangoJsonApiClient(
        container.read,
        http_test.MockClient((request) async {
          expect(request.headers[HttpHeaders.authorizationHeader], "Token 123");
          return http.Response("{}", 200);
        }),
      );

      await client.request("GET", apiUri);
    });
    test("debería lanzar las excepciones generadas por el cliente interno",
        () async {
      final DjangoJsonApiClient client = DjangoJsonApiClient(
        container.read,
        http_test.MockClient((request) => throw Exception("e1")),
      );
      await expectLater(
          () => client.request("GET", apiUri),
          throwsA(isA<Exception>()
              .having((e) => e.toString(), "message", "Exception: e1")));
    });
  });

  group("django json api", () {
    //late AppRepository appRepository;
    //late ProviderContainer container;

    setUp(() {
      //appRepository = MockAppRepository();
      /*container = ProviderContainer(
          overrides: [appRepositoryProvider.overrideWithValue(appRepository)]);*/
    });

    DjangoJsonApi buildDjangoJsonApi(http_test.MockClientHandler fn) {
      final appRepository = MockAppRepository();
      when(appRepository.getToken()).thenAnswer((_) => "123");
      final containerPadre = ProviderContainer(
          overrides: [appRepositoryProvider.overrideWithValue(appRepository)]);
      final container = ProviderContainer(parent: containerPadre, overrides: [
        djangoJsonApiClientProvider.overrideWithValue(
            DjangoJsonApiClient(containerPadre.read, http_test.MockClient(fn)))
      ]);
      return DjangoJsonApi(
        //http_test.MockClient(fn),
        container.read,
        apiUri,
      );
    }

    test(
        "si se usan un cliente autenticado, getInspeccion debería realizar una peticion con el token",
        () async {
      String authHeader = "";
      final api = buildDjangoJsonApi((request) async {
        authHeader = request.headers[HttpHeaders.authorizationHeader]!;
        return http.Response("{}", 200);
      });
      await api.descargarInspeccion(1);
      expect(authHeader, contains("123"));
    });

    test("subirFotos debería adjuntar las fotos en el body de la request",
        () async {
      const testFilePath = "./test/infrastructure/datasources/assets/foto.jpg";
      final fotos = [const AppImage.mobile(testFilePath)];
      final sizeOriginal = File(testFilePath).readAsBytesSync().lengthInBytes;
      int bodySize = 0;
      final api = buildDjangoJsonApi((request) async {
        bodySize = request.bodyBytes.lengthInBytes;
        return http.Response("{}", 200);
      });
      await api.subirFotos(fotos, "1", Categoria.inspeccion);
      // esta es una forma bastante indirecta de probar que el archivo se
      //incluya en el body de la request
      expect(bodySize, greaterThan(sizeOriginal));
    }, onPlatform: {
      'browser': const Skip('solo lee imagenes del filesystem local')
    });

    test("descargarTodosLosCuestionarios debería descargar los cuestionarios",
        () async {
      final api =
          buildDjangoJsonApi((request) async => http.Response("{}", 200));
      await api.descargarTodosLosCuestionarios("123");
    }, skip: "esta funcion no se deja probar facilmente");

    test(
        "descargarTodasLasFotos debería descargar todas las fotos y extraerlas en las carpetas correspondientes",
        () async {
      final api =
          buildDjangoJsonApi((request) async => http.Response("{}", 200));
      await api.descargarTodasLasFotos("123");
    }, skip: "esta funcion no se deja probar facilmente");

    /// la funcion que se esta probando realmente al invocar [getInspeccion]
    /// es [_ejecutarRequest] pero como es privada se debe probar desde esta otra
    group("Tipos de errores", () {
      test(
          "getInspeccion debería lanzar ErrorDeConexion cuando hay un SocketException",
          () async {
        final api =
            buildDjangoJsonApi((request) => throw const SocketException(""));
        await expectLater(
            () => api.descargarInspeccion(1), throwsA(isA<ErrorDeConexion>()));
      });
      test(
          'getInspeccion debería lanzar ErrorInesperadoDelServidor cuando el status es 500',
          () async {
        final api = buildDjangoJsonApi(
            (request) async => http.Response("no json", 500));
        await expectLater(() => api.descargarInspeccion(1),
            throwsA(isA<ErrorInesperadoDelServidor>()));
      });
      test(
          'getInspeccion debería lanzar ErrorDecodificandoLaRespuesta cuando la respuesta no es json valido',
          () async {
        final api =
            buildDjangoJsonApi((request) async => http.Response("boo", 200));
        await expectLater(() => api.descargarInspeccion(1),
            throwsA(isA<ErrorDecodificandoLaRespuesta>()));
      });
      test(
          'getInspeccion debería lanzar ErrorDeCredenciales cuando el estatus es 401',
          () async {
        final api = buildDjangoJsonApi(
            (request) async => http.Response(r'{"detail":""}', 401));

        await expectLater(
            () => api.descargarInspeccion(1), throwsA(isA<ErrorDeCredenciales>()));
      });
      test(
          'getInspeccion debería lanzar ErrorEnLaComunicacionConLaApi cuando el estatus es 404',
          () async {
        final api =
            buildDjangoJsonApi((request) async => http.Response('404', 404));

        await expectLater(() => api.descargarInspeccion(-1),
            throwsA(isA<ErrorEnLaComunicacionConLaApi>()));
      });
      test(
          'getInspeccion debería lanzar ErrorEnLaComunicacionConLaApi cuando el estatus es 400',
          () async {
        final api = buildDjangoJsonApi((request) async => http.Response(
            '{"id":["Este campo es requerido."],"clase":["Este campo es requerido."]}',
            400));

        await expectLater(() => api.descargarInspeccion(1),
            throwsA(isA<ErrorEnLaComunicacionConLaApi>()));
      });
      test(
          'getInspeccion debería lanzar ErrorEnLaComunicacionConLaApi cuando el estatus es 405',
          () async {
        final api = buildDjangoJsonApi((request) async => http.Response.bytes(
            utf8.encode(r'{"detail":"Método \"DELETE\" no permitido."}'), 405));

        await expectLater(() => api.descargarInspeccion(1),
            throwsA(isA<ErrorEnLaComunicacionConLaApi>()));
      });
      test(
          'getInspeccion debería lanzar ErrorEnLaComunicacionConLaApi cuando el estatus es 415',
          () async {
        final api = buildDjangoJsonApi((request) async => http.Response.bytes(
            utf8.encode(
                r'{"detail":"Tipo de medio \"text/plain; charset=utf-8\" incompatible en la solicitud."}'),
            415));

        await expectLater(() => api.descargarInspeccion(1),
            throwsA(isA<ErrorEnLaComunicacionConLaApi>()));
      });
      test(
          'getInspeccion debería lanzar ErrorInesperadoDelServidor cuando el estatus es uno no considerado',
          () async {
        final api =
            buildDjangoJsonApi((request) async => http.Response("", 485));

        await expectLater(() => api.descargarInspeccion(1),
            throwsA(isA<ErrorInesperadoDelServidor>()));
      });
    });
  });
}
