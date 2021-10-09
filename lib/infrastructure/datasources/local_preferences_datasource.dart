import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/core/entities/usuario.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>(
    (ref) => throw Exception('Provider was not initialized'));

/// Clase encargada de guardar localmente los datos que la app debe recordar cada vez que se inicie
abstract class LocalPreferencesDataSource {
  Future<bool> saveUser(Usuario user);
  Future<bool> deleteUser();
  Usuario? getUser();
  Future<bool> saveUltimaSincronizacion(DateTime momento);
  DateTime? getUltimaSincronizacion();
  Future<bool> saveAppId(int appId);
  int? getAppId();
}

class SharedPreferencesDataSourceImpl implements LocalPreferencesDataSource {
  static const userKey = 'user';
  static const appIdKey = 'appId';
  static const ultimaActualizacionKey = 'ultimaActualizacion';
  //TODO: si hay que guardar mas preferencias considerar guardarlas todas en un solo json
  final SharedPreferences _preferences;

  SharedPreferencesDataSourceImpl(this._preferences);

  /// Guarda usuario para que no se deba iniciar sesión cada vez que se abra la app
  @override
  Future<bool> saveUser(Usuario user) async =>
      _preferences.setString(userKey, json.encode(user.toJson()));

  /// Borra el usuario cuando se presiona cerrar sesión, la proxima vez que se abra la app deberá inciar sesión de nuevo
  @override
  Future<bool> deleteUser() async => _preferences.remove(userKey);

  /// Devuelve el usuario guardado localmente
  @override
  Usuario? getUser() {
    final mayBeUser = _preferences.getString(userKey);
    if (mayBeUser == null) return null;
    return Usuario.fromJson(json.decode(mayBeUser) as Map<String, dynamic>);
  }

  final String dateformat = "yyyy-MM-dd hh:mm:ss";

  /// Guarda el momento de la ultima sincronización con gomac
  @override
  Future<bool> saveUltimaSincronizacion(DateTime momento) {
    final date = DateFormat(dateformat).format(momento);
    return _preferences.setString(ultimaActualizacionKey, date);
  }

  /// Devuelve el momento de la ultima sincronización con Gomac
  @override
  DateTime? getUltimaSincronizacion() {
    final rawUltimaActualizacion =
        _preferences.getString(ultimaActualizacionKey);
    if (rawUltimaActualizacion == null) return null;
    return DateFormat(dateformat).parse(rawUltimaActualizacion);
  }

  /// Guarda localmente el id de la instalación de la app en el dispositivo.
  @override
  Future<bool> saveAppId(int appId) async =>
      _preferences.setInt(appIdKey, appId);

  /// Devuelve el id de la instalación de la app en el dispositivo
  @override
  int? getAppId() => _preferences.getInt(appIdKey);
}
