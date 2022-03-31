import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/domain.dart'
    as dominio;
import 'package:inspecciones/infrastructure/drift_database.dart';

part 'carga_inspeccion_dao.g.dart';

@DriftAccessor(tables: [
  Activos,
  EtiquetasDeActivo,
  ActivosXEtiquetas,
  Cuestionarios,
  CuestionariosXEtiquetas,
  Inspecciones,
  Bloques,
  Titulos,
  EtiquetasDePregunta,
  PreguntasXEtiquetas,
  Preguntas,
  CriticidadesNumericas,
  OpcionesDeRespuesta,
  Respuestas,
])
class CargaDeInspeccionDao extends DatabaseAccessor<Database>
    with _$CargaDeInspeccionDaoMixin {
  CargaDeInspeccionDao(Database db) : super(db);

  Future<List<Cuestionario>> getCuestionariosDisponiblesParaActivo(
      String activoId) async {
    final etiquetas =
        await db.utilsDao.getEtiquetasDeActivo(activoId: activoId);

    final query2 = select(cuestionarios, distinct: true).join([
      innerJoin(cuestionariosXEtiquetas,
          cuestionariosXEtiquetas.cuestionarioId.equalsExp(cuestionarios.id),
          useColumns: false),
      innerJoin(etiquetasDeActivo,
          etiquetasDeActivo.id.equalsExp(cuestionariosXEtiquetas.etiquetaId),
          useColumns: false),
    ])
      ..where(
        cuestionarios.estado.equalsValue(EstadoDeCuestionario.finalizado) &
            etiquetasDeActivo.id.isIn(etiquetas.map((e) => e.id)),
      );

    return query2.map((row) => row.readTable(cuestionarios)).get();
  }

  /// Devuelve todos los bloques de la inspeccion del cuestionario con id=[cuestionarioId] para [activoId]
  ///
  /// Incluye los titulos y las preguntas con sus respectivas opciones de respuesta y respuestas seleccionadas
  Future<dominio.CuestionarioInspeccionado> cargarInspeccion({
    required String cuestionarioId,
    required String activoId,
  }) async {
    final inspeccion = await _getInspeccion(
        cuestionarioId: cuestionarioId, activoId: activoId);

    final inspeccionId = inspeccion?.id;

    final titulos = await _getTitulos(cuestionarioId);

    final numericas =
        await _getPreguntasNumericas(cuestionarioId, inspeccionId);

    final preguntasSeleccionUnica =
        await _getPreguntasDeSeleccionUnica(cuestionarioId, inspeccionId);

    final preguntasSeleccionMultiple =
        await _getPreguntasDeSeleccionMultiple(cuestionarioId, inspeccionId);

    final cuadriculasDeSeleccionUnica =
        await _getCuadriculasDeSeleccionUnica(cuestionarioId, inspeccionId);

    final cuadriculasDeSeleccionMultiple =
        await _getCuadriculasDeSeleccionMultiple(cuestionarioId, inspeccionId);

    final bloques = [
      ...titulos,
      ...preguntasSeleccionUnica,
      ...preguntasSeleccionMultiple,
      ...cuadriculasDeSeleccionUnica,
      ...cuadriculasDeSeleccionMultiple,
      ...numericas,
    ];
    bloques.sort((a, b) => a.value1.compareTo(b.value1));

    return dominio.CuestionarioInspeccionado(
      await _getCuestionario(cuestionarioId),
      inspeccion == null
          ? await _buildInspeccionNueva(activoId: activoId)
          : await _buildInspeccionExistente(inspeccion),
      bloques.map((e) => e.value2).toList(),
    );
  }

  Future<Inspeccion?> _getInspeccion(
      {required String cuestionarioId, required String activoId}) async {
    final activoQuery = select(activos)
      ..where((activo) => activo.id.equals(activoId));
    final activo = await activoQuery.getSingle();
    return (select(inspecciones)
          ..where(
            (inspeccion) =>
                inspeccion.cuestionarioId.equals(cuestionarioId) &
                inspeccion.activoId.equals(activo.pk) &

                /// Para no cargar las que están en el historial
                inspeccion.momentoEnvio.isNull(),
          ))
        .getSingleOrNull();
  }

  Future<dominio.Cuestionario> _getCuestionario(String cuestionarioId) {
    return (select(cuestionarios)
          ..where((cuestionario) => cuestionario.id.equals(cuestionarioId)))
        .map((c) => dominio.Cuestionario(
            id: c.id, tipoDeInspeccion: c.tipoDeInspeccion))
        .getSingle();
  }

  Future<dominio.Inspeccion> _buildInspeccionNueva(
          {required String activoId}) async =>
      dominio.Inspeccion(
        estado: dominio.EstadoDeInspeccion.borrador,
        activo: await db.borradoresDao.buildActivo(activoId: activoId),
        momentoInicio: DateTime.now(),
        criticidadCalculada: 0,
        criticidadCalculadaConReparaciones: 0,
      );

  Future<dominio.Inspeccion> _buildInspeccionExistente(
          Inspeccion inspeccion) async =>
      dominio.Inspeccion(
        id: inspeccion.id,
        estado: inspeccion.estado,
        activo:
            await db.borradoresDao.buildActivo(activoId: inspeccion.activoId),
        momentoInicio: inspeccion.momentoInicio,
        momentoBorradorGuardado: inspeccion.momentoBorradorGuardado,
        momentoFinalizacion: inspeccion.momentoFinalizacion,
        momentoEnvio: inspeccion.momentoEnvio,
        criticidadCalculada: inspeccion.criticidadCalculada,
        criticidadCalculadaConReparaciones:
            inspeccion.criticidadCalculadaConReparaciones,
      );

  /// Devuelve los titulos que pertenecen al cuestionario
  Future<List<Tuple2<int, dominio.Titulo>>> _getTitulos(
      String cuestionarioId) async {
    final query = select(titulos).join([
      innerJoin(bloques, bloques.id.equalsExp(titulos.bloqueId)),
    ])
      ..where(bloques.cuestionarioId.equals(cuestionarioId));
    return query.map((row) {
      final bloque = row.readTable(bloques);
      final titulo = row.readTable(titulos);
      return Tuple2<int, dominio.Titulo>(
        bloque.nOrden,
        _buildTitulo(titulo),
      );
    }).get();
  }

  dominio.Titulo _buildTitulo(Titulo titulo) => dominio.Titulo(
        titulo: titulo.titulo,
        descripcion: titulo.descripcion,
        fotosGuia: [],
      );

  /// Devuelve las preguntas numericas de la inspección, con la respuesta que
  /// se haya insertado y las criticidadesNumericas (rangos de criticidad)
  Future<List<Tuple2<int, dominio.PreguntaNumerica>>> _getPreguntasNumericas(
      String cuestionarioId, String? inspeccionId) async {
    final res =
        await _getPreguntasDeTipo(cuestionarioId, TipoDePregunta.numerica);

    return Future.wait(res.map((e) async {
      final bloque = e.value1;
      final pregunta = e.value2;
      final criticidadesNumericas =
          await _getCriticidadesNumericas(pregunta.id);
      final etiquetas = await _getEtiquetasDePregunta(pregunta.id);
      final respuesta = await _getRespuestaDePregunta(
        pregunta,
        inspeccionId,
      );
      return Tuple2(
        bloque.nOrden,
        _buildPreguntaNumerica(
          criticidadesNumericas,
          pregunta,
          etiquetas,
          respuesta,
        ),
      );
    }));
  }

  dominio.PreguntaNumerica _buildPreguntaNumerica(
          List<CriticidadNumerica> criticidadesNumericas,
          Pregunta pregunta,
          List<EtiquetaDePregunta> etiquetas,
          Respuesta? respuesta) =>
      dominio.PreguntaNumerica(
        criticidadesNumericas
            .map((c) => dominio.RangoDeCriticidad(
                c.valorMinimo, c.valorMaximo, c.criticidad))
            .toList(),
        pregunta.unidades!,
        id: pregunta.id,
        titulo: pregunta.titulo,
        descripcion: pregunta.descripcion,
        fotosGuia: pregunta.fotosGuia,
        criticidad: pregunta.criticidad,
        etiquetas:
            etiquetas.map((e) => dominio.Etiqueta(e.clave, e.valor)).toList(),
        respuesta: respuesta == null
            ? null
            : dominio.RespuestaNumerica(
                _buildMetaRespuesta(respuesta),
                respuestaNumerica: respuesta.valorNumerico,
              ),
      );

  Future<List<CriticidadNumerica>> _getCriticidadesNumericas(
      String preguntaId) async {
    final query = select(criticidadesNumericas)
      ..where((c) => c.preguntaId.equals(preguntaId));
    return query.get();
  }

  Future<List<Tuple2<int, dominio.PreguntaDeSeleccionUnica>>>
      _getPreguntasDeSeleccionUnica(
    String cuestionarioId,
    String? inspeccionId,
  ) async {
    final res = await _getPreguntasDeTipo(
        cuestionarioId, TipoDePregunta.seleccionUnica);

    return Future.wait(res.map((e) async {
      final bloque = e.value1;
      final pregunta = e.value2;
      final opciones = await _getOpcionesDeRespuesta(pregunta.id);
      final etiquetas = await _getEtiquetasDePregunta(pregunta.id);
      final respuesta =
          await _getRespuestaDeSeleccionUnica(pregunta, inspeccionId);
      return Tuple2(
          bloque.nOrden,
          _buildPreguntaDeSeleccionUnica(
            pregunta,
            opciones,
            etiquetas,
            respuesta,
          ));
    }));
  }

  dominio.PreguntaDeSeleccionUnica _buildPreguntaDeSeleccionUnica(
    Pregunta pregunta,
    List<OpcionDeRespuesta> opciones,
    List<EtiquetaDePregunta> etiquetas,
    Tuple2<Respuesta, OpcionDeRespuesta?>? respuesta,
  ) {
    final listaOpciones =
        opciones.map((e) => _buildOpcionDeRespuesta(e)).toList();
    return dominio.PreguntaDeSeleccionUnica(
      listaOpciones,
      id: pregunta.id,
      titulo: pregunta.titulo,
      descripcion: pregunta.descripcion,
      fotosGuia: pregunta.fotosGuia,
      criticidad: pregunta.criticidad,
      etiquetas:
          etiquetas.map((e) => dominio.Etiqueta(e.clave, e.valor)).toList(),
      respuesta: respuesta == null
          ? null
          : dominio.RespuestaDeSeleccionUnica(
              _buildMetaRespuesta(respuesta.value1),
              listaOpciones.firstWhereOrNull(
                  (opcion) => opcion.id == respuesta.value2?.id),
            ),
    );
  }

  Future<Tuple2<Respuesta, OpcionDeRespuesta?>?> _getRespuestaDeSeleccionUnica(
      Pregunta pregunta, String? inspeccionId) async {
    if (inspeccionId == null) return null;

    final query = select(respuestas).join([
      leftOuterJoin(
        opcionesDeRespuesta,
        opcionesDeRespuesta.id.equalsExp(respuestas.opcionSeleccionadaId),
      ),
    ])
      ..where(
        respuestas.preguntaId.equals(pregunta.id) &
            respuestas.inspeccionId.equals(inspeccionId),
      );
    final res = await query
        .map((row) => Tuple2(
              row.readTable(respuestas),
              row.readTableOrNull(opcionesDeRespuesta),
            ))
        .getSingleOrNull();

    return res;
  }

  Future<List<Tuple2<int, dominio.PreguntaDeSeleccionMultiple>>>
      _getPreguntasDeSeleccionMultiple(
    String cuestionarioId,
    String? inspeccionId,
  ) async {
    final res = await _getPreguntasDeTipo(
        cuestionarioId, TipoDePregunta.seleccionMultiple);

    return Future.wait(res.map((e) async {
      final bloque = e.value1;
      final pregunta = e.value2;
      final opciones = await _getOpcionesDeRespuesta(pregunta.id);
      final etiquetas = await _getEtiquetasDePregunta(pregunta.id);
      final respuesta = await _getRespuestaDePregunta(pregunta, inspeccionId);
      final subRespuestas =
          await _getSubRespuestasDeSeleccionMultiple(respuesta);
      return Tuple2(
          bloque.nOrden,
          _buildPreguntaDeSeleccionMultiple(
            pregunta,
            opciones,
            etiquetas,
            respuesta,
            subRespuestas,
          ));
    }));
  }

  dominio.PreguntaDeSeleccionMultiple _buildPreguntaDeSeleccionMultiple(
    Pregunta pregunta,
    List<OpcionDeRespuesta> opciones,
    List<EtiquetaDePregunta> etiquetas,
    Respuesta? respuesta,
    List<Respuesta> subRespuestas,
  ) =>
      dominio.PreguntaDeSeleccionMultiple(
        opciones.map((opcion) => _buildOpcionDeRespuesta(opcion)).toList(),
        opciones.map((op) {
          final respuesta = subRespuestas
              .firstWhereOrNull((s) => op.id == s.opcionRespondidaId);
          return dominio.SubPreguntaDeSeleccionMultiple(
            _buildOpcionDeRespuesta(op),
            id: "", // no aplica la id porque esta pregunta no existe en la bd, es generada a partir de la opcion de respuesta
            titulo: op.titulo,
            descripcion: op.descripcion,
            fotosGuia: [],
            criticidad: op.criticidad,
            etiquetas: [],
            respuesta: respuesta == null
                ? null
                : dominio.SubRespuestaDeSeleccionMultiple(
                    _buildMetaRespuesta(respuesta),
                    estaSeleccionada:
                        respuesta.opcionRespondidaEstaSeleccionada!),
          );
        }).toList(),
        id: pregunta.id,
        criticidad: pregunta.criticidad,
        etiquetas:
            etiquetas.map((e) => dominio.Etiqueta(e.clave, e.valor)).toList(),
        titulo: pregunta.titulo,
        descripcion: pregunta.descripcion,
        fotosGuia: pregunta.fotosGuia,
        respuesta: respuesta == null
            ? null
            : dominio.RespuestaDeSeleccionMultiple(
                _buildMetaRespuesta(respuesta),
                [],
              ),
      );

  Future<List<Respuesta>> _getSubRespuestasDeSeleccionMultiple(
      Respuesta? respuestaMultiplePadre) async {
    if (respuestaMultiplePadre == null) return [];
    final query = select(respuestas)
      ..where((r) => r.respuestaMultipleId.equals(respuestaMultiplePadre.id));
    return query.get();
  }

  Future<List<Tuple2<int, dominio.CuadriculaDeSeleccionUnica>>>
      _getCuadriculasDeSeleccionUnica(
          String cuestionarioId, String? inspeccionId) async {
    final query = select(preguntas).join([
      innerJoin(bloques, bloques.id.equalsExp(preguntas.bloqueId)),
    ])
      ..where(bloques.cuestionarioId.equals(cuestionarioId) &
          preguntas.tipoDePregunta.equalsValue(TipoDePregunta.cuadricula) &
          preguntas.tipoDeCuadricula
              .equalsValue(TipoDeCuadricula.seleccionUnica));
    final res = await query
        .map((row) => Tuple2(
              row.readTable(bloques),
              row.readTable(preguntas),
            ))
        .get();

    return Future.wait(res.map((e) async {
      final bloque = e.value1;
      final cuadricula = e.value2;
      final opciones = await _getOpcionesDeRespuesta(cuadricula.id);
      final etiquetas = await _getEtiquetasDePregunta(cuadricula.id);
      final preguntas = await _getPreguntasDeCuadricula(cuadricula.id);
      final preguntasRespondidas =
          await Future.wait(preguntas.map((pregunta) async {
        final respuesta =
            await _getRespuestaDeSeleccionUnica(pregunta, inspeccionId);
        return _buildPreguntaDeSeleccionUnica(
          pregunta,
          opciones,
          [],
          respuesta,
        );
      }));
      final respuesta = await _getRespuestaDePregunta(cuadricula, inspeccionId);

      return Tuple2(
        bloque.nOrden,
        _buildCuadriculaDeSeleccionUnica(
          preguntasRespondidas,
          opciones,
          cuadricula,
          etiquetas,
          respuesta,
        ),
      );
    }));
  }

  dominio.CuadriculaDeSeleccionUnica _buildCuadriculaDeSeleccionUnica(
    List<dominio.PreguntaDeSeleccionUnica> preguntasRespondidas,
    List<OpcionDeRespuesta> opciones,
    Pregunta cuadricula,
    List<EtiquetaDePregunta> etiquetas,
    Respuesta? respuesta,
  ) =>
      dominio.CuadriculaDeSeleccionUnica(
        preguntasRespondidas,
        opciones.map((o) => _buildOpcionDeRespuesta(o)).toList(),
        id: cuadricula.id,
        titulo: cuadricula.titulo,
        descripcion: cuadricula.descripcion,
        fotosGuia: cuadricula.fotosGuia,
        criticidad: cuadricula.criticidad,
        etiquetas:
            etiquetas.map((e) => dominio.Etiqueta(e.clave, e.valor)).toList(),
        respuesta: respuesta == null
            ? null
            : dominio.RespuestaDeCuadricula(
                _buildMetaRespuesta(respuesta),
                [],
              ),
      );

  Future<List<Tuple2<int, dominio.CuadriculaDeSeleccionMultiple>>>
      _getCuadriculasDeSeleccionMultiple(
          String cuestionarioId, String? inspeccionId) async {
    final query = select(preguntas).join([
      innerJoin(bloques, bloques.id.equalsExp(preguntas.bloqueId)),
    ])
      ..where(bloques.cuestionarioId.equals(cuestionarioId) &
          preguntas.tipoDePregunta.equalsValue(TipoDePregunta.cuadricula) &
          preguntas.tipoDeCuadricula
              .equalsValue(TipoDeCuadricula.seleccionMultiple));
    final res = await query
        .map((row) => Tuple2(
              row.readTable(bloques),
              row.readTable(preguntas),
            ))
        .get();

    return Future.wait(res.map((e) async {
      final bloque = e.value1;
      final cuadricula = e.value2;
      final opciones = await _getOpcionesDeRespuesta(cuadricula.id);
      final etiquetas = await _getEtiquetasDePregunta(cuadricula.id);
      final preguntas = await _getPreguntasDeCuadricula(cuadricula.id);
      final preguntasRespondidas =
          await Future.wait(preguntas.map((pregunta) async {
        final respuesta = await _getRespuestaDePregunta(pregunta, inspeccionId);
        final subRespuestas =
            await _getSubRespuestasDeSeleccionMultiple(respuesta);
        return _buildPreguntaDeSeleccionMultiple(
          pregunta,
          opciones,
          [],
          respuesta,
          subRespuestas,
        );
      }));
      final respuesta = await _getRespuestaDePregunta(cuadricula, inspeccionId);
      return Tuple2(
        bloque.nOrden,
        _buildCuadriculaDeSeleccionMultiple(
          preguntasRespondidas,
          opciones,
          cuadricula,
          etiquetas,
          respuesta,
        ),
      );
    }));
  }

  dominio.CuadriculaDeSeleccionMultiple _buildCuadriculaDeSeleccionMultiple(
    List<dominio.PreguntaDeSeleccionMultiple> preguntasRespondidas,
    List<OpcionDeRespuesta> opciones,
    Pregunta cuadricula,
    List<EtiquetaDePregunta> etiquetas,
    Respuesta? respuesta,
  ) =>
      dominio.CuadriculaDeSeleccionMultiple(
        preguntasRespondidas,
        opciones.map((o) => _buildOpcionDeRespuesta(o)).toList(),
        id: cuadricula.id,
        titulo: cuadricula.titulo,
        descripcion: cuadricula.descripcion,
        fotosGuia: cuadricula.fotosGuia,
        criticidad: cuadricula.criticidad,
        etiquetas:
            etiquetas.map((e) => dominio.Etiqueta(e.clave, e.valor)).toList(),
        respuesta: respuesta == null
            ? null
            : dominio.RespuestaDeCuadricula(
                _buildMetaRespuesta(respuesta),
                [],
              ),
      );

  Future<List<Pregunta>> _getPreguntasDeCuadricula(String cuadriculaId) async {
    final query = select(preguntas)
      ..where((p) => p.cuadriculaId.equals(cuadriculaId));
    return query.get();
  }

  /// Devuelve la respuesta a [pregunta] de tipo numerica.
  Future<Respuesta?> _getRespuestaDePregunta(
      Pregunta pregunta, String? inspeccionId) async {
    if (inspeccionId == null) return null;
    final query = select(respuestas)
      ..where(
        (u) =>
            u.preguntaId.equals(pregunta.id) &
            u.inspeccionId.equals(inspeccionId),
      );

    return query.getSingleOrNull();
  }

  Future<List<OpcionDeRespuesta>> _getOpcionesDeRespuesta(String preguntaId) {
    final query = select(opcionesDeRespuesta)
      ..where((o) => o.preguntaId.equals(preguntaId));
    return query.get();
  }

  Future<List<EtiquetaDePregunta>> _getEtiquetasDePregunta(String preguntaId) {
    final query = select(preguntasXEtiquetas).join([
      innerJoin(etiquetasDePregunta,
          etiquetasDePregunta.id.equalsExp(preguntasXEtiquetas.etiquetaId))
    ])
      ..where(preguntasXEtiquetas.preguntaId.equals(preguntaId));
    return query.map((row) => row.readTable(etiquetasDePregunta)).get();
  }

  Future<List<Tuple2<Bloque, Pregunta>>> _getPreguntasDeTipo(
      String cuestionarioId, TipoDePregunta tipo) {
    final query = select(preguntas).join([
      innerJoin(
        bloques,
        bloques.id.equalsExp(preguntas.bloqueId),
      ),
    ])
      ..where(bloques.cuestionarioId.equals(cuestionarioId) &
          preguntas.tipoDePregunta.equalsValue(tipo));

    return query
        .map((row) => Tuple2(
              row.readTable(bloques),
              row.readTable(preguntas),
            ))
        .get();
  }

  dominio.MetaRespuesta _buildMetaRespuesta(Respuesta respuesta) =>
      dominio.MetaRespuesta(
        observaciones: respuesta.observacion,
        reparada: respuesta.reparado,
        observacionesReparacion: respuesta.observacionReparacion,
        fotosBase: respuesta.fotosBase,
        fotosReparacion: respuesta.fotosReparacion,
        momentoRespuesta: respuesta.momentoRespuesta,
        criticidadDelInspector: respuesta.criticidadDelInspector,
        criticidadCalculada: respuesta
            .criticidadCalculada, // en realidad no se necesita en la carga, solo en el guardado
        criticidadCalculadaConReparaciones: respuesta
            .criticidadCalculadaConReparaciones, // en realidad no se necesita en la carga, solo en el guardado
      );

  dominio.OpcionDeRespuesta _buildOpcionDeRespuesta(OpcionDeRespuesta opcion) =>
      dominio.OpcionDeRespuesta(
          id: opcion.id,
          titulo: opcion.titulo,
          descripcion: opcion.descripcion,
          criticidad: opcion.criticidad,
          requiereCriticidadDelInspector:
              opcion.requiereCriticidadDelInspector);
}
