import 'dart:io';

import 'package:inspecciones/infrastructure/core/typedefs.dart';

abstract class CuestionariosRemoteDataSource {
  Future<File> descargarTodosLosCuestionarios(String token);
  Future<void> descargarTodasLasFotos(String token);

  Future<JsonMap> descargarCuestionario(String cuestionarioId);
  Future<JsonList> getCuestionarios();
  Future<JsonMap> subirCuestionario(JsonMap cuestionario);
}
