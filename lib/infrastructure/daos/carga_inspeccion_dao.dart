import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/domain.dart'
    as dominio;
import 'package:inspecciones/features/llenado_inspecciones/domain/metarespuesta.dart';
import 'package:inspecciones/infrastructure/drift_database.dart';
import 'package:intl/intl.dart';

part 'carga_inspeccion_dao.drift.dart';

@DriftAccessor(tables: [
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
    final query = select(activosXEtiquetas).join([
      innerJoin(etiquetasDeActivo,
          etiquetasDeActivo.id.equalsExp(activosXEtiquetas.etiquetaId)),
    ])
      ..where(activosXEtiquetas.activoId.equals(activoId));

    final etiquetas =
        await query.map((row) => row.readTable(etiquetasDeActivo)).get();

    final query2 = select(cuestionarios, distinct: true).join([
      innerJoin(cuestionariosXEtiquetas,
          cuestionariosXEtiquetas.cuestionarioId.equalsExp(cuestionarios.id),
          useColumns: false),
      innerJoin(etiquetasDeActivo,
          etiquetasDeActivo.id.equalsExp(cuestionariosXEtiquetas.etiquetaId),
          useColumns: false),
    ])
      ..where(etiquetasDeActivo.id.isIn(etiquetas.map((e) => e.id)));

    return query2.map((row) => row.readTable(cuestionarios)).get();
  }

  /// Devuelve todos los bloques de la inspeccion del cuestionario con id=[cuestionarioId] para [activoId]
  ///
  /// Incluye los titulos y las preguntas con sus respectivas opciones de respuesta y respuestas seleccionadas
  Future<Tuple2<dominio.Inspeccion, List<dominio.Bloque>>> cargarInspeccion(
      {required String cuestionarioId,
      required String activoId,
      required String inspectorId}) async {
    final inspeccionExistente = await (select(inspecciones)
          ..where(
            (inspeccion) =>
                inspeccion.cuestionarioId.equals(cuestionarioId) &
                inspeccion.activoId.equals(activoId) &

                /// Para no cargar las que están en el historial
                inspeccion.momentoEnvio.isNull(),
          ))
        .getSingleOrNull();
    //Se crea la inspección si no existe.
    final inspeccion = inspeccionExistente ??
        await _crearInspeccion(
          cuestionarioId: cuestionarioId,
          activoId: activoId,
          inspectorId: inspectorId,
        );
    final inspeccionId = inspeccion.id;

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

    return Tuple2(await _buildInspeccion(inspeccion),
        bloques.map((e) => e.value2).toList());
  }

  Future<dominio.Inspeccion> _buildInspeccion(Inspeccion inspeccion) async =>
      dominio.Inspeccion(
        id: inspeccion.id,
        estado: inspeccion.estado,
        activo: await db.borradoresDao.getActivo(activoId: inspeccion.activoId),
        momentoInicio: inspeccion.momentoInicio,
        momentoBorradorGuardado: inspeccion.momentoBorradorGuardado,
        momentoFinalizacion: inspeccion.momentoFinalizacion,
        momentoEnvio: inspeccion.momentoEnvio,
        inspectorId: inspeccion.inspectorId,
      );

  /// Devuelve la inspección creada al guardarla por primera vez.
  Future<Inspeccion> _crearInspeccion({
    required String cuestionarioId,
    required String activoId,
    required String inspectorId,
  }) async {
    final ins = InspeccionesCompanion.insert(
      id: _generarInspeccionId(activoId),
      cuestionarioId: cuestionarioId,
      activoId: activoId,
      inspectorId: inspectorId,
      momentoInicio: DateTime.now(),
      estado: dominio.EstadoDeInspeccion.borrador,
    );
    return into(inspecciones).insertReturning(ins);
  }

  /// Crea id para una inspección con el formato 'yyMMddHHmmss[activo]'
  String _generarInspeccionId(String activo) {
    final fechaFormateada = DateFormat("yyMMddHHmmss").format(DateTime.now());
    return '$fechaFormateada$activo';
  }

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
      String cuestionarioId, String inspeccionId) async {
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
          inspeccionId,
        ),
      );
    }));
  }

  dominio.PreguntaNumerica _buildPreguntaNumerica(
          List<CriticidadNumerica> criticidadesNumericas,
          Pregunta pregunta,
          List<EtiquetaDePregunta> etiquetas,
          Respuesta? respuesta,
          String inspeccionId) =>
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
        calificable: true,
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
    String inspeccionId,
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
      calificable: true, //TODO: solucionar #19

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
      Pregunta pregunta, String inspeccionId) async {
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
    String inspeccionId,
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
            calificable: false,
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
        calificable: true, //TODO: solucionar #19
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
          String cuestionarioId, String inspeccionId) async {
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
        calificable: true,
        respuesta: respuesta == null
            ? null
            : dominio.RespuestaDeCuadricula(
                _buildMetaRespuesta(respuesta),
                [],
              ),
      );

  Future<List<Tuple2<int, dominio.CuadriculaDeSeleccionMultiple>>>
      _getCuadriculasDeSeleccionMultiple(
          String cuestionarioId, String inspeccionId) async {
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

      return Tuple2(
        bloque.nOrden,
        _buildCuadriculaDeSeleccionMultiple(
          preguntasRespondidas,
          opciones,
          cuadricula,
          etiquetas,
        ),
      );
    }));
  }

  dominio.CuadriculaDeSeleccionMultiple _buildCuadriculaDeSeleccionMultiple(
    List<dominio.PreguntaDeSeleccionMultiple> preguntasRespondidas,
    List<OpcionDeRespuesta> opciones,
    Pregunta cuadricula,
    List<EtiquetaDePregunta> etiquetas,
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
        calificable: true,
      );

  Future<List<Pregunta>> _getPreguntasDeCuadricula(String cuadriculaId) async {
    final query = select(preguntas)
      ..where((p) => p.cuadriculaId.equals(cuadriculaId));
    return query.get();
  }

  /// Devuelve la respuesta a [pregunta] de tipo numerica.
  Future<Respuesta?> _getRespuestaDePregunta(
      Pregunta pregunta, String inspeccionId) {
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

  MetaRespuesta _buildMetaRespuesta(Respuesta respuesta) => MetaRespuesta(
        criticidadInspector: 0,
        observaciones: respuesta.observacion,
        reparada: respuesta.reparado,
        observacionesReparacion: respuesta.observacionReparacion,
        fotosBase: respuesta.fotosBase,
        fotosReparacion: respuesta.fotosReparacion,
      );

  dominio.OpcionDeRespuesta _buildOpcionDeRespuesta(OpcionDeRespuesta opcion) =>
      dominio.OpcionDeRespuesta(
          id: opcion.id,
          titulo: opcion.titulo,
          descripcion: opcion.descripcion,
          criticidad: opcion.criticidad);
}
