import 'package:inspecciones/infrastructure/core/typedefs.dart';

abstract class AuthRemoteDataSource {
  Future<JsonMap> getToken(JsonMap credenciales);
  Future<JsonMap> getPerfil(int? id);
  //Future<JsonMap> registrarApp();
  Future<JsonMap> registrarUsuario(JsonMap form);
}
