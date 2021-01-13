import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:inspecciones/infrastructure/datasources/local_preferences_datasource.dart';
import 'package:inspecciones/injection.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';

import 'package:path_provider/path_provider.dart' as paths;
import 'package:path/path.dart' as p;

import '../moor_database.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Database constructDb() {
    final appId = getIt<ILocalPreferencesDataSource>().getAppId();
    if (appId == null) {
      throw Exception("no se ha definido el appId antes de crear la DB");
    }
    const logStatements = true;
    if (Platform.isIOS || Platform.isAndroid) {
      final executor = LazyDatabase(() async {
        final dataDir = await paths.getApplicationDocumentsDirectory();
        final dbFile = File(p.join(dataDir.path, 'db.sqlite'));
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
