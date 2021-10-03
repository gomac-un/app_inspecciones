import 'dart:async';

import 'package:file/local.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/application/auth/auth_service.dart';
import 'package:inspecciones/core/entities/app_image.dart';
import 'package:inspecciones/infrastructure/repositories/fotos_repository.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_router.dart';
import 'infrastructure/datasources/local_preferences_datasource.dart';
import 'infrastructure/datasources/providers.dart';
import 'infrastructure/datasources/remote_datasource.dart';
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
  if (!kIsWeb) await FlutterDownloader.initialize(debug: kDebugMode);
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        apiUriProvider.overrideWithValue(
          Uri(
            scheme: 'http',
            host: '10.0.2.2',
            port: 8000,
            pathSegments: ['inspecciones', 'api', 'v1'],
          ),
        ),
        sharedPreferencesProvider.overrideWithValue(prefs),
        fileSystemProvider.overrideWithValue(
            const LocalFileSystem()), //TODO: mirar si se puede usar un memoryFileSystem para web
        if (!kIsWeb)
          directorioDeDatosProvider
              .overrideWithValue(await getDirectorioDeDatos()),
      ],
      observers: [RiverpodLogger()],
      child: RemoveFocusOnTap(
        child: Consumer(builder: (context, ref, _) {
          return AppRouter(loginInfo: ref.watch(authListenableProvider));
        }),
      ),
    ),
  );
}
