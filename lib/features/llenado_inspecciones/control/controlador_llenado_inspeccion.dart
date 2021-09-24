import 'package:inspecciones/infrastructure/repositories/inspecciones_repository.dart';

import '../model/bloques/pregunta.dart';
import '../model/cuestionario.dart';

import 'controlador_de_pregunta.dart';
import 'controlador_factory.dart';

class ControladorLlenadoInspeccion {
  final InspeccionesRepository repository;
  final ControladorFactory factory;
  final Cuestionario cuestionario;
  late final List<ControladorDePregunta> controladores = cuestionario.bloques
      .whereType<Pregunta>()
      .map(factory.crearControlador)
      .toList();

  ControladorLlenadoInspeccion(
    this.factory,
    this.cuestionario,
    this.repository,
  );

  guardarBorrador() {
    //TODO: implement
    throw UnimplementedError();
  }

  guardarDefinitivamente() {
    //TODO: implement
    throw UnimplementedError();
  }
}
