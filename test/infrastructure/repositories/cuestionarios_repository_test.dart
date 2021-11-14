import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/core/entities/app_image.dart';
import 'package:inspecciones/features/creacion_cuestionarios/tablas_unidas.dart'
    as drift;
import 'package:inspecciones/infrastructure/datasources/cuestionarios_remote_datasource.dart';
import 'package:inspecciones/infrastructure/datasources/providers.dart';
import 'package:inspecciones/infrastructure/drift_database.dart' as drift;
import 'package:inspecciones/infrastructure/repositories/cuestionarios_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../db/daos/utils.dart';
import 'cuestionarios_repository_test.mocks.dart';

@GenerateMocks([
  CuestionariosRemoteDataSource,
])
main() {
  group("descargarCuestionario", () {
    late MockCuestionariosRemoteDataSource _api;
    late drift.Database _db;
    late ProviderContainer container;
    late CuestionariosRepository repository;

    const cuestionarioId = "3d20ce74-6d29-48e0-8f52-97fe9cdd9e0e";
    final file = File(
        'test/infrastructure/repositories/fixtures/get_cuestionario_fixture.json');
    late Map<String, dynamic> fixture;

    setUp(() async {
      _api = MockCuestionariosRemoteDataSource();
      _db = drift.Database(NativeDatabase.memory());
      container = ProviderContainer(overrides: [
        cuestionariosRemoteDataSourceProvider.overrideWithValue(_api),
        drift.driftDatabaseProvider.overrideWithValue(_db),
      ]);
      repository = CuestionariosRepository(container.read);

      fixture = jsonDecode(await file.readAsString());
    });

    tearDown(() async {
      await _db.close();
    });
    test("se puede descargar un cuestionario vacio", () async {
      when(_api.descargarCuestionario("1")).thenAnswer((_) async => {
            "id": "1",
            "tipo_de_inspeccion": "",
            "version": 1,
            "periodicidad_dias": 1,
            "etiquetas_aplicables": [],
            "bloques": []
          });
      final res = await repository.descargarCuestionario(cuestionarioId: "1");

      expect(res.isRight(), isTrue);
      expect(await getNroFilas(_db, _db.cuestionarios), 1);
    });
    test("los datos del cuestionario se deberian guardar", () async {
      when(_api.descargarCuestionario(cuestionarioId))
          .thenAnswer((_) async => fixture);

      final res = await repository.descargarCuestionario(
          cuestionarioId: cuestionarioId);

      expect(res.isRight(), isTrue);
      expect(await getNroFilas(_db, _db.cuestionarios), 1);
      final resDB = await repository.getCuestionarioYEtiquetas(cuestionarioId);
      final cuestionario = resDB.cuestionario;
      expect(cuestionario.tipoDeInspeccion, "preoperacional");
      expect(cuestionario.version, 1);
      expect(cuestionario.periodicidadDias, 1);

      final etiquetas = resDB.etiquetas;
      expect(etiquetas, hasLength(1));
      expect(etiquetas.first.clave, "color");
      expect(etiquetas.first.valor, "amarillo");

      final bloques = await repository.cargarCuestionario(cuestionarioId);

      expect(bloques, hasLength(4));

      final titulo = bloques[0] as drift.Titulo;
      verifyTitulo(titulo);

      final pregunta = bloques[1] as drift.PreguntaConOpcionesDeRespuesta;
      verifyPreguntaDeUnicaRespuesta(pregunta);

      final preguntaNumerica = bloques[2] as drift.PreguntaNumerica;
      verifyPreguntaNumerica(preguntaNumerica);

      final cuadricula =
          bloques[3] as drift.CuadriculaConPreguntasYConOpcionesDeRespuesta;
      verifyCuadricula(cuadricula);
    });
  });
}

void verifyTitulo(drift.Titulo titulo) {
  expect(titulo.titulo, "tit");
  expect(titulo.descripcion, "desc");

  final fotos = titulo.fotos;
  expect(fotos.length, 1);
  expect(
      fotos.first,
      isA<RemoteImage>().having((f) => f.url, "url",
          "http://testserver/media/fotos_cuestionarios/perfil.png"));
}

void verifyPreguntaDeUnicaRespuesta(
    drift.PreguntaConOpcionesDeRespuesta pregunta) {
  expect(pregunta.pregunta.titulo, "tit");
  expect(pregunta.pregunta.descripcion, "desc");
  expect(pregunta.pregunta.criticidad, 1);

  final etiquetasDePregunta = pregunta.etiquetas;
  expect(etiquetasDePregunta, hasLength(1));
  expect(etiquetasDePregunta.first.clave, "sistema");
  expect(etiquetasDePregunta.first.valor, "motor");

  final opcionesDeRespuesta = pregunta.opcionesDeRespuesta;
  expect(opcionesDeRespuesta, hasLength(1));
  expect(opcionesDeRespuesta.first.id, "ef6e754b-789f-4f61-81af-1466c3db402e");
  expect(opcionesDeRespuesta.first.titulo, "tit");
  expect(opcionesDeRespuesta.first.descripcion, "desc");
  expect(opcionesDeRespuesta.first.criticidad, 1);

  final fotos = pregunta.pregunta.fotosGuia;
  expect(fotos.length, 1);
  expect(
      fotos.first,
      isA<RemoteImage>().having((f) => f.url, "url",
          "http://testserver/media/fotos_cuestionarios/perfil.png"));
}

void verifyPreguntaNumerica(drift.PreguntaNumerica pregunta) {
  expect(pregunta.pregunta.titulo, "tit");
  expect(pregunta.pregunta.descripcion, "desc");
  expect(pregunta.pregunta.criticidad, 1);

  final etiquetasDePregunta = pregunta.etiquetas;
  expect(etiquetasDePregunta.length, 1);
  expect(etiquetasDePregunta.first.clave, "sistema");
  expect(etiquetasDePregunta.first.valor, "motor");

  final criticidades = pregunta.criticidades;
  expect(criticidades, hasLength(1));
  expect(criticidades.first.valorMinimo, 0);
  expect(criticidades.first.valorMaximo, 10);
  expect(criticidades.first.criticidad, 1);

  final fotos = pregunta.pregunta.fotosGuia;
  expect(fotos.length, 1);
  expect(
      fotos.first,
      isA<RemoteImage>().having((f) => f.url, "url",
          "http://testserver/media/fotos_cuestionarios/perfil.png"));
}

void verifyCuadricula(
    drift.CuadriculaConPreguntasYConOpcionesDeRespuesta pregunta) {
  final cuadricula = pregunta.cuadricula;
  expect(cuadricula.pregunta.titulo, "cuadricula");
  expect(cuadricula.pregunta.descripcion, "desc");
  expect(cuadricula.pregunta.criticidad, 1);
  expect(cuadricula.pregunta.tipoDePregunta, drift.TipoDePregunta.cuadricula);
  expect(cuadricula.pregunta.tipoDeCuadricula,
      drift.TipoDeCuadricula.seleccionUnica);

  final etiquetasDePregunta = cuadricula.etiquetas;
  expect(etiquetasDePregunta, hasLength(1));
  expect(etiquetasDePregunta.first.clave, "sistema");
  expect(etiquetasDePregunta.first.valor, "motor");

  final opcionesDeRespuesta = cuadricula.opcionesDeRespuesta;
  expect(opcionesDeRespuesta, hasLength(1));
  expect(opcionesDeRespuesta.first.titulo, "tit");
  expect(opcionesDeRespuesta.first.descripcion, "desc");
  expect(opcionesDeRespuesta.first.criticidad, 1);

  final fotos = cuadricula.pregunta.fotosGuia;
  expect(fotos.length, 1);
  expect(
      fotos.first,
      isA<RemoteImage>().having((f) => f.url, "url",
          "http://testserver/media/fotos_cuestionarios/perfil.png"));

  final subPreguntas = pregunta.preguntas;
  expect(subPreguntas, hasLength(1));
  final subPregunta = subPreguntas.first.pregunta;
  expect(subPregunta.titulo, "tit");
  expect(subPregunta.descripcion, "");
  expect(subPregunta.tipoDePregunta, drift.TipoDePregunta.parteDeCuadricula);
}
