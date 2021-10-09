import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../control/controladores_de_pregunta/controlador_de_pregunta_numerica.dart';

class WidgetPreguntaNumerica extends StatelessWidget {
  final ControladorDePreguntaNumerica controlador;

  const WidgetPreguntaNumerica(
    this.controlador, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: ReactiveTextField(
        formControl: controlador.respuestaEspecificaControl,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9\.\-]'))
        ],
        valueAccessor: MyDoubleValueAccessor(),
        validationMessages: (control) => {
          ValidationMessage.number: 'Debe ser un número válido',
        },
        decoration: InputDecoration(
            labelText: "valor", suffix: Text(controlador.pregunta.unidades)),
      ),
    );
  }
}
