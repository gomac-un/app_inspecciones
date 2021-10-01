import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/infrastructure/datasources/providers.dart';
import 'package:inspecciones/infrastructure/repositories/fotos_repository.dart';
import 'package:moor/moor_web.dart';

import '../moor_database.dart';

final moorDatabaseProvider = Provider((ref) {
  final appId = ref.read(localPreferencesDataSourceProvider).getAppId();
  if (appId == null) {
    throw Exception("no se ha definido el appId antes de crear la DB");
  }
  return MoorDatabase(
    // TODO: verificar que asi funciona la database web
    WebDatabase('db', logStatements: kDebugMode),
    appId,
    ref.watch(fotosRepositoryProvider),
  );
});
