import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/infrastructure/datasources/providers.dart';
import 'package:inspecciones/infrastructure/network_info/shared.dart';
import 'package:inspecciones/infrastructure/repositories/app_repository.dart';
import 'package:inspecciones/infrastructure/repositories/fotos_repository.dart';
import 'package:inspecciones/infrastructure/repositories/inspecciones_remote_repository.dart';
import 'package:inspecciones/infrastructure/repositories/user_repository.dart';

import '../drift_database.dart';
import 'cuestionarios_repository.dart';

final userRepositoryProvider = Provider(
  (ref) => UserRepository(
    ref.read,
    ref.watch(localPreferencesDataSourceProvider),
    ref.watch(networkInfoProvider),
    ref.watch(appRepositoryProvider),
  ),
);

final cuestionariosRepositoryProvider =
    Provider((ref) => CuestionariosRepository(
          ref.watch(cuestionariosRemoteDataSourceProvider),
          ref.watch(fotosRemoteDataSourceProvider),
          ref.watch(driftDatabaseProvider),
          ref.watch(fotosRepositoryProvider),
        ));

final inspeccionesRemoteRepositoryProvider =
    Provider((ref) => InspeccionesRemoteRepository(
          ref.watch(inspeccionesRemoteDataSourceProvider),
          ref.watch(fotosRemoteDataSourceProvider),
          ref.watch(driftDatabaseProvider),
          ref.watch(fotosRepositoryProvider),
        ));
