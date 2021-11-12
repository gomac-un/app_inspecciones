import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/domain.dart'
    as dominio;
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

  test('''se pueden guardar datos de la inspeccion''', () async {
    final activo = await _db
        .into(_db.activos)
        .insertReturning(ActivosCompanion.insert(id: "1"));
    final cuestionario = await _db
        .into(_db.cuestionarios)
        .insertReturning(CuestionariosCompanion.insert(
          tipoDeInspeccion: "preoperacional",
          version: 1,
          periodicidadDias: 1,
          estado: EstadoDeCuestionario.finalizado,
          subido: false,
        ));

    final inspeccionYBloques = await _db.cargaDeInspeccionDao.cargarInspeccion(
        cuestionarioId: cuestionario.id, activoId: activo.id, inspectorId: "1");

    final inspeccion = inspeccionYBloques.value1;

    final inspeccionModificada = dominio.Inspeccion(
      id: inspeccion.id,
      estado: dominio.EstadoDeInspeccion.finalizada,
      activo: inspeccion.activo,
      momentoInicio: inspeccion.momentoInicio,
      momentoBorradorGuardado: DateTime.fromMillisecondsSinceEpoch(0),
      momentoFinalizacion: DateTime.fromMillisecondsSinceEpoch(0),
      inspectorId: inspeccion.inspectorId,
    );

    await _db.guardadoDeInspeccionDao
        .guardarInspeccion([], inspeccionModificada);

    final inspeccionYBloques2 = await _db.cargaDeInspeccionDao.cargarInspeccion(
        cuestionarioId: cuestionario.id, activoId: activo.id, inspectorId: "1");
    final inspeccion2 = inspeccionYBloques2.value1;

    expect(inspeccion2.estado, dominio.EstadoDeInspeccion.finalizada);
    expect(inspeccion2.momentoBorradorGuardado,
        DateTime.fromMillisecondsSinceEpoch(0));
    expect(inspeccion2.momentoFinalizacion,
        DateTime.fromMillisecondsSinceEpoch(0));
  });
  test('''se pueden guardar preguntas de seleccion unica''', () async {
    final activo = await _db
        .into(_db.activos)
        .insertReturning(ActivosCompanion.insert(id: "1"));
    final cuestionario = await _db
        .into(_db.cuestionarios)
        .insertReturning(CuestionariosCompanion.insert(
          tipoDeInspeccion: "preoperacional",
          version: 1,
          periodicidadDias: 1,
          estado: EstadoDeCuestionario.finalizado,
          subido: false,
        ));
    final bloque = await _db.into(_db.bloques).insertReturning(
        BloquesCompanion.insert(nOrden: 1, cuestionarioId: cuestionario.id));

    final pregunta =
        await _db.into(_db.preguntas).insertReturning(PreguntasCompanion.insert(
              titulo: "titulo",
              descripcion: "descripcion",
              criticidad: 1,
              fotosGuia: [],
              bloqueId: Value(bloque.id),
              tipoDePregunta: TipoDePregunta.seleccionUnica,
            ));
    final opcion = await _db.into(_db.opcionesDeRespuesta).insertReturning(
        OpcionesDeRespuestaCompanion.insert(
            titulo: "titulo",
            descripcion: "descripcion",
            criticidad: 1,
            preguntaId: pregunta.id));

    final inspeccionYBloques = await _db.cargaDeInspeccionDao.cargarInspeccion(
        cuestionarioId: cuestionario.id, activoId: activo.id, inspectorId: "1");

    final inspeccion1 = inspeccionYBloques.value1;
    final bloques1 = inspeccionYBloques.value2;
    final pregunta1 = bloques1.first as dominio.PreguntaDeSeleccionUnica;
    pregunta1.respuesta = dominio.RespuestaDeSeleccionUnica(
        dominio.MetaRespuesta(observaciones: "observacion respuesta"),
        pregunta1.opcionesDeRespuesta.first);

    await _db.guardadoDeInspeccionDao
        .guardarInspeccion([pregunta1], inspeccion1);

    final inspeccionYBloques2 = await _db.cargaDeInspeccionDao.cargarInspeccion(
        cuestionarioId: cuestionario.id, activoId: activo.id, inspectorId: "1");
    final bloques2 = inspeccionYBloques2.value2;
    final pregunta2 = bloques2.first as dominio.PreguntaDeSeleccionUnica;

    expect(pregunta2.respuesta!.metaRespuesta.observaciones,
        "observacion respuesta");
    expect(pregunta2.respuesta!.opcionSeleccionada!.id, opcion.id);
  });
  test('''se pueden guardar preguntas de seleccion multiple''', () async {
    final activo = await _db
        .into(_db.activos)
        .insertReturning(ActivosCompanion.insert(id: "1"));
    final cuestionario = await _db
        .into(_db.cuestionarios)
        .insertReturning(CuestionariosCompanion.insert(
          tipoDeInspeccion: "preoperacional",
          version: 1,
          periodicidadDias: 1,
          estado: EstadoDeCuestionario.finalizado,
          subido: false,
        ));
    final bloque = await _db.into(_db.bloques).insertReturning(
        BloquesCompanion.insert(nOrden: 1, cuestionarioId: cuestionario.id));

    final pregunta =
        await _db.into(_db.preguntas).insertReturning(PreguntasCompanion.insert(
              titulo: "titulo",
              descripcion: "descripcion",
              criticidad: 1,
              fotosGuia: [],
              bloqueId: Value(bloque.id),
              tipoDePregunta: TipoDePregunta.seleccionMultiple,
            ));
    await _db.into(_db.opcionesDeRespuesta).insertReturning(
        OpcionesDeRespuestaCompanion.insert(
            titulo: "titulo",
            descripcion: "descripcion",
            criticidad: 1,
            preguntaId: pregunta.id));

    final inspeccionYBloques = await _db.cargaDeInspeccionDao.cargarInspeccion(
        cuestionarioId: cuestionario.id, activoId: activo.id, inspectorId: "1");

    final inspeccion1 = inspeccionYBloques.value1;
    final bloques1 = inspeccionYBloques.value2;
    final pregunta1 = bloques1.first as dominio.PreguntaDeSeleccionMultiple;
    pregunta1.respuesta = dominio.RespuestaDeSeleccionMultiple(
        dominio.MetaRespuesta(observaciones: "observacion respuesta padre"),
        pregunta1.respuestas
            .map((subrespuesta) => subrespuesta
              ..respuesta = dominio.SubRespuestaDeSeleccionMultiple(
                  dominio.MetaRespuesta(
                      observaciones: "observacion respuesta hija"),
                  estaSeleccionada: true))
            .toList());

    await _db.guardadoDeInspeccionDao
        .guardarInspeccion([pregunta1], inspeccion1);

    final inspeccionYBloques2 = await _db.cargaDeInspeccionDao.cargarInspeccion(
        cuestionarioId: cuestionario.id, activoId: activo.id, inspectorId: "1");
    final bloques2 = inspeccionYBloques2.value2;
    final pregunta2 = bloques2.first as dominio.PreguntaDeSeleccionMultiple;

    expect(pregunta2.respuesta!.metaRespuesta.observaciones,
        "observacion respuesta padre");
    expect(pregunta2.respuestas.first.respuesta!.metaRespuesta.observaciones,
        "observacion respuesta hija");
    expect(pregunta2.respuestas.first.respuesta!.estaSeleccionada, true);
  });
  //TODO: probar las cuadriculas
}
