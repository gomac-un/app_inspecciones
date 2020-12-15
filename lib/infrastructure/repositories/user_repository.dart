import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:inspecciones/infrastructure/local_preferences_datasource.dart';
import 'package:inspecciones/infrastructure/remote_datasource.dart';
import 'package:inspecciones/infrastructure/repositories/api_model.dart';
import 'package:meta/meta.dart';

@injectable
class UserRepository {
  final InspeccionesRemoteDataSource api;
  final ILocalPreferencesDataSource localPreferences;

  UserRepository(this.api, this.localPreferences);

  Future<User> authenticateUser({UserLogin userLogin}) async {
    Token token = await api.getToken(userLogin);
    User user = User(
      id: 0,
      username: userLogin.username,
      token: token.token,
      //TODO: otros datos
    );
    return user;
  }

  Future<void> saveLocalUser({@required User user}) async {
    // write token with the user to the local database
    await localPreferences.saveUser(user);
  }

  Future<void> deleteLocalUser({@required int id}) async {
    await localPreferences.deleteUser();
  }

  User getLocalUser() {
    final res = localPreferences.getUser();
    return res;
  }
}
