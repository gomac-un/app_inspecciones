import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/features/configuracion_organizacion/domain/entities.dart';
import 'package:inspecciones/utils/future_either_x.dart';

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

  Future<Tuple2<ApiFailure?, Set<ActivoEnLista>>>
      refreshListaDeActivos() async {
    final remoteRes = await apiExceptionToApiFailure(
      () => _api
          .getListaDeActivos()
          .then((l) => l.map((j) => ActivoEnLista.fromMap(j)).toList()),
    );

    await remoteRes.fold((_) {}, (r) => _db.organizacionDao.setActivos(r));
    final activos = await _db.organizacionDao.getActivos();

    return Tuple2(remoteRes.fold(id, (_) => null), activos.toSet());
  }

  Future<Either<ApiFailure, Unit>> guardarActivo(ActivoEnLista activo) =>
      apiExceptionToApiFailure(
        () => _api.guardarActivo(activo.toMap()).then((r) => unit),
      );

  Future<Either<ApiFailure, Unit>> borrarActivo(ActivoEnLista activo) =>
      apiExceptionToApiFailure(
        () => _api.borrarActivo(activo.id),
      ).nestedEvaluatedMap(
          (_) => _db.organizacionDao.borrarActivo(activo).then((r) => unit));

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

  Future<void> guardarEtiquetasJerarquicasDeActivos(
          List<Jerarquia> etiquetas) =>
      _db.organizacionDao.setEtiquetasJerarquicasDeActivos(etiquetas);

  Future<void> guardarEtiquetasJerarquicasDePreguntas(
          List<Jerarquia> etiquetas) =>
      _db.organizacionDao.setEtiquetasJerarquicasDePreguntas(etiquetas);

  Future<Either<ApiFailure, Unit>> sincronizarEtiquetasDeActivos() async {
    return apiExceptionToApiFailure(
      () => _api.getListaDeEtiquetasDeActivos().then((l) =>
          l.map((j) => Jerarquia.fromMap(j['json'], esLocal: false)).toList()),
    )
        .nestedEvaluatedMap((etiquetas) =>
            _db.organizacionDao.setEtiquetasJerarquicasDeActivos(etiquetas))
        .flatMap((_) => _subirEtiquetasPendientesDeActivos());
  }

  Future<Either<ApiFailure, Unit>> _subirEtiquetasPendientesDeActivos() async {
    final etiquetasPendientes =
        await _db.organizacionDao.getEtiquetasPendientesDeActivos();
    if (etiquetasPendientes.isEmpty) return const Right(unit);

    return apiExceptionToApiFailure(
      () => _api.subirListaDeEtiquetasDeActivos(
          etiquetasPendientes.map((e) => e.toJson()).toList()),
    ).nestedEvaluatedMap((_) => _db.organizacionDao
        .desmarcarEtiquetasPendientesDeActivo()
        .then((_) => unit));
  }

  Future<Either<ApiFailure, Unit>> sincronizarEtiquetasDePreguntas() async {
    return apiExceptionToApiFailure(
      () => _api.getListaDeEtiquetasDePreguntas().then((l) =>
          l.map((j) => Jerarquia.fromMap(j['json'], esLocal: true)).toList()),
    )
        .nestedEvaluatedMap((etiquetas) =>
            _db.organizacionDao.setEtiquetasJerarquicasDePreguntas(etiquetas))
        .flatMap((_) => _subirEtiquetasPendientesDePreguntas());
  }

  Future<Either<ApiFailure, Unit>>
      _subirEtiquetasPendientesDePreguntas() async {
    final etiquetasPendientes =
        await _db.organizacionDao.getEtiquetasPendientesDePreguntas();
    if (etiquetasPendientes.isEmpty) return const Right(unit);

    return apiExceptionToApiFailure(
      () => _api.subirListaDeEtiquetasDePreguntas(
          etiquetasPendientes.map((e) => e.toJson()).toList()),
    ).nestedEvaluatedMap((_) => _db.organizacionDao
        .desmarcarEtiquetasPendientesDePregunta()
        .then((_) => unit));
  }
}
