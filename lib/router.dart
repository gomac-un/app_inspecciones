import 'package:auto_route/auto_route_annotations.dart';
import 'package:inspecciones/mvvc/creacion_form_page.dart';
import 'package:inspecciones/mvvc/llenado_form_page.dart';
import 'package:inspecciones/presentation/pages/borradores_screen.dart';
import 'package:inspecciones/presentation/pages/login_screen.dart';
import 'package:inspecciones/presentation/pages/sincronizacion_screen.dart';
import 'package:inspecciones/presentation/pages/splash_screen.dart';

@MaterialAutoRouter(
  generateNavigationHelperExtension: true,
  routes: <AutoRoute>[
    // initial route is named "/"
    MaterialRoute(page: SplashPage, initial: true),
    MaterialRoute(page: LoginScreen),
    MaterialRoute(page: BorradoresPage),
    MaterialRoute(page: CreacionFormPage),
    MaterialRoute(page: LlenadoFormPage),
    MaterialRoute(page: SincronizacionPage),
  ],
)
class $AutoRouter {}
