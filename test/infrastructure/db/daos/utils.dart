import 'package:drift/drift.dart';
import 'package:inspecciones/infrastructure/drift_database.dart';

Future<int> getNroFilas<T extends HasResultSet, R>(
    Database _db, ResultSetImplementation<T, R> t) {
  final count = countAll();
  final query = _db.selectOnly(t)..addColumns([count]);
  return query.map((row) => row.read(count)).getSingle();
}
