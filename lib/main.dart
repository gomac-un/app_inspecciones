import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'features/llenado_inspecciones/ui/llenado_de_inspeccion_screen.dart';
import 'features/llenado_inspecciones/ui/theme.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final theme = ref.watch(themeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: theme.copyWith(
          inputDecorationTheme: theme.inputDecorationTheme.copyWith(
        filled: true,
      )),
      home: const InspeccionPage(nuevaInspeccion: true),
    );
  }
}
