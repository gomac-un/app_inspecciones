import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/borrador.dart'
    as borr_dom;
import 'package:inspecciones/features/llenado_inspecciones/domain/cuestionario.dart'
    as cuest_dom;
import 'package:inspecciones/features/llenado_inspecciones/domain/inspeccion.dart'
    as insp_dom;
import 'package:inspecciones/features/llenado_inspecciones/domain/modelos.dart'
    as act_dom;
import 'package:inspecciones/infrastructure/drift_database.dart';

part 'borradores_dao.drift.dart';

@DriftAccessor(tables: [
  Respuestas,
  Inspecciones,
  Activos,
])
class BorradoresDao extends DatabaseAccessor<Database>
    with _$BorradoresDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  BorradoresDao(Database db) : super(db);

  /// Regresa el total de preguntas respondidas en una inspección con id=[id]
  /// (Se usa en la página de borradores para mostrar el avance)
  Future<int> getTotalRespuesta(int inspeccionId) async {
    final query = selectOnly(respuestas, distinct: true)
      ..addColumns([respuestas.preguntaId])
      ..where(respuestas.inspeccionId.equals(inspeccionId));
    final res = await query.map((row) => row.read(respuestas.preguntaId)).get();
    return res.length;
  }

  /// Devuelve [List<Borrador>] con todas las inspecciones que han sido guardadas
  /// para mostrar en la UI en borradores_screen.dart
  Stream<List<borr_dom.Borrador>> borradores(bool toHistoryScreen) {
    final query = select(inspecciones).join([
      innerJoin(activos, activos.id.equalsExp(inspecciones.activoId)),
    ])

      /// Se filtran los que tengan momentoEnvio nulo, esto, porque también están quedando guardadas las enviadas para el historial
      /// y estas no se muestran en la pantalla de borradores.
      ..where(toHistoryScreen
          ? inspecciones.momentoEnvio.isNotNull()
          : inspecciones.momentoEnvio.isNull());
    final borradores = query
        .map((row) => Tuple2<Activo, Inspeccion>(
            row.readTable(activos), row.readTable(inspecciones)))
        .watch();

    /// Agrupación del resultado de la consulta en la clase Borrador para manejarlo mejor en la UI
    return borradores.asyncMap<List<borr_dom.Borrador>>(
      (l) async => Future.wait<borr_dom.Borrador>(
        l.map(
          (b) async {
            final inspeccion = b.value2;

            /// Se consulta el cuestionario asociado a cada inspección, para saber de que tipo es
            final cuestionario = await db.getCuestionario(inspeccion);
            return borr_dom.Borrador(
                insp_dom.Inspeccion(
                  id: inspeccion.id,
                  momentoEnvio: inspeccion.momentoEnvio,
                  activo: await getActivoPorId(inspeccion.activoId),
                  estado: inspeccion.estado,
                  esNueva: inspeccion.esNueva,
                  criticidadReparacion: inspeccion.criticidadReparacion,
                  criticidadTotal: inspeccion.criticidadTotal,
                ),
                cuest_dom.Cuestionario(
                    id: cuestionario.id,
                    tipoDeInspeccion: cuestionario.tipoDeInspeccion!),

                /// Cantidad de preguntas respondidas
                avance: await getTotalRespuesta(inspeccion.id),

                /// Total de preguntas del cuestionario
                total: await db.getTotalPreguntas(cuestionario.id));
          },
        ),
      ),
    );
  }

  Future<act_dom.Activo> getActivoPorId(int id) async {
    final query = select(activos)..where((tbl) => tbl.id.equals(id));
    final activo = await query.getSingle();
    return act_dom.Activo(id: activo.id.toString(), modelo: activo.modelo);
  }

  Future<void> eliminarHistorialEnviados() async {
    //TODO: implement
    throw UnimplementedError();
  }

  /// Elimina la inspección donde inspeccion.id = [borrador.inspeccion.id] y
  /// en cascada las respuestas asociadas
  Future<void> eliminarBorrador(borr_dom.Borrador borrador) async {
    await (delete(inspecciones)
          ..where((ins) => ins.id.equals(borrador.inspeccion.id)))
        .go();
  }

  /// Método usado cuando se envía inspección al server que actualiza el momento de envío y
  /// elimina las respuestas
  Future<void> eliminarRespuestas(int inspeccionId) async {
    /// Se está actualizando en la bd porque para el historial, la inspeccion no se va a borrar del cel
    ///  y se necesita el momento de envio como constancia
    await (update(inspecciones)..where((i) => i.id.equals(inspeccionId))).write(
      InspeccionesCompanion(
        momentoEnvio: Value(DateTime.now()),
      ),
    );

    /// Se eliminan las respuestas porque no es necesario para el historial y
    /// no tiene sentido tenerlas ocupando espacio  en la bd
    await (delete(respuestas)
          ..where((res) => res.inspeccionId.equals(inspeccionId)))
        .go();
  }
}
