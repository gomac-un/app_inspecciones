import 'package:inspecciones/infrastructure/core/typedefs.dart';

abstract class AuthRemoteDataSource {
  Future<JsonObject> getToken(JsonObject credenciales);
  Future<JsonObject> getPermisos(String username);
  Future<JsonObject> registrarApp();
}
