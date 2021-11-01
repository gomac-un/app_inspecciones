import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/infrastructure/repositories/inspecciones_remote_repository.dart';
import 'package:inspecciones/infrastructure/repositories/organizacion_repository.dart';
import 'package:inspecciones/infrastructure/repositories/user_repository.dart';

import 'app_repository.dart';
import 'cuestionarios_repository.dart';

final appRepositoryProvider = Provider((ref) => AppRepository(ref.read));

final userRepositoryProvider = Provider((ref) => UserRepository(ref.read));

final cuestionariosRepositoryProvider =
    Provider((ref) => CuestionariosRepository(ref.read));

final inspeccionesRemoteRepositoryProvider =
    Provider((ref) => InspeccionesRemoteRepository(ref.read));

final organizacionRemoteRepositoryProvider =
    Provider((ref) => OrganizacionRepository(ref.read));
