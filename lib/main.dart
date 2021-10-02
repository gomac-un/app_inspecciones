import 'package:file/local.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/core/entities/app_image.dart';
import 'package:inspecciones/infrastructure/repositories/fotos_repository.dart';
import 'package:inspecciones/presentation/pages/login_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'infrastructure/core/directorio_de_datos.dart';
import 'infrastructure/datasources/local_preferences_datasource.dart';
import 'infrastructure/datasources/providers.dart';
import 'infrastructure/datasources/remote_datasource.dart';
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
  await FlutterDownloader.initialize(debug: kDebugMode);
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        apiUriProvider.overrideWithValue(
          Uri(
              scheme: 'http',
              host: '10.0.2.2',
              port: 8000,
              pathSegments: ['inspecciones', 'api', 'v1']),
        ),
        sharedPreferencesProvider.overrideWithValue(prefs),
        fileSystemProvider.overrideWithValue(
            const LocalFileSystem()), //TODO: mirar si se puede usar un memoryFileSystem para web
        if (!kIsWeb)
          directorioDeDatosProvider
              .overrideWithValue(await _getDirectorioDeDatos()),
      ],
      observers: [Logger()],
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ref.watch(themeProvider),

      home:
          const LoginPage(), //const CuestionariosPage(),  //const LoginPage(), //const EdicionFormPage(),
    );
  }
}

class Logger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    print({
      "action": "didUpdateProvider",
      "provider": "${provider.name ?? provider.runtimeType}",
      "previousValue": "$previousValue",
      "newValue": "$newValue"
    });
  }

  @override
  void didAddProvider(
    ProviderBase provider,
    Object? value,
    ProviderContainer container,
  ) {
    print({
      "action": "didAddProvider",
      "provider": "${provider.name ?? provider.runtimeType}",
      "value": "$value"
    });
  }

  @override
  void didDisposeProvider(
    ProviderBase provider,
    ProviderContainer containers,
  ) {
    print({
      "action": "didUpdateProvider",
      "provider": "${provider.name ?? provider.runtimeType}",
    });
  }
}
