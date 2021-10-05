import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_failure.freezed.dart';

@freezed
class ApiFailure with _$ApiFailure {
  const factory ApiFailure.errorDeConexion(String mensaje) = _ErrorDeConexion;
  const factory ApiFailure.errorInesperadoDelServidor(String mensaje) =
      _ErrorInesperadoDelServidor;
  const factory ApiFailure.errorDecodificandoLaRespuesta(String mensaje) =
      _ErrorDecodificandoLaRespuesta;
  const factory ApiFailure.errorDeCredenciales(String mensaje) =
      _ErrorDeCredenciales;
  const factory ApiFailure.errorDePermisos(String mensaje) = _ErrorDePermisos;
  const factory ApiFailure.errorDeComunicacionConLaApi(String mensaje) =
      _ErrorDeComunicacionConLaApi;
}
