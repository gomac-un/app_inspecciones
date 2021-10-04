import 'package:dartz/dartz.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/borrador.dart'
    as borr_dom;
import 'package:inspecciones/features/llenado_inspecciones/domain/cuestionario.dart'
    as cuest_dom;
import 'package:inspecciones/features/llenado_inspecciones/domain/inspeccion.dart'
    as insp_dom;
import 'package:inspecciones/features/llenado_inspecciones/domain/modelos.dart'
    as act_dom;
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/infrastructure/tablas_unidas.dart';
import 'package:moor/moor.dart';

part 'borradores_dao.moor.dart';

/// Acceso a los datos de la Bd.
///
/// Incluye los métodos necesarios para  insertar, actualizar, borrar y consultar la información
/// relacionada con las inspecciones y cuestionarios.
@UseDao(tables: [
  /// Definición de las tablas a las que necesitamos acceder para obtener la información
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
  Contratistas,
  Sistemas,
  SubSistemas,
])
class BorradoresDao extends DatabaseAccessor<MoorDatabase>
    with _$BorradoresDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  BorradoresDao(MoorDatabase db) : super(db);

  /// Regresa el total de preguntas respondidas en una inspección con id=[id]
  /// (Se usa en la página de borradores para mostrar el avance)
  Future<int> getTotalRespuesta(int inspeccionId) async {
    final query = await customSelect(
      '''
      SELECT DISTINCT respuestas.pregunta_id  FROM respuestas
      WHERE respuestas.inspeccion_id = $inspeccionId 
      ;''',
    ).map((row) => Respuesta.fromData(row.data, db)).get();
    // Devuelve solo la cantidad
    return query.length;
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
        .map((row) => {
              'activo': row.readTable(activos),
              'inspeccion': row.readTable(inspecciones)
            })
        .watch();

    /// Agrupación del resultado de la consulta en la clase Borrador para manejarlo mejor en la UI
    return borradores.asyncMap<List<borr_dom.Borrador>>(
      (l) async => Future.wait<borr_dom.Borrador>(
        l.map(
          (b) async {
            final inspeccion = b['inspeccion'] as Inspeccion;

            /// Se consulta el cuestionario asociado a cada inspección, para saber de que tipo es
            final cuestionario = await db.getCuestionario(inspeccion);
            return borr_dom.Borrador(
                insp_dom.Inspeccion(
                  id: inspeccion.id,
                  momentoEnvio: inspeccion.momentoEnvio,
                  activo: await getActivoPorId(inspeccion.activoId),
                  estado: insp_dom.EstadoDeInspeccion.values.firstWhere(
                      (element) => element.index == inspeccion.estado.index),
                  esNueva: inspeccion.esNueva,
                  criticidadReparacion: inspeccion.criticidadReparacion,
                  criticidadTotal: inspeccion.criticidadTotal,
                ),
                cuest_dom.Cuestionario(
                    id: cuestionario.id,
                    tipoDeInspeccion: cuestionario.tipoDeInspeccion),

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
  }

  /// Elimina la inspección donde inspeccion.id = [borrador.inspeccion.id] y en cascada las respuestas asociadas
  Future eliminarBorrador(borr_dom.Borrador borrador) async {
    await (delete(inspecciones)
          ..where((ins) => ins.id.equals(borrador.inspeccion.id)))
        .go();
  }

  /// Método usado cuando se envía inspección al server que actualiza el momento de envío y
  /// elimina las respuestas
  Future eliminarRespuestas(Borrador borrador) async {
    /// Se está actualizando en la bd porque para el historial, la inspeccion no se va a borrar del cel
    ///  y se necesita el momento de envio como constancia //TODO: implementar historial
    await (update(inspecciones)
          ..where((i) => i.id.equals(borrador.inspeccion.id)))
        .write(
      InspeccionesCompanion(
        momentoEnvio: Value(DateTime.now()),
      ),
    );

    /// Se eliminan las respuestas porque no es necesario para el historial y
    /// no tiene sentido tenerlas ocupando espacio  en la bd
    await (delete(respuestas)
          ..where((res) => res.inspeccionId.equals(borrador.inspeccion.id)))
        .go();
  }
}

/// TODO: probar esta extension
extension AsyncMappings<E> on Iterable<E> {
  //Iterable<T> map<T>(T toElement(E e)) => MappedIterable<E, T>(this, toElement);
  Future<Iterable<T>> asyncMap<T>(Future<T> Function(E e) toElement) {
    return Future.wait(map((e) => toElement(e)));
  }
}
