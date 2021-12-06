import 'package:drift/web.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../drift_database.dart';
import 'database_name.dart';

final driftDatabaseProvider = Provider((ref) {
  return Database(
      WebDatabase(ref.watch(databaseNameProvider), logStatements: kDebugMode));
});
