import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../control/controlador_llenado_inspeccion.dart';
import '../widgets/loading_dialog.dart';

typedef ActionCallback = Future<void> Function({
  VoidCallback? onStart,
  VoidCallback? onFinish,
  CallbackWithMessage? onSuccess,
  CallbackWithMessage? onError,
});

class LlenadoAppBarButton extends StatelessWidget {
  final ActionCallback action;
  final Widget icon;
  final String? tooltip;
  const LlenadoAppBarButton(
      {Key? key, required this.action, required this.icon, this.tooltip})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => action(
        onStart: () => mostrarCargando(context),
        onFinish: () => esconderCargando(context),
        onSuccess: (msg) => mostrarExito(context, msg),
        onError: (msg) => mostrarError(context: context, msg: msg),
      ),
      icon: icon,
      tooltip: tooltip,
    );
  }
}

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

void mostrarInvalido(BuildContext context) => mostrarError(
      context: context,
      title: "Inspeccion con respuestas no válidas",
      msg:
          "Se mostrarán unicamente las respuestas no válidas para que las revise y pueda finalizar la inspección",
      actions: [
        Consumer(builder: (context, ref, _) {
          return TextButton(
            child: const Text("ok"),
            onPressed: () {
              ref.read(filtroPreguntasProvider).state =
                  FiltroPreguntas.invalidas;
              Navigator.of(context).pop();
            },
          );
        })
      ],
    );
