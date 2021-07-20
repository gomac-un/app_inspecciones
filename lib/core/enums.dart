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
/// Cuando presionamos el botón guardar por primera vez, el estado es borrador
/// Mientras no se presione el botón finalizar y se haya llendao todo el formulario
/// El estado será borrador.
/// Al presionar por primera vez finalizar y haber llenado el formulario completamente, el
/// estado pasa a ser enReparación.
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
