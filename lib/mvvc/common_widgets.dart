import 'package:flutter/material.dart';

class PreguntaCard extends StatelessWidget {
  final Widget child;
  final String titulo;
  final String descripcion;
  final int criticidad;
  final String estado;

  const PreguntaCard(
      {Key key, this.child, this.titulo, this.descripcion, this.criticidad, this.estado})
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
                  if (criticidad > 0)
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red,
                      size: 25, /* color: Colors.white, */
                    )
                  else
                    Icon(
                      Icons.remove_red_eye,
                      color: Colors.green[200], /* color: Colors.white, */
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
