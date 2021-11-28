import 'package:drift/native.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/infrastructure/datasources/organizacion_remote_datasource.dart';
import 'package:inspecciones/infrastructure/datasources/providers.dart';
import 'package:inspecciones/infrastructure/drift_database.dart' as drift;
import 'package:inspecciones/infrastructure/repositories/organizacion_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'organizacion_repository_test.mocks.dart';

@GenerateMocks([
  OrganizacionRemoteDataSource,
])
main() {
  group("refreshListaDeActivos", () {
    late MockOrganizacionRemoteDataSource _api;
    late drift.Database _db;
    late ProviderContainer container;
    late OrganizacionRepository repository;
    setUp(() {
      _api = MockOrganizacionRemoteDataSource();
      _db = drift.Database(NativeDatabase.memory());
      container = ProviderContainer(overrides: [
        organizacionRemoteDataSourceProvider.overrideWithValue(_api),
        drift.driftDatabaseProvider.overrideWithValue(_db),
      ]);
      repository = OrganizacionRepository(container.read);
    });
    tearDown(() async {
      await _db.close();
    });
    test("devuelve una lista vacia si la api remota devuelve lista vacia",
        () async {
      when(_api.getListaDeActivos()).thenAnswer((_) async => []);

      final res = await repository.refreshListaDeActivos();

      final failure = res.value1;
      final listaDeActivos = res.value2;
      expect(failure, isNull);
      expect(listaDeActivos.length, 0);
    });
    test(
        "si ya obtuvo los activos una vez y a la segunda vez la api falla, trae los activos guardados y el error",
        () async {
      when(_api.getListaDeActivos()).thenAnswer((_) async => [
            {
              'id': 'a1',
              'etiquetas': [
                {'clave': 'ce1', 'valor': 've1'}
              ]
            }
          ]);

      await repository.refreshListaDeActivos();

      when(_api.getListaDeActivos()).thenAnswer((_) async => throw Exception());

      final res = await repository.refreshListaDeActivos();

      final failure = res.value1;
      final listaDeActivos = res.value2;
      expect(failure, isNotNull);
      expect(listaDeActivos.length, 1);
    });
  });
}
