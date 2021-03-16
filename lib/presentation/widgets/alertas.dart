import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void mostrarMensaje(BuildContext context, String tipo, String mensaje,
    {bool ocultar = true}) {
  Alert(
    context: context,
    style: AlertStyle(
      overlayColor: Theme.of(context).primaryColorLight,
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      animationDuration: const Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: const BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: const TextStyle(
        color: Colors.white,
      ),
    ),
    type: tipo == 'exito' ? AlertType.success : AlertType.error,
    title: tipo == 'exito' ? 'Éxito' : 'Error',
    desc: mensaje,
    buttons: [
      DialogButton(
        onPressed: () => {
          Navigator.pop(context),
          if (ocultar == true) ExtendedNavigator.of(context).pop()
        },
        color: Theme.of(context).accentColor,
        radius: BorderRadius.circular(10.0),
        child: const Text(
          "Aceptar",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    ],
  ).show();
}

void mostrarErrores(BuildContext context, AbstractControl<dynamic> form) {
  Alert(
    context: context,
    style: AlertStyle(
      overlayColor: Theme.of(context).primaryColorLight,
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      animationDuration: const Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: const BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: const TextStyle(
        color: Colors.white,
      ),
    ),
    type: AlertType.error,
    title: 'Error',
    desc: 'La inspección tiene errores',
    buttons: [
      DialogButton(
        onPressed: () => {
          Navigator.pop(context),
        },
        color: Theme.of(context).accentColor,
        radius: BorderRadius.circular(10.0),
        child: const Text(
          "Aceptar",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      DialogButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) =>
                    AlertDialog(title: const Text("Errores: "), content: Text(
                        /*JsonEncoder.withIndent('  ')
                                        .convert(json.encode(form.errors)),*/
                        /* form.errors.values.toString(), */
                        obtenerErrores(form))));
          },
          color: Theme.of(context).accentColor,
          radius: BorderRadius.circular(10.0),
          child: const Text(
            "Ver errores",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ))
    ],
  ).show();
}

String obtenerErrores(AbstractControl<dynamic> form) {
  String texto = '';
  String textoApoyo = '';
  form.errors.forEach((key, value) => {
        if ((value as Map<String, dynamic>).length > 1)
          {
            textoApoyo =
                '- $key:     ${obtenertextoValores(value as Map<String, dynamic>)} ',
            texto = '$texto \n$textoApoyo',
          }
        else
          {
            textoApoyo = '- $key:\n    $value ',
            texto = '$texto \n$textoApoyo',
          }
      });
  texto = texto.replaceAll('{', '');
  texto = texto.replaceAll('}', '');
  return texto;
}

String obtenertextoValores(Map<String, dynamic> value) {
  String texto = '';
  String textoApoyo = '';
  value.forEach((key, value) => {
        if ((value as Map<String, dynamic>).isNotEmpty)
          {
            textoApoyo =
                '    - $key: ${obtenertextoValores2(value as Map<String, dynamic>)} ',
            texto = '$texto \n$textoApoyo',
          }
        else
          {
            textoApoyo = '   $key: $value ',
            texto = '$texto \n $textoApoyo',
          }
      });
  return texto;
}

String obtenertextoValores2(Map<String, dynamic> value) {
  String texto = '';
  String textoApoyo = '';
  value.forEach((key, value) => {
        textoApoyo = '        $key: $value ',
        texto = '$texto \n $textoApoyo',
      });
  return texto;
}
