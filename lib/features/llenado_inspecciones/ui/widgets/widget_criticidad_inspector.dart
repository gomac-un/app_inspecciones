import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class WidgetCriticidadInspector extends StatelessWidget {
  final FormControl<int> criticidadInspectorControl;
  const WidgetCriticidadInspector(this.criticidadInspectorControl, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        const Text('Criticidad', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Text(
          'Asigne una criticidad dependiendo del estado de la falla',
          style: Theme.of(context).textTheme.caption,
          textAlign: TextAlign.center,
        ),
        Row(
          children: [
            IconButton(
              iconSize: 20,
              icon: const Icon(Icons.info_outline),
              onPressed: () => _mostrarInformacionCriticidad(context),
            ),
            Expanded(
              child: ReactiveSlider(
                formControl: criticidadInspectorControl,
                min: 1,
                max: 4,
                divisions: 3,
                labelBuilder: (v) => v.round().toString(),
                activeColor: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  _mostrarInformacionCriticidad(BuildContext context) => showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Nivel de gravedad de la falla',
              textAlign: TextAlign.center,
            ),
            content: Text(
              "Cada opción representa un porcentaje de la gravedad de la falla así:\n\n-Criticidad 1 representa el 55%\n-Criticidad 2 representa el 70%\n-Criticidad 3 representa el 80%\n-Criticidad 4 representa el 100%",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Aceptar'),
              )
            ],
          );
        },
      );
}
