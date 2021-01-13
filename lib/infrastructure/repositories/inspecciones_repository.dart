import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:inspecciones/core/error/exceptions.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/infrastructure/datasources/remote_datasource.dart';
import 'package:inspecciones/infrastructure/fotos_manager.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';

@injectable
class InspeccionesRepository {
  final InspeccionesRemoteDataSource _api;
  final Database _db;

  InspeccionesRepository(this._api, this._db);

  Future<Either<ApiFailure, Unit>> subirInspeccion(
      Inspeccion inspeccion) async {
    //TODO: mostrar el progreso en la ui
    final ins = await _db.getInspeccionConRespuestas(inspeccion);
    try {
      /*final res = await _api.putRecurso('/inspecciones/${ins['id']}/', ins,
          token: _token);*/
      log(jsonEncode(ins));
      await _api.postRecurso('/inspecciones/', ins);

      final idDocumento = ins['id'].toString();
      const tipoDocumento = 'inspecciones';
      final fotos = await FotosManager.getFotosDeDocumento(
          idDocumento: idDocumento, tipoDocumento: tipoDocumento);
      await _api.subirFotos(fotos, idDocumento, tipoDocumento);

      return right(unit);
    } on TimeoutException {
      return const Left(ApiFailure.noHayConexionAlServidor());
    } on CredencialesException catch (e) {
      return Left(ApiFailure.serverError(jsonEncode(e.respuesta)));
    } on ServerException catch (e) {
      return Left(ApiFailure.serverError(jsonEncode(e.respuesta)));
    } catch (e) {
      return Left(ApiFailure.serverError(e.toString()));
    }
  }

  Future<Either<ApiFailure, Unit>> subirCuestionariosPendientes() async {
    //TODO: subir cada uno, o todos a la vez para mas eficiencia
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
      await _api.postRecurso('/cuestionarios-completos/', ins);
      await _db.marcarCuestionarioSubido(cuestionario);

      final idDocumento = ins['id'].toString();
      const tipoDocumento = 'cuestionarios';
      final fotos = await FotosManager.getFotosDeDocumento(
          idDocumento: idDocumento, tipoDocumento: tipoDocumento);
      await _api.subirFotos(fotos, idDocumento, tipoDocumento);

      return right(unit);
    } on TimeoutException {
      return const Left(ApiFailure.noHayConexionAlServidor());
    } on CredencialesException catch (e) {
      return Left(ApiFailure.serverError(jsonEncode(e.respuesta)));
    } on ServerException catch (e) {
      return Left(ApiFailure.serverError(jsonEncode(e.respuesta)));
    }
  }

  Future descargarCuestionarios(String savedir, String nombreJson) async {
    _api.descargaFlutterDownloader('/server/', savedir, nombreJson);
  }

  Future descargarFotos(String savedir, String nombreZip) async {
    _api.descargaFlutterDownloader(
        '/media/fotos-app-inspecciones/cuestionarios.zip', savedir, nombreZip);
  }
}
