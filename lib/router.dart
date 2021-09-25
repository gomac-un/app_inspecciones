import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';

import 'features/creacion_cuestionarios/creacion_form_page.dart';
import 'features/creacion_cuestionarios/edicion_form_page.dart';
import 'presentation/pages/borradores_screen.dart';
import 'presentation/pages/cuestionarios_screen.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/sincronizacion_page.dart';

/// Definición de todas las rutas de la app.
///
/// Al añadir una nueva ruta se debe correr en consola el comando 'flutter pub run build_runner build --delete-conflicting-outputs'
@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      path: "/",
      name: "AuthenticatedRouter",
      page: EmptyRouterPage,
      children: [
        RedirectRoute(path: '', redirectTo: 'sincronizacion'),
        AutoRoute(path: "sincronizacion", page: SincronizacionPage),
        //AutoRoute(path: "cuestionarios", page: CuestionariosPage),
        AutoRoute(
          path: "cuestionarios",
          name: "CuestionariosRouter",
          page: EmptyRouterPage,
          children: [
            AutoRoute(path: '', page: CuestionariosPage),
            AutoRoute(path: 'nuevo', page: CreacionFormPage),
            AutoRoute(path: ':cuestionarioId', page: EdicionFormPage),
            RedirectRoute(path: '*', redirectTo: ''),
          ],
        ),
        AutoRoute(path: "borradores", page: BorradoresPage),
      ],
    ),
    AutoRoute(path: "/login", page: LoginPage),
    RedirectRoute(path: "*", redirectTo: "/"),

    // initial route is named "/"
    /*MaterialRoute(page: SplashPage, initial: true),
    MaterialRoute(page: LoginPage),
    MaterialRoute(page: CreacionFormPage),
    MaterialRoute(page: BorradoresPage),
    MaterialRoute(page: LlenadoFormPage),
    MaterialRoute(page: GruposScreen),
    MaterialRoute(page: HistoryInspeccionesPage),*/
  ],
)
class $AppRouter {}
