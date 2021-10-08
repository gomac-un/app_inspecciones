import 'package:inspecciones/infrastructure/core/typedefs.dart';

abstract class AuthRemoteDataSource {
  Future<JsonObject> getToken(JsonObject credenciales);
  Future<JsonObject> getPermisos(String username, String token);
  Future<JsonObject> registrarApp();
}
