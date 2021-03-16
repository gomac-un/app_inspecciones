class ServerException implements Exception {
  final Map<String, dynamic> respuesta;

  ServerException(this.respuesta);
}

class CredencialesException {
  final Map<String, dynamic> respuesta;

  CredencialesException(this.respuesta);
}

class InternetException {
}

class CacheException implements Exception {}
