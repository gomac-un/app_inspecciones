import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/mvvc/common_widgets.dart';
import 'package:inspecciones/mvvc/creacion_cards.dart';
import 'package:inspecciones/mvvc/creacion_form_view_model.dart';
import 'package:inspecciones/mvvc/form_scaffold.dart';
import 'package:inspecciones/mvvc/reactive_multiselect_dialog_field.dart';
import 'package:inspecciones/presentation/widgets/action_button.dart';
import 'package:inspecciones/presentation/widgets/alertas.dart';
import 'package:inspecciones/presentation/widgets/loading_dialog.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CreacionFormPage extends StatelessWidget implements AutoRouteWrapper {
  final Cuestionario cuestionario;
  final CuestionarioConContratista cuestionarioDeModelo;
  final List<IBloqueOrdenable> bloques;
  const CreacionFormPage(
      {Key key, this.cuestionario, this.cuestionarioDeModelo, this.bloques})
      : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) => Provider(
        create: (ctx) => CreacionFormViewModel(
            cuestionario, cuestionarioDeModelo,
            bloquesBD: bloques),
        dispose: (context, CreacionFormViewModel value) => value.dispose(),
        child: this,
      );

  @override
  Widget build(BuildContext context) {
    final formGroup =
        Provider.of<CreacionFormViewModel>(context, listen: false);

    return ReactiveForm(
      formGroup: formGroup,
      child: ValueListenableBuilder<EstadoDeCuestionario>(
        valueListenable: formGroup.estado,
        builder: (context, estado, child) {
          return FormScaffold(
            title: Text(estado == EstadoDeCuestionario.borrador
                ? 'Creación de cuestionario'
                : 'Visualización cuestionario'),
            // ignore: prefer_const_literals_to_create_immutables
            actions: [
              /* if (estado == EstadoDeCuestionario.borrador) */
              BotonGuardarBorrador(
                estado: estado,
              ),
            ],
            body: Column(
              children: [
                PreguntaCard(
                  titulo: 'Tipo de inspección',
                  child: Column(
                    children: [
                      ValueListenableBuilder<List<String>>(
                        valueListenable: formGroup.tiposDeInspeccion,
                        builder: (context, value, child) {
                          return ReactiveDropdownField<String>(
                            formControlName: "tipoDeInspeccion",
                            validationMessages: (control) =>
                                {'required': 'Este valor es requerido'},
                            items: value
                                .map((e) => DropdownMenuItem<String>(
                                      value: e,
                                      child: Text(e),
                                    ))
                                .toList(),
                            decoration: const InputDecoration(
                              labelText: 'Seleccione el tipo de inspeccion',
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      ReactiveValueListenableBuilder<String>(
                          formControlName: "tipoDeInspeccion",
                          builder: (context, value, child) {
                            if (value.value == "otra") {
                              return ReactiveTextField(
                                formControlName: "nuevoTipoDeInspeccion",
                                validationMessages: (control) =>
                                    {'required': 'Este valor es requerido'},
                                decoration: const InputDecoration(
                                  labelText: 'Escriba el tipo de inspeccion',
                                  prefixIcon: Icon(Icons.text_fields),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          }),
                    ],
                  ),
                ),
                PreguntaCard(
                  titulo: 'Modelos de vehículo',
                  child: ValueListenableBuilder<List<String>>(
                      valueListenable: formGroup.modelos,
                      builder: (context, modelos, child) {
                        return ReactiveMultiSelectDialogField(
                            formControlName: 'modelos',
                            items: modelos
                                .map((e) => MultiSelectItem(e, e))
                                .toList(),
                            buttonText: const Text(
                                'Modelos a los que aplica esta inspección'),
                            validationMessages: (control) => {
                                  ValidationMessage.minLength:
                                      'Seleccione al menos un modelo',
                                  'yaExiste':
                                      'El modelo ${control.getError('yaExiste')} ya tiene asociado un cuestionario de este tipo',
                                });
                      }),
                ),
                PreguntaCard(
                  titulo: 'Contratista',
                  child: ValueListenableBuilder<List<Contratista>>(
                    valueListenable: formGroup.contratistas,
                    builder: (context, value, child) {
                      return ReactiveDropdownField(
                        formControlName: 'contratista',
                        validationMessages: (control) =>
                            {'required': 'Seleccione un contratista'},
                        items: value
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.nombre),
                                ))
                            .toList(),
                        decoration: const InputDecoration(
                          labelText: 'Seleccione un contratista',
                        ),
                        onTap: () {
                          FocusScope.of(context)
                              .unfocus(); // para que no salte el teclado si tenia un textfield seleccionado
                        },
                      );
                    },
                  ),
                ),
                PreguntaCard(
                  titulo: 'Periodicidad',
                  descripcion: '(en días)',
                  child: ReactiveSlider(
                    formControlName: 'periodicidad',
                    max: 100.0,
                    divisions: 100,
                    labelBuilder: (v) => v.round().toString(),
                  ),
                ),
                AnimatedList(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  initialItemCount: (formGroup.control("bloques") as FormArray)
                      .controls
                      .length,
                  itemBuilder: (context, index, animation) {
                    return ControlWidgetAnimado(
                      element: (formGroup.control("bloques") as FormArray)
                          .controls[index],
                      index: index,
                      animation: animation,
                    );
                  },
                ),
                const SizedBox(height: 60),
              ],
            ),
            floatingActionButton: BotonFinalizar(
              estado: estado,
            ),
          );
        },
      ),
    );
  }
}

class BotonGuardarBorrador extends StatelessWidget {
  const BotonGuardarBorrador({
    Key key,
    @required this.estado,
  }) : super(key: key);
  final EstadoDeCuestionario estado;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CreacionFormViewModel>(context);
    final form = ReactiveForm.of(context);
    return IconButton(
      icon: const Icon(Icons.archive),
      //label: 'Guardar borrador',
      onPressed: () async {
        if ((viewModel.control('modelos') as FormControl<List<String>>)
                .value
                .isEmpty ||
            (viewModel.control('tipoDeInspeccion') as FormControl<String>)
                .value
                .isEmpty) {
          Scaffold.of(context).showSnackBar(const SnackBar(
              content: Text(
                  "Seleccione el tipo de inspección o elija por lo menos un modelo antes de guardar el cuestionario")));
        } else if (!form.valid) {
          form.markAllAsTouched();
          mostrarErrores(context, form);
        } else {
          /* LoadingDialog.show(context); */
          await viewModel.guardarCuestionarioEnLocal(estado);
          /* LoadingDialog.hide(context); */
          Scaffold.of(context)
              .showSnackBar(const SnackBar(content: Text("Guardado exitoso")));
        }
      },
    );
  }
}

class BotonFinalizar extends StatelessWidget {
  const BotonFinalizar({
    Key key,
    @required this.estado,
  }) : super(key: key);
  final EstadoDeCuestionario estado;

  @override
  Widget build(BuildContext context) {
    final form = ReactiveForm.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ActionButton(
            iconData: Icons.done_all_outlined,
            label: estado == EstadoDeCuestionario.borrador
                ? 'Finalizar'
                : 'Aceptar',
            onPressed: !form.valid
                ? () {
                    if (estado == EstadoDeCuestionario.borrador) {
                      form.markAllAsTouched();

                      mostrarErrores(context, form);
                    } else {
                      Navigator.of(context).pop();
                    }
                  }
                : () {
                    finalizarCuestionario(context);
                  },
          ),
        ],
      ),
    );
  }

  void finalizarCuestionario(BuildContext context) {
    final viewModel =
        Provider.of<CreacionFormViewModel>(context, listen: false);
    // set up the buttons
    final cancelButton = FlatButton(
      onPressed: () => Navigator.of(context).pop(),
      child: const Text("Cancelar"), // OJO con el context
    );
    final Widget continueButton = FlatButton(
      onPressed: () async {
        Navigator.of(context).pop();

        if (estado == EstadoDeCuestionario.borrador) {
          LoadingDialog.show(context);
          await viewModel
              .guardarCuestionarioEnLocal(EstadoDeCuestionario.finalizada);
          LoadingDialog.hide(context);
          mostrarMensaje(context, 'exito', 'Cuestionario creado exitosamente');
        } else {
          ExtendedNavigator.of(context).pop();
        }
      },
      child: const Text("Aceptar"),
    );
    // set up the AlertDialog
    final alert = AlertDialog(
      title: const Text("Alerta"),
      content: const Text(
          "¿Está seguro que desea finalizar este cuestionario? Si lo hace, no podrá editarlo después"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    if (estado == EstadoDeCuestionario.borrador) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    } else {
      Navigator.of(context).pop();
    }
  }
}
