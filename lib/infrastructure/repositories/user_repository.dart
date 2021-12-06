import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/core/entities/usuario.dart';
import 'package:inspecciones/domain/api/api_failure.dart';

import '../core/typedefs.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/local_preferences_datasource.dart';
import '../datasources/providers.dart';
import '../utils/transformador_excepciones_api.dart';
import 'providers.dart';

class UserRepository {
  final Reader _read;
  AuthRemoteDataSource get _api => _read(authRemoteDataSourceProvider);
  LocalPreferencesDataSource get _localPreferences =>
      _read(localPreferencesDataSourceProvider);

  UserRepository(this._read);

  Future<void> saveLocalUser({required Usuario user}) async {
    await _localPreferences.saveUser(user);
  }

  /// Elimina user guardado localmente cuando se presiona cerrar sesión,
  /// el usuario deberá iniciar sesión la próxima vez que abra la app
  Future<void> deleteLocalUser() {
    _read(appRepositoryProvider)
        .guardarToken(null); // esto puede que sea tarea de otra clase
    return _localPreferences.deleteUser();
  }

  /// Devuelve usuario si hay uno guardado (No se debe iniciar sesión),
  /// en caso contrario null (Aparece login_screen).
  Option<Usuario> getLocalUser() => optionOf(_localPreferences.getUser());

  Future<Either<ApiFailure, String>> registrarUsuario(
          {required JsonMap formulario}) =>
      apiExceptionToApiFailure(() =>
          _api.registrarUsuario(formulario).then((res) => res['username']));

  Future<Either<ApiFailure, Perfil>> getMiPerfil() => apiExceptionToApiFailure(
      () => _api.getPerfil(null).then((res) => Perfil.fromJson(res)));

  Future<Either<ApiFailure, Perfil>> getPerfil(int id) =>
      apiExceptionToApiFailure(
          () => _api.getPerfil(id).then((res) => Perfil.fromJson(res)));
}

class Perfil {
  final bool estaActivo;
  final DateTime fechaRegistro;
  final String username;
  final String nombre;
  final String email;
  final String foto;
  final String celular;
  final String organizacion;
  final String rol;

  Perfil(this.estaActivo, this.fechaRegistro, this.username, this.nombre,
      this.email, this.foto, this.celular, this.organizacion, this.rol);

  factory Perfil.fromJson(Map<String, dynamic> json) => Perfil(
        json['esta_activo'],
        DateTime.parse(json['fecha_registro']),
        json['username'],
        json['nombre'],
        json['email'],
        json['foto'],
        json['celular'],
        json['organizacion'],
        json['rol'],
      );
}
