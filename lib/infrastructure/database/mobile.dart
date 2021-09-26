import 'dart:io';
import 'package:injectable/injectable.dart';

import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';

import 'package:path/path.dart' as p;

import '../moor_database.dart';

import 'package:inspecciones/infrastructure/core/directorio_de_datos.dart';
import 'package:inspecciones/infrastructure/datasources/local_preferences_datasource.dart';

@module
abstract class DatabaseRegistrator {
  @lazySingleton
  Database constructDb(
    LocalPreferencesDataSource localPreferencesDataSource,
    DirectorioDeDatos directorioDeDatos,
  ) {
    final appId = localPreferencesDataSource.getAppId();
    if (appId == null) {
      throw Exception("no se ha definido el appId antes de crear la DB");
    }

    const logStatements = true;
    if (Platform.isIOS || Platform.isAndroid) {
      final executor = LazyDatabase(() async {
        final dbFile = File(p.join(directorioDeDatos.path, 'db.sqlite'));
        return VmDatabase(dbFile, logStatements: logStatements);
      });

      return Database(executor, appId);
    }
    if (Platform.isMacOS || Platform.isLinux) {
      final file = File('db.sqlite');
      return Database(VmDatabase(file, logStatements: logStatements), appId);
    }
    // if (Platform.isWindows) {
    //   final file = File('db.sqlite');
    //   return Database(VMDatabase(file, logStatements: logStatements));
    // }
    return Database(VmDatabase.memory(logStatements: logStatements), appId);
  }
}
