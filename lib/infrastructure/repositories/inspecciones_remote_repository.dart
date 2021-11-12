import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/cuestionario.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/identificador_inspeccion.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/inspeccion.dart';
import 'package:inspecciones/infrastructure/datasources/fotos_remote_datasource.dart';
import 'package:inspecciones/infrastructure/datasources/providers.dart';
import 'package:inspecciones/utils/future_either_x.dart';

import '../datasources/inspecciones_remote_datasource.dart';
import '../drift_database.dart' as drift;
import '../utils/transformador_excepciones_api.dart';
import 'fotos_repository.dart';

class InspeccionesRemoteRepository {
  final Reader _read;
  InspeccionesRemoteDataSource get _api =>
      _read(inspeccionesRemoteDataSourceProvider);
  FotosRemoteDataSource get _apiFotos => _read(fotosRemoteDataSourceProvider);
  drift.Database get _db => _read(drift.driftDatabaseProvider);
  FotosRepository get _fotosRepository => _read(fotosRepositoryProvider);

  InspeccionesRemoteRepository(this._read);

  /// Descarga desde el servidor una inspección identificadada con [id] para
  ///  poder continuarla en la app.
  /// retorna Right(unit) si se decargó exitosamente, de ser así, posteriormente
  /// se puede iniciar la inspeccion desde la pantalla de borradores
  Future<Either<ApiFailure, IdentificadorDeInspeccion>> getInspeccionServidor(
      int id) async {
    final inspeccionMap = apiExceptionToApiFailure(
      () => _api.getInspeccion(id),
    );

    /// Al descargarla, se debe guardar en la bd para poder acceder a ella
    return inspeccionMap.nestedEvaluatedMap(
      (ins) => _db.sincronizacionDao.guardarInspeccionBD(ins),
    );
  }

  /// Envia [inspeccion] al server
  Future<Either<ApiFailure, Unit>> subirInspeccion(
      Inspeccion inspeccion, Cuestionario cuestionario) async {
    //TODO: mostrar el progreso en la ui
    /// Se obtiene un json con la info de la inspeción y sus respectivas respuestas
    final inspAEnviar = drift.Inspeccion(
      id: inspeccion.id,
      estado: inspeccion.estado,
      activoId: inspeccion.activo.id,
      momentoInicio: inspeccion.momentoInicio,
      momentoBorradorGuardado: inspeccion.momentoBorradorGuardado,
      momentoEnvio: DateTime.now(),
      cuestionarioId: cuestionario.id,
      inspectorId: inspeccion.inspectorId,
    );
    final inspeccionMap =
        await _db.sincronizacionDao.getInspeccionConRespuestas(inspAEnviar);

    /// Se hace la petición a diferentes urls dependiendo si es una inspección
    ///  creada o si es una edición de una que ya fue subida al server
    crearInspeccion() => //inspeccion.esNueva ?
        _api.crearInspeccion(inspeccionMap)
        //: _api.actualizarInspeccion(inspeccion.id, inspeccionMap)
        ;

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
}
