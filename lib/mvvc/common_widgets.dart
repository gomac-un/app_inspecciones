import 'package:flutter/material.dart';

class PreguntaCard extends StatelessWidget {
  final Widget child;
  final String titulo;
  final String descripcion;

  const PreguntaCard({Key key, this.child, this.titulo, this.descripcion})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
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
            if (descripcion != null)
              Text(
                descripcion,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}
