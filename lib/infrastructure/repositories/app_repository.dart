import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/features/login/credenciales.dart';

import '../datasources/auth_remote_datasource.dart';
import '../datasources/local_preferences_datasource.dart';
import '../datasources/providers.dart';
import '../drift_database.dart';
import '../utils/transformador_excepciones_api.dart';

class AppRepository {
  final Reader _read;
  AuthRemoteDataSource get _api => _read(authRemoteDataSourceProvider);
  Database get _db => _read(driftDatabaseProvider);
  LocalPreferencesDataSource get _localPreferences =>
      _read(localPreferencesDataSourceProvider);

  AppRepository(this._read);

  Future<void> limpiarDatosLocales() => _db.recrearTodasLasTablas();

  /// obtiene el token usado para la autenticacion en el servicio
  Future<Either<ApiFailure, String>> getTokenFromApi(
          Credenciales credenciales) =>
      apiExceptionToApiFailure(() async {
        final resMap = await _api.getToken(credenciales.toJson());
        return resMap['token'] as String;
      });

  /// Guarda el [token] en el almacenamiento persistente
  Future<void> guardarToken(String? token) =>
      _localPreferences.saveToken(token).then((_) => getToken());

  /// Obtiene el token almacenado
  String? getToken() => _localPreferences.getToken();
}
