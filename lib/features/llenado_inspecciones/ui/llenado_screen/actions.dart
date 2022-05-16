import 'package:flutter/material.dart';

import '../../control/controlador_llenado_inspeccion.dart';
import '../widgets/loading_dialog.dart';

class BotonGuardar extends StatelessWidget {
  final GuardadoCallback guardar;
  final Widget icon;
  final Widget firstChild;
  final String? tooltip;
  final bool isDisabled;
  const BotonGuardar(
      {Key? key,
      required this.guardar,
      required this.icon,
      this.tooltip,
      required this.isDisabled,
      required this.firstChild})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      FloatingActionButton(
        child: firstChild,
        onPressed: () {
          //...
        },
        heroTag: null,
      ),
      const SizedBox(
        height: 10,
      ),
      FloatingActionButton(
        onPressed: () =>
            isDisabled ? null : agregarMensajesAccion(context)(guardar),
        child: icon,
        tooltip: tooltip,
        disabledElevation: 8,
        backgroundColor: isDisabled ? Colors.grey : null,
      ),
    ]);
  }
}

EjecucionCallback agregarMensajesAccion(BuildContext context) =>
    (GuardadoCallback funcionDeGuardado) => funcionDeGuardado(
          onStart: () => mostrarCargando(context),
          onFinish: () => esconderCargando(context),
          onSuccess: (msg) => mostrarExito(context, msg),
          onError: (msg) => mostrarError(context: context, msg: msg),
        );

void mostrarCargando(BuildContext context) => LoadingDialog.show(context);

void esconderCargando(BuildContext context) => LoadingDialog.hide(context);

void mostrarExito(BuildContext context, String msg) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

void mostrarError({
  required BuildContext context,
  required String msg,
  String title = "Error",
  List<Widget>? actions,
}) =>
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Wrap(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red),
                  Text(title),
                ],
              ),
              content: Text(msg),
              actions: actions,
            ));

void mostrarInvalido(BuildContext context,
        ControladorLlenadoInspeccion controladorInspeccion) =>
    mostrarError(
      context: context,
      title: "Inspeccion con respuestas no válidas",
      msg:
          "Se mostrarán unicamente las respuestas no válidas para que las revise y pueda finalizar la inspección",
      actions: [
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text("Aceptar"),
          onPressed: () {
            controladorInspeccion.filtroPreguntas.value =
                FiltroPreguntas.invalidas;
            Navigator.of(context).pop();
          },
        ),
      ],
    );

Future<bool?> mostrarConfirmacion({
  required BuildContext context,
  required Widget content,
  String title = "Confirmación",
  //List<Widget>? actions,
}) =>
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: content,
        actions: [
          ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancelar")),
          ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Ok")),
        ],
      ),
    );

void mostrarMensajeReparacion(BuildContext context) =>
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Por favor realice las reparaciones necesarias")));
