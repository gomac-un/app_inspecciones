import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/mvvc/common_widgets.dart';
import 'package:inspecciones/mvvc/llenado_cards.dart';
import 'package:inspecciones/mvvc/llenado_controls.dart';
import 'package:inspecciones/mvvc/llenado_form_view_model.dart';
import 'package:inspecciones/presentation/widgets/action_button.dart';
import 'package:inspecciones/presentation/widgets/alertas.dart';
import 'package:inspecciones/presentation/widgets/loading_dialog.dart';
import 'package:inspecciones/router.gr.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LlenadoFormPage extends StatelessWidget implements AutoRouteWrapper {
  final int activo;
  final int cuestionarioId;

  const LlenadoFormPage({
    Key key,
    this.activo,
    this.cuestionarioId,
  }) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) => Provider(
        create: (ctx) => LlenadoFormViewModel(activo, cuestionarioId),
        dispose: (context, LlenadoFormViewModel value) => value.dispose(),
        child: this,
      );

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LlenadoFormViewModel>(context);

    return ReactiveForm(
      formGroup: viewModel.form,
      child: ValueListenableBuilder<EstadoDeInspeccion>(
          valueListenable: viewModel.estado,
          builder: (context, estado, child) {
            return Scaffold(
              appBar: AppBar(
                title: Text(estado == EstadoDeInspeccion.enReparacion
                    ? 'Reparación de problemas'
                    : 'Llenado de inspeccion'),
                /* actions: [
                    if (estado == EstadoDeInspeccion.borrador ||
                        estado == EstadoDeInspeccion.enReparacion)
                      BotonesGuardado(
                        estado: estado,
                        activo: activo,
                        cuestionarioId: cuestionarioId,
                      )
                    else
                      const SizedBox.shrink(),
                  ], */
              ),
              body: SafeArea(
                child: ValueListenableBuilder<bool>(
                    valueListenable: viewModel.cargada,
                    builder: (context, cargada, child) {
                      final readOnly = viewModel.esNueva.value;
                      String titulo;

                      if (estado == EstadoDeInspeccion.borrador ||
                          estado == EstadoDeInspeccion.enReparacion) {
                        titulo = 'Calificación parcial\nantes de la reparación';
                      } else {
                        titulo = 'Calificación total\n antes de la reparación';
                      }
                      String titulo1;
                      if (estado == EstadoDeInspeccion.borrador ||
                          estado == EstadoDeInspeccion.enReparacion) {
                        titulo1 = 'Calificación parcial\ndespués de reparación';
                      } else {
                        titulo1 = 'Calificación total\ndespués de reparación';
                      }
                      if (!cargada) {
                        return const CircularProgressIndicator();
                      }
                      final controller = PageController();
                      final bloques = estado == EstadoDeInspeccion.borrador ||
                              estado == EstadoDeInspeccion.finalizada
                          ? viewModel.bloques.controls
                          : viewModel.bloques.controls
                              .where((blo) =>
                                  (blo as BloqueDeFormulario).criticidad > 0 ||
                                  blo is TituloFormGroup)
                              .toList();
                      final criticidadTotal = viewModel.bloques.controls
                          .fold<int>(
                              0,
                              (p, c) =>
                                  p + (c as BloqueDeFormulario).criticidad);
                      final criticidadReparacion = viewModel.bloques.controls
                          .fold<int>(
                              0,
                              (p, c) =>
                                  p +
                                  (c as BloqueDeFormulario)
                                      .criticidadReparacion);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PageView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: controller,
                            itemCount: bloques.length,
                            itemBuilder: (context, i) {
                              final element = bloques[i] as BloqueDeFormulario;
                              if (element is TituloFormGroup) {
                                return Center(
                                  child: Column(
                                    children: [
                                      TituloCard(formGroup: element),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      BotonesComunes(
                                        estado: estado,
                                        esTitulo: true,
                                        criticidadTotal: criticidadTotal,
                                        titulo: titulo,
                                        criticidadReparacion:
                                            criticidadReparacion,
                                        titulo1: titulo1,
                                        controller: controller,
                                        i: i,
                                      )
                                    ],
                                  ),
                                );
                              }
                              if (element
                                  is RespuestaSeleccionSimpleFormGroup) {
                                return SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: LinearProgressIndicator(
                                          value: (i + 1) / bloques.length,
                                          minHeight: 5,
                                        ),
                                      ),
                                      SeleccionSimpleCard(
                                        formGroup: element,
                                        readOnly: readOnly,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      BotonesComunes(
                                        estado: estado,
                                        esTitulo: false,
                                        criticidadTotal: criticidadTotal,
                                        titulo: titulo,
                                        criticidadReparacion:
                                            criticidadReparacion,
                                        titulo1: titulo1,
                                        controller: controller,
                                        i: i,
                                      )
                                    ],
                                  ),
                                );
                              }
                              if (element is RespuestaCuadriculaFormArray) {
                                return SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: LinearProgressIndicator(
                                          value: (i + 1) / bloques.length,
                                          minHeight: 5,
                                        ),
                                      ),
                                      CuadriculaCard(
                                        formArray: element,
                                        readOnly: readOnly,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      BotonesComunes(
                                        estado: estado,
                                        esTitulo: false,
                                        criticidadTotal: criticidadTotal,
                                        titulo: titulo,
                                        criticidadReparacion:
                                            criticidadReparacion,
                                        titulo1: titulo1,
                                        controller: controller,
                                        i: i,
                                      )
                                    ],
                                  ),
                                );
                              }
                              if (element is RespuestaNumericaFormGroup) {
                                return SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: LinearProgressIndicator(
                                          value: (i + 1) / bloques.length,
                                          minHeight: 5,
                                        ),
                                      ),
                                      NumericaCard(
                                        formGroup: element,
                                        readOnly: readOnly,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      BotonesComunes(
                                        estado: estado,
                                        esTitulo: false,
                                        criticidadTotal: criticidadTotal,
                                        titulo: titulo,
                                        criticidadReparacion:
                                            criticidadReparacion,
                                        titulo1: titulo1,
                                        controller: controller,
                                        i: i,
                                      )
                                    ],
                                  ),
                                );
                              }
                              return Text(
                                  "error: el bloque $i no tiene una card que lo renderice");
                            }),
                      );
                    }),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: BotonesGuardado(
                estado: estado,
                activo: activo,
                cuestionarioId: cuestionarioId,
              ),
            );
          }),
    );
  }
}

class BotonesComunes extends StatelessWidget {
  final String titulo;
  final EstadoDeInspeccion estado;
  final int criticidadTotal;

  final String titulo1;

  final int criticidadReparacion;
  final int i;
  final PageController controller;

  final bool esTitulo;

  const BotonesComunes({
    Key key,
    @required this.titulo,
    @required this.criticidadTotal,
    @required this.titulo1,
    @required this.criticidadReparacion,
    @required this.i,
    @required this.controller,
    @required this.esTitulo,
    @required this.estado,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LlenadoFormViewModel>(context);
    final esTitul = esTitulo ?? false;
    final bloques = viewModel.estado.value == EstadoDeInspeccion.borrador ||
            viewModel.estado.value == EstadoDeInspeccion.finalizada
        ? viewModel.bloques.controls
        : viewModel.bloques.controls
            .where((blo) =>
                (blo as BloqueDeFormulario).criticidad > 0 ||
                blo is TituloFormGroup)
            .toList();
    return Row(
      children: [
        Expanded(child: Container()),
        Expanded(
          flex: 4,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (i != 0)
                    FloatingActionButton(
                      heroTag: 'atras',
                      onPressed: () {
                        controller.animateToPage(
                          i - 1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.linear,
                        );
                      },
                      child: const Icon(Icons.navigate_before),
                    ),
                  const SizedBox(
                    width: 15.0,
                  ),
                  if (i != bloques.length - 1)
                    FloatingActionButton(
                      heroTag: 'adelante',
                      onPressed: () {
                        controller.animateToPage(
                          i + 1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.linear,
                        );
                      },
                      child: const Icon(Icons.navigate_next),
                    ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              if (!esTitulo ?? false)
                PreguntaCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        titulo,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      if (criticidadTotal > 0)
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.red,
                          size: 25, /* color: Colors.white, */
                        )
                      else
                        Icon(
                          Icons.remove_red_eye,
                          color: Colors.green[200], /* color: Colors.white, */
                        ),
                      Text(
                        ' ${criticidadTotal.toString()}',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ),
              if (!esTitulo &&
                  [EstadoDeInspeccion.enReparacion, EstadoDeInspeccion.finalizada]
                      .contains(estado))
                PreguntaCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        titulo1,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      if (criticidadTotal > 0)
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.red,
                          size: 25, /* color: Colors.white, */
                        )
                      else
                        Icon(
                          Icons.remove_red_eye,
                          color: Colors.green[200], /* color: Colors.white, */
                        ),
                      Text(
                        ' ${criticidadReparacion.toString()}',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ),
              const SizedBox(
                height: 120,
              )
            ],
          ),
        ),
      ],
    );
  }
}

class BotonesGuardado extends StatelessWidget {
  final int activo;
  final int cuestionarioId;
  const BotonesGuardado({
    Key key,
    @required this.estado,
    this.activo,
    this.cuestionarioId,
  }) : super(key: key);

  final EstadoDeInspeccion estado;

  @override
  Widget build(BuildContext context) {
    final form = ReactiveForm.of(context);
    final viewModel = Provider.of<LlenadoFormViewModel>(context);
    final borradorKey = GlobalKey();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          if ([EstadoDeInspeccion.borrador, EstadoDeInspeccion.enReparacion]
              .contains(estado))
            ActionButton(
              key: borradorKey,
              iconData: Icons.archive,
              label: 'Guardar',
              onPressed: () async {
                final criticidadTotal = viewModel.bloques.controls.fold<int>(
                    0, (p, c) => p + (c as BloqueDeFormulario).criticidad);
                final criticidadReparacion = viewModel.bloques.controls
                    .fold<int>(
                        0,
                        (p, c) =>
                            p + (c as BloqueDeFormulario).criticidadReparacion);
                LoadingDialog.show(context);
                await viewModel.guardarInspeccionEnLocal(
                    estado: estado,
                    criticidadTotal: criticidadTotal,
                    criticidadReparacion: criticidadReparacion);
                LoadingDialog.hide(context);
                viewModel.fueGuardado.value = true;
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: const Text("Guardado exitoso"),
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
                /* Scaffold.of(context).showSnackBar(
                    const SnackBar(content: Text("Guardado exitoso"))); */
              },
            ),
          ValueListenableBuilder<bool>(
            builder: (BuildContext context, value, Widget child) {
              if(value){
                return FloatingActionButton.extended(
                heroTag: null,
                icon: const Icon(Icons.done_all_outlined),
                label: Text(estado == EstadoDeInspeccion.finalizada
                    ? 'Aceptar'
                    : 'Finalizar'),
                onPressed: !form.valid
                    ? () {
                        final snackBar = SnackBar(
                          content: const Text('La inspección tiene errores'),
                          action: SnackBarAction(
                            label: 'Ver errores',
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Aceptar',
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ),
                                  ],
                                  title: const Text("Errores:"),
                                  content: Text(
                                      /*JsonEncoder.withIndent('  ')
                                          .convert(json.encode(form.errors)),*/
                                      /* form.errors.values.toString(), */
                                      _obtenerErrores(form, estado: estado)),
                                ),
                              );
                            },
                          ),
                        );
                        if (estado == EstadoDeInspeccion.borrador) {
                          form.markAllAsTouched();
                          Scaffold.of(context).showSnackBar(snackBar);
                        } else if (estado == EstadoDeInspeccion.enReparacion) {
                          form.markAllAsTouched();
                          if (form.errors.isEmpty && form.valid) {
                            finalizarInspeccion(context, estado);
                          } else {
                            Scaffold.of(context).showSnackBar(snackBar);
                            /*   mostrarErrores(context, form, estado: estado); */
                          }
                        }
                      }
                    : () {
                        finalizarInspeccion(context, estado);
                      },
              );
              }
              return const SizedBox.shrink();
              
            },
            valueListenable: viewModel.fueGuardado,
          ),
        ],
      ),
    );
  }

  String _obtenerErrores(AbstractControl<dynamic> form,
      {EstadoDeInspeccion estado}) {
    String texto = '';
    String textoApoyo = '';
    final errores = form.errors['bloques'];
    errores.forEach((key, value) {
      textoApoyo = estado == EstadoDeInspeccion.enReparacion
          ? '- Pregunta $key: asegúrese de haber incluido observaciones y fotos de la reparación.'
          : '- Pregunta $key: asegúrese de responder la pregunta y tomar las fotos base.';
      texto = '$texto \n$textoApoyo';
    });
    return texto;
  }

  Future<void> finalizarInspeccion(
      BuildContext context, EstadoDeInspeccion estadoIns) async {
    final viewModel = Provider.of<LlenadoFormViewModel>(context, listen: false);
    // set up the buttons
    final cancelButton = FlatButton(
      onPressed: () => Navigator.of(context).pop(),
      child: const Text("Cancelar"), // OJO con el context
    );
    final Widget continueButton = FlatButton(
      onPressed: () async {
        Navigator.of(context).pop();

        await guardarParaReparacion(context, estado);
      },
      child: const Text("Aceptar"),
    );
    // set up the AlertDialog
    final alert = AlertDialog(
      title: const Text("Alerta"),
      content: const Text(
          "¿Está seguro que desea finalizar esta inspección? Si lo hace, no podrá editarla después "),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog

    if (estado == EstadoDeInspeccion.enReparacion) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    } else if (estado == EstadoDeInspeccion.borrador) {
      final criticidadTotal = viewModel.bloques.controls
          .fold<int>(0, (p, c) => p + (c as BloqueDeFormulario).criticidad);
      if (criticidadTotal <= 0) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      } else {
        await guardarParaReparacion(context, estado);
      }
    } else {
      Navigator.of(context).pop();
    }
  }

  Future guardarParaReparacion(
      BuildContext context, EstadoDeInspeccion estadoIns) async {
    final viewModel = Provider.of<LlenadoFormViewModel>(context, listen: false);
    switch (estadoIns) {
      case EstadoDeInspeccion.borrador:
        final criticidadTotal = viewModel.bloques.controls
            .fold<int>(0, (p, c) => p + (c as BloqueDeFormulario).criticidad);
        final criticidadReparacion = viewModel.bloques.controls.fold<int>(
            0, (p, c) => p + (c as BloqueDeFormulario).criticidadReparacion);
        if (criticidadTotal > 0) {
          viewModel.estado.value = EstadoDeInspeccion.enReparacion;
          LoadingDialog.show(context);
          await viewModel.guardarInspeccionEnLocal(
              estado: EstadoDeInspeccion.enReparacion,
              criticidadTotal: criticidadTotal,
              criticidadReparacion: criticidadReparacion);
          LoadingDialog.hide(context);
          await showDialog(
            context: context,
            builder: (context) => AlertReparacion(),
          );
          //machetazo para recargar el formulario con los datos insertados en la DB
          ExtendedNavigator.of(context).popAndPush(Routes.llenadoFormPage,
              arguments: LlenadoFormPageArguments(
                  activo: activo, cuestionarioId: cuestionarioId));
        } else {
          mostrarMensaje(context,
              'Ha finalizado la inspección, no debe hacer reparaciones');
        }
        break;
      case EstadoDeInspeccion.enReparacion:
        mostrarMensaje(context, 'Inspección finalizada');
        break;
      default:
    }
  }

  Future guardarYSalir(BuildContext context) async {
    final viewModel = Provider.of<LlenadoFormViewModel>(context, listen: false);
    final criticidadTotal = viewModel.bloques.controls
        .fold<int>(0, (p, c) => p + (c as BloqueDeFormulario).criticidad);
    final criticidadReparacion = viewModel.bloques.controls.fold<int>(
        0, (p, c) => p + (c as BloqueDeFormulario).criticidadReparacion);
    viewModel.estado.value = EstadoDeInspeccion.finalizada;
    LoadingDialog.show(context);
    await viewModel.guardarInspeccionEnLocal(
      estado: EstadoDeInspeccion.finalizada,
      criticidadTotal: criticidadTotal,
      criticidadReparacion: criticidadReparacion,
    );
    LoadingDialog.hide(context);
    ExtendedNavigator.of(context).pop();
  }

  void mostrarMensaje(BuildContext context, String mensaje) {
    Alert(
      context: context,
      style: AlertStyle(
        overlayColor: Colors.blueAccent[100],
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
      type: AlertType.success,
      title: 'Éxito',
      desc: mensaje,
      buttons: [
        DialogButton(
          onPressed: () async =>
              {Navigator.pop(context), await guardarYSalir(context)},
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
}

class ErroresDialog extends StatelessWidget {
  final AbstractControl form;

  const ErroresDialog({Key key, this.form}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(form.errors['bloques']);
    return AlertDialog(
      title: const Text("Errores: "),
      content: Text(
        /*JsonEncoder.withIndent('  ')
        .convert(json.encode(form.errors)),*/
        form.errors['bloques'].toString(), //TODO: darle un formato adecuado
      ),
    );
  }
}

class AlertReparacion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Inicio reparacion"),
      content: const Text("Por favor realice las reparaciones necesarias"),
      actions: [
        TextButton(
            onPressed: ExtendedNavigator.of(context).pop,
            child: const Text("ok"))
      ],
    );
  }
}

/* class InspeccionCondicional extends StatelessWidget {
  final EstadoDeInspeccion estado;

  const InspeccionCondicional({Key key, this.estado}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LlenadoFormViewModel>(context);
    final listaAMostrar = viewModel.bloques1.value;
    bool readOnly = false;
    return ValueListenableBuilder<List<AbstractControl>>(
      valueListenable: viewModel.bloques1,
      builder: (BuildContext context, value, Widget child) {
        return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: viewModel.bloques1.value.length,
            itemBuilder: (context, i) {
              if (estado == EstadoDeInspeccion.finalizada) {
                readOnly = true;
              }
              final element = listaAMostrar[i] as BloqueDeFormulario;
              if (estado == EstadoDeInspeccion.enReparacion &&
                  element.criticidad == 0) {
                return const SizedBox
                    .shrink(); //Esconde los que tienen criticidad 0 si la inspeccion esta en reparacion
              }
              if (element is TituloFormGroup) {
                return TituloCard(formGroup: element);
              }
              if (element is RespuestaSeleccionSimpleFormGroup &&
                  element.pregunta.pregunta.esCondicional != true) {
                return SeleccionSimpleCard(
                    formGroup: element, readOnly: readOnly);
              }
              if (element is RespuestaSeleccionSimpleFormGroup &&
                  element.pregunta.pregunta.esCondicional == true) {
                /* if(element.seccion != null){
                borrarBloques(i,element.seccion, listaAMostrar);}
              else{
                agregar();
              } */
                return SeleccionSimpleCard(
                  formGroup: element,
                  readOnly: readOnly,
                );
              }
              if (element is RespuestaCuadriculaFormArray) {
                return CuadriculaCard(formArray: element);
              }
              if (element is RespuestaNumericaFormGroup) {
                return NumericaCard(
                  formGroup: element,
                  readOnly: readOnly,
                );
              }
              return Text(
                  "error: el bloque $i no tiene una card que lo renderice");
            });
      },
    );
  }
}
 */
