import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/identificador_inspeccion.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/inspeccion.dart';
import 'package:inspecciones/infrastructure/datasources/fotos_remote_datasource.dart';
import 'package:inspecciones/infrastructure/utils/future_either_x.dart';

import '../datasources/inspecciones_remote_datasource.dart';
import '../moor_database.dart' as moor;
import '../utils/transformador_excepciones_api.dart';
import 'fotos_repository.dart';

class InspeccionesRemoteRepository {
  final InspeccionesRemoteDataSource _api;
  final FotosRemoteDataSource _apiFotos;
  final moor.MoorDatabase _db;
  final FotosRepository _fotosRepository;

  InspeccionesRemoteRepository(
      this._api, this._apiFotos, this._db, this._fotosRepository);

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
      (ins) => _db.guardarInspeccionBD(ins),
    );
  }

  /// Envia [inspeccion] al server
  Future<Either<ApiFailure, Unit>> subirInspeccion(
      Inspeccion inspeccion) async {
    //TODO: mostrar el progreso en la ui
    /// Se obtiene un json con la info de la inspeción y sus respectivas respuestas
    final inspAEnviar = moor.Inspeccion(
        id: inspeccion.id,
        estado: inspeccion.estado,
        activoId: int.parse(inspeccion.activo.id),
        momentoBorradorGuardado: inspeccion.momentoBorradorGuardado,
        momentoEnvio: DateTime.now(),
        criticidadTotal: inspeccion.criticidadTotal,
        criticidadReparacion: inspeccion.criticidadReparacion,
        esNueva: inspeccion.esNueva,
        cuestionarioId: inspeccion.cuestionario.cuestionario.id);
    final inspeccionMap = await _db.getInspeccionConRespuestas(inspAEnviar);

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
}
