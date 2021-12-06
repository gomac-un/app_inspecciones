import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'application/auth/auth_service.dart';
import 'features/configuracion_organizacion/organizacion_page.dart';
import 'features/creacion_cuestionarios/lista_cuestionarios_screen.dart';
import 'features/llenado_inspecciones/domain/identificador_inspeccion.dart';
import 'features/llenado_inspecciones/ui/history_screen.dart';
import 'features/llenado_inspecciones/ui/lista_inspecciones_screen.dart';
import 'features/llenado_inspecciones/ui/llenado_de_inspeccion_screen.dart';
import 'features/login/login_page.dart';
import 'features/registro_usuario/registro_usuario_page.dart';
import 'theme.dart';
import 'utils.dart';

/// para deeplink se puede usar
/// adb shell am start -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d "http://gomac.com/registro?org=1"
final goRouterProvider = Provider((ref) => GoRouter(
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
          name: 'login',
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => const OrganizacionPage(),
        ),
        GoRoute(
          path: '/cuestionarios',
          name: 'cuestionarios',
          builder: (context, state) => const CuestionariosPage(),
        ),
        GoRoute(
          path: '/inspecciones',
          name: 'inspecciones',
          builder: (context, state) => const InspeccionesPage(),
        ),
        GoRoute(
          path: '/history',
          name: 'history',
          builder: (context, state) => const HistoryInspeccionesPage(),
        ),
        GoRoute(
          path: '/inspeccion/:activoid/:cuestionarioid',
          name: 'inspeccion',
          builder: (context, state) => InspeccionPage(
            inspeccionId: IdentificadorDeInspeccion(
              activo: state.params['activoid']!,
              cuestionarioId: state.params['cuestionarioid']!,
            ),
          ),
        ),
        GoRoute(
          path: '/registro',
          name: 'registro',
          builder: (context, state) => RegistroUsuarioPage(
            organizacionId: int.parse(state.queryParams['org']!),
          ),
        ),
        GoRoute(
          path: '/organizacion',
          name: 'organizacion',
          builder: (context, state) => const OrganizacionPage(),
        ),
      ],

      // redireccion automatica a la pantalla de login si el usuario no esta autenticado
      redirect: (state) {
        final autenticado = ref.read(authListenableProvider).loggedIn;

        final urlsNoProtegidas = ['/login', '/registro'];
        final vaHaciaProtegida = !urlsNoProtegidas.contains(state.subloc);
        final vaHaciaLogin = state.subloc == '/login';

        // si el usuario no esta autenticado y va hacia una pagina protegida, se tiene que loguear primero
        if (!autenticado && vaHaciaProtegida) {
          return '/login?from=${state.location}';
        }

        // si el usuario esta autenticado y va hacia login, no se tiene que loguear otra vez
        if (autenticado && vaHaciaLogin) return '/';

        // no hay redireccion
        return null;
      },
      refreshListenable: ref.watch(authListenableProvider.notifier),
      observers: [
        ClearFocusOnPop(),
        SentryNavigatorObserver(),
      ],
    ));

class AppRouter extends ConsumerWidget {
  const AppRouter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Inspecciones',
      theme: ref.watch(themeProvider),
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
    );
  }
}
