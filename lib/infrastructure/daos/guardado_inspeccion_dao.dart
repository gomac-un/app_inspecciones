import 'package:drift/drift.dart';
import 'package:inspecciones/core/error/errors.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/domain.dart'
    as dominio;
import 'package:inspecciones/infrastructure/drift_database.dart';
import 'package:intl/intl.dart';

part 'guardado_inspeccion_dao.g.dart';

@DriftAccessor(tables: [
  Inspecciones,
  Respuestas,
  Activos,
])
class GuardadoDeInspeccionDao extends DatabaseAccessor<Database>
    with _$GuardadoDeInspeccionDaoMixin {
  GuardadoDeInspeccionDao(Database db) : super(db);

  /// Realiza el guardado de la inspección al presionar el botón guardar o finalizar en el llenado.
  Future<void> guardarInspeccion(
    List<dominio.Pregunta> preguntas,
    dominio.CuestionarioInspeccionado inspeccionForm,
  ) async {
    return transaction(() async {
      final estado = inspeccionForm.inspeccion.estado;
      final inspeccion = await _getOrCreateInspeccion(
        cuestionarioId: inspeccionForm.cuestionario.id,
        inspeccionDominio: inspeccionForm.inspeccion,
      );
      await (update(inspecciones)..where((i) => i.id.equals(inspeccion.id)))
          .write(InspeccionesCompanion(
        momentoBorradorGuardado: Value(DateTime.now()),
        momentoFinalizacion: Value(
            estado == dominio.EstadoDeInspeccion.finalizada
                ? DateTime.now()
                : null),
        estado: Value(estado),
        criticidadCalculada:
            Value(inspeccionForm.inspeccion.criticidadCalculada),
        criticidadCalculadaConReparaciones:
            Value(inspeccionForm.inspeccion.criticidadCalculadaConReparaciones),
      ));

      await _deleteRespuestas(inspeccion.id);

      for (final pregunta in preguntas) {
        //TODO: implementar en un visitor
        if (pregunta is dominio.PreguntaDeSeleccionUnica) {
          await _guardarRespuestaDeSeleccionUnica(pregunta, inspeccion.id);
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
          await _guardarRespuestaDeSeleccionMultiple(pregunta, inspeccion.id);
        } else if (pregunta is dominio.CuadriculaDeSeleccionUnica) {
          final respuesta = pregunta.respuesta!;
          await _guardarRespuesta(
            pregunta.respuesta!.metaRespuesta,
            TipoDeRespuesta.cuadricula,
            preguntaId: pregunta.id,
            inspeccionId: inspeccion.id,
          );
          for (final subPregunta in respuesta.respuestas) {
            await _guardarRespuestaDeSeleccionUnica(subPregunta, inspeccion.id);
          }
        } else if (pregunta is dominio.CuadriculaDeSeleccionMultiple) {
          final respuesta = pregunta.respuesta!;
          await _guardarRespuesta(
            pregunta.respuesta!.metaRespuesta,
            TipoDeRespuesta.cuadricula,
            preguntaId: pregunta.id,
            inspeccionId: inspeccion.id,
          );
          for (final subPregunta in respuesta.respuestas) {
            await _guardarRespuestaDeSeleccionMultiple(
                subPregunta, inspeccion.id);
          }
        } else {
          throw TaggedUnionError(pregunta);
        }
      }
    });
  }

  Future<Inspeccion> _getOrCreateInspeccion({
    required String cuestionarioId,
    required dominio.Inspeccion inspeccionDominio,
  }) async {
    final inspeccionExistente = await (select(inspecciones)
          ..where(
            (i) =>
                i.cuestionarioId.equals(cuestionarioId) &
                i.activoId.equals(inspeccionDominio.activo.pk) &

                /// Para no cargar las que están en el historial
                i.momentoEnvio.isNull(),
          ))
        .getSingleOrNull();
    //Se crea la inspección si no existe.
    return inspeccionExistente ??
        await _crearInspeccion(
          cuestionarioId: cuestionarioId,
          inspeccionDominio: inspeccionDominio,
        );
  }

  /// Devuelve la inspección creada al guardarla por primera vez.
  Future<Inspeccion> _crearInspeccion({
    required String cuestionarioId,
    required dominio.Inspeccion inspeccionDominio,
  }) async {
    final activoQuery = select(activos)
      ..where((activo) => activo.id.equals(inspeccionDominio.activo.id));
    final activo = await activoQuery.getSingle();
    final ins = InspeccionesCompanion.insert(
      id: _generarInspeccionId(inspeccionDominio.activo.id),
      cuestionarioId: cuestionarioId,
      activoId: activo.pk,
      momentoInicio: inspeccionDominio.momentoInicio,
      estado: inspeccionDominio.estado,
      criticidadCalculada: inspeccionDominio.criticidadCalculada,
      criticidadCalculadaConReparaciones:
          inspeccionDominio.criticidadCalculadaConReparaciones,
    );
    return into(inspecciones).insertReturning(ins);
  }

  /// Crea id para una inspección con el formato 'yyMMddHHmmss[activo]'
  String _generarInspeccionId(String activo) {
    final fechaFormateada = DateFormat("yyMMddHHmmss").format(DateTime.now());
    return '$fechaFormateada$activo';
  }

  Future<void> _guardarRespuestaDeSeleccionUnica(
    dominio.PreguntaDeSeleccionUnica pregunta,
    String inspeccionId,
  ) {
    final respuesta = pregunta.respuesta!;
    return _guardarRespuesta(
      pregunta.respuesta!.metaRespuesta,
      TipoDeRespuesta.seleccionUnica,
      preguntaId: pregunta.id,
      inspeccionId: inspeccionId,
      opcionSeleccionada: respuesta.opcionSeleccionada,
    );
  }

  Future<void> _guardarRespuestaDeSeleccionMultiple(
    dominio.PreguntaDeSeleccionMultiple pregunta,
    String inspeccionId,
  ) async {
    final respuesta = pregunta.respuesta!;
    final respuestaPadre = await _guardarRespuesta(
      pregunta.respuesta!.metaRespuesta,
      TipoDeRespuesta.seleccionMultiple,
      preguntaId: pregunta.id,
      inspeccionId: inspeccionId,
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
        criticidadDelInspector: Value(metaRespuesta.criticidadDelInspector),
        criticidadCalculada: Value(metaRespuesta.criticidadCalculada),
        criticidadCalculadaConReparaciones:
            Value(metaRespuesta.criticidadCalculadaConReparaciones),
      ));

  Future<void> _deleteRespuestas(String inspeccionId) =>
      (delete(respuestas)..where((r) => r.inspeccionId.equals(inspeccionId)))
          .go();
}
