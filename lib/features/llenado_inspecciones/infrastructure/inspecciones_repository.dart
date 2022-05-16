import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/domain/inspecciones/inspecciones_failure.dart';
import 'package:inspecciones/infrastructure/drift_database.dart' as drift;

import '../domain/bloques/bloques.dart';
import '../domain/borrador.dart';
import '../domain/cuestionario.dart';
import '../domain/identificador_inspeccion.dart';

final inspeccionesRepositoryProvider = Provider.autoDispose(
  (ref) => InspeccionesRepository(
    ref.watch(drift.driftDatabaseProvider),
  ),
);

// FEF: Future Either Fail
typedef FEF<C> = Future<Either<InspeccionesFailure, C>>;

class InspeccionesRepository {
  final drift.Database _db;

  InspeccionesRepository(this._db);

  Stream<List<Borrador>> getBorradores() =>
      _db.borradoresDao.borradores(mostrarSoloEnviadas: false);

  FEF<Unit> eliminarRespuestas({Borrador? borrador, String? id}) =>
      _db.borradoresDao
          .eliminarRespuestas(inspeccionId: borrador?.inspeccion.id! ?? id!)
          .then((_) => const Right(unit),
              onError: (e, s) =>
                  Left(InspeccionesFailure.unexpectedError(e.toString())));

  //FEF<List<Cuestionario>> cuestionariosParaActivo(String activo) async {
  Future<Either<InspeccionesFailure, List<Cuestionario>>>
      cuestionariosParaActivo(String activoId) async {
    final cuestionarios = await _db.cargaDeInspeccionDao
        .getCuestionariosDisponiblesParaActivo(activoId);
    return Right(cuestionarios
        .map((cuest) => Cuestionario(
              id: cuest.id,
              tipoDeInspeccion: '${cuest.tipoDeInspeccion} V${cuest.version}',
            ))
        .toList());
  }

  FEF<Unit> eliminarBorrador(Borrador borrador) => _db.borradoresDao
      .eliminarBorrador(borrador)
      .then((_) => const Right(unit),
          onError: (e, s) =>
              Left(InspeccionesFailure.unexpectedError(e.toString())));

  FEF<CuestionarioInspeccionado> cargarInspeccionLocal(
      IdentificadorDeInspeccion id) async {
    // try {
    final cuestionarioInspeccionado =
        await _db.cargaDeInspeccionDao.cargarInspeccion(
      cuestionarioId: id.cuestionarioId,
      activoId: id.activo,
    );
    return Right(cuestionarioInspeccionado);
    // } catch (e) {
    //   return Left(InspeccionesFailure(e.toString()));
    // }
  }

  Future<void> guardarInspeccion(
    List<Pregunta> preguntasRespondidas,
    CuestionarioInspeccionado inspeccion,
  ) =>
      _db.guardadoDeInspeccionDao
          .guardarInspeccion(preguntasRespondidas, inspeccion);
}

InspeccionesFailure apiFailureToInspeccionesFailure(ApiFailure apiFailure) =>
    apiFailure.map(
      errorDeConexion: (_) =>
          const InspeccionesFailure.noHayConexionAlServidor(),
      errorInesperadoDelServidor: (e) => InspeccionesFailure.unexpectedError(e),
      errorDecodificandoLaRespuesta: (e) =>
          InspeccionesFailure.unexpectedError(e),
      errorDeCredenciales: (e) => InspeccionesFailure.unexpectedError(e),
      errorDePermisos: (e) => InspeccionesFailure.noTienePermisos(e),
      errorDeComunicacionConLaApi: (e) =>
          InspeccionesFailure.unexpectedError(e),
      errorDeProgramacion: (e) => InspeccionesFailure.unexpectedError(e),
      errorDatabase: (e) => InspeccionesFailure.errorDatabase(e),
    );
