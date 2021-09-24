import 'package:flutter/material.dart';
import '../../model/bloques/titulo.dart';

class WidgetTitulo extends StatelessWidget {
  final Titulo titulo;
  const WidgetTitulo(this.titulo, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(titulo.titulo),
        Text(titulo.descripcion),
      ],
    );
  }
}
