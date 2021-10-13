import 'package:drift/web.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/infrastructure/datasources/providers.dart';
import 'package:inspecciones/infrastructure/repositories/fotos_repository.dart';

import '../drift_database.dart';

final driftDatabaseProvider = Provider((ref) {
  final appId = ref.read(localPreferencesDataSourceProvider).getAppId();
  if (appId == null) {
    throw Exception("no se ha definido el appId antes de crear la DB");
  }
  return Database(
    // TODO: verificar que asi funciona la database web
    WebDatabase('db', logStatements: kDebugMode),
    appId,
    ref.watch(fotosRepositoryProvider),
  );
});
