import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/bloques/bloques.dart'
    as bl_dom;
import 'package:inspecciones/features/llenado_inspecciones/domain/bloques/titulo.dart'
    as tit_dom;
import 'package:inspecciones/features/llenado_inspecciones/domain/inspeccion.dart'
    as insp_dom;
import 'package:inspecciones/features/llenado_inspecciones/domain/inspeccion.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/infrastructure/repositories/fotos_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart' hide isNull;
import 'package:test/test.dart';

// Fake class
class FakeFotosRepository extends Fake implements FotosRepository {}

@GenerateMocks([FotosRepository])
void main() {
  late MoorDatabase _db;
  late FakeFotosRepository _fotosRepository;

  setUp(() {
    _fotosRepository = FakeFotosRepository();

    _db = MoorDatabase(
      VmDatabase.memory(),
      1,
      _fotosRepository,
    );
  });

  tearDown(() async {
    await _db.close();
  });
  group("getCuestionariosDisponiblesParaActivo", () {
    late int cuestionarioId;

    setUp(() async {
      cuestionarioId = await _db
          .into(_db.cuestionarios)
          .insert(CuestionariosCompanion.insert(
            tipoDeInspeccion: "preoperacional",
            estado: EstadoDeCuestionario.finalizada,
            esLocal: false,
          ));
    });

    Future<int> asociarModeloACuestionario(String modelo) => _db
        .into(_db.cuestionarioDeModelos)
        .insert(CuestionarioDeModelosCompanion.insert(
          modelo: modelo,
          periodicidad: 1,
          cuestionarioId: cuestionarioId,
        ));

    Future<int> insertarActivo(String modelo) =>
        _db.into(_db.activos).insert(ActivosCompanion.insert(modelo: modelo));

    test('''getCuestionariosDisponiblesParaActivo deberia traer un cuestionario 
        que este asignado a todos los activos''', () async {
      await asociarModeloACuestionario("todos");
      final activoId = await insertarActivo("kenworth");

      final res = await _db.cargaDeInspeccionDao
          .getCuestionariosDisponiblesParaActivo(activoId);

      expect(res.length, 1);
      expect(res.first.tipoDeInspeccion, "preoperacional");
    });

    test('''getCuestionariosDisponiblesParaActivo deberia traer un cuestionario 
        que este asignado al modelo del activo''', () async {
      const modelo = "kenworth";
      await asociarModeloACuestionario(modelo);
      final activoId = await insertarActivo(modelo);

      final res = await _db.cargaDeInspeccionDao
          .getCuestionariosDisponiblesParaActivo(activoId);

      expect(res.length, 1);
      expect(res.first.tipoDeInspeccion, "preoperacional");
    });

    test('''getCuestionariosDisponiblesParaActivo deberia traer una lista vacía 
          si no hay cuestionarios asociados al modelo''', () async {
      await asociarModeloACuestionario("moto");
      final activoId = await insertarActivo("kenworth");

      final res = await _db.cargaDeInspeccionDao
          .getCuestionariosDisponiblesParaActivo(activoId);

      expect(res.length, 0);
    });

    test('''getCuestionariosDisponiblesParaActivo deberia traer una lista vacía 
        si el activo no existe a pesar de que haya un cuestionario para todos''',
        () async {
      await asociarModeloACuestionario("todos");

      final res = await _db.cargaDeInspeccionDao
          .getCuestionariosDisponiblesParaActivo(2);

      expect(res.length, 0);
    });

    test('''getCuestionariosDisponiblesParaActivo no deberia traer cuestionarios
         repetidos si el cuestionario esta asociado tanto a todos como al modelo 
         en especifico''', () async {
      await asociarModeloACuestionario("todos");
      await asociarModeloACuestionario("kenworth");

      final activoId = await insertarActivo("kenworth");

      final res = await _db.cargaDeInspeccionDao
          .getCuestionariosDisponiblesParaActivo(activoId);

      expect(res.length, 1);
      expect(res.first.tipoDeInspeccion, "preoperacional");
    });

    test('''getCuestionariosDisponiblesParaActivo deberia traer una lista de 
        cuestionarios si varios aplican''', () async {
      await asociarModeloACuestionario("todos");

      final cuestionarioId2 = await _db
          .into(_db.cuestionarios)
          .insert(CuestionariosCompanion.insert(
            tipoDeInspeccion: "motor",
            estado: EstadoDeCuestionario.finalizada,
            esLocal: false,
          ));
      await _db
          .into(_db.cuestionarioDeModelos)
          .insert(CuestionarioDeModelosCompanion.insert(
            modelo: "kenworth",
            periodicidad: 1,
            cuestionarioId: cuestionarioId2,
          ));

      final activoId = await insertarActivo("kenworth");

      final res = await _db.cargaDeInspeccionDao
          .getCuestionariosDisponiblesParaActivo(activoId);

      expect(res.length, 2);
      expect(res[0].id != res[1].id, true);
    });
  });
  group("cargarInspeccion", () {
    late int cuestionarioId;
    late int activoId;
    late int inspeccionId;

    setUp(() async {
      cuestionarioId = await _db.into(_db.cuestionarios).insert(
          CuestionariosCompanion.insert(
              tipoDeInspeccion: "preoperacional",
              estado: EstadoDeCuestionario.finalizada,
              esLocal: false));

      activoId = await _db
          .into(_db.activos)
          .insert(ActivosCompanion.insert(modelo: "kenworth"));

      inspeccionId = await _db.into(_db.inspecciones).insert(
          InspeccionesCompanion.insert(
              estado: EstadoDeInspeccion.borrador,
              criticidadTotal: 0,
              criticidadReparacion: 0,
              cuestionarioId: cuestionarioId,
              activoId: activoId));
    });
    test(
        "si el cuestionario no tiene bloques, cargarInspeccion debería cargar una inspección vacía",
        () async {
      final res = await _db.cargaDeInspeccionDao
          .cargarInspeccion(cuestionarioId: cuestionarioId, activoId: activoId);

      expect(res.value1.id, inspeccionId);
      expect(res.value2.length, 0);
    });
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
    test('''si el cuestionario tiene asociada una pregunta de seleccion unica y 
    la inspeccion es nueva, cargarInspeccion debería cargar la pregunta con sus 
    opciones pero sin respuesta''', () async {
      final activoId2 = await _db
          .into(_db.activos)
          .insert(ActivosCompanion.insert(modelo: "moto"));
      final bloqueId = await _db.into(_db.bloques).insert(
          BloquesCompanion.insert(nOrden: 1, cuestionarioId: cuestionarioId));

      final preguntaId = await _db.into(_db.preguntas).insert(
          PreguntasCompanion.insert(
              titulo: "titulo",
              descripcion: "descripcion",
              criticidad: 1,
              bloqueId: bloqueId,
              tipo: TipoDePregunta.unicaRespuesta));

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
      final bloqueId = await _db.into(_db.bloques).insert(
          BloquesCompanion.insert(nOrden: 1, cuestionarioId: cuestionarioId));

      final preguntaId = await _db.into(_db.preguntas).insert(
          PreguntasCompanion.insert(
              titulo: "titulo",
              descripcion: "descripcion",
              criticidad: 1,
              bloqueId: bloqueId,
              tipo: TipoDePregunta.unicaRespuesta));

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
