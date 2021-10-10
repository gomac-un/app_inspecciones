import 'package:flutter_test/flutter_test.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/infrastructure/repositories/fotos_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:moor/ffi.dart';

import 'carga_inspeccion_dao_test.mocks.dart';

@GenerateMocks([FotosRepository])
void main() {
  late MoorDatabase _db;
  late MockFotosRepository _fotosRepository;

  setUp(() {
    _fotosRepository = MockFotosRepository();

    _db = MoorDatabase(
      VmDatabase.memory(),
      1,
      _fotosRepository,
    );
  });

  tearDown(() async {
    await _db.close();
  });
  group("getCuestionariosDisponiblesParaActivo", () {
    late int cuestionarioId;

    setUp(() async {
      cuestionarioId = await _db
          .into(_db.cuestionarios)
          .insert(CuestionariosCompanion.insert(
            tipoDeInspeccion: "preoperacional",
            estado: EstadoDeCuestionario.finalizada,
            esLocal: false,
          ));
    });

    Future<int> asociarModeloACuestionario(String modelo) => _db
        .into(_db.cuestionarioDeModelos)
        .insert(CuestionarioDeModelosCompanion.insert(
          modelo: modelo,
          periodicidad: 1,
          cuestionarioId: cuestionarioId,
        ));

    Future<int> insertarActivo(String modelo) =>
        _db.into(_db.activos).insert(ActivosCompanion.insert(modelo: modelo));

    test('''getCuestionariosDisponiblesParaActivo deberia traer un cuestionario 
        que este asignado a todos los activos''', () async {
      await asociarModeloACuestionario("todos");
      final activoId = await insertarActivo("kenworth");

      final res = await _db.cargaDeInspeccionDao
          .getCuestionariosDisponiblesParaActivo(activoId);

      expect(res.length, 1);
      expect(res.first.tipoDeInspeccion, "preoperacional");
    });

    test('''getCuestionariosDisponiblesParaActivo deberia traer un cuestionario 
        que este asignado al modelo del activo''', () async {
      const modelo = "kenworth";
      await asociarModeloACuestionario(modelo);
      final activoId = await insertarActivo(modelo);

      final res = await _db.cargaDeInspeccionDao
          .getCuestionariosDisponiblesParaActivo(activoId);

      expect(res.length, 1);
      expect(res.first.tipoDeInspeccion, "preoperacional");
    });

    test('''getCuestionariosDisponiblesParaActivo deberia traer una lista vacía 
          si no hay cuestionarios asociados al modelo''', () async {
      await asociarModeloACuestionario("moto");
      final activoId = await insertarActivo("kenworth");

      final res = await _db.cargaDeInspeccionDao
          .getCuestionariosDisponiblesParaActivo(activoId);

      expect(res.length, 0);
    });

    test('''getCuestionariosDisponiblesParaActivo deberia traer una lista vacía 
        si el activo no existe a pesar de que haya un cuestionario para todos''',
        () async {
      await asociarModeloACuestionario("todos");

      final res = await _db.cargaDeInspeccionDao
          .getCuestionariosDisponiblesParaActivo(2);

      expect(res.length, 0);
    });

    test('''getCuestionariosDisponiblesParaActivo no deberia traer cuestionarios
         repetidos si el cuestionario esta asociado tanto a todos como al modelo 
         en especifico''', () async {
      await asociarModeloACuestionario("todos");
      await asociarModeloACuestionario("kenworth");

      final activoId = await insertarActivo("kenworth");

      final res = await _db.cargaDeInspeccionDao
          .getCuestionariosDisponiblesParaActivo(activoId);

      expect(res.length, 1);
      expect(res.first.tipoDeInspeccion, "preoperacional");
    });

    test('''getCuestionariosDisponiblesParaActivo deberia traer una lista de 
        cuestionarios si varios aplican''', () async {
      await asociarModeloACuestionario("todos");

      final cuestionarioId2 = await _db
          .into(_db.cuestionarios)
          .insert(CuestionariosCompanion.insert(
            tipoDeInspeccion: "motor",
            estado: EstadoDeCuestionario.finalizada,
            esLocal: false,
          ));
      await _db
          .into(_db.cuestionarioDeModelos)
          .insert(CuestionarioDeModelosCompanion.insert(
            modelo: "kenworth",
            periodicidad: 1,
            cuestionarioId: cuestionarioId2,
          ));

      final activoId = await insertarActivo("kenworth");

      final res = await _db.cargaDeInspeccionDao
          .getCuestionariosDisponiblesParaActivo(activoId);

      expect(res.length, 2);
      expect(res[0] != res[1], true);
    });
  });
}
