import 'dart:developer' as developer;

import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/inspeccion.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/modelos.dart';
import 'package:inspecciones/infrastructure/moor_database.dart' as moor;
import 'package:inspecciones/infrastructure/repositories/fotos_repository.dart';

import '../domain/bloques/bloques.dart';
import '../domain/borrador.dart';
import '../domain/cuestionario.dart';
import '../domain/identificador_inspeccion.dart';

final inspeccionesRepositoryProvider = Provider((ref) => InspeccionesRepository(
      ref.watch(moor.moorDatabaseProvider),
      ref.watch(fotosRepositoryProvider),
    ));

//TODO: pasar a freezed
class InspeccionesFailure {
  final String msg;

  InspeccionesFailure(this.msg);
}

// FEF: Future Either Fail
typedef FEF<C> = Future<Either<InspeccionesFailure, C>>;

class InspeccionesRepository {
  final moor.MoorDatabase _db;
  final FotosRepository _fotosRepository;

  InspeccionesRepository(this._db, this._fotosRepository);

  Stream<List<Borrador>> getBorradores() => _db.borradoresDao.borradores(false);

  //FEF<List<Cuestionario>> cuestionariosParaActivo(String activo) async {
  Future<Either<InspeccionesFailure, List<Cuestionario>>>
      cuestionariosParaActivo(String activo) async {
    try {
      final activoId = int.parse(activo);
      final cuestionarios =
          await _db.llenadoDao.cuestionariosParaActivo(activoId);
      return Right(cuestionarios
          .map((cuest) => Cuestionario(
              id: cuest.id, tipoDeInspeccion: cuest.tipoDeInspeccion))
          .toList());
    } catch (e) {
      return Left(InspeccionesFailure('Activo invalido'));
    }
  }

  Future eliminarBorrador(Borrador borrador) =>
      _db.borradoresDao.eliminarBorrador(borrador);

  Future<Either<InspeccionesFailure, CuestionarioInspeccionado>>
      cargarInspeccionLocal(IdentificadorDeInspeccion id) async {
    developer.log("cargando inspeccion $id");
    try {
      final inspeccionCompleta = await _db.llenadoDao
          .cargarInspeccion(id.cuestionarioId, int.parse(id.activo));
      inspeccionCompleta.value2.sort((a, b) => a.nOrden.compareTo(b.nOrden));
      final cuestionario =
          await _db.creacionDao.getCuestionario(id.cuestionarioId);
      final inspeccion = inspeccionCompleta.value1;
      final activo =
          await _db.borradoresDao.getActivoPorId(inspeccion.activoId);
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
    } catch (e) {
      return Left(InspeccionesFailure(e.toString()));
    }
  }

  FEF<CuestionarioInspeccionado> cargarInspeccionRemota(
      int inspeccionId) async {
    //TODO: implementar
    developer.log("cargando inspeccion $inspeccionId");
    //await Future.delayed(const Duration(seconds: 1));
    if (inspeccionId == 1) {
      return Right(await _inspeccionNueva());
    } else {
      return Right(await _inspeccionIniciada());
    }
  }

  Future<void> guardarInspeccion(List<Pregunta> preguntasRespondidas,
      {required Inspeccion inspeccion}) async {
    _db.llenadoDao.guardarInspeccion(preguntasRespondidas, inspeccion,
        fotosManager: _fotosRepository);
  }

}
