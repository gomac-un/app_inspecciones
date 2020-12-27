import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:inspecciones/application/auth/usuario.dart';
import 'package:inspecciones/core/error/exceptions.dart';
import 'package:inspecciones/domain/auth/auth_failure.dart';
import 'package:inspecciones/infrastructure/datasources/local_preferences_datasource.dart';
import 'package:inspecciones/infrastructure/datasources/remote_datasource.dart';
import 'package:inspecciones/infrastructure/repositories/api_model.dart';
import 'package:meta/meta.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

@injectable
class UserRepository {
  final InspeccionesRemoteDataSource api;
  final ILocalPreferencesDataSource localPreferences;

  UserRepository(this.api, this.localPreferences);

  Future<Either<AuthFailure, Usuario>> authenticateUser(
      {UserLogin userLogin}) async {
    String token;
    final hayInternet = await _hayInternet();

    if (!hayInternet) {
      return const Left(AuthFailure.noHayInternet());
    }

    try {
      token = await _getToken(userLogin);
    } on TimeoutException {
      return const Left(AuthFailure.noHayConexionAlServidor());
    } on CredencialesException {
      return const Left(AuthFailure.usuarioOPasswordInvalidos());
    }

    final user = Usuario(
        documento: userLogin.username,
        password: userLogin.password,
        esAdmin:
            false, //TODO: averiguar si es admin desde el server o desde la bd local
        token: token);
    return Right(user);
  }

  Future<String> _getToken(UserLogin userLogin) async {
    final res = await api.postRecurso(
      '/api-token-auth/',
      userLogin.toJson(),
      token: null,
    );
    return res['token'] as String;
  }

  Future<void> saveLocalUser({@required Usuario user}) async {
    // write token with the user to the local database
    await localPreferences.saveUser(user);
  }

  Future<void> deleteLocalUser() async {
    await localPreferences.deleteUser();
  }

  Option<Usuario> getLocalUser() => optionOf(localPreferences.getUser());

  Future<bool> _hayInternet() async => DataConnectionChecker().hasConnection;
}
