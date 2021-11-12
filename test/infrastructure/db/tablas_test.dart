import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:inspecciones/core/enums.dart';
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

  Future<Activo> _crearActivo() =>
      _db.into(_db.activos).insertReturning(ActivosCompanion.insert(id: "1"));
  test('''no se pueden crear dos etiquetas con la misma natural key''',
      () async {
    await _db.into(_db.etiquetasDeActivo).insert(
        EtiquetasDeActivoCompanion.insert(clave: "modelo", valor: "2020"));
    await expectLater(
        () => _db.into(_db.etiquetasDeActivo).insert(
            EtiquetasDeActivoCompanion.insert(clave: "modelo", valor: "2020")),
        throwsA(isA<SqliteException>().having((e) => e.message,
            "unique violation", contains("UNIQUE constraint failed"))));
  });
  test('''se pueden asociar activos con etiquetas''', () async {
    final activo = await _crearActivo();
    final etiqueta = await _db.into(_db.etiquetasDeActivo).insertReturning(
        EtiquetasDeActivoCompanion.insert(clave: "modelo", valor: "2020"));
    await _db.into(_db.activosXEtiquetas).insert(
        ActivosXEtiquetasCompanion.insert(
            activoId: activo.id, etiquetaId: etiqueta.id));
  });
  test('''no se puede asociar un activo con una etiqueta inexistente''',
      () async {
    final activo = await _crearActivo();
    await expectLater(
        () => _db.into(_db.activosXEtiquetas).insert(
            ActivosXEtiquetasCompanion.insert(
                activoId: activo.id, etiquetaId: 99)),
        throwsA(isA<SqliteException>().having((e) => e.message,
            "foreign key error", contains("FOREIGN KEY constraint failed"))));
  });
  test('''no se puede asociar un activo dos veces con una etiqueta''',
      () async {
    final activo = await _crearActivo();

    final etiqueta1 = await _db.into(_db.etiquetasDeActivo).insertReturning(
        EtiquetasDeActivoCompanion.insert(clave: "modelo", valor: "2020"));

    final asociacion1 = await _db.into(_db.activosXEtiquetas).insertReturning(
        ActivosXEtiquetasCompanion.insert(
            activoId: activo.id, etiquetaId: etiqueta1.id));

    await expectLater(
        () => _db.into(_db.activosXEtiquetas).insert(
            ActivosXEtiquetasCompanion.insert(
                activoId: activo.id, etiquetaId: etiqueta1.id)),
        throwsA(isA<SqliteException>().having((e) => e.message,
            "unique violation", contains("UNIQUE constraint failed"))));
  });
  test('''no se puede asociar un activo inexistente a una etiqueta''',
      () async {
    final etiqueta = await _db.into(_db.etiquetasDeActivo).insertReturning(
        EtiquetasDeActivoCompanion.insert(clave: "modelo", valor: "2020"));
    await expectLater(
        () => _db.into(_db.activosXEtiquetas).insert(
            ActivosXEtiquetasCompanion.insert(
                activoId: "999", etiquetaId: etiqueta.id)),
        throwsA(isA<SqliteException>().having((e) => e.message,
            "foreign key error", contains("FOREIGN KEY constraint failed"))));
  });
  test('''las asociaciones se borran en cascada con el activo''', () async {
    final activo = await _crearActivo();
    final etiqueta = await _db.into(_db.etiquetasDeActivo).insertReturning(
        EtiquetasDeActivoCompanion.insert(clave: "modelo", valor: "2020"));
    await _db.into(_db.activosXEtiquetas).insert(
        ActivosXEtiquetasCompanion.insert(
            activoId: activo.id, etiquetaId: etiqueta.id));

    var count = countAll();
    final etiquetas1 = await (_db.selectOnly(_db.activosXEtiquetas)
          ..addColumns([count]))
        .map((row) => row.read(count))
        .getSingle();
    expect(etiquetas1, 1);
    final activosBorrados = await (_db.delete(_db.activos)
          ..where((a) => a.id.equals(activo.id)))
        .go();
    expect(activosBorrados, 1);
    final etiquetas2 = await (_db.selectOnly(_db.activosXEtiquetas)
          ..addColumns([count]))
        .map((row) => row.read(count))
        .getSingle();
    expect(etiquetas2, 0);
  });
  Future<Cuestionario> _crearCuestionario() =>
      _db.into(_db.cuestionarios).insertReturning(CuestionariosCompanion.insert(
            tipoDeInspeccion: "preoperacional",
            version: 1,
            periodicidadDias: 1,
            estado: EstadoDeCuestionario.finalizado,
            subido: false,
          ));
  test('''se pueden asociar cuestionarios con etiquetas''', () async {
    final cuestionario = await _crearCuestionario();
    final etiqueta = await _db.into(_db.etiquetasDeActivo).insertReturning(
        EtiquetasDeActivoCompanion.insert(clave: "modelo", valor: "2020"));
    await _db.into(_db.cuestionariosXEtiquetas).insert(
        CuestionariosXEtiquetasCompanion.insert(
            cuestionarioId: cuestionario.id, etiquetaId: etiqueta.id));
  });
  test(
      '''No se pueden crear dos cuestionarios con el mismo tipo y la misma version''',
      () async {
    await _db.into(_db.cuestionarios).insert(CuestionariosCompanion.insert(
          tipoDeInspeccion: "preoperacional",
          version: 1,
          periodicidadDias: 1,
          estado: EstadoDeCuestionario.finalizado,
          subido: false,
        ));
    await expectLater(
        () => _db.into(_db.cuestionarios).insert(CuestionariosCompanion.insert(
              tipoDeInspeccion: "preoperacional",
              version: 1,
              periodicidadDias: 1,
              estado: EstadoDeCuestionario.finalizado,
              subido: false,
            )),
        throwsA(isA<SqliteException>().having((e) => e.message,
            "unique violation", contains("UNIQUE constraint failed"))));
  });

  Future<Bloque> _crearBloque(Cuestionario cuestionario) =>
      _db.into(_db.bloques).insertReturning(
          BloquesCompanion.insert(cuestionarioId: cuestionario.id, nOrden: 1));
  test('''se pueden crear titulos''', () async {
    final bloque = await _crearBloque(await _crearCuestionario());

    final titulo =
        await _db.into(_db.titulos).insertReturning(TitulosCompanion.insert(
              bloqueId: bloque.id,
              titulo: "titulo",
              descripcion: "descripcion",
              fotos: [],
            ));

    expect(titulo.bloqueId, bloque.id);
    expect(titulo.fotos, []);
  });
  test('''un bloque puede estar asociado solo a un titulo''', () async {
    final bloque = await _crearBloque(await _crearCuestionario());

    final titulo1 =
        await _db.into(_db.titulos).insertReturning(TitulosCompanion.insert(
              bloqueId: bloque.id,
              titulo: "titulo",
              descripcion: "descripcion",
              fotos: [],
            ));

    await expectLater(
        () => _db.into(_db.titulos).insert(TitulosCompanion.insert(
            bloqueId: bloque.id,
            titulo: "titulo2",
            descripcion: "descripcion2",
            fotos: [])),
        throwsA(isA<SqliteException>().having((e) => e.message,
            "unique violation", contains("UNIQUE constraint failed"))));
  });

  test('''se pueden crear preguntas de seleccion unica''', () async {
    final bloque = await _crearBloque(await _crearCuestionario());

    final pregunta =
        await _db.into(_db.preguntas).insertReturning(PreguntasCompanion.insert(
              titulo: "titulo",
              descripcion: "descripcion",
              criticidad: 1,
              fotosGuia: [],
              bloqueId: Value(bloque.id),
              tipoDePregunta: TipoDePregunta.seleccionUnica,
            ));
    final opcionDeRespuesta = await _db
        .into(_db.opcionesDeRespuesta)
        .insertReturning(OpcionesDeRespuestaCompanion.insert(
          titulo: "opcion",
          descripcion: "descripcion",
          criticidad: 1,
          preguntaId: pregunta.id,
        ));

    expect(pregunta.bloqueId, bloque.id);
    expect(pregunta.tipoDePregunta, TipoDePregunta.seleccionUnica);
  });

  Future<Pregunta> _crearPreguntaSimple(Cuestionario c) =>
      _crearBloque(c).then((bloque) =>
          _db.into(_db.preguntas).insertReturning(PreguntasCompanion.insert(
                titulo: "titulo",
                descripcion: "descripcion",
                criticidad: 1,
                fotosGuia: [],
                bloqueId: Value(bloque.id),
                tipoDePregunta: TipoDePregunta.seleccionUnica,
              )));

  test('''se pueden agregar etiquetas a las preguntas''', () async {
    final pregunta = await _crearPreguntaSimple(await _crearCuestionario());

    final etiqueta = await _db.into(_db.etiquetasDePregunta).insertReturning(
        EtiquetasDePreguntaCompanion.insert(clave: "sistema", valor: "motor"));
    await _db.into(_db.preguntasXEtiquetas).insert(
        PreguntasXEtiquetasCompanion.insert(
            preguntaId: pregunta.id, etiquetaId: etiqueta.id));
  });
  test('''se pueden crear preguntas numericas''', () async {
    final bloque = await _crearBloque(await _crearCuestionario());

    final pregunta =
        await _db.into(_db.preguntas).insertReturning(PreguntasCompanion.insert(
              titulo: "titulo",
              descripcion: "descripcion",
              criticidad: 1,
              fotosGuia: [],
              bloqueId: Value(bloque.id),
              tipoDePregunta: TipoDePregunta.numerica,
            ));
    final criticidadNumerica = await _db
        .into(_db.criticidadesNumericas)
        .insertReturning(CriticidadesNumericasCompanion.insert(
          valorMinimo: 0,
          valorMaximo: 10,
          criticidad: 1,
          preguntaId: pregunta.id,
        ));

    expect(pregunta.bloqueId, bloque.id);
    expect(pregunta.tipoDePregunta, TipoDePregunta.numerica);
  });
  test('''se pueden crear preguntas tipo cuadricula''', () async {
    final bloque = await _crearBloque(await _crearCuestionario());

    final cuadricula =
        await _db.into(_db.preguntas).insertReturning(PreguntasCompanion.insert(
              titulo: "titulo",
              descripcion: "descripcion",
              criticidad: 1,
              fotosGuia: [],
              bloqueId: Value(bloque.id),
              tipoDePregunta: TipoDePregunta.cuadricula,
              tipoDeCuadricula: const Value(TipoDeCuadricula.seleccionUnica),
            ));
    final opcionDeRespuesta = await _db
        .into(_db.opcionesDeRespuesta)
        .insertReturning(OpcionesDeRespuestaCompanion.insert(
          titulo: "opcion",
          descripcion: "descripcion",
          criticidad: 1,
          preguntaId: cuadricula.id,
        ));
    final subPregunta =
        await _db.into(_db.preguntas).insertReturning(PreguntasCompanion.insert(
              titulo: "subtitulo",
              descripcion: "subdescripcion",
              criticidad: 1,
              fotosGuia: [],
              cuadriculaId: Value(cuadricula.id),
              tipoDePregunta: TipoDePregunta.parteDeCuadricula,
            ));

    expect(cuadricula.bloqueId, bloque.id);
    expect(cuadricula.tipoDePregunta, TipoDePregunta.cuadricula);
  });
  test('''se pueden crear inspecciones''', () async {
    final cuestionario = await _crearCuestionario();
    final activo = await _crearActivo();
    final inspeccion = await _db
        .into(_db.inspecciones)
        .insertReturning(InspeccionesCompanion.insert(
          id: '2112010521301',
          cuestionarioId: cuestionario.id,
          activoId: activo.id,
          inspectorId: "123",
          momentoInicio: DateTime.fromMillisecondsSinceEpoch(0),
          estado: EstadoDeInspeccion.borrador,
        ));
    expect(inspeccion.cuestionarioId, cuestionario.id);
    expect(inspeccion.activoId, activo.id);
    expect(inspeccion.inspectorId, "123");
    expect(inspeccion.momentoInicio, DateTime.fromMillisecondsSinceEpoch(0));
  });

  Future<OpcionDeRespuesta> _crearOpcionDeRespuesta(Pregunta pregunta) => _db
      .into(_db.opcionesDeRespuesta)
      .insertReturning(OpcionesDeRespuestaCompanion.insert(
        titulo: "opcion",
        descripcion: "descripcion",
        criticidad: 1,
        preguntaId: pregunta.id,
      ));

  Future<Tuple3<Inspeccion, Pregunta, OpcionDeRespuesta>>
      _crearInspeccionConPregunta() => _crearCuestionario().then(
            (cuestionario) => _crearActivo()
                .then(
                  (activo) => _db.into(_db.inspecciones).insertReturning(
                        InspeccionesCompanion.insert(
                          id: '2112010521301',
                          cuestionarioId: cuestionario.id,
                          activoId: activo.id,
                          inspectorId: "123",
                          momentoInicio: DateTime.fromMillisecondsSinceEpoch(0),
                          estado: EstadoDeInspeccion.borrador,
                        ),
                      ),
                )
                .then(
                  (inspeccion) => _crearPreguntaSimple(cuestionario).then(
                    (pregunta) => _crearOpcionDeRespuesta(pregunta).then(
                      (opcion) => Tuple3(
                        inspeccion,
                        pregunta,
                        opcion,
                      ),
                    ),
                  ),
                ),
          );
  test('''se puede crear una respuesta de pregunta simple''', () async {
    final tuple = await _crearInspeccionConPregunta();
    final inspeccion = tuple.value1;
    final pregunta = tuple.value2;
    final opcion = tuple.value3;

    final respuesta = await _db
        .into(_db.respuestas)
        .insertReturning(RespuestasCompanion.insert(
          preguntaId: Value(pregunta.id),
          observacion: "observacion",
          reparado: false,
          observacionReparacion: "observacionReparacion",
          momentoRespuesta: Value(DateTime.fromMillisecondsSinceEpoch(0)),
          fotosBase: [],
          fotosReparacion: [],
          tipoDeRespuesta: TipoDeRespuesta.seleccionUnica,
          inspeccionId: Value(inspeccion.id),
          opcionSeleccionadaId: Value(opcion.id),
        ));
    expect(respuesta.inspeccionId, inspeccion.id);
    expect(respuesta.preguntaId, pregunta.id);
  });
}
