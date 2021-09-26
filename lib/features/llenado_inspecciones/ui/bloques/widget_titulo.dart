import 'package:flutter/material.dart';

import '../../domain/bloques/titulo.dart';

class WidgetTitulo extends StatelessWidget {
  final Titulo titulo;
  const WidgetTitulo(
    this.titulo, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondary,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text(
            titulo.titulo,
            style: Theme.of(context)
                .textTheme
                .headline5
                ?.copyWith(color: Theme.of(context).colorScheme.onSecondary),
          ),
          subtitle: Text(
            titulo.descripcion,
            style: Theme.of(context)
                .textTheme
                .bodyText2
                ?.copyWith(color: Theme.of(context).colorScheme.onSecondary),
          ),
        ),
      ),
    );
  }
}
