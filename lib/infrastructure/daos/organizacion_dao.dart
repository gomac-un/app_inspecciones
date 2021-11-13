import 'package:drift/drift.dart';
import 'package:inspecciones/features/configuracion_organizacion/domain/entities.dart';
import 'package:inspecciones/infrastructure/drift_database.dart';

part 'organizacion_dao.drift.dart';

@DriftAccessor(tables: [
  EtiquetasDeActivo,
  Activos,
  ActivosXEtiquetas,
])
class OrganizacionDao extends DatabaseAccessor<Database>
    with _$OrganizacionDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  OrganizacionDao(Database db) : super(db);

  Future<List<ActivoEnLista>> getActivos() async {
    final activosInsertados = await select(activos).get();
    return Future.wait(
      activosInsertados.map(
        (a) async => ActivoEnLista(
          a.id,
          await db.utilsDao
              .getEtiquetasDeActivo(activoId: a.id)
              .then((l) => l.map((e) => Etiqueta(e.clave, e.valor)).toList()),
        ),
      ),
    );
  }
}
