import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:inspecciones/core/error/exceptions.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/infrastructure/core/errors.dart';
import 'package:inspecciones/infrastructure/datasources/django_json_api.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/infrastructure/repositories/fotos_repository.dart';
import 'package:inspecciones/infrastructure/tablas_unidas.dart';

extension FutureEither<L, R> on Future<Either<L, R>> {
  Future<Either<L, R2>> flatMap<R2>(Function1<R, Future<Either<L, R2>>> f) {
    return then(
      (either1) => either1.fold(
        (l) => Future.value(left<L, R2>(l)),
        f,
      ),
    );
  }

  Future<Either<L, R2>> map<R2>(Function1<R, Either<L, R2>> f) {
    return then(
      (either1) => either1.fold(
        (l) => Future.value(left<L, R2>(l)),
        (r) => Future.value(f(r)),
      ),
    );
  }

  // TODO: Find an official FP name for mapping multiple layers deep into a nested composition
  Future<Either<L, R2>> nestedMap<R2>(Function1<R, R2> f) {
    return then(
      (either1) => either1.fold(
        (l) => Future.value(left<L, R2>(l)),
        (r) => Future.value(right<L, R2>(f(r))),
      ),
    );
  }

  Future<Either<L2, R>> leftMap<L2>(Function1<L, L2> f) {
    return then(
      (either1) => either1.fold(
        (l) => Future.value(left(f(l))),
        (r) => Future.value(right<L2, R>(r)),
      ),
    );
  }

  Future<Either<L, R2>> nestedEvaluatedMap<R2>(Future<R2> Function(R) f) {
    return then(
      (either1) => either1.fold(
        (l) => Future.value(left<L, R2>(l)),
        (r) async => right<L, R2>(await f(r)),
      ),
    );
  }
}

class InspeccionesRepository {
  final DjangoJsonApi _api;

  final MoorDatabase _db;
  final FotosRepository _fotosRepository;

  InspeccionesRepository(this._api, this._db, this._fotosRepository);

  /// Despues de la descarga de una inpeccion desde el server, se tiene que consultar nuevamente de la bd
  Future<Inspeccion> getInspeccionParaTerminar(int id) =>
      _db.getInspeccionParaTerminar(id);

  /// Descarga desde el servidor una inspección identificadada con [id] para poder continuarla en la app.
  /// retorna Right(unit) si se decargó exitosamente, de ser así, posteriormente
  /// se puede iniciar la inspeccion desde la pantalla de borradores
  Future<Either<ApiFailure, Unit>> getInspeccionServidor(int id) async {
    final inspeccionMap =
        _capturarExcepcionesDeApi(() => _api.getInspeccion(id));

    /// Al descargarla, se debe guardar en la bd para poder acceder a ella
    return inspeccionMap.nestedEvaluatedMap(
        (ins) => _db.guardarInspeccionBD(ins).then((_) => unit));
  }

  Future<Either<ApiFailure, T>> _capturarExcepcionesDeApi<T>(
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
    } catch (e) {
      return Left(ApiFailure.errorInesperadoDelServidor(e.toString()));
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
      const tipoDocumento = Categoria.inspeccion;
      final fotos = await _fotosRepository.getFotosDeDocumento(
        Categoria.inspeccion,
        identificador: idDocumento,
      );
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

  Stream<List<Borrador>> getBorradores() => _db.borradoresDao.borradores();
  Future eliminarRespuestas(Borrador borrador) =>
      _db.borradoresDao.eliminarRespuestas(borrador); //TODO que devuelve?
  /* Future<List<Cuestionario>> cuestionariosParaActivo(int activo) =>
      _db.llenadoDao.cuestionariosParaActivo(activo); */
  Future eliminarBorrador(Borrador borrador) =>
      _db.borradoresDao.eliminarBorrador(borrador); //TODO que devuelve?
}
