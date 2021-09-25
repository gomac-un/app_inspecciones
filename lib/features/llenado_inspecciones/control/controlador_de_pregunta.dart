import 'package:reactive_forms/reactive_forms.dart';

import '../domain/bloques/pregunta.dart';
import '../domain/metarespuesta.dart';
import 'visitors/controlador_de_pregunta_visitor.dart';

abstract class ControladorDePregunta<T extends Pregunta> {
  final T pregunta;

  late final MetaRespuesta respuesta =
      pregunta.respuesta?.metaRespuesta ?? MetaRespuesta.vacia();

  late final criticidadInspectorControl =
      fb.control(respuesta.criticidadInspector);
  late final observacionControl = fb.control(respuesta.observaciones);
  late final reparadoControl = fb.control(respuesta.reparada);

  late final observacionReparacionControl =
      fb.control(respuesta.observacionesReparacion);
  late final fotosBaseControl = fb.control<List<dynamic>>([]);
  late final fotosGuiaControl = fb.control<List<dynamic>>([]);

  abstract final AbstractControl respuestaEspecificaControl;

  late final metaRespuestaControl = fb.group({
    "criticidadInspector": criticidadInspectorControl,
    "observacion": observacionControl,
    "observacionReparacion": observacionReparacionControl,
    "reparado": reparadoControl,
    "fotosBase": fotosBaseControl,
    "fotosGuia": fotosGuiaControl,
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
  }

  bool esValido() => control.valid;

  MetaRespuesta guardarMetaRespuesta() => MetaRespuesta(
        observaciones: observacionControl.value!,
        reparada: reparadoControl.value!,
        observacionesReparacion: observacionReparacionControl.value!,
      );

  /// solo se puede usar para leer el calculo, para componentes de la ui que deben
  /// reaccionar a cambios de este calculo se debe usar [criticidadCalculadaProvider]
  int get criticidadCalculada =>
      criticidadPregunta *
      (criticidadRespuesta ??
          1) * // si no se conoce el valor, la criticidad por defecto es 1
      (reparadoControl.value! ? 0 : 1);

  int get criticidadPregunta => pregunta.criticidad;

  /// debe basarse unicamente en informacion obtenida de respuestaEspecificaControl
  /// para que [criticidadCalculadaProvider] funcione bien
  int? get criticidadRespuesta;

  void accept(ControladorDePreguntaVisitor visitor);
}
