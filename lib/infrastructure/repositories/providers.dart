import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/infrastructure/datasources/providers.dart';
import 'package:inspecciones/infrastructure/network_info/shared.dart';
import 'package:inspecciones/infrastructure/repositories/fotos_repository.dart';
import 'package:inspecciones/infrastructure/repositories/user_repository.dart';

import '../moor_database.dart';
import 'cuestionarios_repository.dart';

final userRepositoryProvider = Provider((ref) => UserRepository(
    ref.watch(authRemoteDataSourceProvider),
    ref.watch(localPreferencesDataSourceProvider),
    ref.watch(networkInfoProvider)));

final cuestionariosRepositoryProvider =
    Provider((ref) => CuestionariosRepository(
          ref.watch(moorDatabaseProvider),
          ref.watch(inspeccionesRemoteDataSourceProvider),
          ref.watch(fotosRepositoryProvider),
        ));
