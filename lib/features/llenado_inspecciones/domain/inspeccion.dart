import 'activo.dart';

class Inspeccion {
  final String? id;
  EstadoDeInspeccion
      estado; // no es final porque se usa para indicar el estado en el guardado
  final Activo activo;
  final DateTime momentoInicio;
  final DateTime? momentoBorradorGuardado;
  final DateTime? momentoFinalizacion;
  final DateTime? momentoEnvio;

  int criticidadCalculada;
  int criticidadCalculadaConReparaciones;

  Inspeccion({
    this.id,
    required this.estado,
    required this.activo,
    required this.momentoInicio,
    this.momentoBorradorGuardado,
    this.momentoFinalizacion,
    this.momentoEnvio,
    required this.criticidadCalculada,
    required this.criticidadCalculadaConReparaciones,
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
