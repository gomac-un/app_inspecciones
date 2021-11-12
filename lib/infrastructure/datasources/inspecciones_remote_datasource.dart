import 'dart:async';

import 'package:inspecciones/infrastructure/core/typedefs.dart';

abstract class InspeccionesRemoteDataSource {
  Future<JsonMap> getInspeccion(int id);
  Future<JsonMap> crearInspeccion(JsonMap inspeccion);
  Future<JsonMap> actualizarInspeccion(int inspeccionId, JsonMap inspeccion);
}
