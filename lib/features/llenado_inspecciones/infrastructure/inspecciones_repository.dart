import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/core/enums.dart' as en;
import 'package:inspecciones/core/error/exceptions.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/inspeccion.dart';
import 'package:inspecciones/infrastructure/datasources/providers.dart';
import 'package:inspecciones/infrastructure/datasources/remote_datasource.dart';
import 'package:inspecciones/infrastructure/moor_database.dart' as moor;
import 'package:inspecciones/infrastructure/repositories/fotos_repository.dart';

import '../domain/bloques/bloques.dart';
import '../domain/borrador.dart';
import '../domain/cuestionario.dart';
import '../domain/identificador_inspeccion.dart';

final inspeccionesRepositoryProvider = Provider((ref) => InspeccionesRepository(
    ref.watch(moor.moorDatabaseProvider),
    ref.watch(fotosRepositoryProvider),
    ref.watch(inspeccionesRemoteDataSourceProvider)));

//TODO: pasar a freezed
class InspeccionesFailure {
  final String msg;

  InspeccionesFailure(this.msg);
}

// FEF: Future Either Fail
typedef FEF<C> = Future<Either<InspeccionesFailure, C>>;

class InspeccionesRepository {
  final InspeccionesRemoteDataSource _api;
  final moor.MoorDatabase _db;
  final FotosRepository _fotosRepository;

  InspeccionesRepository(this._db, this._fotosRepository, this._api);

  Stream<List<Borrador>> getBorradores() => _db.borradoresDao.borradores(false);

  Future eliminarRespuestas(Borrador borrador) =>
      _db.borradoresDao.eliminarRespuestas(borrador.inspeccion.id);

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

  FEF<CuestionarioInspeccionado> cargarInspeccionLocal(
      IdentificadorDeInspeccion id) async {
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

  Future<void> guardarInspeccion(List<Pregunta> preguntasRespondidas,
      {required Inspeccion inspeccion}) async {
    _db.llenadoDao.guardarInspeccion(preguntasRespondidas, inspeccion,
        fotosManager: _fotosRepository);
  }

  /// Envia [inspeccion] al server
  Future<Either<ApiFailure, Unit>> subirInspeccion(
      Inspeccion inspeccion) async {
    //TODO: mostrar el progreso en la ui
    /// Se obtiene un json con la info de la inspeción y sus respectivas respuestas
    final inspAEnviar = moor.Inspeccion(
        id: inspeccion.id,
        estado: en.EstadoDeInspeccion.values
            .firstWhere((element) => element.index == inspeccion.estado.index),
        activoId: int.parse(inspeccion.activo.id),
        momentoBorradorGuardado: inspeccion.momentoBorradorGuardado,
        momentoEnvio: DateTime.now(),
        criticidadTotal: inspeccion.criticidadTotal,
        criticidadReparacion: inspeccion.criticidadReparacion,
        esNueva: inspeccion.esNueva,
        cuestionarioId: inspeccion.cuestionario.cuestionario.id);
    final ins = await _db.getInspeccionConRespuestas(inspAEnviar);
    try {
      const _urlInsp = '/inspecciones/';

      /// [inspeccion.esNueva] es un campo usado localmente para saber si fue creada o se descaargó desde el server.
      /// Se debe eliminar de [ins] porque genera un error en el server. (En proceso de mejora)
      ins.remove('esNueva');
      log(jsonEncode(ins));

      /// Se hace la petición a diferentes urls dependiendo si es una inspección creada o si es una edición de una que ya fue subida al server
      inspeccion.esNueva
          ? await _api.postRecurso(_urlInsp, ins)
          : await _api.putRecurso('$_urlInsp${inspeccion.id}/', ins);

      /// Usado para el nombre de la carpeta de las fotos
      final idDocumento = ins['id'].toString();
      const tipoDocumento = Categoria.inspeccion;
      final fotos = await _fotosRepository.getFotosDeDocumento(
        Categoria.inspeccion,
        identificador: idDocumento,
      );
      await _api.subirFotos(fotos, idDocumento, tipoDocumento);

      return right(unit);
    } on TimeoutException {
      return const Left(ApiFailure.noHayConexionAlServidor());
    } on CredencialesException {
      return const Left(ApiFailure.credencialesException());
    } on ServerException catch (e) {
      return Left(ApiFailure.serverError(jsonEncode(e.respuesta)));
    } on InternetException {
      return const Left(ApiFailure.noHayInternet());
    } on PageNotFoundException {
      return const Left(ApiFailure.pageNotFound());
    } catch (e) {
      return Left(ApiFailure.serverError(e.toString()));
    }
  }

  Future<Either<ApiFailure, IdentificadorDeInspeccion>> cargarInspeccionRemota(
      int inspeccionId) async {
    //TODO: implementar
    developer.log("cargando inspeccion $inspeccionId");
    try {
      final endpoint = '/inspecciones/$inspeccionId';
      final inspeccion = await _api.getRecurso(endpoint);

      /// Al descargarla, se debe guardar en la bd para poder acceder a ella
      final id = await _db.guardarInspeccionBD(inspeccion);
      return right(id);
    } on TimeoutException {
      return const Left(ApiFailure.noHayConexionAlServidor());
    } on CredencialesException {
      return const Left(ApiFailure.credencialesException());
    } on ServerException catch (e) {
      return Left(ApiFailure.serverError(jsonEncode(e.respuesta)));
    } on InternetException {
      return const Left(ApiFailure.noHayInternet());
    } on PageNotFoundException {
      return const Left(ApiFailure.pageNotFound());
    } catch (e) {
      return Left(ApiFailure.serverError(e.toString()));
    }
  }
}
