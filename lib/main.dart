import 'package:file/local.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/application/auth/auth_service.dart';
import 'package:inspecciones/core/entities/app_image.dart';
import 'package:inspecciones/infrastructure/repositories/fotos_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_router.dart';
import 'infrastructure/core/directorio_de_datos.dart';
import 'infrastructure/datasources/local_preferences_datasource.dart';
import 'infrastructure/datasources/providers.dart';
import 'infrastructure/datasources/remote_datasource.dart';
import 'presentation/pages/splash_screen.dart';
import 'riverpod_logger.dart';

void main() async {
  // Show a progress indicator while awaiting things
  runApp(
    const MaterialApp(
      home: SplashPage(),
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
      observers: [RiverpodLogger()],
      child: Consumer(builder: (context, ref, _) {
        return AppRouter(loginInfo: ref.watch(authListenableProvider));
      }),
    ),
  );
}

Future<DirectorioDeDatos> _getDirectorioDeDatos() async {
  final add = await getApplicationDocumentsDirectory();
  final directorioDeDatos = DirectorioDeDatos(add.path);
  return directorioDeDatos;
}
