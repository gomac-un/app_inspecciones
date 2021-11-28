import 'package:file/file.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'app_repository.dart';
import 'cuestionarios_repository.dart';
import 'inspecciones_remote_repository.dart';
import 'organizacion_repository.dart';
import 'user_repository.dart';

final appRepositoryProvider = Provider((ref) => AppRepository(ref.read));

final userRepositoryProvider = Provider((ref) => UserRepository(ref.read));

final cuestionariosRepositoryProvider =
    Provider((ref) => CuestionariosRepository(ref.read));

final inspeccionesRemoteRepositoryProvider =
    Provider((ref) => InspeccionesRemoteRepository(ref.read));

final organizacionRepositoryProvider =
    Provider((ref) => OrganizacionRepository(ref.read));

final fileSystemProvider = Provider<FileSystem>(
    (ref) => throw Exception("no se ha definido el FileSystem"));
