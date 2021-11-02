import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/infrastructure/core/directorio_de_datos.dart';
import 'package:inspecciones/infrastructure/datasources/providers.dart';
import 'package:inspecciones/infrastructure/repositories/fotos_repository.dart';
import 'package:path/path.dart' as path;

import '../drift_database.dart';

final driftDatabaseProvider = Provider((ref) {
  return Database(
    _getQueryExecutor(ref.read(directorioDeDatosProvider)),
    ref.watch(fotosRepositoryProvider),
  );
});

QueryExecutor _getQueryExecutor(DirectorioDeDatos directorio) {
  const logStatements = kDebugMode;
  if (Platform.isIOS || Platform.isAndroid) {
    return LazyDatabase(() async {
      final dbFile = File(path.join(directorio.path, 'db.sqlite'));
      return NativeDatabase(dbFile, logStatements: logStatements);
    });
  }

  if (Platform.isMacOS || Platform.isLinux) {
    final dbFile = File('db.sqlite');
    return NativeDatabase(dbFile, logStatements: logStatements);
  }

  return NativeDatabase.memory(logStatements: logStatements);
}
