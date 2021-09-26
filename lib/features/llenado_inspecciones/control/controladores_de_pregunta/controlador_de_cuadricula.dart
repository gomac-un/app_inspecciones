import 'package:reactive_forms/reactive_forms.dart';

import '../../domain/bloques/preguntas/cuadricula.dart';
import '../../domain/bloques/preguntas/pregunta_de_seleccion.dart';
import '../../domain/bloques/preguntas/pregunta_de_seleccion_multiple.dart';
import '../../domain/bloques/preguntas/pregunta_de_seleccion_unica.dart';
import '../../domain/respuesta.dart';
import '../controlador_de_pregunta.dart';
import '../visitors/controlador_de_pregunta_visitor.dart';
import 'controlador_de_pregunta_de_seleccion_multiple.dart';
import 'controlador_de_pregunta_de_seleccion_unica.dart';

abstract class ControladorDeCuadricula<
    A extends Respuesta,
    B extends RespuestaDeCuadricula<A>,
    C extends PreguntaDeSeleccion<A>,
    T extends Cuadricula<A, B, C>,
    S extends ControladorDePregunta<C>> extends ControladorDePregunta<T> {
  abstract final List<S> controladoresPreguntas;

  @override
  late final FormArray respuestaEspecificaControl =
      fb.array(controladoresPreguntas.map((c) => c.control).toList());

  ControladorDeCuadricula(T pregunta) : super(pregunta);

  @override
  int get criticidadRespuesta => controladoresPreguntas.fold(
        0,
        (count, c) => count + c.criticidadCalculada,
      );
}

/// La dublicación de código siguiente se debe a que se tiene que instanciar
/// un tipo genérico subtipo de [ControladorDePregunta] para generar la lista de
///  [controladoresPreguntas] pero como no se pueden llamar constructores de
/// genericos, toca hacerlo a mano
class ControladorDeCuadriculaDeSeleccionMultiple
    extends ControladorDeCuadricula<
        RespuestaDeSeleccionMultiple,
        RespuestaDeCuadriculaDeSeleccionMultiple,
        PreguntaDeSeleccionMultiple,
        CuadriculaDeSeleccionMultiple,
        ControladorDePreguntaDeSeleccionMultiple> {
  @override
  late final controladoresPreguntas = pregunta.preguntas
      .map((p) => ControladorDePreguntaDeSeleccionMultiple(p))
      .toList();

  ControladorDeCuadriculaDeSeleccionMultiple(
      CuadriculaDeSeleccionMultiple pregunta)
      : super(pregunta);

  @override
  void accept(ControladorDePreguntaVisitor visitor) {
    visitor.visitCuadriculaSeleccionMultiple(this);
  }
}

class ControladorDeCuadriculaDeSeleccionUnica extends ControladorDeCuadricula<
    RespuestaDeSeleccionUnica,
    RespuestaDeCuadriculaDeSeleccionUnica,
    PreguntaDeSeleccionUnica,
    CuadriculaDeSeleccionUnica,
    ControladorDePreguntaDeSeleccionUnica> {
  @override
  late final controladoresPreguntas = pregunta.preguntas
      .map((p) => ControladorDePreguntaDeSeleccionUnica(p))
      .toList();

  ControladorDeCuadriculaDeSeleccionUnica(CuadriculaDeSeleccionUnica pregunta)
      : super(pregunta);

  @override
  void accept(ControladorDePreguntaVisitor visitor) {
    visitor.visitCuadriculaSeleccionUnica(this);
  }
}
