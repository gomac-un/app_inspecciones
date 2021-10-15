import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/features/login/credenciales.dart';

import '../../utils/future_either_x.dart';
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

  /// genera el código unico que identifica cada instalación de la app
  /// en caso de que no exista uno ya
  /// Consulta si en [localPreferences] se ha guardado el appId (Código unico de instalación),
  /// en caso de que no se hace petición a gomac para obtenerlo
  Future<Either<ApiFailure, int>> getOrRegisterAppId() async {
    final cachedAppId = _localPreferences.getAppId();
    if (cachedAppId != null) {
      return Right(cachedAppId);
    }
    return apiExceptionToApiFailure(_api.registrarApp).map(
      (appIdMap) {
        final appId = appIdMap['id'] as int;
        _localPreferences.saveAppId(appId);
        return Right(appId);
      },
    );
  }

  /// obtiene el token usado para la autenticacion en el servicio
  Future<Either<ApiFailure, String>> getTokenFromApi(
          Credenciales credenciales) =>
      apiExceptionToApiFailure(() async {
        final resMap = await _api.getToken(credenciales.toJson());
        return resMap['token'] as String;
      });

  /// Guarda el [token] en el almacenamiento persistente y además lo registra
  Future<void> guardarToken(String? token) =>
      _localPreferences.saveToken(token).then((_) => getToken());

  /// Obtiene el token almacenado
  String? getToken() {
    return _localPreferences.getToken();
    //_read(tokenProvider).state = token;
  }

  DateTime? getUltimaSincronizacion() =>
      _localPreferences.getUltimaSincronizacion();

  Future<void> saveUltimaSincronizacion(DateTime momento) =>
      _localPreferences.saveUltimaSincronizacion(momento);
}
