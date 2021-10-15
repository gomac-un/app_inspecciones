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
  Bloques,
  Preguntas,
  Cuestionarios,
])
class BorradoresDao extends DatabaseAccessor<Database>
    with _$BorradoresDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  BorradoresDao(Database db) : super(db);

  /// Devuelve [List<Borrador>] con todas las inspecciones que han sido guardadas
  /// para mostrar en la UI en borradores_screen.dart
  Stream<List<borr_dom.Borrador>> borradores({required bool enviadas}) {
    final query = select(inspecciones).join([
      innerJoin(activos, activos.id.equalsExp(inspecciones.activoId)),
      innerJoin(cuestionarios,
          cuestionarios.id.equalsExp(inspecciones.cuestionarioId)),
    ])

      /// Se filtran los que tengan momentoEnvio nulo, esto, porque también están
      /// quedando guardadas las enviadas para el historial
      /// y estas no se muestran en la pantalla de borradores.
      ..where(enviadas
          ? inspecciones.momentoEnvio.isNotNull()
          : inspecciones.momentoEnvio.isNull());
    final borradores = query
        .map((row) => Tuple3<Inspeccion, Activo, Cuestionario>(
              row.readTable(inspecciones),
              row.readTable(activos),
              row.readTable(cuestionarios),
            ))
        .watch();

    /// Agrupación del resultado de la consulta en la clase Borrador para manejarlo mejor en la UI
    return borradores.asyncMap<List<borr_dom.Borrador>>(
      (l) async => Future.wait<borr_dom.Borrador>(
        l.map(
          (b) async {
            final inspeccion = b.value1;
            final cuestionario = b.value3;
            return borr_dom.Borrador(
                insp_dom.Inspeccion(
                  id: inspeccion.id,
                  momentoEnvio: inspeccion.momentoEnvio,
                  activo: await getActivo(inspeccion.activoId),
                  estado: inspeccion.estado,
                  esNueva: inspeccion.esNueva,
                  criticidadReparacion: inspeccion.criticidadReparacion,
                  criticidadTotal: inspeccion.criticidadTotal,
                ),
                cuest_dom.Cuestionario(
                  id: cuestionario.id,
                  tipoDeInspeccion: cuestionario.tipoDeInspeccion!,
                ),

                /// Cantidad de preguntas respondidas
                avance: await _getNroPreguntasRespondidas(inspeccion.id),

                /// Total de preguntas del cuestionario
                total: await _getNroPreguntas(cuestionario.id));
          },
        ),
      ),
    );
  }

  /// Devuelve la cantidad total de preguntas que tiene el cuestionario con id=[cuestionarioId]
  Future<int> _getNroPreguntas(int cuestionarioId) {
    final count = countAll();
    final query = selectOnly(preguntas).join([
      innerJoin(bloques, bloques.id.equalsExp(preguntas.bloqueId)),
    ])
      ..where(bloques.cuestionarioId.equals(cuestionarioId))
      ..addColumns([count]);
    return query.map((row) => row.read(count)).getSingle();
/*
    final bloq = await (select(bloques)
          ..where((b) => b.cuestionarioId.equals(cuestionarioId)))
        .get();
    final bloquesId = bloq.map((e) => e.id).toList();

    /// Va a contar las preguntas cuyos bloques estan en [bloquesId] que son los bloques del cuestionario
    final count = countAll(filter: preguntas.bloqueId.isIn(bloquesId));
    final res = (selectOnly(preguntas)..addColumns([count]))
        .map((row) => row.read(count))
        .getSingle();
    return res;*/
  }

  /// Regresa el total de preguntas respondidas en una inspección con id=[id]
  /// (Se usa en la página de borradores para mostrar el avance)
  Future<int> _getNroPreguntasRespondidas(int inspeccionId) async {
    final count = countAll();
    final query = selectOnly(respuestas)
      ..where(respuestas.inspeccionId.equals(inspeccionId) &
          (respuestas.opcionDeRespuestaId.isNotNull() |
              respuestas.valor.isNotNull()))
      ..addColumns([count]);
    return query.map((row) => row.read(count)).getSingle();
    /*
    final query = selectOnly(respuestas, distinct: true)
      ..addColumns([respuestas.preguntaId])
      ..where(respuestas.inspeccionId.equals(inspeccionId));
    final res = await query.map((row) => row.read(respuestas.preguntaId)).get();
    return res.length;*/
  }

  Future<act_dom.Activo> getActivo(int id) async {
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
