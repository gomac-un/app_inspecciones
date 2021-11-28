import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/core/entities/app_image.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/features/creacion_cuestionarios/tablas_unidas.dart'
    as drift;
import 'package:inspecciones/infrastructure/core/typedefs.dart';
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
  late MockCuestionariosRemoteDataSource _api;
  late drift.Database _db;
  late ProviderContainer container;
  late CuestionariosRepository repository;

  setUp(() async {
    _api = MockCuestionariosRemoteDataSource();
    _db = drift.Database(NativeDatabase.memory());
    container = ProviderContainer(overrides: [
      cuestionariosRemoteDataSourceProvider.overrideWithValue(_api),
      drift.driftDatabaseProvider.overrideWithValue(_db),
    ]);
    repository = CuestionariosRepository(container.read);
  });

  tearDown(() async {
    await _db.close();
  });
  group("descargarCuestionario", () {
    const cuestionarioId = "3d20ce74-6d29-48e0-8f52-97fe9cdd9e0e";
    final file = File(
        'test/infrastructure/repositories/fixtures/get_cuestionario_fixture.json');
    late JsonMap fixture;

    setUp(() async {
      fixture = jsonDecode(await file.readAsString());
    });
    test("se puede descargar un cuestionario vacio", () async {
      when(_api.descargarCuestionario("1")).thenAnswer((_) async => {
            "id": "1",
            "tipo_de_inspeccion": "preoperacional",
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
      final resDB = await repository.getCuestionarioCompleto(cuestionarioId);
      final cuestionario = resDB.cuestionario;
      expect(cuestionario.tipoDeInspeccion, "preoperacional");
      expect(cuestionario.version, 1);
      expect(cuestionario.periodicidadDias, 1);

      final etiquetas = resDB.etiquetas;
      expect(etiquetas, hasLength(1));
      expect(etiquetas.first.clave, "color");
      expect(etiquetas.first.valor, "amarillo");

      final bloques = resDB.bloques;

      expect(bloques, hasLength(4));

      final titulo = bloques[0] as drift.TituloD;
      verifyTitulo(titulo);

      final pregunta = bloques[1] as drift.PreguntaDeSeleccion;
      verifyPreguntaDeUnicaRespuesta(pregunta);

      final preguntaNumerica = bloques[2] as drift.PreguntaNumerica;
      verifyPreguntaNumerica(preguntaNumerica);

      final cuadricula =
          bloques[3] as drift.CuadriculaConPreguntasYConOpcionesDeRespuesta;
      verifyCuadricula(cuadricula);
    });
  });
  group("getListaDeCuestionariosServer", () {
    final file = File(
        'test/infrastructure/repositories/fixtures/list_cuestionarios_fixture.json');
    late JsonList fixture;

    setUp(() async {
      fixture = jsonDecode(await file.readAsString());
    });
    test("debería devolver la lista de cuestionarios", () async {
      when(_api.getCuestionarios()).thenAnswer((_) async => fixture);

      final res = await repository.getListaDeCuestionariosServer();

      expect(res.isRight(), isTrue);
      final cuestionarios = res.getOrElse(() => throw Exception("error"));
      expect(cuestionarios, hasLength(1));
      expect(cuestionarios.first.tipoDeInspeccion, "preoperacional");
    });
  });

  group("subirCuestionario", () {
    final file = File(
        'test/infrastructure/repositories/fixtures/subir_cuestionario_fixture.json');
    late JsonMap fixture;

    setUp(() async {
      fixture = jsonDecode(await file.readAsString());
    });
    test("debería enviar un cuestionario", () async {
      final cuestionario = buildCuestionarioDePrueba();
      final cuestionarioId = cuestionario.cuestionario.id.value;
      await _db.guardadoDeCuestionarioDao.guardarCuestionario(cuestionario);

      when(_api.subirCuestionario(any)).thenAnswer((_) async => {});
      when(_api.subirFotosCuestionario(any)).thenAnswer((_) async => {
            'f1.jpg': "664a0e98-7cab-4070-ac2a-59007416ba53",
            'f2.jpg': "664a0e98-7cab-4070-ac2a-59007416ba54",
            "f3.jpg": "8876414b-e018-4d40-bb86-9e31b96da560",
          });

      await repository.subirCuestionario(cuestionarioId);

      final jsonEnviado =
          verify(_api.subirCuestionario(captureAny)).captured.single;

      expect(jsonEnviado, fixture);
      final cuestionarioDB = await _db.select(_db.cuestionarios).getSingle();
      expect(cuestionarioDB.subido, true);
    });
  });
}

void verifyTitulo(drift.TituloD titulo) {
  expect(titulo.titulo.titulo, "tit");
  expect(titulo.titulo.descripcion, "desc");

  final fotos = titulo.titulo.fotos;
  expect(fotos.length, 1);
  expect(
      fotos.first,
      isA<RemoteImage>().having((f) => f.url, "url",
          "http://testserver/media/fotos_cuestionarios/perfil.png"));
}

void verifyPreguntaDeUnicaRespuesta(drift.PreguntaDeSeleccion pregunta) {
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

drift.CuestionarioCompletoCompanion buildCuestionarioDePrueba() =>
    drift.CuestionarioCompletoCompanion(
        drift.CuestionariosCompanion.insert(
            id: const Value("d32ca126-dbe1-4869-8112-474aeb8a34b4"),
            tipoDeInspeccion: "preoperacional",
            version: 1,
            periodicidadDias: 1,
            estado: EstadoDeCuestionario.finalizado,
            subido: false),
        [
          drift.EtiquetasDeActivoCompanion.insert(
              clave: "color", valor: "amarillo")
        ],
        [
          drift.TituloDCompanion(drift.TitulosCompanion.insert(
              id: const Value("664a0e98-7cab-4070-ac2a-59007416ba52"),
              bloqueId: "",
              titulo: "titulo",
              descripcion: "",
              fotos: [
                const AppImage.mobile("fotos/f1.jpg"),
                const AppImage.mobile("fotos/f2.jpg")
              ])),
          drift.PreguntaDeSeleccionCompanion(
            drift.PreguntasCompanion.insert(
              id: const Value("c28c6d44-179c-4aa3-9852-8411e12962fb"),
              titulo: "tit",
              descripcion: "desc",
              criticidad: 1,
              fotosGuia: [],
              tipoDePregunta: drift.TipoDePregunta.seleccionUnica,
            ),
            [
              drift.OpcionesDeRespuestaCompanion.insert(
                  id: const Value("36b824a6-f342-467e-ac57-4949066f15c5"),
                  titulo: "tit",
                  descripcion: "desc",
                  criticidad: 1,
                  preguntaId: "")
            ],
            [
              drift.EtiquetasDePreguntaCompanion.insert(
                  clave: "sistema", valor: "motor")
            ],
          ),
          drift.PreguntaNumericaCompanion(
            drift.PreguntasCompanion.insert(
              id: const Value("4514c156-988e-44bb-a0c2-c9e216ed09f3"),
              titulo: "tit",
              descripcion: "desc",
              criticidad: 1,
              fotosGuia: [],
              tipoDePregunta: drift.TipoDePregunta.numerica,
            ),
            [
              drift.CriticidadesNumericasCompanion.insert(
                  id: const Value("52656dca-01aa-4fa9-9221-530c02df3b7b"),
                  criticidad: 1,
                  valorMinimo: 0,
                  valorMaximo: 10,
                  preguntaId: "")
            ],
            [
              drift.EtiquetasDePreguntaCompanion.insert(
                  clave: "sistema", valor: "motor")
            ],
          ),
          drift.CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion(
              drift.PreguntaDeSeleccionCompanion(
                drift.PreguntasCompanion.insert(
                    id: const Value("57e0fc73-15ff-4e5c-a43f-65ccd0a08769"),
                    titulo: "cuadricula",
                    descripcion: "desc",
                    criticidad: 1,
                    fotosGuia: [const AppImage.mobile("fotos/f3.jpg")],
                    tipoDePregunta: drift.TipoDePregunta.cuadricula,
                    tipoDeCuadricula:
                        const Value(drift.TipoDeCuadricula.seleccionUnica)),
                [
                  drift.OpcionesDeRespuestaCompanion.insert(
                      id: const Value("3417dec5-7783-4ca2-9f28-56b09dbd55b2"),
                      titulo: "tit",
                      descripcion: "desc",
                      criticidad: 1,
                      preguntaId: "")
                ],
                [
                  drift.EtiquetasDePreguntaCompanion.insert(
                      clave: "sistema", valor: "motor")
                ],
              ),
              [
                drift.PreguntaDeSeleccionCompanion(
                    drift.PreguntasCompanion.insert(
                      id: const Value("b5d44619-7a0a-4c8d-9486-bab7da37fe67"),
                      titulo: "tit",
                      descripcion: "",
                      criticidad: 1,
                      fotosGuia: [],
                      tipoDePregunta: drift.TipoDePregunta.parteDeCuadricula,
                    ),
                    [],
                    [])
              ])
        ]);
