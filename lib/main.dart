import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:inspecciones/application/auth/auth_bloc.dart';
import 'package:inspecciones/mvvc/auth_listener_widget.dart';
import 'package:inspecciones/router.gr.dart';

import 'injection.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Inicializa el service locator.
  await configureDependencies();
  await FlutterDownloader.initialize();

  final _appRouter = AppRouter();

  runApp(
    MaterialApp.router(
      routerDelegate:
          _appRouter.delegate(navigatorObservers: () => [ClearFocusOnPop()]),
      routeInformationParser: _appRouter.defaultRouteParser(),

      /// Permite 'internacionalizar' la app. Se usa para poder cambiar el idioma del calendario en
      /// planeacion_grupos_cards.dart
      localizationsDelegates: const [GlobalMaterialLocalizations.delegate],
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
        child: BlocProvider(
          create: (context) =>
              getIt<AuthBloc>()..add(const AuthEvent.startingApp()),
          child: AuthListener(
            router: _appRouter,
            child: router!,
          ),
        ),
      ),
      //InspeccionScreen(),
    ),
  );
}

/// Tema personalizado, donde se definen los estilos de la app
final customTheme = ThemeData(
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      backgroundColor: const Color.fromRGBO(237, 181, 34, 1),
    ),
  ),
  //brightness: Brightness.dark,
  primaryColorLight: const Color.fromRGBO(229, 236, 233, 1),
  brightness: Brightness.light,
  primaryColor: const Color.fromRGBO(28, 44, 59, 1),
  /*const Color.fromRGBO(28, 44, 59, 1),const Color.fromRGBO(114, 163, 141, 1), Colors.blue */
  accentColor: const Color.fromRGBO(237, 181, 34, 1),
  highlightColor: const Color.fromRGBO(237, 181, 34, 0.5),
  scaffoldBackgroundColor: const Color.fromRGBO(114, 163, 141, 1),
  visualDensity: VisualDensity.compact,
  inputDecorationTheme: InputDecorationTheme(
    border: const UnderlineInputBorder(),
    fillColor: Colors.grey.withOpacity(.3),
    filled: true,
  ),
  textTheme: const TextTheme(
      headline1: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.25)),
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

final RouteObserver<PageRoute> loginRequester = RouteObserver<PageRoute>();
