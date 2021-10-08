import 'dart:io';

import 'package:inspecciones/infrastructure/core/typedefs.dart';
import 'package:inspecciones/infrastructure/repositories/fotos_repository.dart';

abstract class FotosRemoteDataSource {
  Future<JsonObject> subirFotos(
      Iterable<File> fotos, String idDocumento, Categoria tipoDocumento);
}
