import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:inspecciones/application/auth/usuario.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Clase encargada de guardar localmente los datos que la app debe recordar cada vez que se inicie
abstract class ILocalPreferencesDataSource {
  Future<bool> saveUser(Usuario user);
  Future<bool> deleteUser();
  Usuario getUser();
  Future<bool> saveUltimaActualizacion();
  DateTime getUltimaActualizacion();
  Future<bool> saveAppId(int appId);
  int getAppId();
}

@LazySingleton(as: ILocalPreferencesDataSource)
class SharedPreferencesDataSource implements ILocalPreferencesDataSource {
  //TODO: mirar si los datasource realmente deberian retornar datos crudos https://bloclibrary.dev/#/architecture
  static const userKey = 'user';
  static const appIdKey = 'appId';
  static const ultimaActualizacionKey = 'ultimaActualizacion';
  //TODO: si hay que guardar mas preferencias considerar guardarlas todas en un solo json
  final SharedPreferences preferences;

  SharedPreferencesDataSource(this.preferences);

  /// Guarda usuario para que no se deba iniciar sesión cada vez que se abra la app
  @override
  Future<bool> saveUser(Usuario user) async =>
      preferences.setString(userKey, jsonEncode(user.toJson()));

  /// Borra el usuario cuando se presiona cerrar sesión, la proxima vez que se abra la app deberá inciar sesión de nuevo
  @override
  Future<bool> deleteUser() async => preferences.remove(userKey);

  /// Devuelve el usuario guardado localmente
  @override
  Usuario getUser() {
    if (preferences.getString(userKey) == null) return null;
    return Usuario.fromJson(
        jsonDecode(preferences.getString(userKey)) as Map<String, dynamic>);
  }

  /// Guarda el momento de la ultima sincronización con gomac
  @override
  Future<bool> saveUltimaActualizacion() {
    final date = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());
    return preferences.setString(ultimaActualizacionKey, date);
  }

  /// Devuelve el momento de la ultima sincronización con Gomac
  @override
  DateTime getUltimaActualizacion() {
    if (preferences.getString(ultimaActualizacionKey) == null) return null;
    return DateFormat("yyyy-MM-dd hh:mm:ss")
        .parse(preferences.getString(ultimaActualizacionKey));
  }

  /// Guarda localmente el id de la instalación de la app en el dispositivo.
  /// Así podrá entrar a llenar inspecciones aún cuando no tenga internet
  @override
  Future<bool> saveAppId(int appId) async =>
      preferences.setInt(appIdKey, appId);

  /// Devuelve el id de la instalación de la app en el dispositivo
  @override
  int getAppId() => preferences.getInt(appIdKey);
}
