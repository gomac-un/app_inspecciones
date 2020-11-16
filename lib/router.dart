import 'package:auto_route/auto_route_annotations.dart';
import 'package:inspecciones/presentation/pages/borradores_screen.dart';
import 'package:inspecciones/presentation/pages/home_screen.dart';
import 'package:inspecciones/presentation/pages/llenar_cuestionario_form_page.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    // initial route is named "/"
    MaterialRoute(page: HomeScreen, initial: true),
    MaterialRoute(page: BorradoresPage),
    MaterialRoute(page: LlenarCuestionarioFormPage),
  ],
)
class $AutoRouter {}
