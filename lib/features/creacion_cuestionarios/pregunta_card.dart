import 'package:flutter/material.dart';

class PreguntaCard extends StatelessWidget {
  final Widget child;
  final String titulo;

  const PreguntaCard({
    Key? key,
    required this.child,
    required this.titulo,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              titulo,
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}
