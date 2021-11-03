import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:inspecciones/infrastructure/drift_database.dart';
import 'package:test/test.dart';

void main() {
  late Database _db;

  setUp(() {
    _db = Database(
      NativeDatabase.memory(),
    );
  });

  tearDown(() async {
    await _db.close();
  });

  test('''se pueden crear activos''', () async {
    await _db.into(_db.activos).insert(ActivosCompanion.insert(id: "1"));
  });
  test('''se pueden crear etiquetas''', () async {
    await _db.into(_db.etiquetasDeActivo).insert(
        EtiquetasDeActivoCompanion.insert(clave: "modelo", valor: "2020"));
  });
  test('''no se pueden crear dos etiquetas con la misma natural key''',
      () async {
    await _db.into(_db.etiquetasDeActivo).insert(
        EtiquetasDeActivoCompanion.insert(clave: "modelo", valor: "2020"));
    await expectLater(
        () => _db.into(_db.etiquetasDeActivo).insert(
            EtiquetasDeActivoCompanion.insert(clave: "modelo", valor: "2020")),
        throwsA(isA<SqliteException>().having((e) => e.message,
            "unique violation", contains("UNIQUE constraint failed"))));
  });
  test('''se pueden asociar activos con etiquetas''', () async {
    final activo = await _db
        .into(_db.activos)
        .insertReturning(ActivosCompanion.insert(id: "1"));
    final etiqueta = await _db.into(_db.etiquetasDeActivo).insertReturning(
        EtiquetasDeActivoCompanion.insert(clave: "modelo", valor: "2020"));
    await _db.into(_db.activosXEtiquetas).insert(
        ActivosXEtiquetasCompanion.insert(
            activoId: activo.id, etiquetaId: etiqueta.id));
  });
  test('''no se puede asociar un activo con una etiqueta inexistente''',
      () async {
    final activo = await _db
        .into(_db.activos)
        .insertReturning(ActivosCompanion.insert(id: "1"));
    await expectLater(
        () => _db.into(_db.activosXEtiquetas).insert(
            ActivosXEtiquetasCompanion.insert(
                activoId: activo.id, etiquetaId: 99)),
        throwsA(isA<SqliteException>().having((e) => e.message,
            "foreign key error", contains("FOREIGN KEY constraint failed"))));
  });
  test('''no se puede asociar un activo inexistente a una etiqueta''',
      () async {
    final etiqueta = await _db.into(_db.etiquetasDeActivo).insertReturning(
        EtiquetasDeActivoCompanion.insert(clave: "modelo", valor: "2020"));
    await expectLater(
        () => _db.into(_db.activosXEtiquetas).insert(
            ActivosXEtiquetasCompanion.insert(
                activoId: "999", etiquetaId: etiqueta.id)),
        throwsA(isA<SqliteException>().having((e) => e.message,
            "foreign key error", contains("FOREIGN KEY constraint failed"))));
  });
  test('''las asociaciones se borran en cascada con el activo''', () async {
    final activo = await _db
        .into(_db.activos)
        .insertReturning(ActivosCompanion.insert(id: "1"));
    final etiqueta = await _db.into(_db.etiquetasDeActivo).insertReturning(
        EtiquetasDeActivoCompanion.insert(clave: "modelo", valor: "2020"));
    await _db.into(_db.activosXEtiquetas).insert(
        ActivosXEtiquetasCompanion.insert(
            activoId: activo.id, etiquetaId: etiqueta.id));

    var count = countAll();
    final etiquetas1 = await (_db.selectOnly(_db.activosXEtiquetas)..addColumns([count]))
        .map((row) => row.read(count))
        .getSingle();
    expect(etiquetas1, 1);
    final activosBorrados = await (_db.delete(_db.activos)
          ..where((a) => a.id.equals(activo.id)))
        .go();
    expect(activosBorrados, 1);
    final etiquetas2 = await (_db.selectOnly(_db.activosXEtiquetas)..addColumns([count]))
        .map((row) => row.read(count))
        .getSingle();
    expect(etiquetas2, 0);
  });
}
