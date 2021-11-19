import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/core/entities/app_image.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/features/creacion_cuestionarios/tablas_unidas.dart'
    as drift;
import 'package:inspecciones/features/llenado_inspecciones/domain/domain.dart';
import 'package:inspecciones/infrastructure/core/typedefs.dart';
import 'package:inspecciones/infrastructure/datasources/inspecciones_remote_datasource.dart';
import 'package:inspecciones/infrastructure/datasources/providers.dart';
import 'package:inspecciones/infrastructure/drift_database.dart' as drift;
import 'package:inspecciones/infrastructure/repositories/inspecciones_remote_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'inspecciones_remote_repository_test.mocks.dart';

@GenerateMocks([
  InspeccionesRemoteDataSource,
])
main() {
  late MockInspeccionesRemoteDataSource _api;
  late drift.Database _db;
  late ProviderContainer container;
  late InspeccionesRemoteRepository repository;

  setUp(() async {
    _api = MockInspeccionesRemoteDataSource();
    _db = drift.Database(NativeDatabase.memory());
    container = ProviderContainer(overrides: [
      inspeccionesRemoteDataSourceProvider.overrideWithValue(_api),
      drift.driftDatabaseProvider.overrideWithValue(_db),
    ]);
    repository = InspeccionesRemoteRepository(container.read);
  });

  tearDown(() async {
    await _db.close();
  });
  group("subirInspeccion", () {
    final file = File(
        'test/infrastructure/repositories/fixtures/subir_inspeccion_fixture.json');
    late JsonMap fixture;

    setUp(() async {
      fixture = jsonDecode(await file.readAsString());
    });
    test("debería enviar una inspeccion", () async {
      final cuestionarioInspeccionado = buildCuestionarioInspeccionado();
      final preguntasRespondidas = buildPreguntasRespondidas();

      await _db
          .into(_db.activos)
          .insert(drift.ActivosCompanion.insert(id: "a1"));

      await _db.guardadoDeCuestionarioDao
          .guardarCuestionario(buildCuestionario());

      await _db.guardadoDeInspeccionDao
          .guardarInspeccion(preguntasRespondidas, cuestionarioInspeccionado);

      when(_api.crearInspeccion(any)).thenAnswer((_) async => {});
      when(_api.subirFotosInspeccion(any)).thenAnswer((_) async => {
            'f1.jpg': "6b948801-d0a9-4679-ab89-fcdc54be7c9a",
            'f2.jpg': "138dc9b8-2f0a-439f-ba98-1a95a9c02eb8",
          });

      await repository.subirInspeccion(IdentificadorDeInspeccion(
          activo: "a1",
          cuestionarioId: "10ba76eb-0774-41f0-8dc5-a600767c5690"));

      final JsonMap jsonEnviado =
          verify(_api.crearInspeccion(captureAny)).captured.single;

      expect(jsonEnviado['id'],
          isNotNull); // el id no se puede dejar en el fixture porque depende de la fecha
      expect(jsonEnviado..remove('id'), fixture);
      final inspeccionDB = await _db.select(_db.inspecciones).getSingle();
      expect(inspeccionDB.momentoEnvio, isNotNull);
    });
  });
}

drift.CuestionarioCompletoCompanion buildCuestionario() =>
    drift.CuestionarioCompletoCompanion(
        drift.CuestionariosCompanion.insert(
            id: const Value("10ba76eb-0774-41f0-8dc5-a600767c5690"),
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
          drift.PreguntaDeSeleccionCompanion(
            drift.PreguntasCompanion.insert(
              id: const Value("7a01e199-073e-4703-bc26-62fe3dfb80d3"),
              titulo: "p",
              descripcion: "",
              criticidad: 1,
              fotosGuia: [],
              tipoDePregunta: drift.TipoDePregunta.seleccionUnica,
            ),
            [
              drift.OpcionesDeRespuestaCompanion.insert(
                  id: const Value("eb80d8e2-48a8-4f0d-a68e-e6ef0a291919"),
                  titulo: "o",
                  descripcion: "",
                  criticidad: 1,
                  preguntaId: "")
            ],
            [],
          ),
        ]);

List<Pregunta> buildPreguntasRespondidas() {
  final opcion = OpcionDeRespuesta(
      id: "eb80d8e2-48a8-4f0d-a68e-e6ef0a291919",
      titulo: "o",
      descripcion: "",
      criticidad: 1);
  return [
    PreguntaDeSeleccionUnica(
      [opcion],
      id: "7a01e199-073e-4703-bc26-62fe3dfb80d3",
      titulo: "p",
      descripcion: "",
      fotosGuia: [],
      criticidad: 1,
      etiquetas: [],
      calificable: false,
      respuesta: RespuestaDeSeleccionUnica(
        MetaRespuesta(
          fotosBase: [const AppImage.mobile("images/f1.jpg")],
          fotosReparacion: [const AppImage.mobile("images/f2.jpg")],
          reparada: false,
          observaciones: "observacion",
          observacionesReparacion: "observacion reparacion",
          momentoRespuesta: DateTime.utc(2020, 1, 1),
        ),
        opcion,
      ),
    ),
  ];
}

CuestionarioInspeccionado buildCuestionarioInspeccionado() =>
    CuestionarioInspeccionado(
      Cuestionario(
          id: "10ba76eb-0774-41f0-8dc5-a600767c5690",
          tipoDeInspeccion: "preoperacional"),
      Inspeccion(
          id: "e7830f11-5097-484c-8d0a-90d423d69dda",
          estado: EstadoDeInspeccion.finalizada,
          activo: Activo(id: "a1", etiquetas: []),
          momentoInicio: DateTime.utc(2020, 1, 1),
          inspectorId: "ins1"),
      [],
    );
