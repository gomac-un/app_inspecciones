import 'package:dartz/dartz.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/infrastructure/core/api_exceptions.dart';

/// ejecuta una [operation] que puede lanzar las excepciones definidas en
/// [api_exceptions.dart] y las convierte en un [ApiFailure]
Future<Either<ApiFailure, T>> apiExceptionToApiFailure<T>(
    Future<T> Function() operation) async {
  try {
    return Right(await operation());
  } on ErrorDeConexion catch (e) {
    return Left(ApiFailure.errorDeConexion(e.mensaje));
  } on ErrorInesperadoDelServidor catch (e) {
    return Left(ApiFailure.errorInesperadoDelServidor(e.mensaje));
  } on ErrorDecodificandoLaRespuesta catch (e) {
    return Left(ApiFailure.errorDecodificandoLaRespuesta(e.respuesta));
  } on ErrorDeCredenciales catch (e) {
    return Left(ApiFailure.errorDeCredenciales(e.mensaje));
  } on ErrorDePermisos catch (e) {
    return Left(ApiFailure.errorDePermisos(e.mensaje));
  } on ErrorEnLaComunicacionConLaApi catch (e) {
    return Left(ApiFailure.errorDeComunicacionConLaApi(e.mensaje));
  } on ErrorDatabase catch (e) {
    return Left(ApiFailure.errorDatabase(e.mensaje));
  } catch (e) {
    return Left(ApiFailure.errorInesperadoDelServidor(e.toString()));
  }
}
