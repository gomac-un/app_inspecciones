import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:inspecciones/core/error/exceptions.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/infrastructure/datasources/remote_datasource.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:kt_dart/kt.dart';
import 'package:moor/moor.dart';

@injectable
class PlaneacionRepository {
  final InspeccionesRemoteDataSource _api;
  final Database _db;

  PlaneacionRepository(this._api, this._db);

  Future<Either<ApiFailure, Unit>> crearGrupos(
      GrupoXTipoInspeccion grupo) async {
    final Map<String, dynamic> jsonGrupos = {};
    jsonGrupos['tipoInspeccion'] = grupo.tipoInspeccion.toJson();
    final una = grupo.grupos
        .map((gru) => gru.toJson(serializer: const CustomSerializer()))
        .toList();
    jsonGrupos['grupos'] = una;
    try {
      log(jsonEncode(jsonGrupos));
      await _api.postRecurso('/grupo_inspeccion/', jsonGrupos);

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
}

class CustomSerializer extends ValueSerializer {
  const CustomSerializer();

  @override
  T fromJson<T>(dynamic json) {
    if (json == null) {
      return null;
    }

    /*if (T == KtList) {
      return (json as List<String>).toImmutableList() as T;
    }*/
    if (json is List) {
      // https://stackoverflow.com/questions/50188729/checking-what-type-is-passed-into-a-generic-method
      // machetazo que convierte todas las listas a KtList<String> dado que no
      // se puede preguntar por T == KtList<String>, puede que se pueda arreglar
      // cuando los de dart implementen los alias de tipos https://github.com/dart-lang/language/issues/65
      return json.cast<String>().toImmutableList() as T;
    }

    if (T == DateTime) {
      return DateTime.parse(json as String) as T;
    }

    if (T == double && json is int) {
      return json.toDouble() as T;
    }

    // blobs are encoded as a regular json array, so we manually convert that to
    // a Uint8List
    if (T == Uint8List && json is! Uint8List) {
      final asList = (json as List).cast<int>();
      return Uint8List.fromList(asList) as T;
    }

    return json as T;
  }

  @override
  dynamic toJson<T>(T value) {
    if (value is DateTime) {
      return value.toIso8601String();
    }

    if (value is KtList) {
      return value.iter.toList();
    }

    return value;
  }
}
