import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/main.dart';

import 'local_preferences_datasource.dart';
import 'remote_datasource.dart';

/*final inspeccionesRemoteDataSourceProvider =
    Provider<InspeccionesRemoteDataSource>((ref) => DjangoJsonAPI());*/

final authRemoteDataSourceProvider = Provider((ref) => AuthRemoteDatasource());

final localPreferencesDataSourceProvider = Provider<LocalPreferencesDataSource>(
    (ref) =>
        SharedPreferencesDataSourceImpl(ref.watch(sharedPreferencesProvider)));
