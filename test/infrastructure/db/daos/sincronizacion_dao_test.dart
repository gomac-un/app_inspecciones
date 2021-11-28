import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/features/configuracion_organizacion/domain/entities.dart';
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

  group("setActivos", () {
    test("deberia limpiar la tabla de activos y de activosxetiquetas",
        () async {
      final activo1 = await _db
          .into(_db.activos)
          .insertReturning(ActivosCompanion.insert(id: "a1"));
      final etiqueta1 = await _db.into(_db.etiquetasDeActivo).insertReturning(
          EtiquetasDeActivoCompanion.insert(clave: "clave", valor: "valor"));
      await _db.into(_db.activosXEtiquetas).insert(
          ActivosXEtiquetasCompanion.insert(
              activoId: activo1.id, etiquetaId: etiqueta1.id));

      await _db.sincronizacionDao.setActivos([]);

      expect(await getNroFilas(_db, _db.activos), 0);
      expect(await getNroFilas(_db, _db.etiquetasDeActivo), 0);
      expect(await getNroFilas(_db, _db.activosXEtiquetas), 0);
    });
    test("deberia insertar el activo y etiqueta dados", () async {
      await _db.sincronizacionDao.setActivos([
        ActivoEnLista("a1", [Etiqueta("clave", "valor")])
      ]);
      expect(
          await (_db.select(_db.activos)..where((a) => a.id.equals("a1")))
              .getSingleOrNull(),
          isNotNull);
      expect(
          await (_db.select(_db.etiquetasDeActivo)
                ..where(
                    (e) => e.clave.equals("clave") & e.valor.equals("valor")))
              .getSingleOrNull(),
          isNotNull);
      expect(
          await (_db.select(_db.activosXEtiquetas)
                ..where((axe) => axe.activoId.equals("a1")))
              .getSingleOrNull(),
          isNotNull);
    });
    test("deberia crear una sola etiqueta cuando la misma viene en dos activos",
        () async {
      await _db.sincronizacionDao.setActivos([
        ActivoEnLista("a1", [Etiqueta("clave", "valor")]),
        ActivoEnLista("a2", [Etiqueta("clave", "valor")]),
      ]);
      expect(await getNroFilas(_db, _db.activos), 2);
      expect(await getNroFilas(_db, _db.etiquetasDeActivo), 1);
      expect(
          await (_db.select(_db.etiquetasDeActivo)
                ..where(
                    (e) => e.clave.equals("clave") & e.valor.equals("valor")))
              .getSingleOrNull(),
          isNotNull);
      expect(await getNroFilas(_db, _db.activosXEtiquetas), 2);
      expect(
          await (_db.select(_db.activosXEtiquetas)
                ..where((axe) => axe.activoId.equals("a1")))
              .getSingleOrNull(),
          isNotNull);
      expect(
          await (_db.select(_db.activosXEtiquetas)
                ..where((axe) => axe.activoId.equals("a2")))
              .getSingleOrNull(),
          isNotNull);
    });
    test("deberia dejar las etiquetas referenciadas por cuestionarios",
        () async {
      final activo1 = await _db
          .into(_db.activos)
          .insertReturning(ActivosCompanion.insert(id: "a1"));
      final etiqueta1 = await _db.into(_db.etiquetasDeActivo).insertReturning(
          EtiquetasDeActivoCompanion.insert(clave: "clave", valor: "valor"));
      await _db.into(_db.activosXEtiquetas).insert(
          ActivosXEtiquetasCompanion.insert(
              activoId: activo1.id, etiquetaId: etiqueta1.id));
      final cuestionario = await _db.into(_db.cuestionarios).insertReturning(
          CuestionariosCompanion.insert(
              tipoDeInspeccion: "preoperacional",
              version: 1,
              periodicidadDias: 1,
              estado: EstadoDeCuestionario.borrador,
              subido: false));
      await _db.into(_db.cuestionariosXEtiquetas).insert(
          CuestionariosXEtiquetasCompanion.insert(
              cuestionarioId: cuestionario.id, etiquetaId: etiqueta1.id));

      await _db.sincronizacionDao.setActivos([]);

      expect(await getNroFilas(_db, _db.activos), 0);
      expect(await getNroFilas(_db, _db.etiquetasDeActivo), 1);
      expect(await getNroFilas(_db, _db.activosXEtiquetas), 0);
    });
  });
}
