class ServerException implements Exception {
  //TODO: agregar mensaje
  final String mensaje;

  ServerException(this.mensaje);
}

class CacheException implements Exception {}
