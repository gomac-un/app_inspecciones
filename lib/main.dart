import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/core/entities/app_image.dart';
import 'package:inspecciones/infrastructure/repositories/fotos_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'infrastructure/core/directorio_de_datos.dart';
import 'infrastructure/datasources/local_preferences_datasource.dart';
import 'infrastructure/datasources/providers.dart';
import 'presentation/pages/login_page.dart';
import 'theme.dart';

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
        fileSystemProvider.overrideWithValue(
            const LocalFileSystem()), //TODO: mirar si se puede usar un memoryFileSystem para web
        if (!kIsWeb)
          directorioDeDatosProvider
              .overrideWithValue(await _getDirectorioDeDatos()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<DirectorioDeDatos> _getDirectorioDeDatos() async {
  final add = await getApplicationDocumentsDirectory();
  final directorioDeDatos = DirectorioDeDatos(add.path);
  return directorioDeDatos;
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
      home:
          const LoginPage(), //const CuestionariosPage(),  //const BorradoresPage(), //const EdicionFormPage(),
    );
  }
}
