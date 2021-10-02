import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';

final appRepositoryProvider =
    Provider((ref) => AppRepository(ref.watch(moorDatabaseProvider)));

class AppRepository {
  final MoorDatabase db;

  AppRepository(this.db);

  Future<void> limpiarDatosLocales() => db.limpiezaBD();
}
