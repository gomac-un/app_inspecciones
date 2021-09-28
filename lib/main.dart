import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'features/llenado_inspecciones/control/controlador_llenado_inspeccion.dart';
import 'features/llenado_inspecciones/domain/identificador_inspeccion.dart';
import 'features/llenado_inspecciones/ui/llenado_de_inspeccion_screen.dart';
import 'features/llenado_inspecciones/ui/theme.dart';
import 'presentation/pages/inicio_inspeccion_form_widget.dart';

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
      //InspeccionPage(nuevaInspeccion: true)
      home: Scaffold(
        body: const Text("Llenado"),
        floatingActionButton: Builder(builder: (context) {
          return FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
                final res = await showDialog<IdentificadorDeInspeccion>(
                  context: context,
                  builder: (BuildContext context) => const Dialog(
                    child: InicioInspeccionForm(),
                  ),
                );
                if (res != null) {
                  ref.read(inspeccionIdProvider).state = res;
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const InspeccionPage()));
                }
              });
        }),
      ),
    );
  }
}
