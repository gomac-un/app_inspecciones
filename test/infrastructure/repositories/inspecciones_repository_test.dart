import 'package:dartz/dartz.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/cuestionario.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/identificador_inspeccion.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/inspeccion.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/activo.dart';
import 'package:inspecciones/infrastructure/core/api_exceptions.dart';
import 'package:inspecciones/infrastructure/datasources/fotos_remote_datasource.dart';
import 'package:inspecciones/infrastructure/datasources/inspecciones_remote_datasource.dart';
import 'package:inspecciones/infrastructure/drift_database.dart' as drift;
import 'package:inspecciones/infrastructure/repositories/fotos_repository.dart';
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
    FotosRepository
  ],
)
main() {
  late MockInspeccionesRemoteDataSource _api;
  late MockFotosRemoteDataSource _apiFotos;
  late MockDatabase _db;
  late MockFotosRepository _fotosRepository;
  late InspeccionesRemoteRepository repository;

  setUp(() {
    _api = MockInspeccionesRemoteDataSource();
    _apiFotos = MockFotosRemoteDataSource();
    _db = MockDatabase();
    _fotosRepository = MockFotosRepository();
    repository =
        InspeccionesRemoteRepository(_api, _apiFotos, _db, _fotosRepository);
  });

  group("getInspeccionServidor", () {
    test(
        "debería devolver el [IdentificadorDeInspeccion] si no hay excepciones",
        () async {
      when(_api.getInspeccion(1)).thenAnswer((_) async => {});
      when(_db.guardarInspeccionBD({})).thenAnswer((_) => Future.value(
            IdentificadorDeInspeccion(activo: "1", cuestionarioId: 1),
          ));

      final res = await repository.getInspeccionServidor(1);

      expect(res,
          Right(IdentificadorDeInspeccion(activo: "1", cuestionarioId: 1)));
    });
    test("debería devolver Left(ApiFailure) si hay ErrorDeConexion", () async {
      when(_api.getInspeccion(1))
          .thenAnswer((_) async => throw const ErrorDeConexion(""));

      final res = await repository.getInspeccionServidor(1);

      expect(res, const Left(ApiFailure.errorDeConexion("")));
    });
    test(
        "debería devolver Left(ApiFailure.errorInesperadoDelServidor) si la api lanza una excepcion inesperada",
        () async {
      //TODO: debería ser errorInesperadoDelDatasource o considerar dejar propagar la excepcion
      when(_api.getInspeccion(1)).thenAnswer((_) async => throw Exception());

      final res = await repository.getInspeccionServidor(1);

      expect(
          res, const Left(ApiFailure.errorInesperadoDelServidor("Exception")));
    });
    test("debería lanzar excepcion si guardarInspeccionBD lanza excepcion",
        () async {
      // TODO: estas excepciones se deberian convertir a Failures
      when(_api.getInspeccion(1)).thenAnswer((_) async => {});
      when(_db.guardarInspeccionBD({}))
          .thenAnswer((_) async => throw Exception());

      await expectLater(
          () => repository.getInspeccionServidor(1), throwsA(isA<Exception>()));
    });
  });
  group("subirInspeccion", () {
    test("debería devolver Right(unit) si no hay excepciones", () async {
      final inspeccion = Inspeccion(
        id: 1,
        estado: EstadoDeInspeccion.borrador,
        criticidadTotal: 1,
        criticidadReparacion: 1,
        activo: Activo(id: "1", modelo: "1"),
        esNueva: true,
      );
      final cuestionario = CuestionarioInspeccionado(
          Cuestionario(id: 1, tipoDeInspeccion: "a"), inspeccion, []);
      inspeccion.cuestionario = cuestionario;

      when(_db.getInspeccionConRespuestas(any))
          .thenAnswer((_) async => {"id": "1"});
      when(_api.crearInspeccion({"id": "1"})).thenAnswer((_) async => {});
      when(_fotosRepository.getFotosDeDocumento(
        Categoria.inspeccion,
        identificador: "1",
      )).thenAnswer((_) async => []);
      when(_apiFotos.subirFotos([], "1", Categoria.inspeccion))
          .thenAnswer((_) async => {});

      final res = await repository.subirInspeccion(inspeccion);

      expect(res, const Right(unit));
    });
    test("debería devolver Left(ApiFailure) si hay ErrorDeConexion", () async {
      final inspeccion = Inspeccion(
        id: 1,
        estado: EstadoDeInspeccion.borrador,
        criticidadTotal: 1,
        criticidadReparacion: 1,
        activo: Activo(id: "1", modelo: "1"),
        esNueva: true,
      );
      final cuestionario = CuestionarioInspeccionado(
          Cuestionario(id: 1, tipoDeInspeccion: "a"), inspeccion, []);
      inspeccion.cuestionario = cuestionario;

      when(_db.getInspeccionConRespuestas(any))
          .thenAnswer((_) async => {"id": "1"});
      when(_api.crearInspeccion({"id": "1"}))
          .thenAnswer((_) async => throw const ErrorDeConexion(""));

      final res = await repository.subirInspeccion(inspeccion);

      expect(res, const Left(ApiFailure.errorDeConexion("")));
    });
  });
}
