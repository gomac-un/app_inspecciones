enum TipoDePregunta {
  unicaRespuesta,
  multipleRespuesta,
  parteDeCuadriculaUnica,
  parteDeCuadriculaMultiple,
  numerica,
  binaria,
  fecha,
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

enum EstadoDeCuestionario {
  borrador,
  finalizada,
}

/// Estados que puede tener un sistema paraa un activo en un grupo o ronda de inspección determinado.
enum EstadoProgramacion {
  asignado,
  noAsignado,
  noAplica,
}
