import 'package:inspecciones/core/entities/app_image.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../model/bloques/pregunta.dart';

abstract class ControladorDePregunta {
  late final Pregunta pregunta;
  final observacionControl = fb.control("");
  final observacionReparacionControl = fb.control("");
  final reparadoControl = fb.control(false);
  final fotosBaseControl = fb.control<List<AppImage>>([]);
  final fotosGuiaControl = fb.control<List<AppImage>>([]);
  //TODO: inicializar con la info de la DB

  late final control = fb.group({
    "observacion": observacionControl,
    "observacionReparacion": observacionReparacionControl,
    "reparado": reparadoControl,
    "fotosBase": fotosBaseControl,
    "fotosGuia": fotosGuiaControl,
  });

  bool esValido() => control.valid;
  void guardar();
}
