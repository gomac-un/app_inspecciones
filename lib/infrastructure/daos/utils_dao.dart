import 'package:drift/drift.dart';
import 'package:inspecciones/infrastructure/drift_database.dart';

part 'utils_dao.drift.dart';

@DriftAccessor(tables: [
  EtiquetasDeActivo,
  ActivosXEtiquetas,
])
class UtilsDao extends DatabaseAccessor<Database> with _$UtilsDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  UtilsDao(Database db) : super(db);

  Future<List<EtiquetaDeActivo>> getEtiquetasDeActivo(
      {required String activoId}) async {
    final query = select(activosXEtiquetas).join([
      innerJoin(etiquetasDeActivo,
          etiquetasDeActivo.id.equalsExp(activosXEtiquetas.etiquetaId)),
    ])
      ..where(activosXEtiquetas.activoId.equals(activoId));

    return query.map((row) => row.readTable(etiquetasDeActivo)).get();
  }
}
