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

/// Contiene los metodos encargados de subir cuestionarios e inspecciones al server y descargar inspecciones.
@injectable
class InspeccionesRepository {
  final InspeccionesRemoteDataSource _api;
  final Database _db;

  InspeccionesRepository(this._api, this._db);

  /// Despues de la descarga de una inpeccion desde el server, se tiene que consultar nuevamente de la bd
  Future<Inspeccion> getInspeccionParaTerminar(int id) =>
      _db.getInspeccionParaTerminar(id);

  /// Descarga desde el servidor una inspección identificadada con [id] para poder continuarla en la app.
  Future<Either<ApiFailure, Unit>> getInspeccionServidor(int id) async {
    try {
      final endpoint = '/inspecciones/$id';
      final inspeccion = await _api.getRecurso(endpoint);

      /// Al descargarla, se debe guardar en la bd para poder acceder a ella
      await _db.guardarInspeccionBD(inspeccion);
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

  /// Envia [inspeccion] al server
  Future<Either<ApiFailure, Unit>> subirInspeccion(
      Inspeccion inspeccion) async {
    //TODO: mostrar el progreso en la ui
    /// Se obtiene un json con la info de la inspeción y sus respectivas respuestas
    final ins = await _db.getInspeccionConRespuestas(inspeccion);
    try {
      const _urlInsp = '/inspecciones/';

      /// [inspeccion.esNueva] es un campo usado localmente para saber si fue creada o se descaargó desde el server.
      /// Se debe eliminar de [ins] porque genera un error en el server. (En proceso de mejora)
      ins.remove('esNueva');
      log(jsonEncode(ins));

      /// Se hace la petición a diferentes urls dependiendo si es una inspección creada o si es una edición de una que ya fue subida al server
      inspeccion.esNueva
          ? await _api.postRecurso(_urlInsp, ins)
          : await _api.putRecurso('$_urlInsp${inspeccion.id}/', ins);

      /// Usado para el nombre de la carpeta de las fotos
      final idDocumento = ins['id'].toString();
      const tipoDocumento = 'inspecciones';
      final fotos = await FotosManager.getFotosDeDocumento(
          idDocumento: idDocumento, tipoDocumento: tipoDocumento);
      await _api.subirFotos(fotos, idDocumento, tipoDocumento);

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

  Future<Either<ApiFailure, Unit>> subirCuestionariosPendientes() async {
    //TODO: subir cada uno, o todos a la vez para mas eficiencia
    throw UnimplementedError();
  }

  /// Envia [cuestionario] al server.
  Future<Either<ApiFailure, Unit>> subirCuestionario(
      Cuestionario cuestionario) async {
    /// Json con info de [cuestionario] y sus respectivos bloques.
    final cues = await _db.getCuestionarioCompleto(cuestionario);
    log(jsonEncode(cues));
    try {
      log(jsonEncode(cues));
      await _api.postRecurso('/cuestionarios-completos/', cues);

      /// Como los cuestionarios quedan en el celular, se marca como subidos para que no se envíe al server un cuestionario que ya existe.
      /// cambia [cuestionario.esLocal] = false.
      await _db.marcarCuestionarioSubido(cuestionario);

      /// Usado para el nombre de la carpeta de las fotos
      final idDocumento = cues['id'].toString();
      const tipoDocumento = 'cuestionarios';
      final fotos = await FotosManager.getFotosDeDocumento(
          idDocumento: idDocumento, tipoDocumento: tipoDocumento);
      await _api.subirFotos(fotos, idDocumento, tipoDocumento);
      return right(unit);
    } on TimeoutException {
      return const Left(ApiFailure.noHayConexionAlServidor());
    } on CredencialesException catch (e) {
      return Left(ApiFailure.serverError(jsonEncode(e.respuesta)));
    } on InternetException {
      return const Left(ApiFailure.noHayInternet());
    } on ServerException catch (e) {
      return Left(ApiFailure.serverError(jsonEncode(e.respuesta)));
    }
  }

  /// Descarga los cuestionarios y todo lo necesario para tratarlos:
  /// activos, sistemas, contratistas y subsistemas
  Future descargarCuestionarios(String savedir, String nombreJson) async {
    _api.descargaFlutterDownloader('/server/', savedir, nombreJson);
  }

  /// Descarga todas las fotos de todos los cuestionarios
  Future descargarFotos(String savedir, String nombreZip) async {
    _api.descargaFlutterDownloader(
        '/media/fotos-app-inspecciones/cuestionarios.zip', savedir, nombreZip);
  }
}
