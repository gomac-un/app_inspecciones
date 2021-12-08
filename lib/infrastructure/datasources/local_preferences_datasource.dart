import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/core/entities/usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>(
    (ref) => throw Exception('Provider was not initialized'));

/// Clase encargada de guardar localmente los datos que la app debe recordar cada vez que se inicie
abstract class LocalPreferencesDataSource {
  Future<bool> saveUser(Usuario user);
  Future<bool> deleteUser();
  Usuario? getUser();

  Future<bool> saveToken(String? token);
  String? getToken();

  /// Obtiene el tema, false es dark y true es bright
  bool? getTema();

  /// Guarda el tema, false es dark y true es bright
  Future<bool> saveTema(bool tema);
}

class SharedPreferencesDataSourceImpl implements LocalPreferencesDataSource {
  static const _userKey = 'user';
  static const _tokenKey = 'token';
  static const _temaKey = 'tema';
  //TODO: si hay que guardar mas preferencias considerar guardarlas todas en un solo json
  final SharedPreferences _preferences;

  SharedPreferencesDataSourceImpl(this._preferences);

  /// Guarda usuario para que no se deba iniciar sesión cada vez que se abra la app
  @override
  Future<bool> saveUser(Usuario user) async =>
      _preferences.setString(_userKey, json.encode(user.toJson()));

  /// Borra el usuario cuando se presiona cerrar sesión, la proxima vez que se abra la app deberá inciar sesión de nuevo
  @override
  Future<bool> deleteUser() async => _preferences.remove(_userKey);

  /// Devuelve el usuario guardado localmente
  @override
  Usuario? getUser() {
    final mayBeUser = _preferences.getString(_userKey);
    if (mayBeUser == null) return null;
    return Usuario.fromJson(json.decode(mayBeUser) as Map<String, dynamic>);
  }

  @override
  String? getToken() => _preferences.getString(_tokenKey);

  @override
  Future<bool> saveToken(String? token) => token != null
      ? _preferences.setString(_tokenKey, token)
      : _preferences.remove(_tokenKey);

  @override
  bool? getTema() => _preferences.getBool(_temaKey);

  @override
  Future<bool> saveTema(bool tema) => _preferences.setBool(_temaKey, tema);
}
