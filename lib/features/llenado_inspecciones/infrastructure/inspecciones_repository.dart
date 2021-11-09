import 'dart:async';
import 'dart:developer' as developer;

import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/domain/inspecciones/inspecciones_failure.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/inspeccion.dart';
import 'package:inspecciones/infrastructure/drift_database.dart' as drift;
import 'package:inspecciones/infrastructure/repositories/fotos_repository.dart';

import '../domain/bloques/bloques.dart';
import '../domain/borrador.dart';
import '../domain/cuestionario.dart';
import '../domain/identificador_inspeccion.dart';

final inspeccionesRepositoryProvider = Provider(
  (ref) => InspeccionesRepository(
    ref.watch(drift.driftDatabaseProvider),
    ref.watch(fotosRepositoryProvider),
  ),
);

// FEF: Future Either Fail
typedef FEF<C> = Future<Either<InspeccionesFailure, C>>;

class InspeccionesRepository {
  final drift.Database _db;
  final FotosRepository _fotosRepository;

  InspeccionesRepository(this._db, this._fotosRepository);

  Stream<List<Borrador>> getBorradores() =>
      _db.borradoresDao.borradores(mostrarSoloEnviadas: false);

  FEF<Unit> eliminarRespuestas(Borrador borrador) => _db.borradoresDao
      .eliminarRespuestas(inspeccionId: borrador.inspeccion.id)
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
              tipoDeInspeccion: cuest.tipoDeInspeccion,
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
    developer.log("cargando inspeccion $id");
    // try {
    final inspeccionCompleta = await _db.cargaDeInspeccionDao.cargarInspeccion(
        cuestionarioId: id.cuestionarioId, activoId: int.parse(id.activo));
    final cuestionario =
        await _db.cargaDeCuestionarioDao.getCuestionario(id.cuestionarioId);
    final inspeccion = inspeccionCompleta.value1;
    final activo = await _db.borradoresDao.getActivo(inspeccion.activoId);
    final cuestionarioInspeccionado = CuestionarioInspeccionado(
        Cuestionario(
            id: cuestionario.id,
            tipoDeInspeccion: cuestionario.tipoDeInspeccion!),
        Inspeccion(
            id: inspeccion.id,
            estado: EstadoDeInspeccion.values.firstWhere(
                (element) => element.index == inspeccion.estado.index),
            activo: activo,
            momentoBorradorGuardado: inspeccion.momentoBorradorGuardado,
            momentoEnvio: inspeccion.momentoEnvio,
            criticidadTotal: inspeccion.criticidadTotal,
            criticidadReparacion: inspeccion.criticidadReparacion),
        inspeccionCompleta.value2);
    return Right(cuestionarioInspeccionado);
    // } catch (e) {
    //   return Left(InspeccionesFailure(e.toString()));
    // }
  }

  Future<void> guardarInspeccion(
    Iterable<Pregunta> preguntasRespondidas,
    Inspeccion inspeccion,
  ) =>
      _db.guardadoDeInspeccionDao.guardarInspeccion(
        preguntasRespondidas,
        inspeccion,
        _fotosRepository,
      );
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
    );
