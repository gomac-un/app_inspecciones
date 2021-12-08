import 'package:flutter/material.dart';

import 'administrador_de_etiquetas.dart';

class ListaDeEtiquetasPage extends StatelessWidget {
  const ListaDeEtiquetasPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: const [
      MenuDeEtiquetas(TipoDeEtiqueta.activo),
      MenuDeEtiquetas(TipoDeEtiqueta.pregunta)
    ]));
  }
}
