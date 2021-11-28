import 'package:reactive_forms/reactive_forms.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/bloques/preguntas/cuadricula.dart';
import '../../domain/bloques/preguntas/opcion_de_respuesta.dart';
import '../../domain/bloques/preguntas/pregunta_de_seleccion.dart';
import '../../domain/bloques/preguntas/pregunta_de_seleccion_multiple.dart';
import '../../domain/bloques/preguntas/pregunta_de_seleccion_unica.dart';
import '../../domain/respuesta.dart';
import '../controlador_de_pregunta.dart';
import '../controlador_llenado_inspeccion.dart';
import '../visitors/controlador_de_pregunta_visitor.dart';
import 'controlador_de_pregunta_de_seleccion_multiple.dart';
import 'controlador_de_pregunta_de_seleccion_unica.dart';

abstract class ControladorDeCuadricula<
        B extends RespuestaDeCuadricula,
        C extends PreguntaDeSeleccion,
        R extends AbstractControl,
        T extends Cuadricula<B, C>,
        S extends ControladorDePregunta<C, R>>
    extends ControladorDePregunta<T, FormArray> {
  abstract final List<S> controladoresPreguntas;

  @override
  late final FormArray respuestaEspecificaControl =
      fb.array(controladoresPreguntas.map((c) => c.control).toList());

  ControladorDeCuadricula(
      T pregunta, ControladorLlenadoInspeccion controlInspeccion)
      : super(pregunta, controlInspeccion);

  @override
  late final ValueStream<bool> requiereCriticidadDelInspector =
      BehaviorSubject.seeded(false);

  @override
  late final ValueStream<int?> criticidadRespuesta = Rx.combineLatest<int, int>(
          controladoresPreguntas.map((c) => c.criticidadCalculada),
          (values) => values.fold(0, (count, c) => count + c))
      .toVSwithInitial(criticidadRespuestaSync);

  int get criticidadRespuestaSync => controladoresPreguntas.fold(
        0,
        (count, c) => count + c.criticidadCalculada.value,
      );
}

/// La dublicación de código siguiente se debe a que se tiene que instanciar
/// un tipo genérico subtipo de [ControladorDePregunta] para generar la lista de
///  [controladoresPreguntas] pero como no se pueden llamar constructores de
/// genericos, toca hacerlo a mano
class ControladorDeCuadriculaDeSeleccionMultiple
    extends ControladorDeCuadricula<
        RespuestaDeCuadriculaDeSeleccionMultiple,
        PreguntaDeSeleccionMultiple,
        FormArray,
        CuadriculaDeSeleccionMultiple,
        ControladorDePreguntaDeSeleccionMultiple> {
  @override
  late final controladoresPreguntas = pregunta.preguntas
      .map(
          (p) => ControladorDePreguntaDeSeleccionMultiple(p, controlInspeccion))
      .toList();

  ControladorDeCuadriculaDeSeleccionMultiple(
      CuadriculaDeSeleccionMultiple pregunta,
      ControladorLlenadoInspeccion controlInspeccion)
      : super(pregunta, controlInspeccion);

  @override
  R accept<R>(ControladorDePreguntaVisitor<R> visitor) =>
      visitor.visitCuadriculaSeleccionMultiple(this);
}

class ControladorDeCuadriculaDeSeleccionUnica extends ControladorDeCuadricula<
    RespuestaDeCuadriculaDeSeleccionUnica,
    PreguntaDeSeleccionUnica,
    FormControl<OpcionDeRespuesta?>,
    CuadriculaDeSeleccionUnica,
    ControladorDePreguntaDeSeleccionUnica> {
  @override
  late final controladoresPreguntas = pregunta.preguntas
      .map((p) => ControladorDePreguntaDeSeleccionUnica(p, controlInspeccion))
      .toList();

  ControladorDeCuadriculaDeSeleccionUnica(CuadriculaDeSeleccionUnica pregunta,
      ControladorLlenadoInspeccion controlInspeccion)
      : super(pregunta, controlInspeccion);

  @override
  R accept<R>(ControladorDePreguntaVisitor<R> visitor) =>
      visitor.visitCuadriculaSeleccionUnica(this);
}
