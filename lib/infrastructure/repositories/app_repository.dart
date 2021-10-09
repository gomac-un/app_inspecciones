import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/features/login/credenciales.dart';

import '../datasources/auth_remote_datasource.dart';
import '../datasources/local_preferences_datasource.dart';
import '../datasources/providers.dart';
import '../moor_database.dart';
import '../utils/future_either_x.dart';
import '../utils/transformador_excepciones_api.dart';

final appRepositoryProvider = Provider((ref) => AppRepository(
      ref.read,
      ref.watch(localPreferencesDataSourceProvider),
    ));

class AppRepository {
  AuthRemoteDataSource get _api => _read(authRemoteDataSourceProvider);
  MoorDatabase get _db => _read(moorDatabaseProvider);
  final Reader _read;

  final LocalPreferencesDataSource _localPreferences;

  AppRepository(this._read, this._localPreferences);

  Future<void> limpiarDatosLocales() => _db.limpiezaBD();

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

  /// obtiene y registra el token usado para la autenticacion en el servicio
  Future<Either<ApiFailure, String>> registrarToken(
      Credenciales credenciales) async {
    return apiExceptionToApiFailure(() async {
      final resMap = await _api.getToken(credenciales.toJson());
      final token = resMap['token'] as String;
      // esto puede que sea tarea de otra clase
      _read(tokenProvider.notifier).state = token;
      return token;
    });
  }

  DateTime? getUltimaSincronizacion() =>
      _localPreferences.getUltimaSincronizacion();

  Future<bool> saveUltimaSincronizacion(DateTime momento) =>
      _localPreferences.saveUltimaSincronizacion(momento);
}
