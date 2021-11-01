import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/features/configuracion_organizacion/domain/entities.dart';
import 'package:inspecciones/infrastructure/core/typedefs.dart';
import 'package:inspecciones/infrastructure/datasources/organizacion_remote_datasource.dart';
import 'package:inspecciones/infrastructure/datasources/providers.dart';
import 'package:inspecciones/infrastructure/utils/transformador_excepciones_api.dart';

class OrganizacionRepository {
  final Reader _read;
  OrganizacionRemoteDataSource get _api =>
      _read(organizacionRemoteDataSourceProvider);

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

  Future<Either<ApiFailure, List<ActivoEnLista>>> getListaDeActivos() =>
      apiExceptionToApiFailure(
        () => _api
            .getListaDeActivos()
            .then((l) => l.map((j) => ActivoEnLista.fromMap(j)).toList()),
      );

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
