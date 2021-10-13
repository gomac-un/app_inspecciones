import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

///TODO: plantear mejor las funciones de este archivo

enum TipoDeMensaje { exito, error }

/// Alerta que permite dar estilos personalizados. Se usa a la hora de
/// creación y envío de cuestionarios
void mostrarMensaje(BuildContext context, TipoDeMensaje tipo, String mensaje,
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
    type: tipo == TipoDeMensaje.exito ? AlertType.success : AlertType.error,
    title: tipo == TipoDeMensaje.exito ? 'Éxito' : 'Error',
    desc: mensaje,
    buttons: [
      DialogButton(
        onPressed: () => {
          Navigator.of(context).pop(),
          if (ocultar == true) Navigator.of(context).pop()
        },
        color: Theme.of(context).colorScheme.secondary,
        radius: BorderRadius.circular(10.0),
        child: const Text(
          "Aceptar",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    ],
  ).show();
}

/// Usada para mostrar los errores de la creación de cuestionarios.
Future<void> mostrarErrores(
    BuildContext context, AbstractControl<dynamic> form) {
  
  return Alert(
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
        color: Theme.of(context).colorScheme.secondary,
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
          color: Theme.of(context).colorScheme.secondary,
          radius: BorderRadius.circular(10.0),
          child: const Text(
            "Ver errores",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ))
    ],
  ).show();
}

/// Un machetazo para mostrar un poquito más lindos los errores del cuestionario.
/// Si se cambia nombre de un error, probablemente no se vaya a mostrar aquí
String obtenerErrores(AbstractControl<dynamic> form) {
  String texto = '';
  String textoApoyo = '';
  final errorSistema = form.errors['sistema'] != null
      ? 'Elija el sistema del cuestionario'
      : null;
  final errorContratista =
      form.errors['contratista'] != null ? 'Seleccione el contratista' : null;
  final errorTipo = form.errors['tipoDeInspeccion'] != null ||
          form.errors['nuevoTipoDeInspeccion'] != null
      ? 'Seleccione el tipo de inspección'
      : null;
  final errorModelo = form.errors['modelos'] as Map;

  texto = errorTipo != null ? '- $errorTipo' : '';

  final x = errorModelo['minLength'];
  if (x != null) {
    texto = texto.isNotEmpty
        ? '$texto \n- Elija por lo menos un modelo'
        : '$texto- Elija por lo menos un modelo';
  } else if (errorModelo['yaExiste'] != null) {
    texto = texto.isNotEmpty
        ? '$texto \n- Ya existe un cuestionario de este tipo para alguno de los modelos'
        : '$texto- Ya existe un cuestionario de este tipo para alguno de los modelos';
  }

  if (errorSistema != null) {
    texto =
        texto.isNotEmpty ? '$texto \n- $errorSistema' : '$texto- $errorSistema';
  }
  if (errorContratista != null) {
    texto = texto.isNotEmpty
        ? '$texto \n- $errorContratista'
        : '$texto- $errorContratista';
  }
  final erroresBloques = form.errors['bloques'] as Map?;
  if (erroresBloques != null) {
    if (texto.isNotEmpty) {
      texto = '$texto \n- Los siguientes bloques presentan algún error';
    } else {
      texto = '- Los siguientes bloques tienen algún error';
    }
  }
  erroresBloques?.forEach((key, value) {
    textoApoyo = '    - Bloque ${int.parse(key as String) + 1}';
    texto = '$texto \n$textoApoyo';
  });
  return texto;
}
