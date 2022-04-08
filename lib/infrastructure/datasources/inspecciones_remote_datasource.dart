import 'dart:async';

import 'package:inspecciones/infrastructure/core/typedefs.dart';

abstract class InspeccionesRemoteDataSource {
  Future<JsonMap> descargarInspeccion(String id);
  Future<JsonMap> actualizarInspeccion(String inspeccionId, JsonMap inspeccion);
  Future<JsonMap> subirFotosInspeccion(JsonList fotos);
  Future<JsonMap> subirInspeccion(JsonMap inspeccion);
}
