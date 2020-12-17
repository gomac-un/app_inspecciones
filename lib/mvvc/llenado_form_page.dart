import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/mvvc/form_scaffold.dart';
import 'package:inspecciones/mvvc/llenado_cards.dart';
import 'package:inspecciones/mvvc/llenado_controls.dart';
import 'package:inspecciones/mvvc/llenado_form_view_model.dart';
import 'package:inspecciones/presentation/widgets/action_button.dart';
import 'package:inspecciones/presentation/widgets/loading_dialog.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class LlenadoFormPage extends StatelessWidget implements AutoRouteWrapper {
  final String vehiculo;
  final int cuestionarioId;

  const LlenadoFormPage({
    Key key,
    this.vehiculo,
    this.cuestionarioId,
  }) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) => Provider(
        create: (ctx) => LlenadoFormViewModel(vehiculo, cuestionarioId),
        dispose: (context, LlenadoFormViewModel value) => value.form.dispose(),
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
            return FormScaffold(
              title: Text(estado == EstadoDeInspeccion.reparacion
                  ? 'Reparación de problemas'
                  : 'Llenado de inspeccion'),
              actions: [
                BotonGuardarBorrador(
                  estado: estado,
                ),
              ],
              body: Column(
                children: [
                  ValueListenableBuilder<bool>(
                      valueListenable: viewModel.cargada,
                      builder: (context, cargada, child) {
                        if (!cargada) return const CircularProgressIndicator();
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: viewModel.bloques.controls.length,
                            itemBuilder: (context, i) {
                              final element = viewModel.bloques.controls[i]
                                  as BloqueDeFormulario;
                              if (estado == EstadoDeInspeccion.reparacion &&
                                  element.criticidad == 0) {
                                return const SizedBox.shrink();
                              }
                              if (element is TituloFormGroup) {
                                return TituloCard(formGroup: element);
                              }
                              if (element
                                  is RespuestaSeleccionSimpleFormGroup) {
                                return SeleccionSimpleCard(formGroup: element);
                              }
                              if (element is RespuestaCuadriculaFormArray) {
                                return CuadriculaCard(formArray: element);
                              }
                              return Text(
                                  "error: el bloque $i no tiene una card que lo renderice");
                            });
                      }),
                  const SizedBox(height: 60),
                ],
              ),
              floatingActionButton: BotonesGuardado(
                estado: estado,
              ),
            );
          }),
    );
  }
}

class BotonGuardarBorrador extends StatelessWidget {
  const BotonGuardarBorrador({
    Key key,
    @required this.estado,
  }) : super(key: key);

  final EstadoDeInspeccion estado;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LlenadoFormViewModel>(context);
    return IconButton(
      icon: const Icon(Icons.archive),
      //label: 'Guardar borrador',
      onPressed: () async {
        LoadingDialog.show(context);
        await viewModel.guardarInspeccionEnLocal(estado: estado);
        LoadingDialog.hide(context);
        Scaffold.of(context)
            .showSnackBar(const SnackBar(content: Text("Guardado exitoso")));
      },
    );
  }
}

class BotonesGuardado extends StatelessWidget {
  const BotonesGuardado({
    Key key,
    @required this.estado,
  }) : super(key: key);

  final EstadoDeInspeccion estado;

  @override
  Widget build(BuildContext context) {
    final form = ReactiveForm.of(context);
    final viewModel = Provider.of<LlenadoFormViewModel>(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ActionButton(
            iconData: Icons.done_all_outlined,
            label: 'Finalizar',
            onPressed: !form.valid
                ? () {
                    form.markAllAsTouched();
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Row(
                      children: [
                        const Text("La inspeccion tiene errores"),
                        FlatButton(
                          onPressed: () => showDialog(
                              context: context,
                              builder: (context) => ErroresDialog(form: form)),
                          child: const Text("ver errores"),
                        ),
                      ],
                    )));
                  }
                : () async {
                    switch (estado) {
                      case EstadoDeInspeccion.borrador:
                        final criticidadTotal = viewModel.bloques.controls
                            .fold<int>(
                                0,
                                (p, c) =>
                                    p + (c as BloqueDeFormulario).criticidad);
                        if (criticidadTotal > 0) {
                          viewModel.estado.value =
                              EstadoDeInspeccion.reparacion;
                          LoadingDialog.show(context);
                          await viewModel.guardarInspeccionEnLocal(
                              estado: EstadoDeInspeccion.reparacion);
                          LoadingDialog.hide(context);
                          showDialog(
                            context: context,
                            builder: (context) => AlertReparacion(),
                          );
                        } else {
                          await guardarYSalir(context);
                        }
                        break;
                      case EstadoDeInspeccion.reparacion:
                        await guardarYSalir(context);
                        break;
                      default:
                    }
                  },
          ),
        ],
      ),
    );
  }

  Future guardarYSalir(BuildContext context) async {
    final viewModel = Provider.of<LlenadoFormViewModel>(context, listen: false);
    viewModel.estado.value = EstadoDeInspeccion.enviada;
    LoadingDialog.show(context);
    await viewModel.guardarInspeccionEnLocal(
      estado: EstadoDeInspeccion.enviada,
    );
    LoadingDialog.hide(context);
    ExtendedNavigator.of(context).pop("Inspeccion finalizada");
  }
}

class ErroresDialog extends StatelessWidget {
  final AbstractControl form;

  const ErroresDialog({Key key, this.form}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Errores: "),
      content: Text(
        /*JsonEncoder.withIndent('  ')
        .convert(json.encode(form.errors)),*/
        form.errors.toString(), //TODO: darle un formato adecuado
      ),
    );
  }
}

class AlertReparacion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Inicio reparacion"),
      content: const Text("Por favor realize las reparaciones necesarias"),
      actions: [
        TextButton(
            onPressed: ExtendedNavigator.of(context).pop,
            child: const Text("ok"))
      ],
    );
  }
}
