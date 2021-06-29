import 'package:collection/collection.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:moor/moor.dart';
part 'planeacion_dao.g.dart';

@UseDao(tables: [
  GruposInspeccioness,
  Activos,
  Sistemas,
  ProgramacionSistemas,
  ProgramacionSistemasXActivo,
  TiposDeInspecciones
])
class PlaneacionDao extends DatabaseAccessor<Database>
    with _$PlaneacionDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  PlaneacionDao(Database db) : super(db);
  Stream<List<GrupoXTipoInspeccion>> obtenerGruposActuales() {
    final query = select(gruposInspeccioness).join([
      innerJoin(
        tiposDeInspecciones,
        tiposDeInspecciones.id.equalsExp(gruposInspeccioness.tipoInspeccion),
      ),
    ])
      ..where(gruposInspeccioness.anio.equals(DateTime.now().year));

    final res = query
        .map((row) => {
              'tipo': row.readTable(tiposDeInspecciones),
              'grupos': row.readTable(gruposInspeccioness),
            })
        .watch()
        .asyncMap(
          (l) => Future.wait(
            groupBy(l, (e) => e['tipo']).entries.map(
              (entry) async {
                return GrupoXTipoInspeccion(
                    tipoInspeccion: (entry.key as TiposDeInspeccione),
                    grupos: entry.value
                        .map((item) => item['grupos'] as GruposInspecciones)
                        .toList());
              },
            ),
          ),
        );
    return res;
  }

  Future<List<int>> getGruposConInspeccion() async {
    final queryGrupos = selectOnly(gruposInspeccioness, distinct: true)
      ..where(gruposInspeccioness.anio.equals(DateTime.now().year))
      ..addColumns([gruposInspeccioness.tipoInspeccion]);
    return queryGrupos
        .map((row) => row.read(gruposInspeccioness.tipoInspeccion))
        .get();
  }

  // Este es para los grupos
  Future<List<TiposDeInspeccione>> getInspeccionesSinGrupo() async {
    // Para que no aparezca los que ya tienen un grupo planeado para el año actual, así no se puede crear grupos para una inspección que ya existe.
    final idsTipo = await getGruposConInspeccion();
    final query = select(tiposDeInspecciones, distinct: true)
      ..where((tip) => tip.id.isNotIn(idsTipo));
    return query.get();
  }

  Future<List<String>> getInspeccionesConGrupo() async {
    final idsTipo = await getGruposConInspeccion();
    final query = selectOnly(tiposDeInspecciones, distinct: true)
      ..where(tiposDeInspecciones.id.isIn(idsTipo))
      ..addColumns([tiposDeInspecciones.tipo]);
    return query.map((row) => row.read(tiposDeInspecciones.tipo)).get();
  }

  Stream<List<GruposInspecciones>> getGrupoXInspeccionId(int tipoId) {
    final query = select(gruposInspeccioness)
      ..where((gru) =>
          gru.tipoInspeccion.equals(tipoId) &
          gru.anio.equals(DateTime.now().year));
    return query.watch();
  }

  Stream<List<GruposInspecciones>> obtenerTodosGruposXInspeccionid(int tipoId) {
    final query = select(gruposInspeccioness)
      ..where((gru) => gru.tipoInspeccion.equals(tipoId));
    return query.watch();
  }

  Future<List<GrupoXTipoInspeccion>> getGruposXTipoInspeccionId(
      int tipoId) async {
    final query = select(gruposInspeccioness).join([
      innerJoin(
        tiposDeInspecciones,
        tiposDeInspecciones.id.equalsExp(gruposInspeccioness.tipoInspeccion),
      ),
    ])
      ..where(gruposInspeccioness.anio.equals(DateTime.now().year) &
          gruposInspeccioness.tipoInspeccion.equals(tipoId));

    final res = await query
        .map((row) => {
              'tipo': row.readTable(tiposDeInspecciones),
              'grupos': row.readTable(gruposInspeccioness),
            })
        .get();
    final respuesta = Future.wait(
      groupBy(res, (e) => e['tipo']).entries.map(
        (entry) async {
          return GrupoXTipoInspeccion(
              tipoInspeccion: entry.key as TiposDeInspeccione,
              grupos: entry.value
                  .map((item) => item['grupos'] as GruposInspecciones)
                  .toList());
        },
      ),
    );
    return respuesta;
  }

  Future<int> guardarGrupos(GrupoXTipoInspeccion grupos) async {
    int tipoId;
    await transaction(
      () async {
        final tipoInspeccion = grupos.tipoInspeccion.toCompanion(true);
        if (tipoInspeccion.id.present) {
          tipoId = tipoInspeccion.id.value;
        } else {
          tipoId =
              await into(tiposDeInspecciones).insert(grupos.tipoInspeccion);
        }
        final List<int> gruposId = [];
        await Future.forEach<GruposInspecciones>(
          grupos.grupos,
          (gru) async {
            final grupo = gru.toCompanion(true).copyWith(
                tipoInspeccion: Value(tipoId),
                totalGrupos: Value(grupos.grupos.length));
            int grupoId;
            if (grupo.id.present) {
              await into(gruposInspeccioness).insertOnConflictUpdate(grupo);
              grupoId = gru.id;
            } else {
              grupoId = await into(gruposInspeccioness).insert(grupo);
            }
            gruposId.add(grupoId);
          },
        );

        await (delete(gruposInspeccioness)
              ..where((gru) =>
                  gru.id.isNotIn(gruposId) &
                  gru.tipoInspeccion.equals(tipoId) &
                  gru.anio.equals(DateTime.now().year)))
            .go();
      },
    );
    return tipoId;
  }

  Future actualizarGrupos(List<GruposInspecciones> grupos) async {
    return transaction(
      () async {
        final tipoId = grupos.first.tipoInspeccion;
        final List<int> gruposId = [];
        await Future.forEach<GruposInspecciones>(
          grupos,
          (gru) async {
            final grupo = gru.toCompanion(true);
            int grupoId;
            if (grupo.id.present) {
              await into(gruposInspeccioness).insertOnConflictUpdate(grupo);
              grupoId = gru.id;
            } else {
              grupoId = await into(gruposInspeccioness).insert(grupo);
            }
            gruposId.add(grupoId);
          },
        );

        await (delete(gruposInspeccioness)
              ..where((gru) =>
                  gru.id.isNotIn(gruposId) &
                  gru.tipoInspeccion.equals(tipoId) &
                  gru.anio.equals(DateTime.now().year)))
            .go();
      },
    );
  }

  Future borrarGrupos() async {
    await (delete(gruposInspeccioness)).go();
  }

  Future<List<int>> getActivos() {
    final query = selectOnly(activos, distinct: true)
      ..addColumns([activos.id])
      ..limit(15);
    return query.map((row) => row.read(activos.id)).get();
  }

  Future<List<Sistema>> programacion() async {
    final listaSistemas = [
      'Dirección',
      'Suspensión',
      'Motor principal',
      'Frenos y Neumática',
      'Eléctrico',
      'Hidráulico',
      'Estructura',
      'Transmisión'
    ];

    final querySistemas = select(sistemas)
      ..where(
        (sis) => sis.nombre.isIn(listaSistemas),
      );

    print(await querySistemas.get());

    return querySistemas.get();
  }

  Future<List<Programacion>> getProgramacionSistemas() async {
    final query = select(programacionSistemas).join([
      leftOuterJoin(
        programacionSistemasXActivo,
        programacionSistemasXActivo.programacionSistemaId
            .equalsExp(programacionSistemas.id),
      ),
      leftOuterJoin(sistemas,
          sistemas.id.equalsExp(programacionSistemasXActivo.sistemaId))
    ])
      ..where(programacionSistemas.mes.equals(DateTime.now().month));

    final res = await query
        .map((row) => {
              'programacion': row.readTable(programacionSistemas),
              'sistemas': row.readTable(sistemas)
            })
        .get();
    return Future.wait(
      groupBy(res, (e) => e['programacion']).entries.map((entry) async {
        return Programacion(
            programacion: (entry.key as ProgramacionSistema).toCompanion(true),
            sistemas: entry.value
                .map((item) => item['sistemas'] as Sistema)
                .toList());
      }),
    );
  }

  Future<GruposInspecciones> getGrupoByMonth() {
    final mesActual = DateTime.now();
    final query = select(gruposInspeccioness)
      ..where((gru) =>
          gru.inicio.month.isSmallerOrEqualValue(mesActual.month) &
          gru.fin.month.isBiggerOrEqualValue(mesActual.month) &
          gru.anio.equals(mesActual.year));
    return query.getSingle();
  }

  Future saveProgramacionSistemas(List<Programacion> programacion) async {
    return transaction(
      () async {
        await Future.forEach<Programacion>(
          programacion,
          (prog) async {
            int progId;
            if (prog.programacion.id.present) {
              await into(programacionSistemas)
                  .insertOnConflictUpdate(prog.programacion);
              progId = prog.programacion.id.value;
            } else {
              progId =
                  await into(programacionSistemas).insert(prog.programacion);
            }
            await (delete(programacionSistemasXActivo)
                  ..where((gru) => gru.programacionSistemaId.equals(progId)))
                .go();
            if (prog.sistemas.isNotEmpty) {
              final progXActivo = prog?.sistemas
                  ?.where((e) => e != null)
                  ?.map(
                    (e) => ProgramacionSistemasXActivoCompanion(
                      programacionSistemaId: Value(progId),
                      sistemaId: Value(e.id),
                    ),
                  )
                  ?.toList();

              await batch((batch) {
                batch.insertAll(programacionSistemasXActivo, progXActivo);
              });
            }
          },
        );
      },
    );
  }

  Future datosPrueba() async {
    final mesActual = DateTime.now();
    final query = select(gruposInspeccioness)
      ..where((gru) =>
          gru.inicio.month.isSmallerOrEqualValue(mesActual.month) &
          gru.fin.month.isBiggerOrEqualValue(mesActual.month) &
          gru.anio.equals(mesActual.year));
    final grupo = await query.getSingle();
    final listaProgramacion = [
      ProgramacionSistemasCompanion(
        activoId: Value(2),
        grupoId: Value(grupo.id),
        mes: Value(6),
        estado: Value(EstadoProgramacion.asignado),
      ),
      ProgramacionSistemasCompanion(
        activoId: Value(2),
        grupoId: Value(grupo.id),
        mes: Value(6),
        estado: Value(EstadoProgramacion.noAsignado),
      ),
      ProgramacionSistemasCompanion(
        activoId: Value(2),
        grupoId: Value(grupo.id),
        mes: Value(6),
        estado: Value(EstadoProgramacion.noAplica),
      ),
      ProgramacionSistemasCompanion(
        activoId: Value(4),
        grupoId: Value(grupo.id),
        mes: Value(6),
        estado: Value(EstadoProgramacion.asignado),
      ),
      ProgramacionSistemasCompanion(
        activoId: Value(4),
        grupoId: Value(grupo.id),
        mes: Value(6),
        estado: Value(EstadoProgramacion.noAsignado),
      ),
      ProgramacionSistemasCompanion(
        activoId: Value(4),
        grupoId: Value(grupo.id),
        mes: Value(6),
        estado: Value(EstadoProgramacion.noAplica),
      ),
    ];
    await batch((batch) {
      batch.insertAll(programacionSistemas, listaProgramacion);
    });
    /* final listaInter = [
      ProgramacionSistemasXActivoCompanion(
          programacionSistemaId: Value(700000000000002), sistemaId: Value(14)),
      ProgramacionSistemasXActivoCompanion(
          programacionSistemaId: Value(700000000000002), sistemaId: Value(15)),
      ProgramacionSistemasXActivoCompanion(
          programacionSistemaId: Value(700000000000005), sistemaId: Value(13)),
    ];
    for (int i = 1; i <= 12; i++) {
      listaInter.add(
        ProgramacionSistemasXActivoCompanion(
            programacionSistemaId: Value(700000000000001), sistemaId: Value(i)),
      );
    }
    await batch((batch) {
      batch.insertAll(programacionSistemasXActivo, listaInter);
    }); */
  }
}
