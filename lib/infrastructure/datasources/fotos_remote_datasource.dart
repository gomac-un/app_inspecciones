import 'package:inspecciones/core/entities/app_image.dart';

import '../core/typedefs.dart';
import '../repositories/fotos_repository.dart';

abstract class FotosRemoteDataSource {
  Future<JsonMap> subirFotos(
      Iterable<AppImage> fotos, String idDocumento, Categoria tipoDocumento);
}
