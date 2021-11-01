import 'dart:io';

import 'package:inspecciones/infrastructure/core/typedefs.dart';

abstract class CuestionariosRemoteDataSource {
  Future<JsonMap> crearCuestionario(JsonMap cuestionario);
  Future<File> descargarTodosLosCuestionarios(String token);
  Future<void> descargarTodasLasFotos(String token);
}
