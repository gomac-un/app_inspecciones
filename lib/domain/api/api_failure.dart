import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_failure.freezed.dart';

@freezed
class ApiFailure with _$ApiFailure {
  /// Ocurre cuando no se puede realizar la conexion con el servidor,
  /// pueden haber muchas razones entre ellas que el dispositivo no tenga internet,
  /// el servidor esté caido, el servidor haya cambiado de direccion, cambio de
  /// puerto, no se pudo realizar el handshake tls, etc.
  const factory ApiFailure.errorDeConexion(String mensaje) = _ErrorDeConexion;

  /// Error lanzado cuando ocurre un error que no se habia pronosticado en ninguno
  /// de los otros tipos de errores
  const factory ApiFailure.errorInesperadoDelServidor(String mensaje) =
      _ErrorInesperadoDelServidor;

  /// Error lanzado cuando se intenta decodificar la respuesta esperada en un
  /// formato y el proceso falla, por ejemplo cuando se espera un json y el
  /// servidor envia un error sin formato.
  const factory ApiFailure.errorDecodificandoLaRespuesta(String mensaje) =
      _ErrorDecodificandoLaRespuesta;

  /// Error lanzado cuando el servidor informa que las credenciales no son validas,
  /// puede ser que se hayan vencido o el servidor haya forzado el logout,
  /// si ocurre se debe volver a realizar el login.
  const factory ApiFailure.errorDeCredenciales(String mensaje) =
      _ErrorDeCredenciales;

  /// Error lanzado cuando a pesar de tener las credenciales correctas,el servidor
  /// informa que el usuario actual no puede realizar la acción por falta de permisos.
  const factory ApiFailure.errorDePermisos(String mensaje) = _ErrorDePermisos;

  /// Error lanzado cuando la APP realiza una peticion a la API pero es rechazada,
  /// esto se puede deber a cambios en la API o a un error de programación de la APP
  const factory ApiFailure.errorDeComunicacionConLaApi(String mensaje) =
      _ErrorDeComunicacionConLaApi;

  /// Error lanzado cuando ocurre una excepcion no pronosticada
  const factory ApiFailure.errorDeProgramacion(String mensaje) =
      _ErrorDeProgramacion;

  const factory ApiFailure.errorDatabase(String mensaje) = _ErrorDatabase;
}
