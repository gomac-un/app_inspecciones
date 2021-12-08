import 'dart:async';

import 'package:inspecciones/infrastructure/core/typedefs.dart';

abstract class InspeccionesRemoteDataSource {
  Future<JsonMap> descargarInspeccion(int id);
  Future<JsonMap> actualizarInspeccion(int inspeccionId, JsonMap inspeccion);
  Future<JsonMap> subirFotosInspeccion(JsonList fotos);
  Future<JsonMap> subirInspeccion(JsonMap inspeccion);
}
