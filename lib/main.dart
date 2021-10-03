import 'package:file/local.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/application/auth/auth_service.dart';
import 'package:inspecciones/core/entities/app_image.dart';
import 'package:inspecciones/infrastructure/repositories/fotos_repository.dart';
import 'package:inspecciones/presentation/pages/borradores_screen.dart';
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
      child: Consumer(builder: (context, ref, _) {
        return MyApp(loginInfo: ref.watch(authListenableProvider));
      }),
    ),
  );
}

Future<DirectorioDeDatos> _getDirectorioDeDatos() async {
  final add = await getApplicationDocumentsDirectory();
  final directorioDeDatos = DirectorioDeDatos(add.path);
  return directorioDeDatos;
}

class MyApp extends ConsumerWidget {
  final LoginInfo loginInfo;
  MyApp({Key? key, required this.loginInfo}) : super(key: key);

  late final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const BorradoresPage(),
        ),
      ),
      GoRoute(
        name: 'login',
        path: '/login',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const LoginPage(),
        ),
      ),
    ],

    errorPageBuilder: (context, state) => MaterialPage<void>(
      key: state.pageKey,
      child: Text(state.error.toString()),
    ),

    // redirect to the login page if the user is not logged in
    redirect: (state) {
      final loggedIn = loginInfo.loggedIn;

      final goingToLogin = state.subloc == '/login';

      // the user is not logged in and not headed to /login, they need to login
      if (!loggedIn && !goingToLogin) return '/login?from=${state.location}';

      // the user is logged in and headed to /login, no need to login again
      if (loggedIn && goingToLogin) return '/';

      // no need to redirect at all
      return null;
    },
    refreshListenable: loginInfo,
  );

  @override
  Widget build(BuildContext context, ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Inspecciones',
      theme: ref.watch(themeProvider),
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
//const LoginPage(), //const CuestionariosPage(),  //const LoginPage(), //const EdicionFormPage(),
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
    if (previousValue is StateController<bool>) {
      previousValue = previousValue.state;
    }
    if (newValue is StateController<bool>) {
      newValue = newValue.state;
    }
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
