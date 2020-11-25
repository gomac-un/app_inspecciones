import 'package:moor/moor_web.dart';

import '../moor_database.dart';

Database constructDb({bool logStatements = false}) {
  return Database(WebDatabase('db', logStatements: logStatements));
}
