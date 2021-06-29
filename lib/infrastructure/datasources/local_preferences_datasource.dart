import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:inspecciones/application/auth/usuario.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ILocalPreferencesDataSource {
  Future<bool> saveUser(Usuario user);
  Future<bool> deleteUser();
  Usuario getUser();
  Future<bool> saveUltimaActualizacion();
  DateTime getUltimaActualizacion();
  Future<bool> saveAppId(int appId);
  int getAppId();
  Future<bool> saveNoVolverAMostrar();
  bool getMostrarAlerta();
}

@LazySingleton(as: ILocalPreferencesDataSource)
class SharedPreferencesDataSource implements ILocalPreferencesDataSource {
  //TODO: mirar si los datasource realmente deberian retornar datos crudos https://bloclibrary.dev/#/architecture
  static const userKey = 'user';
  static const appIdKey = 'appId';
  static const alertaKey = 'mostrarAlerta';
  static const ultimaActualizacionKey = 'ultimaActualizacion';
  //TODO: si hay que guardar mas preferencias considerar guardarlas todas en un solo json
  final SharedPreferences preferences;

  SharedPreferencesDataSource(this.preferences);

  @override
  Future<bool> saveUser(Usuario user) async =>
      preferences.setString(userKey, jsonEncode(user.toJson()));

  @override
  Future<bool> deleteUser() async => preferences.remove(userKey);

  @override
  Usuario getUser() {
    if (preferences.getString(userKey) == null) return null;
    return Usuario.fromJson(
        jsonDecode(preferences.getString(userKey)) as Map<String, dynamic>);
  }

  @override
  Future<bool> saveUltimaActualizacion() {
    final date = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());
    return preferences.setString(ultimaActualizacionKey, date);
  }

  @override
  DateTime getUltimaActualizacion() {
    if (preferences.getString(ultimaActualizacionKey) == null) return null;
    return DateFormat("yyyy-MM-dd hh:mm:ss")
        .parse(preferences.getString(ultimaActualizacionKey));
  }

  @override
  Future<bool> saveAppId(int appId) async =>
      preferences.setInt(appIdKey, appId);

  @override
  int getAppId() => preferences.getInt(appIdKey);

  @override
  Future<bool> saveNoVolverAMostrar() async =>
      preferences.setBool('mostrarAlerta', false);

  @override
  bool getMostrarAlerta() {
    if (preferences.getBool(alertaKey) == null) return null;
    return preferences.getBool(alertaKey);
  }
}
