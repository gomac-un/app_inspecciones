import 'package:inspecciones/core/entities/app_image.dart';
import 'package:inspecciones/utils/rx_x.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:rxdart/rxdart.dart';

import '../domain/bloques/pregunta.dart';
import '../domain/metarespuesta.dart';
import 'controlador_llenado_inspeccion.dart';
import 'visitors/controlador_de_pregunta_visitor.dart';

export 'package:inspecciones/utils/rx_x.dart';

abstract class ControladorDePregunta<P extends Pregunta,
    R extends AbstractControl> {
  final ControladorLlenadoInspeccion controlInspeccion;

  final P pregunta;

  /// guarda el momento de la ultima edicion
  late final ValueStream<DateTime?> momentoRespuesta =
      respuestaEspecificaControl.valueChanges
          .map<DateTime?>((_) => DateTime.now())
          .toVSwithInitial(pregunta.respuesta?.metaRespuesta.momentoRespuesta);

  late final MetaRespuesta respuesta =
      pregunta.respuesta?.metaRespuesta ?? MetaRespuesta.vacia();

  // se asigna 1 por defecto porque el widget no acepta null, por lo tanto se
  //solo las opciones de respuesta que acepten criticidad del inspector deben
  // guardar este valor, de lo contrario se guarda null
  late final criticidadDelInspectorControl =
      fb.control(respuesta.criticidadDelInspector ?? 1);

  late final observacionControl = fb.control(respuesta.observaciones);
  late final reparadoControl = fb.control(respuesta.reparada);

  late final observacionReparacionControl = fb.control(
    respuesta.observacionesReparacion,
  );
  late final fotosBaseControl = fb.control<List<AppImage>>(respuesta.fotosBase);
  late final fotosReparacionControl =
      fb.control<List<AppImage>>(respuesta.fotosReparacion);

  abstract final R respuestaEspecificaControl;

  late final metaRespuestaControl = fb.group({
    "criticidadDelInspector": criticidadDelInspectorControl,
    "observacion": observacionControl,
    "observacionReparacion": observacionReparacionControl,
    "reparado": reparadoControl,
    "fotosBase": fotosBaseControl,
    "fotosReparacion": fotosReparacionControl,
  }, [
    // Aunque un control sea inválido, el grupo es válido. Se valida el grupo entero.
    ReparadoValidator().validate
  ]);

  /// el control de reactive forms que debe contener directa o indirectamente
  /// todos los controles asociados a este [ControladorDePregunta], si algun
  /// control no se asocia, entonces no se validará ni se desactivará cuando
  /// sea necesario
  final FormGroup control = FormGroup({});

  ControladorDePregunta(this.pregunta, this.controlInspeccion) {
    // el addAll es necesario para que el grupo sea invalido cuando uno de los controles
    // sean invalidos,
    // TODO: investigar por que ocurre esto
    control.addAll({
      'metaRespuesta': metaRespuestaControl,
      "respuestaEspecifica": respuestaEspecificaControl,
    });
  }

  bool esValido() => control.valid;

  ValueStream<bool> get requiereCriticidadDelInspector;

  /// las preguntas de seleccion deben sobreescribir este método para agregarle
  /// la criticidad del inspector
  MetaRespuesta guardarMetaRespuesta() => MetaRespuesta(
        observaciones: observacionControl.value!,
        fotosBase: fotosBaseControl.value!,
        reparada: reparadoControl.value!,
        observacionesReparacion: observacionReparacionControl.value!,
        fotosReparacion: fotosReparacionControl.value!,
        momentoRespuesta: momentoRespuesta.value,
        criticidadDelInspector: requiereCriticidadDelInspector.value
            ? criticidadDelInspectorControl.value
            : null,
        criticidadCalculada: criticidadCalculada.value,
        criticidadCalculadaConReparaciones:
            criticidadCalculadaConReparaciones.value,
      );

  late final ValueStream<
      int> criticidadCalculada = Rx.combineLatest3<int?, bool, int, int>(
    criticidadRespuesta,
    requiereCriticidadDelInspector,
    criticidadDelInspectorControl.valueChanges
        .map((r) => r!)
        .toVSwithInitial(criticidadDelInspectorControl.value!),
    (criticidadRespuesta, requiereCriticidadDelInspector,
        criticidadDelInspector) {
      return _calcularCriticidad(
          criticidadPregunta: criticidadPregunta,
          criticidadRespuesta: criticidadRespuesta,
          requiereCriticidadDelInspector: requiereCriticidadDelInspector,
          criticidadDelInspector: criticidadDelInspector);
    },
  )
      /*.throttleTime(
            const Duration(milliseconds: 10),
            trailing: true,
            leading: false,
          ) // para limpiar ruido*/
      .toVSwithInitial(criticidadCalculadaSync);

  late final ValueStream<int> criticidadCalculadaConReparaciones =
      Rx.combineLatest2<int, bool, int>(
    criticidadCalculada,
    reparadoControl.valueChanges
        .map((r) => r!)
        .toVSwithInitial(reparadoControl.value!),
    (criticidadCalculada, reparado) => _calcularCriticidadConReparaciones(
        criticidad: criticidadCalculada, reparado: reparado),
  ).toVSwithInitial(criticidadCalculadaConReparacionesSync);

  int get criticidadCalculadaSync => _calcularCriticidad(
        criticidadPregunta: criticidadPregunta,
        criticidadRespuesta: criticidadRespuesta.value,
        requiereCriticidadDelInspector: requiereCriticidadDelInspector.value,
        criticidadDelInspector: criticidadDelInspectorControl.value!,
      );

  int get criticidadCalculadaConReparacionesSync =>
      _calcularCriticidadConReparaciones(
          criticidad: criticidadCalculadaSync,
          reparado: reparadoControl.value!);

  int _calcularCriticidad(
      {required int criticidadPregunta,
      required int? criticidadRespuesta,
      required bool requiereCriticidadDelInspector,
      required int criticidadDelInspector}) {
    return (criticidadPregunta *
            // si no hay respuesta la criticidad es 0
            (criticidadRespuesta ?? 0) *
            // si no aplica, no modifica el calculo
            (requiereCriticidadDelInspector
                ? _calificacionToPorcentaje(criticidadDelInspector)
                : 1))
        .round();
  }

  /// si esta reparada la criticidad es 0
  int _calcularCriticidadConReparaciones(
      {required int criticidad, required bool reparado}) {
    return criticidad * (reparado ? 0 : 1);
  }

  int get criticidadPregunta => pregunta.criticidad;

  ValueStream<int?> get criticidadRespuesta;

  V accept<V>(ControladorDePreguntaVisitor<V> visitor);

  /// verificar que este factor solo pueda reducir la criticidad
  static double _calificacionToPorcentaje(int calificacion) {
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
            "el valor de calificacion inválido, solo se permite de 1 a 4");
    }
  }

  void dispose() {
    control.dispose();
  }
}

class ReparadoValidator extends Validator<dynamic> {
  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    final metaRespuestaControl = control as FormGroup;
    final reparado =
        metaRespuestaControl.control('reparado') as FormControl<bool>;
    final observacion = metaRespuestaControl.control('observacionReparacion')
        as FormControl<String>;
    final fotosReparacion = metaRespuestaControl.control('fotosReparacion')
        as FormControl<List<AppImage>>;
    final error = {ValidationMessage.required: true};
    if (reparado.value != null && reparado.value!) {
      if (observacion.value!.trim().isEmpty) {
        observacion.setErrors(error);
      }
      if (fotosReparacion.value!.isEmpty) {
        fotosReparacion.setErrors(error);
      }
    } else {
      observacion.removeError(ValidationMessage.required);
      fotosReparacion.removeError(ValidationMessage.required);
    }
    return null;
  }
}
