import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/llenado_inspecciones/control/controlador_llenado_inspeccion.dart';
import 'features/llenado_inspecciones/domain/identificador_inspeccion.dart';
import 'features/llenado_inspecciones/ui/llenado_de_inspeccion_screen.dart';
import 'theme.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>(
    (ref) => throw Exception('Provider was not initialized'));
void main() async {
  // Show a progress indicator while awaiting things
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    ),
  );
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        inspeccionIdProvider
            .overrideWithValue(StateController(IdentificadorDeInspeccion(
          activo: "1",
          cuestionarioId: 1,
        ))),
      ],
      child: const MyApp(),
    ),
  );
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
      //InspeccionPage(nuevaInspeccion: true)
      home: const InspeccionPage(
        inspeccionId: 1,
      ),
    );
  }
}
