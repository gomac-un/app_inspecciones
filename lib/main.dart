import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspecciones/application/auth/auth_bloc.dart';
import 'package:inspecciones/mvvc/auth_listener_widget.dart';
import 'package:inspecciones/router.gr.dart';
import 'injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  final navigatorKey = GlobalKey<NavigatorState>();
  runApp(
    MaterialApp(
      builder: ExtendedNavigator.builder(
        observers: [ClearFocusOnPop()],
        navigatorKey: navigatorKey,
        router: AutoRouter(),
        builder: (context, extendedNav) => GestureDetector(
          onTap: () {
            // esto quita el foco (y esconde el teclado) al hacer tap
            // en cualquier lugar no-interactivo de la pantalla https://flutterigniter.com/dismiss-keyboard-form-lose-focus/
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              currentFocus.focusedChild.unfocus();
            }
          },
          child: Theme(
            data: customTheme, //TODO: seleccion de tema
            child: BlocProvider(
              create: (context) => getIt<AuthBloc>()..add(AppStarted()),
              child: AuthListener(
                child: extendedNav,
                navigatorKey: navigatorKey,
              ),
            ),
          ),
        ),
      ), //InspeccionScreen(),
    ),
    /*MaterialApp(
      home: Testing(),
    ),*/
  );
}

final customTheme = ThemeData(
  //brightness: Brightness.dark,
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  accentColor: Colors.deepPurple,
  highlightColor: Colors.purple,
  scaffoldBackgroundColor: Colors.blue,
  visualDensity: VisualDensity.compact,
  inputDecorationTheme: InputDecorationTheme(
    border: const UnderlineInputBorder(),
    fillColor: Colors.grey.withOpacity(.3),
    filled: true,
  ),
);


class ClearFocusOnPop extends NavigatorObserver {
  @override
  void didPop(Route route, Route previousRoute) {
    super.didPop(route, previousRoute);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration.zero);
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    });
  }
}