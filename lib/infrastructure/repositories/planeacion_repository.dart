import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:inspecciones/core/error/exceptions.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/infrastructure/datasources/remote_datasource.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/infrastructure/tablas_unidas.dart';

@injectable
class PlaneacionRepository {
  final InspeccionesRemoteDataSource _api;
  final Database _db;

  PlaneacionRepository(this._api, this._db);

  Future<Either<ApiFailure, Unit>> crearGrupos(
      GrupoXTipoInspeccion grupo) async {
    final Map<String, dynamic> jsonGrupos = {};
    jsonGrupos['tipoInspeccion'] = grupo.tipoInspeccion.toJson();
    final una = grupo.grupos
        .map((gru) => gru.toJson(serializer: const CustomSerializer()))
        .toList();
    jsonGrupos['grupos'] = una;
    try {
      log(jsonEncode(jsonGrupos));
      await _api.postRecurso('/grupo_inspeccion/', jsonGrupos);

      return right(unit);
    } on TimeoutException {
      return const Left(ApiFailure.noHayConexionAlServidor());
    } on CredencialesException {
      return const Left(ApiFailure.credencialesException());
    } on ServerException catch (e) {
      return Left(ApiFailure.serverError(jsonEncode(e.respuesta)));
    } on InternetException {
      return const Left(ApiFailure.noHayInternet());
    } on PageNotFoundException {
      return const Left(ApiFailure.pageNotFound());
    } catch (e) {
      return Left(ApiFailure.serverError(e.toString()));
    }
  }
}
