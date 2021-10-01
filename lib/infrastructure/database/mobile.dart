import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/infrastructure/core/directorio_de_datos.dart';
import 'package:inspecciones/infrastructure/datasources/providers.dart';
import 'package:inspecciones/infrastructure/repositories/fotos_repository.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart' as path;

import '../moor_database.dart';

final moorDatabaseProvider = Provider((ref) {
  final appId = ref.read(localPreferencesDataSourceProvider).getAppId();
  if (appId == null) {
    throw Exception("no se ha definido el appId antes de crear la DB");
  }
  return MoorDatabase(
    _getQueryExecutor(ref.read(directorioDeDatosProvider)),
    appId,
    ref.watch(fotosRepositoryProvider),
  );
});

QueryExecutor _getQueryExecutor(DirectorioDeDatos directorio) {
  const logStatements = kDebugMode;
  if (Platform.isIOS || Platform.isAndroid) {
    return LazyDatabase(() async {
      final dbFile = File(path.join(directorio.path, 'db.sqlite'));
      return VmDatabase(dbFile, logStatements: logStatements);
    });
  }

  if (Platform.isMacOS || Platform.isLinux) {
    final dbFile = File('db.sqlite');
    return VmDatabase(dbFile, logStatements: logStatements);
  }

  return VmDatabase.memory(logStatements: logStatements);
}
