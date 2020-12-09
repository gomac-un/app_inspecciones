import 'package:auto_route/auto_route_annotations.dart';
import 'package:inspecciones/mvvc/creacion_form_page.dart';
import 'package:inspecciones/mvvc/llenado_form_page.dart';
import 'package:inspecciones/presentation/pages/borradores_screen.dart';
import 'package:inspecciones/presentation/pages/crear_cuestionario_form_page.dart';
import 'package:inspecciones/presentation/pages/home_screen.dart';
import 'package:inspecciones/presentation/pages/llenar_cuestionario_form_page.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    // initial route is named "/"
    //MaterialRoute(page: LlenadoFormPage, initial: true),
    MaterialRoute(page: CreacionFormPage, initial: true),
    //MaterialRoute(page: HomeScreen, initial: true),
    /*MaterialRoute(page: BorradoresPage),
    MaterialRoute(page: LlenarCuestionarioFormPage),
    MaterialRoute(page: CrearCuestionarioFormPage),*/
  ],
)
class $AutoRouter {}
