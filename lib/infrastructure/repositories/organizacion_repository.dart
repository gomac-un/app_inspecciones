import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/features/configuracion_organizacion/domain/entities.dart';

import '../core/typedefs.dart';
import '../datasources/organizacion_remote_datasource.dart';
import '../datasources/providers.dart';
import '../drift_database.dart' as drift;
import '../utils/transformador_excepciones_api.dart';

class OrganizacionRepository {
  final Reader _read;
  OrganizacionRemoteDataSource get _api =>
      _read(organizacionRemoteDataSourceProvider);

  drift.Database get _db => _read(drift.driftDatabaseProvider);

  OrganizacionRepository(this._read);

  Future<Either<ApiFailure, List<UsuarioEnLista>>> getListaDeUsuarios() =>
      apiExceptionToApiFailure(
        () => _api
            .getListaDeUsuarios()
            .then((l) => l.map((j) => UsuarioEnLista.fromMap(j)).toList()),
      );

  Future<Either<ApiFailure, Organizacion>> getMiOrganizacion() =>
      apiExceptionToApiFailure(
        () => _api.getOrganizacion(null).then((r) => Organizacion.fromMap(r)),
      );

  Future<Tuple2<ApiFailure?, List<ActivoEnLista>>>
      refreshListaDeActivos() async {
    final remoteRes = await apiExceptionToApiFailure(
      () => _api
          .getListaDeActivos()
          .then((l) => l.map((j) => ActivoEnLista.fromMap(j)).toList()),
    );

    await remoteRes.fold((_) {}, (r) => _db.sincronizacionDao.setActivos(r));
    final activos = await _db.organizacionDao.getActivos();

    return Tuple2(remoteRes.fold(id, (_) => null), activos);
  }

  Future<Either<ApiFailure, Unit>> guardarActivo(ActivoEnLista activo) =>
      apiExceptionToApiFailure(
        () => _api.guardarActivo(activo.toMap()).then((r) => unit),
      );

  Future<Either<ApiFailure, Unit>> crearOrganizacion(
          {required JsonMap formulario}) =>
      apiExceptionToApiFailure(
        () => _api.crearOrganizacion(formulario).then((r) => unit),
      );
  Future<Either<ApiFailure, Unit>> actualizarOrganizacion(
          {required int id, required JsonMap formulario}) =>
      apiExceptionToApiFailure(
        () => _api.actualizarOrganizacion(id, formulario).then((r) => unit),
      );
}
