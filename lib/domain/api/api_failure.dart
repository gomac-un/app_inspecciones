import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_failure.freezed.dart';

@freezed
abstract class ApiFailure with _$ApiFailure {
  const factory ApiFailure.noHayInternet() = NoHayInternet;
  const factory ApiFailure.noHayConexionAlServidor() = NoHayConexionAlServidor;
  const factory ApiFailure.serverError(String msg) = ServerError;
  const factory ApiFailure.credencialesException() = CredencialesError;
  const factory ApiFailure.pageNotFound() = PageNotFoundError;
}
