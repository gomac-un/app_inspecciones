import 'package:flutter/material.dart';

import 'package:reactive_forms/reactive_forms.dart';

import 'creacion_controls.dart';
import 'creacion_widgets.dart';

/// Cuando en el formulario se presiona añadir titulo, este es el widget que se muestra
class CreadorTituloCard extends StatelessWidget {
  final CreadorTituloController controller;

  const CreadorTituloCard({Key? key, required this.controller})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      //TODO: destacar mejor los titulos
      shape: RoundedRectangleBorder(
          side:
              BorderSide(color: Theme.of(context).backgroundColor, width: 2.0),
          borderRadius: BorderRadius.circular(4.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ReactiveTextField(
              style: Theme.of(context).textTheme.headline5,
              formControl: controller.tituloControl,
              validationMessages: (control) =>
                  {ValidationMessage.required: 'El titulo no debe ser vacío'},
              decoration: const InputDecoration(
                labelText: 'Titulo de sección',
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 10),
            ReactiveTextField(
              style: Theme.of(context).textTheme.bodyText2,
              formControl: controller.descripcionControl,
              decoration: const InputDecoration(
                labelText: 'Descripción',
              ),
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 50,
              textCapitalization: TextCapitalization.sentences,
            ),

            /// Row con widgets que permiten añadir o pegar otro bloque debajo del actual.
            BotonesDeBloque(controllerActual: controller),
          ],
        ),
      ),
    );
  }
}
