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
  test("getActivo", () async {
    final activo = await _db.borradoresDao.getActivo(activoId: "1");
    expect(activo.id, "1");
    expect(activo.etiquetas, []);
  });

  Future<Activo> _crearActivo() async {
    final activo = await _db
        .into(_db.activos)
        .insertReturning(ActivosCompanion.insert(id: "1"));
    final etiqueta = await _db.into(_db.etiquetasDeActivo).insertReturning(
        EtiquetasDeActivoCompanion.insert(clave: "modelo", valor: "2020"));
    await _db.into(_db.activosXEtiquetas).insert(
        ActivosXEtiquetasCompanion.insert(
            activoId: activo.id, etiquetaId: etiqueta.id));
    return activo;
  }

  Future<Cuestionario> _crearCuestionario() =>
      _db.into(_db.cuestionarios).insertReturning(CuestionariosCompanion.insert(
          tipoDeInspeccion: "preoperacional",
          version: 1,
          periodicidadDias: 1,
          estado: EstadoDeCuestionario.finalizado,
          subido: false));

  Future<Bloque> _crearBloque(Cuestionario cuestionario) =>
      _db.into(_db.bloques).insertReturning(
          BloquesCompanion.insert(cuestionarioId: cuestionario.id, nOrden: 1));

  Future<Pregunta> _crearPreguntaSimple(Cuestionario c) =>
      _crearBloque(c).then((bloque) =>
          _db.into(_db.preguntas).insertReturning(PreguntasCompanion.insert(
                titulo: "titulo",
                descripcion: "descripcion",
                criticidad: 2,
                fotosGuia: [],
                bloqueId: Value(bloque.id),
                tipoDePregunta: TipoDePregunta.seleccionUnica,
              )));

  Future<OpcionDeRespuesta> _crearOpcionDeRespuesta(Pregunta pregunta) => _db
      .into(_db.opcionesDeRespuesta)
      .insertReturning(OpcionesDeRespuestaCompanion.insert(
        titulo: "opcion",
        descripcion: "descripcion",
        criticidad: 3,
        preguntaId: pregunta.id,
      ));

  Future<Inspeccion> _crearInspeccion(
          Cuestionario cuestionario, Activo activo) =>
      _db.into(_db.inspecciones).insertReturning(
            InspeccionesCompanion.insert(
              id: '2112010521301',
              cuestionarioId: cuestionario.id,
              activoId: activo.id,
              inspectorId: "123",
              momentoInicio: DateTime.fromMillisecondsSinceEpoch(0),
              estado: EstadoDeInspeccion.borrador,
            ),
          );
  Future<Respuesta> _crearRespuesta(
          Inspeccion inspeccion, Pregunta pregunta, OpcionDeRespuesta opcion) =>
      _db.into(_db.respuestas).insertReturning(
            RespuestasCompanion.insert(
              preguntaId: Value(pregunta.id),
              observacion: "observacion",
              reparado: true, //TODO: cambiar a false
              observacionReparacion: "observacionReparacion",
              momentoRespuesta: Value(DateTime.fromMillisecondsSinceEpoch(0)),
              fotosBase: [],
              fotosReparacion: [],
              tipoDeRespuesta: TipoDeRespuesta.seleccionUnica,
              inspeccionId: Value(inspeccion.id),
              opcionSeleccionadaId: Value(opcion.id),
            ),
          );

  Future<Tuple4<Cuestionario, Pregunta, OpcionDeRespuesta, Inspeccion>>
      _crearInspeccionConPregunta() async {
    final cuestionario = await _crearCuestionario();
    final activo = await _crearActivo();
    final pregunta = await _crearPreguntaSimple(cuestionario);
    final opcionDeRespuesta = await _crearOpcionDeRespuesta(pregunta);
    final inspeccion = await _crearInspeccion(cuestionario, activo);

    await _crearRespuesta(inspeccion, pregunta, opcionDeRespuesta);
    return Tuple4(
      cuestionario,
      pregunta,
      opcionDeRespuesta,
      inspeccion,
    );
  }

  test("se puede obtener la lista de borradores con la informacion requerida",
      () async {
    final tuple = await _crearInspeccionConPregunta();
    final cuestionario = tuple.value1;
    final inspeccion = tuple.value4;

    final borradoresStream =
        _db.borradoresDao.borradores(mostrarSoloEnviadas: false);
    final borradores = await borradoresStream.first;
    final borrador = borradores.first;

    expect(borrador.inspeccion.id, inspeccion.id);
    expect(borrador.inspeccion.estado, inspeccion.estado);
    expect(borrador.inspeccion.activo.id, inspeccion.activoId);
    expect(borrador.inspeccion.activo.etiquetas.first.clave, "modelo");
    expect(borrador.inspeccion.activo.etiquetas.first.valor, "2020");
    expect(borrador.inspeccion.momentoBorradorGuardado,
        inspeccion.momentoBorradorGuardado);

    expect(borrador.cuestionario.id, cuestionario.id);
    expect(
        borrador.cuestionario.tipoDeInspeccion, cuestionario.tipoDeInspeccion);

    expect(borrador.totalPreguntas, 1);
    expect(borrador.avance, 1);

    expect(borrador.criticidadTotal, 6);
    expect(borrador.criticidadReparacion, 0);
  });

  test('''se puede eliminar un borrador''', () async {
    await _crearInspeccionConPregunta();

    final borradoresStream =
        _db.borradoresDao.borradores(mostrarSoloEnviadas: false);
    final borradores = await borradoresStream.first;
    final borrador = borradores.first;

    await _db.borradoresDao.eliminarBorrador(borrador);

    final borradoresStream2 =
        _db.borradoresDao.borradores(mostrarSoloEnviadas: false);
    final borradores2 = await borradoresStream2.first;

    expect(borradores2, isEmpty);
  });
  Future<int> _getNroFilas<T extends HasResultSet, R>(
      ResultSetImplementation<T, R> t) {
    final count = countAll();
    final query = _db.selectOnly(t)..addColumns([count]);
    return query.map((row) => row.read(count)).getSingle();
  }

  test('''se pueden eliminar las respuestas de un borrador''', () async {
    final tuple = await _crearInspeccionConPregunta();
    final inspeccion = tuple.value4;

    expect(await _getNroFilas(_db.respuestas), 1);

    await _db.borradoresDao.eliminarRespuestas(inspeccionId: inspeccion.id);

    expect(await _getNroFilas(_db.respuestas), 0);
  });
}
