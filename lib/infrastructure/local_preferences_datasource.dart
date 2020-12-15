import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ILocalPreferencesDataSource {
  Future saveUser(User user);
  Future deleteUser();
  User getUser();
}

@LazySingleton(as: ILocalPreferencesDataSource)
class SharedPreferencesDataSource implements ILocalPreferencesDataSource {
  final SharedPreferences preferences;

  SharedPreferencesDataSource(this.preferences);

  Future saveUser(User user) async {
    await preferences.setString('user', user.toJson());
  }

  Future deleteUser() {
    preferences.remove('user');
  }

  User getUser() {
    return preferences.getString('user');
  }
}
