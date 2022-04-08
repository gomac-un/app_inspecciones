import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/domain.dart'
    as dominio;
import 'package:inspecciones/infrastructure/drift_database.dart';

part 'borradores_dao.g.dart';

@DriftAccessor(tables: [
  EtiquetasDeActivo,
  Activos,
  ActivosXEtiquetas,
  Cuestionarios,
  Inspecciones,
  Bloques,
  Preguntas,
  OpcionesDeRespuesta,
  Respuestas,
])
class BorradoresDao extends DatabaseAccessor<Database>
    with _$BorradoresDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  BorradoresDao(Database db) : super(db);

  /// Devuelve [List<Borrador>] con todas las inspecciones que han sido guardadas
  /// para mostrar en la UI en borradores_screen.dart
  Stream<List<dominio.Borrador>> borradores(
      {required bool mostrarSoloEnviadas}) {
    final query = select(inspecciones).join([
      innerJoin(cuestionarios,
          cuestionarios.id.equalsExp(inspecciones.cuestionarioId))
    ])

      /// Se filtran los que tengan momentoEnvio nulo, esto, porque también están
      /// quedando guardadas las enviadas para el historial
      /// y estas no se muestran en la pantalla de borradores.
      ..where(mostrarSoloEnviadas
          ? inspecciones.momentoEnvio.isNotNull()
          : inspecciones.momentoEnvio.isNull());
    final borradores = query
        .map((row) => Tuple2<Inspeccion, Cuestionario>(
              row.readTable(inspecciones),
              row.readTable(cuestionarios),
            ))
        .watch();

    /// Agrupación del resultado de la consulta en la clase Borrador para manejarlo mejor en la UI
    return borradores.asyncMap<List<dominio.Borrador>>(
      (l) async => Future.wait<dominio.Borrador>(
        l.map(
          (b) async {
            final inspeccion = b.value1;
            final cuestionario = b.value2;
            return dominio.Borrador(
              dominio.Inspeccion(
                  id: inspeccion.id,
                  estado: inspeccion.estado,
                  activo: await buildActivo(activoId: inspeccion.activoId),
                  momentoInicio: inspeccion.momentoInicio,
                  momentoEnvio: inspeccion.momentoEnvio,
                  momentoBorradorGuardado: inspeccion.momentoBorradorGuardado,
                  criticidadCalculada: inspeccion.criticidadCalculada,
                  criticidadCalculadaConReparaciones:
                      inspeccion.criticidadCalculadaConReparaciones,
                  avance: inspeccion.avance,
                  esNueva: inspeccion.esNueva),
              dominio.Cuestionario(
                id: cuestionario.id,
                tipoDeInspeccion: cuestionario.tipoDeInspeccion,
              ),
              //TODO: guardar esta variable para no tener que calcularla siempre, si no cuando se guarde
              avance: inspeccion.avance,
            );
          },
        ),
      ),
    );
  }

  /*
  Future<double> _calcCriticidadInspeccion({
    required String cuestionarioId,
    required String inspeccionId,
    required bool conReparaciones,
  }) {
    // Solo se calculan las criticidades de preguntas de unica respuesta
    //TODO: calcular criticidad de todos los tipos de pregunta
    final criticidadPregunta = preguntas.criticidad;
    final criticidadRespuesta =
        coalesce<int>([opcionesDeRespuesta.criticidad, const Constant(0)]);

    final reparacion =
        (Variable(conReparaciones) & respuestas.reparado).caseMatch(when: {
      const Constant(true): const Constant(0),
      const Constant(false): const Constant(1),
    });
    final criticidadCalculada =
        criticidadPregunta * criticidadRespuesta * reparacion;
    final query = selectOnly(bloques).join([
      innerJoin(preguntas, preguntas.bloqueId.equalsExp(bloques.id),
          useColumns: false),
      innerJoin(respuestas, respuestas.preguntaId.equalsExp(preguntas.id),
          useColumns: false),
      leftOuterJoin(
        opcionesDeRespuesta,
        opcionesDeRespuesta.id.equalsExp(respuestas.opcionSeleccionadaId),
        useColumns: false,
      ),
    ])
      ..where(
        bloques.cuestionarioId.equals(cuestionarioId) &
            respuestas.inspeccionId.equals(inspeccionId),
      )
      ..addColumns([criticidadCalculada]);

    return query
        .map((row) => row.read(criticidadCalculada))
        .get()
        .then((l) => l.fold<double>(0, (p, c) => p + (c ?? 0)));
  }
  */

  Future<dominio.Activo> buildActivo({required String activoId}) async {
    final activoQuery = select(activos)
      ..where(
          (activo) => activo.id.equals(activoId) | activo.pk.equals(activoId));
    final activo = await activoQuery.getSingle();
    final etiquetas =
        await db.utilsDao.getEtiquetasDeActivo(activoId: activoId);

    return dominio.Activo(
        pk: activo.pk,
        id: activo.id,
        etiquetas:
            etiquetas.map((e) => dominio.Etiqueta(e.clave, e.valor)).toList());
  }

  /// Elimina la inspección donde inspeccion.id = [borrador.inspeccion.id] y
  /// en cascada las respuestas asociadas
  Future<void> eliminarBorrador(dominio.Borrador borrador) async {
    await (delete(inspecciones)
          ..where((ins) => ins.id.equals(borrador.inspeccion.id)))
        .go();
  }

  /// Método usado cuando se envía inspección al server que actualiza el momento de envío y
  /// elimina las respuestas
  Future<void> eliminarRespuestas({required String inspeccionId}) async {
    /// Se está actualizando en la bd porque para el historial, la inspeccion no se va a borrar del cel
    ///  y se necesita el momento de envio como constancia
    await (update(inspecciones)..where((i) => i.id.equals(inspeccionId))).write(
      InspeccionesCompanion(
        momentoEnvio: Value(DateTime.now()),
      ),
    ); //TODO: esta accion se debe hacer en el procedimiento de envio

    /// Se eliminan las respuestas porque no es necesario para el historial y
    /// no tiene sentido tenerlas ocupando espacio  en la bd
    await (delete(respuestas)
          ..where((res) => res.inspeccionId.equals(inspeccionId)))
        .go(); //TODO: tener en cuenta las respuestas hijas de una cuadricula
  }

  Future<void> eliminarHistorialEnviados() async {
    //TODO: implement
    throw UnimplementedError();
  }
}
