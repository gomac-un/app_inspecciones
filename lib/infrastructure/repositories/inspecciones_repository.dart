import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/infrastructure/datasources/fotos_remote_datasource.dart';
import 'package:inspecciones/infrastructure/utils/future_either_x.dart';

import '../datasources/inspecciones_remote_datasource.dart';
import '../moor_database.dart';
import '../tablas_unidas.dart';
import '../utils/transformador_excepciones_api.dart';
import 'fotos_repository.dart';

class InspeccionesRepository {
  final InspeccionesRemoteDataSource _api;
  final FotosRemoteDataSource _apiFotos;
  final MoorDatabase _db;
  final FotosRepository _fotosRepository;

  InspeccionesRepository(
      this._api, this._apiFotos, this._db, this._fotosRepository);

  /// Despues de la descarga de una inpeccion desde el server, se tiene que
  /// consultar nuevamente de la bd
  Future<Inspeccion> getInspeccionParaTerminar(int id) =>
      _db.getInspeccionParaTerminar(id);

  /// Descarga desde el servidor una inspección identificadada con [id] para
  ///  poder continuarla en la app.
  /// retorna Right(unit) si se decargó exitosamente, de ser así, posteriormente
  /// se puede iniciar la inspeccion desde la pantalla de borradores
  Future<Either<ApiFailure, Unit>> getInspeccionServidor(int id) async {
    final inspeccionMap = apiExceptionToApiFailure(
      () => _api.getInspeccion(id),
    );

    /// Al descargarla, se debe guardar en la bd para poder acceder a ella
    return inspeccionMap.nestedEvaluatedMap(
      (ins) => _db.guardarInspeccionBD(ins).then((_) => unit),
    );
  }

  /// Envia [inspeccion] al server
  Future<Either<ApiFailure, Unit>> subirInspeccion(
      Inspeccion inspeccion) async {
    //TODO: mostrar el progreso en la ui
    /// Se obtiene un json con la info de la inspeción y sus respectivas respuestas
    final inspeccionMap = await _db.getInspeccionConRespuestas(inspeccion);

    /// [inspeccion.esNueva] es un campo usado localmente para saber si fue creada o se descaargó desde el server.
    /// Se debe eliminar de [ins] porque genera un error en el server. (En proceso de mejora)
    inspeccionMap.remove('esNueva');

    /// Se hace la petición a diferentes urls dependiendo si es una inspección
    ///  creada o si es una edición de una que ya fue subida al server
    crearInspeccion() => inspeccion.esNueva
        ? _api.crearInspeccion(inspeccionMap)
        : _api.actualizarInspeccion(inspeccion.id, inspeccionMap);

    subirFotos() async {
      /// Usado para el nombre de la carpeta de las fotos
      final idDocumento = inspeccionMap['id'].toString();
      const tipoDocumento = Categoria.inspeccion;
      final fotos = await _fotosRepository.getFotosDeDocumento(
        Categoria.inspeccion,
        identificador: idDocumento,
      );
      return _apiFotos.subirFotos(fotos, idDocumento, tipoDocumento);
    }

    return apiExceptionToApiFailure(crearInspeccion).flatMap(
        (a) => apiExceptionToApiFailure(() => subirFotos().then((_) => unit)));
  }

  Stream<List<Borrador>> getBorradores() => _db.borradoresDao.borradores();

  Future<Either<ApiFailure, Unit>> eliminarRespuestas(
          Borrador borrador) async =>
      Right(await _db.borradoresDao
          .eliminarRespuestas(borrador)
          .then((_) => unit));
  /* Future<List<Cuestionario>> cuestionariosParaActivo(int activo) =>
      _db.llenadoDao.cuestionariosParaActivo(activo); */
  Future eliminarBorrador(Borrador borrador) =>
      _db.borradoresDao.eliminarBorrador(borrador);
}
