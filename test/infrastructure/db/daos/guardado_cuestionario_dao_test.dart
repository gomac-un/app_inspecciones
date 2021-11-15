import 'package:drift/native.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/features/creacion_cuestionarios/tablas_unidas.dart';
import 'package:inspecciones/infrastructure/drift_database.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  late Database _db;

  setUp(() {
    _db = Database(NativeDatabase.memory());
  });

  tearDown(() async {
    await _db.close();
  });
  test(
      "se pueden crear dos cuestionarios con etiquetas en comun sin que estas se dupliquen en la db",
      () async {
    await _db.guardadoDeCuestionarioDao.guardarCuestionario(
        CuestionarioCompletoCompanion(
            CuestionariosCompanion.insert(
                tipoDeInspeccion: "preoperacional",
                version: 1,
                periodicidadDias: 1,
                estado: EstadoDeCuestionario.finalizado,
                subido: true),
            [
          EtiquetasDeActivoCompanion.insert(clave: "color", valor: "amarillo")
        ],
            []));
    await _db.guardadoDeCuestionarioDao.guardarCuestionario(
        CuestionarioCompletoCompanion(
            CuestionariosCompanion.insert(
                tipoDeInspeccion: "general",
                version: 1,
                periodicidadDias: 1,
                estado: EstadoDeCuestionario.finalizado,
                subido: true),
            [
          EtiquetasDeActivoCompanion.insert(clave: "color", valor: "amarillo")
        ],
            []));
    expect(await getNroFilas(_db, _db.etiquetasDeActivo), 1);
  });
}
