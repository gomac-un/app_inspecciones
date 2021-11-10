import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/domain.dart'
    as dominio;
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
          tipoDeInspeccion: "preoperacional",
          version: 1,
          periodicidadDias: 1,
          estado: EstadoDeCuestionario.finalizado));

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
              tipoDeInspeccion: "general",
              version: 1,
              periodicidadDias: 1,
              estado: EstadoDeCuestionario.finalizado));
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
    test('''si el cuestionario no tiene bloques, cargarInspeccion debería cargar
        una inspección vacía''', () async {
      final cuestionario = await _crearCuestionario();
      final activo = await _crearActivo();
      final res = await _db.cargaDeInspeccionDao.cargarInspeccion(
          cuestionarioId: cuestionario.id,
          activoId: activo.id,
          inspectorId: "1");

      expect(res.value2.length, 0);
    });

    test('''si la inspeccion no habia sido guardada, cargarInspeccion debería 
        insertar una nueva inspeccion con datos por defecto, un id generado y 
        devolverla''', () async {
      final cuestionario = await _crearCuestionario();
      final activo = await _crearActivo();

      final res = await _db.cargaDeInspeccionDao.cargarInspeccion(
          cuestionarioId: cuestionario.id,
          activoId: activo.id,
          inspectorId: "1");

      final inspeccion = res.value1;

      expect(inspeccion.id.toString(),
          hasLength("yyMMddHHmmss".length + activo.id.toString().length));
      expect(
          inspeccion.id.toString(), startsWith("2")); // valido del 2020 al 2030
      expect(inspeccion.activo.id, activo.id);
      expect(inspeccion.estado, dominio.EstadoDeInspeccion.borrador);
      //TODO: probar el momento de guardado, posiblemente usando el paquete clock
      expect(res.value2.length, 0);
    });

    test(
        '''cargarInspeccion debería lanzar una excepcion si se intenta crear una
         inspeccion con un cuestionarioId inexistente''', () async {
      final activo = await _crearActivo();
      await expectLater(
          () => _db.cargaDeInspeccionDao.cargarInspeccion(
              cuestionarioId: "noexiste",
              activoId: activo.id,
              inspectorId: "1"),
          throwsA(isA<SqliteException>()));
    });

    test(
        '''cargarInspeccion debería lanzar una excepcion si se intenta crear una
         inspeccion con un activoId inexistente''', () async {
      final cuestionario = await _crearCuestionario();
      await expectLater(
          () => _db.cargaDeInspeccionDao.cargarInspeccion(
              cuestionarioId: cuestionario.id,
              activoId: "noexiste",
              inspectorId: "1"),
          throwsA(isA<SqliteException>()));
    });

    test('''si el cuestionario solo tiene asociado un titulo, cargarInspeccion
         debería cargar la inspección con un titulo''', () async {
      final cuestionario = await _crearCuestionario();
      final activo = await _crearActivo();

      final bloque = await _db.into(_db.bloques).insertReturning(
          BloquesCompanion.insert(nOrden: 1, cuestionarioId: cuestionario.id));

      final titulo =
          await _db.into(_db.titulos).insertReturning(TitulosCompanion.insert(
                bloqueId: bloque.id,
                titulo: "titulo",
                descripcion: "descripcion",
                fotos: [],
              ));

      final res = await _db.cargaDeInspeccionDao.cargarInspeccion(
          cuestionarioId: cuestionario.id,
          activoId: activo.id,
          inspectorId: "1");

      final listaBloques = res.value2;

      expect(listaBloques.length, 1);
      expect(listaBloques.first, isA<dominio.Titulo>());
    });

    Future<Pregunta> _agregarPreguntaDeSeleccionUnica(
        Cuestionario cuestionario) async {
      final bloque = await _db.into(_db.bloques).insertReturning(
          BloquesCompanion.insert(nOrden: 1, cuestionarioId: cuestionario.id));

      return _db.into(_db.preguntas).insertReturning(PreguntasCompanion.insert(
          titulo: "titulo",
          descripcion: "descripcion",
          criticidad: 1,
          fotosGuia: [],
          bloqueId: Value(bloque.id),
          tipoDePregunta: TipoDePregunta.seleccionUnica));
    }

    test('''si el cuestionario tiene asociada una pregunta de seleccion unica y 
    la inspeccion es nueva, cargarInspeccion debería cargar la pregunta con sus 
    opciones pero sin respuesta''', () async {
      final cuestionario = await _crearCuestionario();
      final activo = await _crearActivo();
      final pregunta = await _agregarPreguntaDeSeleccionUnica(cuestionario);

      await _db.into(_db.opcionesDeRespuesta).insert(
          OpcionesDeRespuestaCompanion.insert(
              titulo: "opcion",
              descripcion: "descripcion",
              criticidad: 1,
              preguntaId: pregunta.id));

      final res = await _db.cargaDeInspeccionDao.cargarInspeccion(
          cuestionarioId: cuestionario.id,
          activoId: activo.id,
          inspectorId: "1");

      final listaBloques = res.value2;

      expect(listaBloques.length, 1);
      expect(
        listaBloques.first,
        isA<dominio.PreguntaDeSeleccionUnica>()
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
      final cuestionario = await _crearCuestionario();
      final activo = await _crearActivo();
      final pregunta = await _agregarPreguntaDeSeleccionUnica(cuestionario);

      final opcion = await _db.into(_db.opcionesDeRespuesta).insertReturning(
          OpcionesDeRespuestaCompanion.insert(
              titulo: "opcion",
              descripcion: "descripcion",
              criticidad: 1,
              preguntaId: pregunta.id));

      final inspeccion = await _db
          .into(_db.inspecciones)
          .insertReturning(InspeccionesCompanion.insert(
            id: "123",
            cuestionarioId: cuestionario.id,
            activoId: activo.id,
            inspectorId: "1",
            momentoInicio: DateTime.fromMillisecondsSinceEpoch(0),
            estado: dominio.EstadoDeInspeccion.borrador,
          ));

      await _db.into(_db.respuestas).insert(RespuestasCompanion.insert(
            observacion: "observacion",
            reparado: false,
            observacionReparacion: "",
            momentoRespuesta: Value(DateTime.fromMillisecondsSinceEpoch(0)),
            fotosBase: [],
            fotosReparacion: [],
            tipoDeRespuesta: TipoDeRespuesta.seleccionUnica,
            preguntaId: Value(pregunta.id),
            inspeccionId: Value(inspeccion.id),
            opcionSeleccionadaId: Value(opcion.id),
          ));

      final res = await _db.cargaDeInspeccionDao.cargarInspeccion(
          cuestionarioId: cuestionario.id,
          activoId: activo.id,
          inspectorId: "1");

      final listaBloques = res.value2;

      expect(listaBloques.length, 1);
      expect(
        listaBloques.first,
        isA<dominio.PreguntaDeSeleccionUnica>()
            .having(
              (p) => p.opcionesDeRespuesta,
              "opciones de respuesta",
              hasLength(1),
            )
            .having(
              (p) => p.respuesta,
              "respuesta",
              isA<dominio.RespuestaDeSeleccionUnica>()
                  .having(
                    (r) => r.opcionSeleccionada!.id,
                    "opcion seleccionada",
                    opcion.id,
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
        la inspeccion no tiene información guardada, cargarInspeccion debería 
        cargar la pregunta con sus subpreguntas sin respuestas''', () async {
      final cuestionario = await _crearCuestionario();
      final activo = await _crearActivo();

      final bloque = await _db.into(_db.bloques).insertReturning(
          BloquesCompanion.insert(nOrden: 1, cuestionarioId: cuestionario.id));

      final pregunta = await _db.into(_db.preguntas).insertReturning(
          PreguntasCompanion.insert(
              titulo: "titulo",
              descripcion: "descripcion",
              criticidad: 1,
              fotosGuia: [],
              bloqueId: Value(bloque.id),
              tipoDePregunta: TipoDePregunta.seleccionMultiple));

      final opcion = await _db.into(_db.opcionesDeRespuesta).insertReturning(
          OpcionesDeRespuestaCompanion.insert(
              titulo: "opcion",
              descripcion: "descripcion",
              criticidad: 1,
              preguntaId: pregunta.id));

      final res = await _db.cargaDeInspeccionDao.cargarInspeccion(
          cuestionarioId: cuestionario.id,
          activoId: activo.id,
          inspectorId: "1");

      final listaBloques = res.value2;

      expect(listaBloques.length, 1);
      expect(
        listaBloques.first,
        isA<dominio.PreguntaDeSeleccionMultiple>()
            .having(
              (p) => p.opcionesDeRespuesta,
              "opciones de respuesta",
              hasLength(1),
            )
            .having((p) => p.respuesta, "sin respuesta padre", isNull)
            .having((p) => p.respuestas.length, "respuestas", 1)
            .having((p) => p.respuestas.first.opcion.id, "opcion", opcion.id)
            .having(
                (p) => p.respuestas.first.respuesta, "subrespuesta", isNull),
      );
    });

    test(
        '''si el cuestionario tiene asociada una pregunta de seleccion multiple y 
        la inspeccion ya tiene información guardada, cargarInspeccion debería 
        cargar la pregunta con sus opciones y con la respuesta guardada''',
        () async {
      final cuestionario = await _crearCuestionario();
      final activo = await _crearActivo();

      final bloque = await _db.into(_db.bloques).insertReturning(
          BloquesCompanion.insert(nOrden: 1, cuestionarioId: cuestionario.id));

      final pregunta = await _db.into(_db.preguntas).insertReturning(
          PreguntasCompanion.insert(
              titulo: "titulo",
              descripcion: "descripcion",
              criticidad: 1,
              fotosGuia: [],
              bloqueId: Value(bloque.id),
              tipoDePregunta: TipoDePregunta.seleccionMultiple));

      final opcion = await _db.into(_db.opcionesDeRespuesta).insertReturning(
          OpcionesDeRespuestaCompanion.insert(
              titulo: "opcion",
              descripcion: "descripcion",
              criticidad: 1,
              preguntaId: pregunta.id));

      final inspeccion = await _db
          .into(_db.inspecciones)
          .insertReturning(InspeccionesCompanion.insert(
            id: "123",
            cuestionarioId: cuestionario.id,
            activoId: activo.id,
            inspectorId: "1",
            momentoInicio: DateTime.fromMillisecondsSinceEpoch(0),
            estado: dominio.EstadoDeInspeccion.borrador,
          ));

      final respuestaMultiple = await _db
          .into(_db.respuestas)
          .insertReturning(RespuestasCompanion.insert(
            observacion: "observacion",
            reparado: false,
            observacionReparacion: "",
            momentoRespuesta: Value(DateTime.fromMillisecondsSinceEpoch(0)),
            fotosBase: [],
            fotosReparacion: [],
            tipoDeRespuesta: TipoDeRespuesta.seleccionMultiple,
            preguntaId: Value(pregunta.id),
            inspeccionId: Value(inspeccion.id),
          ));

      final subRespuesta = await _db
          .into(_db.respuestas)
          .insertReturning(RespuestasCompanion.insert(
            observacion: "observacion subrespuesta",
            reparado: false,
            observacionReparacion: "",
            momentoRespuesta: Value(DateTime.fromMillisecondsSinceEpoch(0)),
            fotosBase: [],
            fotosReparacion: [],
            tipoDeRespuesta: TipoDeRespuesta.parteDeSeleccionMultiple,
            respuestaMultipleId: Value(respuestaMultiple.id),
            opcionRespondidaId: Value(opcion.id),
            opcionRespondidaEstaSeleccionada: const Value(true),
          ));

      final res = await _db.cargaDeInspeccionDao.cargarInspeccion(
          cuestionarioId: cuestionario.id,
          activoId: activo.id,
          inspectorId: "1");

      final listaBloques = res.value2;

      expect(listaBloques.length, 1);
      expect(
        listaBloques.first,
        isA<dominio.PreguntaDeSeleccionMultiple>()
            .having(
              (p) => p.opcionesDeRespuesta,
              "opciones de respuesta",
              hasLength(1),
            )
            .having((p) => p.respuesta!.metaRespuesta.observaciones,
                "observaciones padre", "observacion")
            .having((p) => p.respuestas.length, "respuestas", 1)
            .having((p) => p.respuestas.first.opcion.id, "opcion", opcion.id)
            .having((p) => p.respuestas.first.respuesta!.estaSeleccionada,
                "seleccionada", true)
            .having(
                (p) =>
                    p.respuestas.first.respuesta!.metaRespuesta.observaciones,
                "observacion",
                "observacion subrespuesta"),
      );
    });

    test(
        '''si el cuestionario tiene asociada una cuadricula de seleccion unica y 
        la inspeccion no tiene información guardada, cargarInspeccion debería 
        cargar la cuadricula con sus subpreguntas sin respuestas''', () async {
      final cuestionario = await _crearCuestionario();
      final activo = await _crearActivo();

      final bloque = await _db.into(_db.bloques).insertReturning(
          BloquesCompanion.insert(nOrden: 1, cuestionarioId: cuestionario.id));

      final cuadricula = await _db
          .into(_db.preguntas)
          .insertReturning(PreguntasCompanion.insert(
            titulo: "titulo",
            descripcion: "descripcion",
            criticidad: 1,
            fotosGuia: [],
            bloqueId: Value(bloque.id),
            tipoDePregunta: TipoDePregunta.cuadricula,
            tipoDeCuadricula: const Value(TipoDeCuadricula.seleccionUnica),
          ));

      final opcion = await _db.into(_db.opcionesDeRespuesta).insertReturning(
          OpcionesDeRespuestaCompanion.insert(
              titulo: "opcion",
              descripcion: "descripcion",
              criticidad: 1,
              preguntaId: cuadricula.id));

      final subPregunta = await _db
          .into(_db.preguntas)
          .insertReturning(PreguntasCompanion.insert(
            titulo: "subpregunta",
            descripcion: "descripcion subpregunta",
            criticidad: 1,
            fotosGuia: [],
            cuadriculaId: Value(cuadricula.id),
            tipoDePregunta: TipoDePregunta.parteDeCuadricula,
          ));

      final res = await _db.cargaDeInspeccionDao.cargarInspeccion(
          cuestionarioId: cuestionario.id,
          activoId: activo.id,
          inspectorId: "1");

      final listaBloques = res.value2;

      expect(listaBloques.length, 1);
      expect(
        listaBloques.first,
        isA<dominio.CuadriculaDeSeleccionUnica>()
            .having(
              (p) => p.opcionesDeRespuesta,
              "opciones de respuesta",
              hasLength(1),
            )
            .having((p) => p.opcionesDeRespuesta.first.id, "opcion", opcion.id)
            .having((p) => p.respuesta, "sin respuesta padre", isNull)
            .having((p) => p.preguntas.length, "subpreguntas", 1)
            .having(
                (p) => p.preguntas.first.titulo, "titulo sub", "subpregunta")
            .having((p) => p.preguntas.first.respuesta, "subrespuesta", isNull),
      );
    });
    test(
        '''si el cuestionario tiene asociada una cuadricula de seleccion simple y 
        la inspeccion tiene información guardada, cargarInspeccion debería 
        cargar la cuadricula con sus subpreguntas y respuestas''', () async {
      final cuestionario = await _crearCuestionario();
      final activo = await _crearActivo();

      final bloque = await _db.into(_db.bloques).insertReturning(
          BloquesCompanion.insert(nOrden: 1, cuestionarioId: cuestionario.id));

      final cuadricula = await _db
          .into(_db.preguntas)
          .insertReturning(PreguntasCompanion.insert(
            titulo: "titulo",
            descripcion: "descripcion",
            criticidad: 1,
            fotosGuia: [],
            bloqueId: Value(bloque.id),
            tipoDePregunta: TipoDePregunta.cuadricula,
            tipoDeCuadricula: const Value(TipoDeCuadricula.seleccionUnica),
          ));

      final opcion = await _db.into(_db.opcionesDeRespuesta).insertReturning(
          OpcionesDeRespuestaCompanion.insert(
              titulo: "opcion",
              descripcion: "descripcion",
              criticidad: 1,
              preguntaId: cuadricula.id));

      final subPregunta = await _db
          .into(_db.preguntas)
          .insertReturning(PreguntasCompanion.insert(
            titulo: "subpregunta",
            descripcion: "descripcion subpregunta",
            criticidad: 1,
            fotosGuia: [],
            cuadriculaId: Value(cuadricula.id),
            tipoDePregunta: TipoDePregunta.parteDeCuadricula,
          ));

      final inspeccion = await _db
          .into(_db.inspecciones)
          .insertReturning(InspeccionesCompanion.insert(
            id: "123",
            cuestionarioId: cuestionario.id,
            activoId: activo.id,
            inspectorId: "1",
            momentoInicio: DateTime.fromMillisecondsSinceEpoch(0),
            estado: dominio.EstadoDeInspeccion.borrador,
          ));

      final respuestaCuadricula = await _db
          .into(_db.respuestas)
          .insertReturning(RespuestasCompanion.insert(
            observacion: "observacion cuadricula",
            reparado: false,
            observacionReparacion: "observacion reparacion",
            momentoRespuesta: Value(DateTime.fromMillisecondsSinceEpoch(0)),
            fotosBase: [],
            fotosReparacion: [],
            tipoDeRespuesta: TipoDeRespuesta.cuadricula,
            preguntaId: Value(cuadricula.id),
            inspeccionId: Value(inspeccion.id),
          ));

      final subRespuestaCuadricula = await _db
          .into(_db.respuestas)
          .insertReturning(RespuestasCompanion.insert(
            observacion: "observacion subrespuesta",
            reparado: false,
            observacionReparacion: "",
            momentoRespuesta: Value(DateTime.fromMillisecondsSinceEpoch(0)),
            fotosBase: [],
            fotosReparacion: [],
            tipoDeRespuesta: TipoDeRespuesta.seleccionUnica,
            preguntaId: Value(subPregunta.id),
            inspeccionId: Value(inspeccion.id),
            opcionSeleccionadaId: Value(opcion.id),
          ));

      final res = await _db.cargaDeInspeccionDao.cargarInspeccion(
          cuestionarioId: cuestionario.id,
          activoId: activo.id,
          inspectorId: "1");

      final listaBloques = res.value2;

      expect(listaBloques.length, 1);
      expect(
        listaBloques.first,
        isA<dominio.CuadriculaDeSeleccionUnica>()
            .having(
              (p) => p.opcionesDeRespuesta,
              "opciones de respuesta",
              hasLength(1),
            )
            .having((p) => p.opcionesDeRespuesta.first.id, "opcion", opcion.id)
            .having((p) => p.respuesta!.metaRespuesta.observaciones,
                "respuesta padre", "observacion cuadricula")
            .having((p) => p.preguntas.length, "subpreguntas", 1)
            .having(
                (p) => p.preguntas.first.titulo, "titulo sub", "subpregunta")
            .having((p) => p.preguntas.first.respuesta!.opcionSeleccionada!.id,
                "subrespuesta", opcion.id),
      );
    });
    test('''si el cuestionario tiene asociada una pregunta de numerica y 
    la inspeccion es nueva, cargarInspeccion debería cargar la pregunta
     sin respuesta''', () async {
      final cuestionario = await _crearCuestionario();
      final activo = await _crearActivo();

      final bloque = await _db.into(_db.bloques).insertReturning(
          BloquesCompanion.insert(nOrden: 1, cuestionarioId: cuestionario.id));

      final pregunta = await _db
          .into(_db.preguntas)
          .insertReturning(PreguntasCompanion.insert(
            titulo: "titulo",
            descripcion: "descripcion",
            criticidad: 1,
            fotosGuia: [],
            bloqueId: Value(bloque.id),
            tipoDePregunta: TipoDePregunta.numerica,
            unidades: const Value("metros"),
          ));

      final rangoDeCriticidad = await _db
          .into(_db.criticidadesNumericas)
          .insertReturning(CriticidadesNumericasCompanion.insert(
            valorMinimo: 10,
            valorMaximo: 20,
            criticidad: 1,
            preguntaId: pregunta.id,
          ));

      final res = await _db.cargaDeInspeccionDao.cargarInspeccion(
          cuestionarioId: cuestionario.id,
          activoId: activo.id,
          inspectorId: "1");

      final listaBloques = res.value2;

      expect(listaBloques.length, 1);
      expect(
        listaBloques.first,
        isA<dominio.PreguntaNumerica>()
            .having(
              (p) => p.rangosDeCriticidad,
              "rangos de criticidad",
              hasLength(1),
            )
            .having(
                (p) => p.rangosDeCriticidad.first.inicio, "inicio rango", 10)
            .having((p) => p.respuesta, "respuesta", isNull),
      );
    });
    //TODO: probar las cuadriculas de seleccion multiple
  });
}
