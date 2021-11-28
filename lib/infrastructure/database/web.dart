import 'package:drift/web.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../drift_database.dart';

final driftDatabaseProvider = Provider((ref) {
  return Database(
    // TODO: verificar que si funciona la database web
    WebDatabase('db', logStatements: kDebugMode),
  );
});
