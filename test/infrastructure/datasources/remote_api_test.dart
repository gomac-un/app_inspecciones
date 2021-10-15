@Skip('''Estos tests no prueban la app sino el servicio de Django, para 
      ejecutarlos se debe tener un servidor corriendo en la apiUri.
     IMPORTANTE: no ejecutar en un servidor de produccion ya que se podrian 
     borrar cosas''')
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:inspecciones/infrastructure/datasources/django_json_api.dart';
import 'package:test/test.dart';

main() {
  final apiUri = Uri.parse("http://127.0.0.1:8000/inspecciones/api/v1");
  late http.Client noLoggedClient;
  late http.Client loggedClient;

  Future<String> _localLogin() async {
    final resToken = await noLoggedClient.post(
        apiUri.appendSegment('api-token-auth'),
        body: {"username": "gato", "password": "gato"});
    return json.decode(resToken.body)['token'];
  }

  setUp(() async {
    noLoggedClient = http.Client();
    loggedClient =
        DjangoJsonApiClient(await _localLogin(), noLoggedClient);
  });
  tearDown(() {
    noLoggedClient.close();
    loggedClient.close();
  });

  test('La pagina 404 debería retornar un html, no un json', () async {
    final res = await noLoggedClient.get(apiUri.appendSegment("capybaras"));
    expect(res.statusCode, 404);
    expect(() => json.decode(res.body), throwsFormatException);
  });
  test(
      'Intentar acceder sin token debería dar error 401 con un json con detail',
      () async {
    final res = await noLoggedClient.get(apiUri.appendSegment("inspecciones"));

    expect(res.statusCode, 401);
    expect(json.decode(res.body)["detail"], isNotEmpty);
  });
  //TODO: probar una peticion donde el servidor lance 403: no autorizado
  test('una peticion normal deberia dar status 200 y la respuesta es tipo json',
      () async {
    final loggedInApi = loggedClient;
    final res = await loggedInApi.get(apiUri.appendSegment("activos"));
    json.decode(res.body);

    expect(res.statusCode, 200);
  });
  test(
      'hacer un post sin body debería dar error 400 y un json con los problemas en cada campo',
      () async {
    final loggedInApi = loggedClient;
    final res = await loggedInApi.post(apiUri.appendSegment("activos"));

    expect(res.statusCode, 400);
    expect(json.decode(res.body)["clase"], isNotEmpty);
  });
  test(
      'hacer un DELETE a un endpoint principal debería dar error 405 y un json con detail',
      () async {
    final loggedInApi = loggedClient;
    final res = await loggedInApi.delete(apiUri.appendSegment("activos"));

    expect(res.statusCode, 405);
    expect(json.decode(res.body)["detail"], isNotEmpty);
  });
  test(
      'mandar un texto sin formato en el body de un post debería dar error 415 y un json con detail',
      () async {
    final loggedInApi = loggedClient;
    final res = await loggedInApi.post(apiUri.appendSegment("activos"),
        body: "capybara");

    expect(res.statusCode, 415);
    expect(json.decode(res.body)["detail"], isNotEmpty);
  });
  test(
      'el endpoint groups deberia lanzar error 500 si el username no existe, esto se considera bug del server',
      () async {
    final loggedInApi = loggedClient;
    final res = await loggedInApi
        .post(apiUri.appendSegment("groups"), body: {"username": "capybara"});

    expect(res.statusCode, 500);
    expect(() => json.decode(res.body), throwsFormatException);
  });
}
