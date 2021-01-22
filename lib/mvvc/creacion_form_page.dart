import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
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
  const CreacionFormPage({Key key}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) => Provider(
        create: (ctx) => CreacionFormViewModel()..cargarDatos(),
        dispose: (context, CreacionFormViewModel value) => value.dispose(),
        child: this,
      );

  @override
  Widget build(BuildContext context) {
    final formGroup =
        Provider.of<CreacionFormViewModel>(context, listen: false);

    return ReactiveForm(
      formGroup: formGroup,
      child: FormScaffold(
        title: const Text('Creación de inspeccion'),
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
              titulo: 'Modelos de vehiculo',
              child: ValueListenableBuilder<List<String>>(
                  valueListenable: formGroup.modelos,
                  builder: (context, modelos, child) {
                    return ReactiveMultiSelectDialogField(
                        formControlName: 'modelos',
                        items:
                            modelos.map((e) => MultiSelectItem(e, e)).toList(),
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
              titulo: 'periodicidad',
              descripcion: '(en dias)',
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
              initialItemCount:
                  (formGroup.control("bloques") as FormArray).controls.length,
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
        floatingActionButton: const BotonFinalizar(),
      ),
    );
  }
}

class BotonFinalizar extends StatelessWidget {
  const BotonFinalizar({
    Key key,
  }) : super(key: key);

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
            label: 'Finalizar',
            onPressed: !form.valid
                ? () {
                    form.markAllAsTouched();
                    /* Scaffold.of(context).showSnackBar(SnackBar(
                        content: Row(
                      children: [
                        const Text("La inspeccion tiene errores"),
                        FlatButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                    title: const Text("Errores: "),
                                    content: Text(
                                      /*JsonEncoder.withIndent('  ')
                                        .convert(json.encode(form.errors)),*/
                                      form.errors.toString(),
                                    )),
                              );
                            },
                            child: const Text("ver errores"))
                      ],
                    ))); */
                    mostrarErrores(context, form);
                  }
                : () async {
                    LoadingDialog.show(context);
                    await (form as CreacionFormViewModel).enviar();
                    LoadingDialog.hide(context);
                    /* ExtendedNavigator.of(context)
                        .pop("Cuestionario creado exitosamente"); */
                        mostrarMensaje(context,'exito', 'Cuestionario creado exitosamente');
                        
                  },
          ),
        ],
      ),
    );
  }
}
