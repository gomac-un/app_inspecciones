import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:inspecciones/core/error/exceptions.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/infrastructure/datasources/remote_datasource.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';

@injectable
class InspeccionRepository {
  final InspeccionesRemoteDataSource _api;
  final Database _db;
  final String _token;

  InspeccionRepository(this._api, this._db, @factoryParam this._token);

  Future<Either<ApiFailure, Unit>> subirInspeccion(
      Inspeccion inspeccion) async {
    //TODO: subir las fotos
    final ins = await _db.getInspeccionConRespuestas(inspeccion);
    try {
      /*final res = await _api.putRecurso('/inspecciones/${ins['id']}/', ins,
          token: _token);*/
      log(jsonEncode(ins));
      await _api.postRecurso('/inspecciones/', ins, token: _token);
      return right(unit);
    } on TimeoutException {
      return const Left(ApiFailure.noHayConexionAlServidor());
    } on CredencialesException catch (e) {
      return Left(ApiFailure.serverError(jsonEncode(e.respuesta)));
    } on ServerException catch (e) {
      return Left(ApiFailure.serverError(jsonEncode(e.respuesta)));
    }
  }

  Future<Either<ApiFailure, Unit>> subirCuestionarios() async {
    //consultar cuestionarios pendientes
    final cuestionariosPendientes = [];
    //subir cada uno, o todos a la vez para mas eficiencia
  }

  Future<Either<ApiFailure, Unit>> subirCuestionario(
      Cuestionario cuestionario) async {
    //TODO: subir las fotos
    final ins = await _db.getCuestionarioCompleto(cuestionario);
    log(jsonEncode(ins));
    try {
      /*final res = await _api.putRecurso('/inspecciones/${ins['id']}/', ins,
          token: _token);*/
      log(jsonEncode(ins));
      await _api.postRecurso('/cuestionarios-completos/', ins, token: _token);
      await _db.marcarCuestionarioSubido(cuestionario);
      return right(unit);
    } on TimeoutException {
      return const Left(ApiFailure.noHayConexionAlServidor());
    } on CredencialesException catch (e) {
      return Left(ApiFailure.serverError(jsonEncode(e.respuesta)));
    } on ServerException catch (e) {
      return Left(ApiFailure.serverError(jsonEncode(e.respuesta)));
    }
  }
}
