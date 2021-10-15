import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/infrastructure/core/directorio_de_datos.dart';
import 'package:inspecciones/infrastructure/datasources/auth_remote_datasource.dart';
import 'package:inspecciones/infrastructure/datasources/cuestionarios_remote_datasource.dart';
import 'package:inspecciones/infrastructure/datasources/fotos_remote_datasource.dart';

import 'django_json_api.dart';
import 'inspecciones_remote_datasource.dart';
import 'local_preferences_datasource.dart';

/// Este se inicializa en el main y se entrega al [ProviderScope]
final apiUriProvider = Provider<Uri>(
    (ref) => throw Exception("no se ha designado la url de la Api"));

/// Este se inicializa en el main y se entrega al [ProviderScope]
final directorioDeDatosProvider = Provider<DirectorioDeDatos>(
    (ref) => throw Exception("no se ha inicializado el directorio de datos"));

/*
/// Parte de la autenticación de Django para acceder a los servicios de la Api
/// https://www.django-rest-framework.org/api-guide/authentication/#tokenauthentication
/// Es [null] si el usuario no se ha autenticado
final tokenProvider =
    Provider<String?>((ref) => ref.read(appRepositoryProvider).getToken());*/

final _djangoJsonApiProvider =
    Provider((ref) => DjangoJsonApi(ref.read, ref.watch(apiUriProvider)));

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) =>
    ref.watch(
        _djangoJsonApiProvider)); //TODO: este NO requiere un cliente http autenticado

final inspeccionesRemoteDataSourceProvider =
    Provider<InspeccionesRemoteDataSource>((ref) => ref.watch(
        _djangoJsonApiProvider)); //TODO: este SI requiere un cliente http autenticado

final cuestionariosRemoteDataSourceProvider =
    Provider<CuestionariosRemoteDataSource>((ref) => ref.watch(
        _djangoJsonApiProvider)); //TODO: este SI requiere un cliente http autenticado

final fotosRemoteDataSourceProvider = Provider<FotosRemoteDataSource>((ref) =>
    ref.watch(
        _djangoJsonApiProvider)); //TODO: este SI requiere un cliente http autenticado

final localPreferencesDataSourceProvider = Provider<LocalPreferencesDataSource>(
    (ref) =>
        SharedPreferencesDataSourceImpl(ref.watch(sharedPreferencesProvider)));
