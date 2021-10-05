import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/infrastructure/core/directorio_de_datos.dart';

import 'local_preferences_datasource.dart';
import 'remote_datasource.dart';

final inspeccionesRemoteDataSourceProvider =
    Provider<InspeccionesRemoteDataSource>(
        (ref) => DjangoJsonAPI(ref.read)); //TODO: implementar

final authRemoteDataSourceProvider =
    Provider((ref) => AuthRemoteDatasource(ref.watch(apiUriProvider)));

final localPreferencesDataSourceProvider = Provider<LocalPreferencesDataSource>(
    (ref) =>
        SharedPreferencesDataSourceImpl(ref.watch(sharedPreferencesProvider)));

final directorioDeDatosProvider = Provider<DirectorioDeDatos>(
    (ref) => throw Exception("no se ha inicializado el directorio de datos"));
