class ApiException implements Exception {
  const ApiException();
}

/// Este archivo contiene todas las excepciones que puede generar una api remota
class ErrorDeConexion extends ApiException {
  final String mensaje;

  /// Error lanzado cuando no se puede realizar la conexion con el servidor,
  /// pueden haber muchas razones entre ellas que el dispositivo no tenga internet,
  /// el servidor esté caido, el servidor haya cambiado de direccion, cambio de
  /// puerto, no se pudo realizar el handshake tls, etc.
  const ErrorDeConexion(this.mensaje);
}

class ErrorInesperadoDelServidor extends ApiException {
  final String mensaje;

  /// Error lanzado cuando ocurre un error que no se habia pronosticado en ninguno
  /// de los otros tipos de errores
  const ErrorInesperadoDelServidor(this.mensaje);
}

class ErrorDecodificandoLaRespuesta extends ApiException {
  final String respuesta;

  /// Error lanzado cuando se intenta decodificar la respuesta esperada en un
  /// formato y el proceso falla, por ejemplo cuando se espera un json y el
  /// servidor envia un error sin formato.
  const ErrorDecodificandoLaRespuesta(this.respuesta);
}

class ErrorDeCredenciales extends ApiException {
  final String mensaje;

  /// Error lanzado cuando el servidor informa que las credenciales no son validas,
  /// puede ser que se hayan vencido o el servidor haya forzado el logout,
  /// si ocurre se debe volver a realizar el login.
  const ErrorDeCredenciales(this.mensaje);
}

class ErrorDePermisos extends ApiException {
  final String mensaje;

  /// Error lanzado cuando a pesar de tener las credenciales correctas,el servidor
  /// informa que el usuario actual no puede realizar la acción por falta de permisos.
  const ErrorDePermisos(this.mensaje);
}

class ErrorEnLaComunicacionConLaApi extends ApiException {
  final String mensaje;

  /// Error lanzado cuando la APP realiza una peticion a la API pero es rechazada,
  /// esto se puede deber a cambios en la API o a un error de programación de la APP
  const ErrorEnLaComunicacionConLaApi(this.mensaje);
}
