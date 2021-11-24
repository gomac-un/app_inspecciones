import 'package:flutter/material.dart';

import '../../control/controlador_de_pregunta.dart';
import '../../domain/bloques/pregunta.dart';
import 'widget_respuesta.dart';

class PreguntaCard extends StatelessWidget {
  final Pregunta pregunta;
  final ControladorDePregunta controlador;
  final Widget child;
  final int nOrden;
  const PreguntaCard({
    Key? key,
    required this.nOrden,
    required this.pregunta,
    required this.controlador,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$nOrden',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const Icon(Icons.arrow_forward_ios),
                ],
              ),
              title: Text(pregunta.titulo),
              subtitle: Text(pregunta.descripcion),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Etiquetas: ${pregunta.etiquetas.join(", ")}",
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: child,
            ),
            WidgetRespuesta(controlador),
            //WidgetCriticidad(controlador), //TODO: mirar que hacer con la feature "criticidad_inspector"
          ],
        ),
      ),
    );
  }
}
