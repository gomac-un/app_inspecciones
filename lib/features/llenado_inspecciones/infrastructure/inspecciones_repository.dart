import 'dart:async';
import 'dart:developer' as developer;

import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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

//TODO: pasar a freezed
class InspeccionesFailure {
  final String msg;

  InspeccionesFailure(this.msg);
}

// FEF: Future Either Fail
typedef FEF<C> = Future<Either<InspeccionesFailure, C>>;

class InspeccionesRepository {
  final drift.Database _db;
  final FotosRepository _fotosRepository;

  InspeccionesRepository(this._db, this._fotosRepository);

  Stream<List<Borrador>> getBorradores() => _db.borradoresDao.borradores(false);

  Future eliminarRespuestas(Borrador borrador) =>
      _db.borradoresDao.eliminarRespuestas(borrador.inspeccion.id);

  //FEF<List<Cuestionario>> cuestionariosParaActivo(String activo) async {
  Future<Either<InspeccionesFailure, List<Cuestionario>>>
      cuestionariosParaActivo(String activo) async {
    final int activoId;
    try {
      activoId = int.parse(activo);
    } on FormatException {
      return Left(InspeccionesFailure('Activo invalido'));
    }
    final cuestionarios = await _db.cargaDeInspeccionDao
        .getCuestionariosDisponiblesParaActivo(activoId);
    return Right(cuestionarios
        .map((cuest) => Cuestionario(
            id: cuest.id, tipoDeInspeccion: cuest.tipoDeInspeccion))
        .toList());
  }

  Future eliminarBorrador(Borrador borrador) =>
      _db.borradoresDao.eliminarBorrador(borrador);

  FEF<CuestionarioInspeccionado> cargarInspeccionLocal(
      IdentificadorDeInspeccion id) async {
    developer.log("cargando inspeccion $id");
    // try {
    final inspeccionCompleta = await _db.cargaDeInspeccionDao.cargarInspeccion(
        cuestionarioId: id.cuestionarioId, activoId: int.parse(id.activo));
    final cuestionario =
        await _db.creacionDao.getCuestionario(id.cuestionarioId);
    final inspeccion = inspeccionCompleta.value1;
    final activo = await _db.borradoresDao.getActivoPorId(inspeccion.activoId);
    final cuestionarioInspeccionado = CuestionarioInspeccionado(
        Cuestionario(
            id: cuestionario.id,
            tipoDeInspeccion: cuestionario.tipoDeInspeccion),
        Inspeccion(
            id: inspeccion.id,
            estado: EstadoDeInspeccion.values.firstWhere(
                (element) => element.index == inspeccion.estado.index),
            activo: activo,
            momentoBorradorGuardado: inspeccion.momentoBorradorGuardado,
            momentoEnvio: inspeccion.momentoEnvio,
            criticidadTotal: inspeccion.criticidadTotal,
            criticidadReparacion: inspeccion.criticidadReparacion,
            esNueva: inspeccion.esNueva),
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
