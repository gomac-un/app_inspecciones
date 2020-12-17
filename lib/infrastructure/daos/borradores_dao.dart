import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:moor/moor.dart';

part 'borradores_dao.g.dart';

@UseDao(tables: [
  Activos,
  CuestionarioDeModelos,
  Cuestionarios,
  Bloques,
  Titulos,
  CuadriculasDePreguntas,
  Preguntas,
  OpcionesDeRespuesta,
  Inspecciones,
  Respuestas,
  RespuestasXOpcionesDeRespuesta,
  Contratistas,
  Sistemas,
  SubSistemas,
])
class BorradoresDao extends DatabaseAccessor<Database>
    with _$BorradoresDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  BorradoresDao(Database db) : super(db);

  Stream<List<Borrador>> borradores() {
    final query = select(inspecciones).join([
      innerJoin(activos,
          activos.identificador.equalsExp(inspecciones.identificadorActivo)),
    ]);

    return query
        .map((row) =>
            Borrador(row.readTable(activos), row.readTable(inspecciones), null))
        .watch()
        .asyncMap((l) async => Future.wait<Borrador>(l.map(
              (e) async => e.copyWith(
                cuestionarioDeModelo:
                    await db.getCuestionarioDeModelo(e.inspeccion),
              ),
            )));
  }

  Future eliminarBorrador(Borrador borrador) async {
    await (delete(inspecciones)
          ..where((ins) => ins.id.equals(borrador.inspeccion.id)))
        .go();
  }
}
