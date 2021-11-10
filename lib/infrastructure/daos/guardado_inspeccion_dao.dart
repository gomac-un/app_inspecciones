import 'package:drift/drift.dart';
import 'package:inspecciones/core/error/errors.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/domain.dart'
    as dominio;
import 'package:inspecciones/infrastructure/drift_database.dart';

part 'guardado_inspeccion_dao.drift.dart';

@DriftAccessor(tables: [
  Inspecciones,
  Respuestas,
])
class GuardadoDeInspeccionDao extends DatabaseAccessor<Database>
    with _$GuardadoDeInspeccionDaoMixin {
  GuardadoDeInspeccionDao(Database db) : super(db);

  /// Realiza el guardado de la inspección al presionar el botón guardar o finalizar en el llenado.
  Future<void> guardarInspeccion(
    Iterable<dominio.Pregunta> preguntas,
    dominio.Inspeccion inspeccion,
  ) async {
    return transaction(() async {
      await (update(inspecciones)..where((i) => i.id.equals(inspeccion.id)))
          .write(InspeccionesCompanion(
        momentoBorradorGuardado: Value(inspeccion.momentoBorradorGuardado),
        momentoFinalizacion: Value(inspeccion.momentoFinalizacion),
        estado: Value(inspeccion.estado),
      ));

      await _deleteRespuestas(inspeccion.id);

      /// Se comienza a procesar las respuestas a cada pregunta.
      await Future.forEach<dominio.Pregunta>(preguntas, (pregunta) async {
        //TODO: implementar en un visitor
        if (pregunta is dominio.PreguntaDeSeleccionUnica) {
          await _guardarRespuestaDeSeleccionUnica(pregunta, inspeccion);
        } else if (pregunta is dominio.PreguntaNumerica) {
          final respuesta = pregunta.respuesta!;
          await _guardarRespuesta(
            pregunta.respuesta!.metaRespuesta,
            TipoDeRespuesta.numerica,
            preguntaId: pregunta.id,
            inspeccionId: inspeccion.id,
            valorNumerico: respuesta.respuestaNumerica,
          );
        } else if (pregunta is dominio.PreguntaDeSeleccionMultiple) {
          await _guardarRespuestaDeSeleccionMultiple(pregunta, inspeccion);
        } else if (pregunta is dominio.CuadriculaDeSeleccionUnica) {
          final respuesta = pregunta.respuesta!;
          await _guardarRespuesta(
            pregunta.respuesta!.metaRespuesta,
            TipoDeRespuesta.cuadricula,
            preguntaId: pregunta.id,
            inspeccionId: inspeccion.id,
          );
          for (final subPregunta in respuesta.respuestas) {
            await _guardarRespuestaDeSeleccionUnica(subPregunta, inspeccion);
          }
        } else if (pregunta is dominio.CuadriculaDeSeleccionMultiple) {
          final respuesta = pregunta.respuesta!;
          final respuestaPadre = await _guardarRespuesta(
            pregunta.respuesta!.metaRespuesta,
            TipoDeRespuesta.cuadricula,
            preguntaId: pregunta.id,
            inspeccionId: inspeccion.id,
          );
          for (final subPregunta in respuesta.respuestas) {
            final respuesta = subPregunta.respuesta!;
            await _guardarRespuestaDeSeleccionMultiple(subPregunta, inspeccion);
          }
        } else {
          throw TaggedUnionError(pregunta);
        }
      });
    });
  }

  Future<void> _guardarRespuestaDeSeleccionUnica(
    dominio.PreguntaDeSeleccionUnica pregunta,
    dominio.Inspeccion inspeccion,
  ) {
    final respuesta = pregunta.respuesta!;
    return _guardarRespuesta(
      pregunta.respuesta!.metaRespuesta,
      TipoDeRespuesta.seleccionUnica,
      preguntaId: pregunta.id,
      inspeccionId: inspeccion.id,
      opcionSeleccionada: respuesta.opcionSeleccionada,
    );
  }

  Future<void> _guardarRespuestaDeSeleccionMultiple(
    dominio.PreguntaDeSeleccionMultiple pregunta,
    dominio.Inspeccion inspeccion,
  ) async {
    final respuesta = pregunta.respuesta!;
    final respuestaPadre = await _guardarRespuesta(
      pregunta.respuesta!.metaRespuesta,
      TipoDeRespuesta.seleccionMultiple,
      preguntaId: pregunta.id,
      inspeccionId: inspeccion.id,
    );
    for (final subPregunta in respuesta.opciones) {
      final respuesta = subPregunta.respuesta!;
      await _guardarRespuesta(
        subPregunta.respuesta!.metaRespuesta,
        TipoDeRespuesta.parteDeSeleccionMultiple,
        respuestaMultipleId: respuestaPadre.id,
        opcionRespondida: subPregunta.opcion,
        opcionRespondidaEstaSeleccionada: respuesta.estaSeleccionada,
      );
    }
  }

  Future<Respuesta> _guardarRespuesta(
    dominio.MetaRespuesta metaRespuesta,
    TipoDeRespuesta tipoDeRespuesta, {
    String? preguntaId,
    String? inspeccionId,
    dominio.OpcionDeRespuesta? opcionSeleccionada,
    double? valorNumerico,
    String? respuestaMultipleId,
    dominio.OpcionDeRespuesta? opcionRespondida,
    bool? opcionRespondidaEstaSeleccionada,
  }) =>
      into(respuestas).insertReturning(RespuestasCompanion(
        observacion: Value(metaRespuesta.observaciones),
        reparado: Value(metaRespuesta.reparada),
        observacionReparacion: Value(metaRespuesta.observacionesReparacion),
        momentoRespuesta: Value(metaRespuesta.momentoRespuesta),
        fotosBase: Value(metaRespuesta.fotosBase),
        fotosReparacion: Value(metaRespuesta.fotosReparacion),
        tipoDeRespuesta: Value(tipoDeRespuesta),
        preguntaId: Value(preguntaId),
        inspeccionId: Value(inspeccionId),
        opcionSeleccionadaId: Value(opcionSeleccionada?.id),
        valorNumerico: Value(valorNumerico),
        respuestaMultipleId: Value(respuestaMultipleId),
        opcionRespondidaId: Value(opcionRespondida?.id),
        opcionRespondidaEstaSeleccionada:
            Value(opcionRespondidaEstaSeleccionada),
      ));

  Future<void> _deleteRespuestas(String inspeccionId) =>
      (delete(respuestas)..where((r) => r.inspeccionId.equals(inspeccionId)))
          .go();
}
