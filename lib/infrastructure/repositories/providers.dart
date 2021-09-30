import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/infrastructure/datasources/providers.dart';
import 'package:inspecciones/infrastructure/repositories/user_repository.dart';

final userRepositoryProvider = Provider((ref) => UserRepository(
    ref.watch(authRemoteDataSourceProvider),
    ref.watch(localPreferencesDataSourceProvider)));
