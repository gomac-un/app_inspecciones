import 'package:drift/native.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/inspeccion.dart'
    show EstadoDeInspeccion;
import 'package:inspecciones/infrastructure/drift_database.dart';
import 'package:test/test.dart';

void main() {
  late Database _db;

  setUp(() {
    _db = Database(NativeDatabase.memory());
  });

  tearDown(() async {
    await _db.close();
  });

  Future<Cuestionario> _crearCuestionario() =>
      _db.into(_db.cuestionarios).insertReturning(CuestionariosCompanion.insert(
          tipoDeInspeccion: "preoperacional", version: 1, periodicidadDias: 1));

  Future<Activo> _crearActivo() =>
      _db.into(_db.activos).insertReturning(ActivosCompanion.insert(id: "1"));

  group("getCuestionariosDisponiblesParaActivo", () {
    Future<void> _asociarEtiquetaAActivo(
            EtiquetaDeActivo etiqueta, Activo activo) =>
        _db.into(_db.activosXEtiquetas).insert(
            ActivosXEtiquetasCompanion.insert(
                activoId: activo.id, etiquetaId: etiqueta.id));

    Future<EtiquetaDeActivo> _crearEtiqueta(String clave, String valor) =>
        _db.into(_db.etiquetasDeActivo).insertReturning(
            EtiquetasDeActivoCompanion.insert(clave: clave, valor: valor));

    Future<void> _asociarEtiquetaACuestionario(
      EtiquetaDeActivo etiqueta,
      Cuestionario cuestionario,
    ) =>
        _db.into(_db.cuestionariosXEtiquetas).insert(
            CuestionariosXEtiquetasCompanion.insert(
                cuestionarioId: cuestionario.id, etiquetaId: etiqueta.id));

    test('''getCuestionariosDisponiblesParaActivo deberia traer un cuestionario 
        que este asignado la etiqueta del activo''', () async {
      final activo = await _crearActivo();
      final etiqueta = await _crearEtiqueta("modelo", "kenworth");
      await _asociarEtiquetaAActivo(etiqueta, activo);
      final cuestionario = await _crearCuestionario();
      await _asociarEtiquetaACuestionario(etiqueta, cuestionario);

      final res = await _db.cargaDeInspeccionDao
          .getCuestionariosDisponiblesParaActivo(activo.id);

      expect(res.length, 1);
      expect(res.first.tipoDeInspeccion, "preoperacional");
    });

    test('''getCuestionariosDisponiblesParaActivo deberia traer una lista vacía 
          si no hay cuestionarios compatibles con el activo''', () async {
      final activo = await _crearActivo();
      final etiquetaActivo = await _crearEtiqueta("modelo", "kenworth");
      await _asociarEtiquetaAActivo(etiquetaActivo, activo);
      final etiquetaCuestionario = await _crearEtiqueta("modelo", "moto");
      final cuestionario = await _crearCuestionario();
      await _asociarEtiquetaACuestionario(etiquetaCuestionario, cuestionario);

      final res = await _db.cargaDeInspeccionDao
          .getCuestionariosDisponiblesParaActivo(activo.id);

      expect(res.length, 0);
    });

    test('''getCuestionariosDisponiblesParaActivo deberia traer una lista de 
        cuestionarios si varios aplican''', () async {
      final etiqueta = await _crearEtiqueta("modelo", "kenworth");

      final cuestionario1 = await _crearCuestionario();
      await _asociarEtiquetaACuestionario(etiqueta, cuestionario1);
      final cuestionario2 = await _db.into(_db.cuestionarios).insertReturning(
          CuestionariosCompanion.insert(
              tipoDeInspeccion: "general", version: 1, periodicidadDias: 1));
      await _asociarEtiquetaACuestionario(etiqueta, cuestionario2);

      final activo = await _crearActivo();
      await _asociarEtiquetaAActivo(etiqueta, activo);

      final cuestionarios = await _db.cargaDeInspeccionDao
          .getCuestionariosDisponiblesParaActivo(activo.id);

      expect(cuestionarios.length, 2);
      expect(cuestionarios[0].id == cuestionarios[1].id, isFalse);
    });
  });
  group("cargarInspeccion", () {
    Future<Inspeccion> _crearInspeccion(
            Cuestionario cuestionario, Activo activo) =>
        _db.into(_db.inspecciones).insertReturning(
              InspeccionesCompanion.insert(
                id: "1",
                cuestionarioId: cuestionario.id,
                activoId: activo.id,
                inspectorId: "1",
                momentoInicio: DateTime.fromMillisecondsSinceEpoch(0),
                estado: EstadoDeInspeccion.borrador,
              ),
            );
    test(
        "si el cuestionario no tiene bloques, cargarInspeccion debería cargar una inspección vacía",
        () async {
      final cuestionario = await _crearCuestionario();
      final activo = await _crearActivo();
      final res = await _db.cargaDeInspeccionDao.cargarInspeccion(
          cuestionarioId: cuestionario.id,
          activoId: activo.id,
          inspectorId: "1");

      expect(res.value2.length, 0);
    });
  });
}
/*
    test(
        "si la inspeccion no habia sido guardada, cargarInspeccion debería insertar una nueva inspeccion con datos por defecto, un id generado y devolverla",
        () async {
      final activoId2 = await _db
          .into(_db.activos)
          .insert(ActivosCompanion.insert(modelo: "moto"));

      final res = await _db.cargaDeInspeccionDao.cargarInspeccion(
          cuestionarioId: cuestionarioId, activoId: activoId2);
      final inspeccionRes = res.value1;

      expect(inspeccionRes.id.toString(),
          hasLength("yyMMddHHmmss".length + activoId2.toString().length));
      expect(inspeccionRes.id.toString(),
          startsWith("2")); // valido del 2020 al 2030
      expect(inspeccionRes.cuestionarioId, cuestionarioId);
      expect(inspeccionRes.activoId, activoId2);
      expect(inspeccionRes.estado, insp_dom.EstadoDeInspeccion.borrador);
      //TODO: probar el momento de guardado, posiblemente usando el paquete clock
      expect(res.value2.length, 0);
    });
    test(
        "cargarInspeccion debería lanzar una excepcion si se intenta crear una inspeccion con un cuestionarioId inexistente",
        () async {
      await expectLater(
          () => _db.cargaDeInspeccionDao
              .cargarInspeccion(cuestionarioId: 2, activoId: activoId),
          throwsA(isA<SqliteException>()));
    });
    test(
        "cargarInspeccion debería lanzar una excepcion si se intenta crear una inspeccion con un activoId inexistente",
        () async {
      await expectLater(
          () => _db.cargaDeInspeccionDao
              .cargarInspeccion(cuestionarioId: cuestionarioId, activoId: 2),
          throwsA(isA<SqliteException>()));
    });
    test(
        "si el cuestionario solo tiene asociado un titulo, cargarInspeccion debería cargar la inspección con un titulo",
        () async {
      final bloqueId = await _db.into(_db.bloques).insert(
          BloquesCompanion.insert(nOrden: 1, cuestionarioId: cuestionarioId));

      await _db.into(_db.titulos).insert(TitulosCompanion.insert(
          titulo: "titulo", descripcion: "descripcion", bloqueId: bloqueId));

      final res = await _db.cargaDeInspeccionDao
          .cargarInspeccion(cuestionarioId: cuestionarioId, activoId: activoId);

      final inspeccionRes = res.value1;
      final listaBloques = res.value2;

      expect(inspeccionRes.id, inspeccionId);
      expect(listaBloques.length, 1);
      expect(listaBloques.first, isA<tit_dom.Titulo>());
    });

    Future<int> _insertarPregunta(
        [TipoDePregunta tipo = TipoDePregunta.unicaRespuesta]) async {
      final bloqueId = await _db.into(_db.bloques).insert(
          BloquesCompanion.insert(nOrden: 1, cuestionarioId: cuestionarioId));

      return _db.into(_db.preguntas).insert(PreguntasCompanion.insert(
          titulo: "titulo",
          descripcion: "descripcion",
          criticidad: 1,
          bloqueId: bloqueId,
          tipo: tipo));
    }

    test('''si el cuestionario tiene asociada una pregunta de seleccion unica y 
    la inspeccion es nueva, cargarInspeccion debería cargar la pregunta con sus 
    opciones pero sin respuesta''', () async {
      final activoId2 = await _db
          .into(_db.activos)
          .insert(ActivosCompanion.insert(modelo: "moto"));

      final preguntaId = await _insertarPregunta();

      await _db.into(_db.opcionesDeRespuesta).insert(
          OpcionesDeRespuestaCompanion.insert(
              preguntaId: Value(preguntaId), texto: "texto", criticidad: 1));

      final res = await _db.cargaDeInspeccionDao.cargarInspeccion(
          cuestionarioId: cuestionarioId, activoId: activoId2);

      final listaBloques = res.value2;

      expect(listaBloques.length, 1);
      expect(
        listaBloques.first,
        isA<bl_dom.PreguntaDeSeleccionUnica>()
            .having(
              (p) => p.opcionesDeRespuesta,
              "opciones de respuesta",
              hasLength(1),
            )
            .having((p) => p.respuesta, "respuesta", isNull),
      );
    });
    test('''si el cuestionario tiene asociada una pregunta de seleccion unica y 
        la inspeccion ya tiene información guardada, cargarInspeccion debería 
        cargar la pregunta con sus opciones y con la respuesta guardada''',
        () async {
      final preguntaId = await _insertarPregunta();

      final opcionId = await _db.into(_db.opcionesDeRespuesta).insert(
          OpcionesDeRespuestaCompanion.insert(
              preguntaId: Value(preguntaId), texto: "texto", criticidad: 1));

      await _db.into(_db.respuestas).insert(RespuestasCompanion.insert(
            inspeccionId: inspeccionId,
            preguntaId: preguntaId,
            observacion: const Value("observacion"),
            opcionDeRespuestaId: Value(opcionId),
          ));

      final res = await _db.cargaDeInspeccionDao
          .cargarInspeccion(cuestionarioId: cuestionarioId, activoId: activoId);

      final listaBloques = res.value2;

      expect(listaBloques.length, 1);
      expect(
        listaBloques.first,
        isA<bl_dom.PreguntaDeSeleccionUnica>()
            .having(
              (p) => p.opcionesDeRespuesta,
              "opciones de respuesta",
              hasLength(1),
            )
            .having(
              (p) => p.respuesta,
              "respuesta",
              isA<bl_dom.RespuestaDeSeleccionUnica>()
                  .having(
                    (r) => r.opcionSeleccionada!.id,
                    "opcion seleccionada",
                    opcionId,
                  )
                  .having(
                    (r) => r.metaRespuesta.observaciones,
                    "observaciones",
                    "observacion",
                  ),
            ),
      );
    });
    test(
        '''si el cuestionario tiene asociada una pregunta de seleccion multiple y 
        la inspeccion ya tiene información guardada, cargarInspeccion debería 
        cargar la pregunta con sus opciones y con la respuesta guardada''',
        () async {
      final preguntaId = await _insertarPregunta();
      final opcionId = await _db.into(_db.opcionesDeRespuesta).insert(
          OpcionesDeRespuestaCompanion.insert(
              preguntaId: Value(preguntaId), texto: "texto", criticidad: 1));

      await _db.into(_db.respuestas).insert(RespuestasCompanion.insert(
            inspeccionId: inspeccionId,
            preguntaId: preguntaId,
            observacion: const Value("observacion"),
            opcionDeRespuestaId: Value(opcionId),
          ));

      final res = await _db.cargaDeInspeccionDao
          .cargarInspeccion(cuestionarioId: cuestionarioId, activoId: activoId);

      final listaBloques = res.value2;

      expect(listaBloques.length, 1);
      expect(
        listaBloques.first,
        isA<bl_dom.PreguntaDeSeleccionUnica>()
            .having(
              (p) => p.opcionesDeRespuesta,
              "opciones de respuesta",
              hasLength(1),
            )
            .having(
              (p) => p.respuesta,
              "respuesta",
              isA<bl_dom.RespuestaDeSeleccionUnica>()
                  .having(
                    (r) => r.opcionSeleccionada!.id,
                    "opcion seleccionada",
                    opcionId,
                  )
                  .having(
                    (r) => r.metaRespuesta.observaciones,
                    "observaciones",
                    "observacion",
                  ),
            ),
      );
    });
  });
}
*/