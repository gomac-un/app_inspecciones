import 'dart:async';

import 'package:file/local.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
//import 'package:inspecciones/infrastructure/repositories/fotos_repository.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_router.dart';
import 'infrastructure/core/directorio_de_datos.dart';
import 'infrastructure/datasources/local_preferences_datasource.dart';
import 'infrastructure/datasources/providers.dart';
import 'infrastructure/repositories/providers.dart';
import 'presentation/pages/splash_screen.dart';
import 'riverpod_logger.dart';
import 'utils.dart';

void main() async {
  // inicializar Sentry solo si es release
  if (kReleaseMode) {
    runZonedGuarded(() async {
      // Configurar sentry para el reporte de errores
      // ver https://docs.sentry.io/platforms/flutter/
      // Sentry should be init. within the 'runZonedGuarded' that 'runApp' is run,
      // so WidgetsFlutterBinding.ensureInitialized() is called correctly.
      // See here that we don't pass the 'appRunner' arg, so you must run 'runApp' yourself.
      await SentryFlutter.init(
        (options) {
          options.dsn =
              'https://febb546f37d34fa6ac06e65f03f32ba2@o973604.ingest.sentry.io/5925032';
        },
      );
      await _ejecutarAppConRiverpod();
    }, (exception, stackTrace) async {
      await Sentry.captureException(exception, stackTrace: stackTrace);
    });
  } else {
    await _ejecutarAppConRiverpod();
  }
}

Future<void> _ejecutarAppConRiverpod() async {
  // Show a progress indicator while awaiting things
  runApp(
    const MaterialApp(
      home: SplashPage(),
    ),
  );
  final prefs = await SharedPreferences.getInstance();

  final androidOverrides = [
    if (!kIsWeb)
      directorioDeDatosProvider.overrideWithValue(await getDirectorioDeDatos()),
    fileSystemProvider.overrideWithValue(const LocalFileSystem()),
  ];

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        if (!kIsWeb) ...androidOverrides,
        apiUriProvider.overrideWithValue(
            _buildApiUri(isWeb: kIsWeb, isProduction: !kDebugMode))
      ],
      observers: [RiverpodLogger()],
      child: const RemoveFocusOnTap(
        child: AppRouter(),
      ),
    ),
  );
}

Uri _buildApiUri({required bool isWeb, required bool isProduction}) {
  final String host;
  if (isProduction) {
    host = 'shepherdator.ddns.net';
  } else if (isWeb) {
    host = 'localhost';
  } else {
    host = '10.0.2.2';
  }
  return Uri(
    scheme: 'http',
    host: host,
    port: isProduction ? 80 : 8000,
    pathSegments: ['inspecciones', 'api', 'v1'],
  );
}
