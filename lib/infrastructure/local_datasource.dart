import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:inspecciones/core/error/exceptions.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';

abstract class InspeccionesLocalDataSource {}

const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

@LazySingleton(as: InspeccionesLocalDataSource)
class InspeccionesLocalDataSourceImplSqlite
    implements InspeccionesLocalDataSource {
  InspeccionesLocalDataSourceImplSqlite();
}
