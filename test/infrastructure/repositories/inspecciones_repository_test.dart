import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/activo.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/cuestionario.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/identificador_inspeccion.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/inspeccion.dart';
import 'package:inspecciones/infrastructure/core/api_exceptions.dart';
import 'package:inspecciones/infrastructure/daos/sincronizacion_dao.dart';
import 'package:inspecciones/infrastructure/datasources/fotos_remote_datasource.dart';
import 'package:inspecciones/infrastructure/datasources/inspecciones_remote_datasource.dart';
import 'package:inspecciones/infrastructure/datasources/providers.dart';
import 'package:inspecciones/infrastructure/drift_database.dart' as drift;
import 'package:inspecciones/infrastructure/repositories/inspecciones_remote_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'inspecciones_repository_test.mocks.dart';

@GenerateMocks(
  [
    InspeccionesRemoteDataSource,
    FotosRemoteDataSource,
    drift.Database,
    SincronizacionDao,
  ],
)
main() {
  late MockInspeccionesRemoteDataSource _api;
  late MockDatabase _db;
  late MockSincronizacionDao _sincronizacionDao;
  late InspeccionesRemoteRepository repository;
  late ProviderContainer container;

  setUp(() {
    _api = MockInspeccionesRemoteDataSource();
    _db = MockDatabase();
    _sincronizacionDao = MockSincronizacionDao();
    when(_db.sincronizacionDao).thenAnswer((_) => _sincronizacionDao);
    container = ProviderContainer(
      overrides: [
        inspeccionesRemoteDataSourceProvider.overrideWithValue(_api),
        drift.driftDatabaseProvider.overrideWithValue(_db),
      ],
    );
    repository = InspeccionesRemoteRepository(container.read);
  });

  group("getInspeccionServidor", () {
    test(
        "debería devolver el [IdentificadorDeInspeccion] si no hay excepciones",
        () async {
      when(_api.getInspeccion(1)).thenAnswer((_) async => {});
      when(_sincronizacionDao.guardarInspeccionBD({}))
          .thenAnswer((_) => Future.value(
                IdentificadorDeInspeccion(activo: "a1", cuestionarioId: "c1"),
              ));

      final res = await repository.descargarInspeccion(1);

      expect(res,
          Right(IdentificadorDeInspeccion(activo: "a1", cuestionarioId: "c1")));
    });
    test("debería devolver Left(ApiFailure) si hay ErrorDeConexion", () async {
      when(_api.getInspeccion(1))
          .thenAnswer((_) async => throw const ErrorDeConexion(""));

      final res = await repository.descargarInspeccion(1);

      expect(res, const Left(ApiFailure.errorDeConexion("")));
    });
    test(
        "debería devolver Left(ApiFailure.errorInesperadoDelServidor) si la api lanza una excepcion inesperada",
        () async {
      //TODO: debería ser errorInesperadoDelDatasource o considerar dejar propagar la excepcion
      when(_api.getInspeccion(1)).thenAnswer((_) async => throw Exception());

      final res = await repository.descargarInspeccion(1);

      expect(
          res, const Left(ApiFailure.errorInesperadoDelServidor("Exception")));
    });
    test("debería lanzar excepcion si guardarInspeccionBD lanza excepcion",
        () async {
      // TODO: estas excepciones se deberian convertir a Failures
      when(_api.getInspeccion(1)).thenAnswer((_) async => {});
      when(_sincronizacionDao.guardarInspeccionBD({}))
          .thenAnswer((_) async => throw Exception());

      await expectLater(
          () => repository.descargarInspeccion(1), throwsA(isA<Exception>()));
    });
  });
  group("subirInspeccion", () {
    test("debería devolver Right(unit) si no hay excepciones", () async {
      final inspeccion = Inspeccion(
        id: "i1",
        estado: EstadoDeInspeccion.borrador,
        activo: Activo(
          id: "a1",
          etiquetas: [],
        ),
        momentoInicio: DateTime.now(),
        inspectorId: "p1",
      );
      final cuestionario = CuestionarioInspeccionado(
          Cuestionario(id: "c1", tipoDeInspeccion: "preoperacional"),
          inspeccion, []);

      when(_sincronizacionDao.getInspeccionConRespuestas(any))
          .thenAnswer((_) async => {"id": "i1"});
      when(_api.crearInspeccion({"id": "i1"})).thenAnswer((_) async => {});

      final res = await repository.subirInspeccion(
          IdentificadorDeInspeccion(activo: "a1", cuestionarioId: "c1"));

      expect(res, const Right(unit));
    });
    test("debería devolver Left(ApiFailure) si hay ErrorDeConexion", () async {
      final inspeccion = Inspeccion(
        id: "i1",
        estado: EstadoDeInspeccion.borrador,
        activo: Activo(id: "a1", etiquetas: []),
        momentoInicio: DateTime.now(),
        inspectorId: "p1",
      );
      final cuestionario = CuestionarioInspeccionado(
          Cuestionario(id: "c1", tipoDeInspeccion: "a"), inspeccion, []);

      when(_sincronizacionDao.getInspeccionConRespuestas(any))
          .thenAnswer((_) async => {"id": "i1"});
      when(_api.crearInspeccion({"id": "i1"}))
          .thenAnswer((_) async => throw const ErrorDeConexion(""));

      final res = await repository.subirInspeccion(
          IdentificadorDeInspeccion(activo: "a1", cuestionarioId: "c1"));

      expect(res, const Left(ApiFailure.errorDeConexion("")));
    });
  });
}
