import 'dart:async';

import 'package:inspecciones/infrastructure/core/typedefs.dart';

abstract class InspeccionesRemoteDataSource {
  Future<JsonObject> getInspeccion(int id);
  Future<JsonObject> crearInspeccion(JsonObject inspeccion);
  Future<JsonObject> actualizarInspeccion(
      int inspeccionId, JsonObject inspeccion);
}
