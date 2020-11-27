import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';

import 'package:path_provider/path_provider.dart' as paths;
import 'package:path/path.dart' as p;

import '../moor_database.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Database constructDb() {
    bool logStatements = true;
    if (Platform.isIOS || Platform.isAndroid) {
      final executor = LazyDatabase(() async {
        final dataDir = await paths.getApplicationDocumentsDirectory();
        final dbFile = File(p.join(dataDir.path, 'db.sqlite'));
        return VmDatabase(dbFile, logStatements: logStatements);
      });
      return Database(executor);
    }
    if (Platform.isMacOS || Platform.isLinux) {
      final file = File('db.sqlite');
      return Database(VmDatabase(file, logStatements: logStatements));
    }
    // if (Platform.isWindows) {
    //   final file = File('db.sqlite');
    //   return Database(VMDatabase(file, logStatements: logStatements));
    // }
    return Database(VmDatabase.memory(logStatements: logStatements));
  }
}
