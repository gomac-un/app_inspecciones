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
      innerJoin(activos, activos.id.equalsExp(inspecciones.activoId)),
    ]);

    return query
        .map((row) =>
            Borrador(row.readTable(activos), row.readTable(inspecciones), null))
        .watch()
        .asyncMap<List<Borrador>>((l) async => Future.wait<Borrador>(l.map(
              (b) async => b.copyWith(
                cuestionario: await db.getCuestionario(b.inspeccion),
              ),
            )));
  }

  Future eliminarBorrador(Borrador borrador) async {
    await (delete(inspecciones)
          ..where((ins) => ins.id.equals(borrador.inspeccion.id)))
        .go();
  }

  Stream<List<Cuestionario>> getCuestionarios() =>
      select(cuestionarios).watch();

  Future eliminarCuestionario(Cuestionario cuestionario) async {
    await (delete(cuestionarios)..where((c) => c.id.equals(cuestionario.id)))
        .go();
  }
}
