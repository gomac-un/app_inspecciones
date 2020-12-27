import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:inspecciones/core/error/exceptions.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/infrastructure/datasources/remote_datasource.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';

@injectable
class InspeccionRepository {
  final InspeccionesRemoteDataSource _api;
  final Database _db;
  final String _token;

  InspeccionRepository(this._api, this._db, @factoryParam this._token);

  Future<Either<ApiFailure, Unit>> subirInspeccion(int inspeccionId) async {
    //TODO: subir las fotos
    final ins = await _db.getInspeccionConRespuestas(inspeccionId);
    try {
      /*final res = await _api.putRecurso('/inspecciones/${ins['id']}/', ins,
          token: _token);*/
      print(ins);
      final res = await _api.postRecurso('/inspecciones/', ins, token: _token);
      return right(unit);
    } on TimeoutException {
      return const Left(ApiFailure.noHayConexionAlServidor());
    } on CredencialesException catch (e) {
      print(e.respuesta);
      return Left(ApiFailure.serverError(jsonEncode(e.respuesta)));
    } on ServerException catch (e) {
      print(e.respuesta);
      return Left(ApiFailure.serverError(jsonEncode(e.respuesta)));
    }
  }

  /*

  Future<void> saveLocalUser({@required Usuario user}) async {
    // write token with the user to the local database
    await localPreferences.saveUser(user);
  }

  Future<void> deleteLocalUser() async {
    await localPreferences.deleteUser();
  }

  Option<Usuario> getLocalUser() => optionOf(localPreferences.getUser());

  Future<bool> _hayInternet() async => DataConnectionChecker().hasConnection;*/
}
