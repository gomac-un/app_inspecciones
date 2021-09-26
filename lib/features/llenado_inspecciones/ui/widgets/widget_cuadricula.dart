import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../control/controladores_de_pregunta/controlador_de_cuadricula.dart';
import '../../domain/bloques/preguntas/opcion_de_respuesta.dart';
import '../widgets/dialog_pregunta.dart';

class WidgetCuadricula extends HookWidget {
  final ControladorDeCuadricula controlador;
  // trampa, pero me da pereza escribir todos los type parameters para que sea generico
  final Iterable<Widget> Function(dynamic controladorPregunta) rowsBuilder;

  const WidgetCuadricula(
    this.controlador, {
    Key? key,
    required this.rowsBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    return Scrollbar(
      controller: scrollController,
      isAlwaysShown: true,
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Table(
            border: const TableBorder(
              horizontalInside: BorderSide(color: Colors.black26),
              verticalInside: BorderSide(color: Colors.black26),
            ),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            //TODO: en google forms el ancho minimo de cada columna es el ancho de la palabra
            //mas larga del titulo de la pregunta para evitar que se corten
            defaultColumnWidth: const FixedColumnWidth(100),

            children: [
              TableRow(
                children: [
                  const SizedBox.shrink(),
                  ...controlador.pregunta.opcionesDeRespuesta.map(
                    (e) => Column(
                      children: [
                        Text(
                          e.titulo,
                          textAlign: TextAlign.center,
                        ),
                        if (e.descripcion.isNotEmpty)
                          IconButton(
                            onPressed: () =>
                                _mostrarInfoExtraOpcionDeRespuesta(context, e),
                            icon: const Icon(Icons.info_outlined),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              ...controlador.controladoresPreguntas.map((controladorPregunta) {
                return TableRow(
                  children: [
                    Wrap(
                      children: [
                        Text(controladorPregunta.pregunta.titulo),
                        IconButton(
                          icon: IconDialogPregunta(
                              controladorPregunta: controladorPregunta),
                          onPressed: () => mostrarDialogPregunta(
                              context, controladorPregunta),
                        ),
                      ],
                    ),
                    ...rowsBuilder(controladorPregunta),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarInfoExtraOpcionDeRespuesta(
      BuildContext context, OpcionDeRespuesta e) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.hideCurrentMaterialBanner();
    scaffold.showMaterialBanner(
      MaterialBanner(
        padding: const EdgeInsets.all(20),
        content: Column(
          children: [
            Text(
              e.titulo,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Text(e.descripcion),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Ok'),
            onPressed: scaffold.hideCurrentMaterialBanner,
          ),
        ],
      ),
    );
  }
}
