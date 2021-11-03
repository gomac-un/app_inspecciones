import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:inspecciones/core/entities/app_image.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/inspeccion.dart';
import 'package:uuid/uuid.dart';

//export 'database/shared.dart';

part 'drift_database.drift.dart';
part 'tablas.dart';

@DriftDatabase(
  tables: [
    Activos,
    ActivosXEtiquetas,
    EtiquetasDeActivo,
    CuestionarioDeModelos,
    Cuestionarios,
    Bloques,
    Titulos,
    CuadriculasDePreguntas,
    Preguntas,
    OpcionesDeRespuesta,
    Inspecciones,
    Respuestas,
    Contratistas,
    Sistemas,
    SubSistemas,
    CriticidadesNumericas,
    GruposInspeccioness,
    ProgramacionSistemas,
    ProgramacionSistemasXActivo,
    TiposDeInspecciones,
  ],
  daos: [
    // CargaDeInspeccionDao,
    // GuardadoDeInspeccionDao,
    // CargaDeCuestionarioDao,
    // GuardadoDeCuestionarioDao,
    // BorradoresDao,
  ],
)
class Database extends _$Database {
  // En el caso de que la db crezca mucho y las consultas empiecen a relentizar
  //la UI se debe considerar el uso de los isolates https://drift.simonbinder.eu/docs/advanced-features/isolates/
  Database(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from == 1) {
          //await m.addColumn(todos, todos.targetDate);
        }
      },
      beforeOpen: (details) async {
        if (details.wasCreated) {
          // create default data
        }
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  /// Elimina todos los datos de la BD
  Future<void> recrearTodasLasTablas() async {
    final m = createMigrator();
    await customStatement('PRAGMA foreign_keys = OFF');

    for (final table in allTables) {
      await m.deleteTable(table.actualTableName);
      await m.createTable(table);
    }

    await customStatement('PRAGMA foreign_keys = ON');
  }
}
