import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';

final moorDatabaseProvider = Provider<MoorDatabase>(
    (ref) => throw Exception("plataforma no soportada para la base de datos"));
