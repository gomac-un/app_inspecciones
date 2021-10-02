import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:moor_db_viewer/moor_db_viewer.dart';

class InspeccionesDbViewerPage extends ConsumerWidget {
  const InspeccionesDbViewerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return MoorDbViewer(ref.read(moorDatabaseProvider));
  }
}
