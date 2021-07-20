import 'package:flutter/material.dart';

/// Reúne todos los widgets comunes a la creación o llenado de inspecciones.
///
/// Si varios tipos de preguntas usan los mismos Widgets, se pueden añadir aquí
//TODO: Refactorizar en llenado_card o creacion_card si hay algún widget que añadir
class PreguntaCard extends StatelessWidget {
  final Widget child;
  final String titulo;
  final String descripcion;

  /// Criticidad de la pregunta.
  final int criticidad;

  /// Para el mensaje de criticidad, puede ser total (Si la inspeccion esta finalizada) o parcial (en cualquier otro caso)
  final String estado;

  const PreguntaCard(
      {Key key,
      this.child,
      this.titulo,
      this.descripcion,
      this.criticidad,
      this.estado})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (titulo != null)
              Text(
                titulo,
                style: Theme.of(context).textTheme.headline6,
              ),
            const SizedBox(height: 5),
            if (descripcion != null)
              Text(
                descripcion,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            const SizedBox(height: 10),
            child,
            if (criticidad != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    criticidad > 0
                        ? Icons.warning_amber_rounded
                        : Icons.remove_red_eye,
                    color: criticidad > 0 ? Colors.red : Colors.green[200],
                    size: 25, /* color: Colors.white, */
                  ),
                  Text(
                    '$estado: ${criticidad.toString()}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
