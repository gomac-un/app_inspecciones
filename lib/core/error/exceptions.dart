class ServerException implements Exception {
  final Map<String, dynamic> respuesta;

  ServerException(this.respuesta);
}

class CredencialesException {
  final Map<String, dynamic> respuesta;

  CredencialesException(this.respuesta);
}
class GroupNotFound implements Exception {}
class PageNotFoundException implements Exception {}

class InternetException {}

class CacheException implements Exception {}
