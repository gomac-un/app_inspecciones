import 'dart:developer' as developer;
import 'dart:math';

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

  Stream<List<Borrador>> getBorradores() => Stream.value([
        Borrador(
          Inspeccion(
            id: 1,
            estado: EstadoDeInspeccion.borrador,
            activo: Activo(id: "1", modelo: "auto"),
            momentoBorradorGuardado: DateTime.now(),
            criticidadTotal: 10,
            criticidadReparacion: 5,
            esNueva: true,
          ),
          Cuestionario(id: 1, tipoDeInspeccion: "preoperacional"),
          avance: 5,
          total: 10,
        )
      ]);

  //FEF<List<Cuestionario>> cuestionariosParaActivo(String activo) async {
  Future<Either<InspeccionesFailure, List<Cuestionario>>>
      cuestionariosParaActivo(String activo) async {
    return Right([
      if (activo == "1")
        Cuestionario(id: 1, tipoDeInspeccion: "preoperacional"),
      Cuestionario(id: 2, tipoDeInspeccion: "otro cuestionario"),
    ]);
  }

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
      {required int inspeccionId}) async {
    /* _db.llenadoDao.guardarInspeccion(respuestas,inspeccionId); */

    developer.log("guardando inspeccion $inspeccionId");
    for (final respuesta in preguntasRespondidas) {
      developer.log(respuesta.toString());
    }
  }

}
