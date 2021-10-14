import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/features/sincronizacion/sincronizacion_page.dart';
import 'package:inspecciones/presentation/pages/cuestionarios_screen.dart';
import 'package:inspecciones/presentation/pages/history_screen.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'application/auth/auth_service.dart';
import 'features/llenado_inspecciones/domain/identificador_inspeccion.dart';
import 'features/llenado_inspecciones/ui/llenado_de_inspeccion_screen.dart';
import 'features/login/login_page.dart';
import 'presentation/pages/borradores_screen.dart';
import 'theme.dart';
import 'utils.dart';

final goRouterProvider = Provider((ref) => GoRouter(
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
          name: 'login',
          path: '/login',
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const LoginPage(),
          ),
        ),
        GoRoute(
          path: '/',
          name: 'home',
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const BorradoresPage(),
          ),
        ),
        GoRoute(
          path: '/cuestionarios',
          name: 'cuestionarios',
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const CuestionariosPage(),
          ),
        ),
        GoRoute(
          path: '/borradores',
          name: 'borradores',
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const BorradoresPage(),
          ),
        ),
        GoRoute(
          path: '/history',
          name: 'history',
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const HistoryInspeccionesPage(),
          ),
        ),
        GoRoute(
          path: '/inspeccion/:activoid/:cuestionarioid',
          name: 'inspeccion',
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: InspeccionPage(
              inspeccionId: IdentificadorDeInspeccion(
                activo: state.params['activoid']!,
                cuestionarioId: int.parse(state.params['cuestionarioid']!),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/sincronizacion',
          name: 'sincronizacion',
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const SincronizacionPage(),
          ),
        ),
      ],

      errorPageBuilder: (context, state) => MaterialPage<void>(
        key: state.pageKey,
        child: Text(state.error.toString()),
      ),

      // redirect to the login page if the user is not logged in
      redirect: (state) {
        final loggedIn = ref.watch(authListenableProvider).loggedIn;

        final goingToLogin = state.subloc == '/login';

        // the user is not logged in and not headed to /login, they need to login
        if (!loggedIn && !goingToLogin) return '/login?from=${state.location}';

        // the user is logged in and headed to /login, no need to login again
        if (loggedIn && goingToLogin) return '/';

        // no need to redirect at all
        return null;
      },
      refreshListenable: ref.watch(authListenableProvider),
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
