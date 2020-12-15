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

  Future saveUser(Usuario user) async {
    await preferences.setString('user', user.toJson());
  }

  Future deleteUser() async {
    await preferences.remove('user');
  }

  Usuario getUser() {
    print(preferences.getString('user'));
    if (preferences.getString('user') == null) return null;
    return Usuario.fromJson(preferences.getString('user'));
  }
}
