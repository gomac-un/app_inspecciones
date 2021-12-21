import 'package:drift/drift.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/identificador_inspeccion.dart';

import '../drift_database.dart';

export '../database/shared.dart';

part 'sincronizacion_dao.g.dart';

@DriftAccessor(tables: [
  Activos,
  ActivosXEtiquetas,
  EtiquetasDeActivo,
  Cuestionarios,
  CuestionariosXEtiquetas,
  Bloques,
  Titulos,
  Preguntas,
  OpcionesDeRespuesta,
  Inspecciones,
  Respuestas,
  CriticidadesNumericas,
])
class SincronizacionDao extends DatabaseAccessor<Database>
    with _$SincronizacionDaoMixin {
  SincronizacionDao(Database db) : super(db);

  /// marca [cuestionario.subido] = true cuando [cuestionario] es subido al server
  Future<void> marcarCuestionarioSubido(String cuestionarioId) =>
      (update(cuestionarios)..where((c) => c.id.equals(cuestionarioId)))
          .write(const CuestionariosCompanion(subido: Value(true)));

  Future<void> marcarInspeccionSubida(IdentificadorDeInspeccion id) =>
      (update(inspecciones)
            ..where((i) =>
                i.activoId.equals(id.activo) &
                i.cuestionarioId.equals(id.cuestionarioId)))
          .write(InspeccionesCompanion(momentoEnvio: Value(DateTime.now())));
}
