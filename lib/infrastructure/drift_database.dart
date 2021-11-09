import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/inspeccion.dart'
    show EstadoDeInspeccion;
import 'package:uuid/uuid.dart';

import 'daos/borradores_dao.dart';
import 'daos/carga_inspeccion_dao.dart';

export 'database/shared.dart';

part 'drift_database.drift.dart';
part 'tablas.dart';

@DriftDatabase(
  tables: [
    Activos,
    ActivosXEtiquetas,
    EtiquetasDeActivo,
    Cuestionarios,
    CuestionariosXEtiquetas,
    Bloques,
    Titulos,
    EtiquetasDePregunta,
    Preguntas,
    PreguntasXEtiquetas,
    OpcionesDeRespuesta,
    CriticidadesNumericas,
    Inspecciones,
    Respuestas,
  ],
  daos: [
    CargaDeInspeccionDao,
    // GuardadoDeInspeccionDao,
    // CargaDeCuestionarioDao,
    // GuardadoDeCuestionarioDao,
    BorradoresDao,
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
