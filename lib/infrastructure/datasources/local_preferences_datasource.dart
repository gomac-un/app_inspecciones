import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:inspecciones/application/auth/usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ILocalPreferencesDataSource {
  Future saveUser(Usuario user);
  Future deleteUser();
  Usuario getUser();
}

@LazySingleton(as: ILocalPreferencesDataSource)
class SharedPreferencesDataSource implements ILocalPreferencesDataSource {
  final SharedPreferences preferences;

  SharedPreferencesDataSource(this.preferences);

  @override
  Future saveUser(Usuario user) async {
    await preferences.setString('user', jsonEncode(user.toJson()));
  }

  @override
  Future deleteUser() async {
    await preferences.remove('user');
  }

  @override
  Usuario getUser() {
    if (preferences.getString('user') == null) return null;
    return Usuario.fromJson(
        jsonDecode(preferences.getString('user')) as Map<String, dynamic>);
  }
}
