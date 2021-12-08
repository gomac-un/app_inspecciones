import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/infrastructure/core/directorio_de_datos.dart';
import 'package:path/path.dart' as path;

import '../drift_database.dart';
import 'database_name.dart';

// TODO: mirar si es seguro hacer este provider autodisposable
final driftDatabaseProvider = Provider((ref) {
  final res = Database(_getQueryExecutor(
    ref.watch(directorioDeDatosProvider),
    ref.watch(databaseNameProvider),
  ));
  ref.onDispose(res.close);
  return res;
});

QueryExecutor _getQueryExecutor(DirectorioDeDatos directorio, String dbname) {
  const logStatements = kDebugMode;
  if (Platform.isIOS || Platform.isAndroid) {
    return LazyDatabase(() async {
      final dbFile = File(path.join(directorio.path, dbname));
      return NativeDatabase(dbFile, logStatements: logStatements);
    });
  }

  if (Platform.isMacOS || Platform.isLinux) {
    final dbFile = File(dbname);
    return NativeDatabase(dbFile, logStatements: logStatements);
  }

  return NativeDatabase.memory(logStatements: logStatements);
}
