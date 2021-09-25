import '../controladores_de_pregunta/controladores_de_pregunta.dart';

abstract class ControladorDePreguntaVisitor {
  void visitSeleccionUnica(ControladorDePreguntaDeSeleccionUnica pregunta);

  void visitCuadriculaSeleccionUnica(
      ControladorDeCuadriculaDeSeleccionUnica pregunta);

  void visitCuadriculaSeleccionMultiple(
      ControladorDeCuadriculaDeSeleccionMultiple pregunta);

  void visitSeleccionMultiple(
      ControladorDePreguntaDeSeleccionMultiple pregunta);

  void visitControladorDePreguntaNumerica(
      ControladorDePreguntaNumerica pregunta);
}
