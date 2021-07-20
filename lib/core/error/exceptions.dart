/// Definición de exceptions tenidas en cuenta para la app
///
/// Usadas principalmente en la comunicación con el server, al enviar inspecciones y cuestionarios.
/// La clase [ServerException] maneja la mayoría de errores.
class ServerException implements Exception {
  final Map<String, dynamic> respuesta;

  ServerException(this.respuesta);
}

class CredencialesException {
  final Map<String, dynamic> respuesta;

  CredencialesException(this.respuesta);
}

class PageNotFoundException implements Exception {}

class InternetException {}

class CacheException implements Exception {}
