import 'package:inspecciones/infrastructure/core/typedefs.dart';

abstract class CuestionariosRemoteDataSource {
  Future<JsonMap> descargarCuestionario(String cuestionarioId);
  Future<JsonList> getCuestionarios();
  Future<JsonMap> subirCuestionario(JsonMap cuestionario);
  Future<JsonMap> actualizarCuestionario(
      String cuestionarioId, JsonMap cuestionario);
  Future<JsonMap> subirFotosCuestionario(JsonList fotos);
}
