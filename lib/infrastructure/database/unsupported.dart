import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/infrastructure/drift_database.dart';

final driftDatabaseProvider = Provider<Database>(
    (ref) => throw Exception("plataforma no soportada para la base de datos"));
