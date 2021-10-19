import 'package:inspecciones/core/entities/app_image.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../domain/bloques/pregunta.dart';
import '../domain/metarespuesta.dart';
import 'visitors/controlador_de_pregunta_visitor.dart';

abstract class ControladorDePregunta<T extends Pregunta> {
  final T pregunta;
  late DateTime? momentoRespuesta =
      pregunta.respuesta?.metaRespuesta.momentoRespuesta;
  late final MetaRespuesta respuesta =
      pregunta.respuesta?.metaRespuesta ?? MetaRespuesta.vacia();

  late final criticidadInspectorControl =
      fb.control(respuesta.criticidadInspector);
  late final observacionControl = fb.control(respuesta.observaciones);
  late final reparadoControl = fb.control(respuesta.reparada);

  late final observacionReparacionControl =
      fb.control(respuesta.observacionesReparacion);
  late final fotosBaseControl = fb.control<List<AppImage>>(respuesta.fotosBase);
  late final fotosReparacionControl =
      fb.control<List<AppImage>>(respuesta.fotosReparacion);

  abstract final AbstractControl respuestaEspecificaControl;
  late final metaRespuestaControl = fb.group({
    "criticidadInspector": criticidadInspectorControl,
    "observacion": observacionControl,
    "observacionReparacion": observacionReparacionControl,
    "reparado": reparadoControl,
    "fotosBase": fotosBaseControl,
    "fotosReparacion": fotosReparacionControl,
  });

  /// el control de reactive forms que debe contener directa o indirectamente
  /// todos los controles asociados a este [ControladorDePregunta], si algun
  /// control no se asocia, entonces no se validará ni se desactivará cuando
  /// sea necesario
  final FormGroup control = FormGroup({});

  ControladorDePregunta(this.pregunta) {
    // el addAll es necesario para que el grupo sea invalido cuando uno de los controles
    // sean invalidos,
    // TODO: investigar por que ocurre esto
    control.addAll({
      'metaRespuesta': metaRespuestaControl,
      "respuestaEspecifica": respuestaEspecificaControl,
    });
    respuestaEspecificaControl.valueChanges.listen((_) {
      momentoRespuesta = DateTime.now();
    }); //guarda el momento de la ultima edicion
  }

  bool esValido() => control.valid;

  MetaRespuesta guardarMetaRespuesta() => MetaRespuesta(
      observaciones: observacionControl.value!,
      fotosBase: fotosBaseControl.value!,
      reparada: reparadoControl.value!,
      observacionesReparacion: observacionReparacionControl.value!,
      fotosReparacion: fotosReparacionControl.value!,
      momentoRespuesta: momentoRespuesta);

  /// solo se puede usar para leer el calculo, para componentes de la ui que deben
  /// reaccionar a cambios de este calculo se debe usar [criticidadCalculadaProvider]
  int get criticidadCalculada => (criticidadPregunta *
          (criticidadRespuesta ??
              1) * // si no se conoce el valor, la criticidad por defecto es 1
          _porcentajeCalificacion(criticidadInspectorControl.value!) *
          (reparadoControl.value! ? 0 : 1))
      .round();

  int get criticidadPregunta => pregunta.criticidad;

  /// debe basarse unicamente en informacion obtenida de respuestaEspecificaControl
  /// para que [criticidadCalculadaProvider] funcione bien
  int? get criticidadRespuesta;

  R accept<R>(ControladorDePreguntaVisitor<R> visitor);

  static double _porcentajeCalificacion(int calificacion) {
    switch (calificacion.round()) {
      case 1:
        return 0.55;

      case 2:
        return 0.70;

      case 3:
        return 0.85;

      case 4:
        return 1;

      default:
        throw Exception(
            "el valor de calificacion mayor a 4, revise el reactive_slider");
    }
  }
}
