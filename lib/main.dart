import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:inspecciones/application/auth/auth_bloc.dart';
import 'package:inspecciones/router.gr.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'injection.dart';

Future main() async {
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

    /// Inicializa el service locator.
    await configureDependencies();
    await FlutterDownloader.initialize();

    runApp(const InspeccionesApp());
  }, (exception, stackTrace) async {
    await Sentry.captureException(exception, stackTrace: stackTrace);
  });
}

class InspeccionesApp extends StatefulWidget {
  const InspeccionesApp({Key? key}) : super(key: key);

  @override
  State<InspeccionesApp> createState() => _InspeccionesAppState();
}

class _InspeccionesAppState extends State<InspeccionesApp> {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthBloc>(),
      child: BlocBuilder<AuthBloc, AuthState>(
        buildWhen: (previous, current) =>
            previous.runtimeType != current.runtimeType,
        builder: (_, state) {
          return MaterialApp.router(
            routerDelegate: AutoRouterDelegate.declarative(
              _appRouter,
              routes: (_) => [
                state.map(
                  unauthenticated: (_) => const LoginRoute(),
                  authenticated: (_) => const AuthenticatedRouter(),
                )
              ],
              navigatorObservers: () => [
                ClearFocusOnPop(),
                SentryNavigatorObserver(),
              ],
            ),
            routeInformationParser: _appRouter.defaultRouteParser(),

            /// Permite 'internacionalizar' la app. Se usa para poder cambiar el idioma del calendario en
            /// planeacion_grupos_cards.dart
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate
            ],
            supportedLocales: const [Locale('en', ''), Locale('es', '')],
            theme: customTheme,
            builder: (context, router) => GestureDetector(
              onTap: () async {
                // esto quita el foco (y esconde el teclado) al hacer tap
                // en cualquier lugar no-interactivo de la pantalla https://flutterigniter.com/dismiss-keyboard-form-lose-focus/
                final currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.focusedChild?.unfocus();
                }
              },
              child: router!,
            ),
            //InspeccionScreen(),
          );
        },
      ),
    );
  }
}

final theme = ThemeData();

/// Tema personalizado, donde se definen los estilos de la app
final customTheme = theme.copyWith(
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      backgroundColor: const Color.fromRGBO(237, 181, 34, 1),
    ),
  ),
  primaryColorLight: const Color.fromRGBO(229, 236, 233, 1),
  /*const Color.fromRGBO(28, 44, 59, 1),const Color.fromRGBO(114, 163, 141, 1), Colors.blue */
  colorScheme: theme.colorScheme.copyWith(
    primary: const Color.fromRGBO(28, 44, 59, 1),
    secondary: const Color.fromRGBO(237, 181, 34, 1),
    brightness: Brightness.light,
    //brightness: Brightness.dark,
  ),
  highlightColor: const Color.fromRGBO(237, 181, 34, 0.5),
  scaffoldBackgroundColor: const Color.fromRGBO(114, 163, 141, 1),
  visualDensity: VisualDensity.compact,
  inputDecorationTheme: theme.inputDecorationTheme.copyWith(
    border: const UnderlineInputBorder(),
    fillColor: Colors.grey.withOpacity(.3),
    filled: true,
  ),
  textTheme: theme.textTheme.copyWith(
    headline1: theme.textTheme.headline1?.copyWith(
        fontSize: 20,
        //color: Colors.white,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.25),
  ),
);

class ClearFocusOnPop extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);

    //El que sigue solo quita el teclado pero deja el focus
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await Future.delayed(Duration.zero);
      // solo quita el teclado pero deja el focus
      //SystemChannels.textInput.invokeMethod('TextInput.hide');
      // quita el focus despues de un pop
      final focus = FocusManager.instance.primaryFocus;
      focus?.unfocus();
    });
  }
}
