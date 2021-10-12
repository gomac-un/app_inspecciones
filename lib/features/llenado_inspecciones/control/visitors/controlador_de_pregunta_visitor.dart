import '../controladores_de_pregunta/controladores_de_pregunta.dart';

abstract class ControladorDePreguntaVisitor<R> {
  R visitSeleccionUnica(ControladorDePreguntaDeSeleccionUnica pregunta);

  R visitCuadriculaSeleccionUnica(
      ControladorDeCuadriculaDeSeleccionUnica pregunta);

  R visitCuadriculaSeleccionMultiple(
      ControladorDeCuadriculaDeSeleccionMultiple pregunta);

  R visitSeleccionMultiple(ControladorDePreguntaDeSeleccionMultiple pregunta);

  R visitControladorDePreguntaNumerica(ControladorDePreguntaNumerica pregunta);
}
