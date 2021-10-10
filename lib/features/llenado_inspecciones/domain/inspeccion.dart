import 'cuestionario.dart';
import 'modelos.dart';

class Inspeccion {
  final int id;
  final EstadoDeInspeccion estado;
  final Activo activo;
  final DateTime? momentoBorradorGuardado;
  final DateTime? momentoEnvio;

  final double criticidadTotal;
  final double criticidadReparacion;
  final bool esNueva;
  //inspector //TODO: agregarle el dato del inspector que la esta haciendo

  late final CuestionarioInspeccionado cuestionario;

  Inspeccion({
    required this.id,
    required this.estado,
    required this.activo,
    this.momentoBorradorGuardado,
    this.momentoEnvio,
    required this.criticidadTotal,
    required this.criticidadReparacion,
    required this.esNueva,
  });
}

/// Los tres estados en los que puede encontrarse una inspección.
///
/// Cuando se comienza a llenar una nueva inspeccion, el estado es borrador
/// Mientras no se presione el botón finalizar y se haya llenado y validado todo
/// el formulario el estado será borrador.
/// Al presionar por primera vez finalizar y haber llenado y validado el
/// formulario completamente, el estado pasa a ser enReparación.
/// Cuando se han realizado las reparaciones y se da finalizar, se cambia el estado a finalizada.
enum EstadoDeInspeccion {
  borrador,
  enReparacion,
  finalizada,
}
