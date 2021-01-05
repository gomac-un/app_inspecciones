import 'package:inspecciones/infrastructure/datasources/local_preferences_datasource.dart';
import 'package:inspecciones/injection.dart';
import 'package:moor/moor_web.dart';

import '../moor_database.dart';

Database constructDb({bool logStatements = false}) {
  return Database(WebDatabase('db', logStatements: logStatements),
      getIt<ILocalPreferencesDataSource>().getAppId());
}
