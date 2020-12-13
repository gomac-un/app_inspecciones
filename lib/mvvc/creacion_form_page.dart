import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/mvvc/common_widgets.dart';
import 'package:inspecciones/mvvc/creacion_cards.dart';
import 'package:inspecciones/mvvc/creacion_form_view_model.dart';
import 'package:inspecciones/mvvc/form_scaffold.dart';
import 'package:inspecciones/presentation/widgets/action_button.dart';
import 'package:inspecciones/presentation/widgets/widgets.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CreacionFormPage extends StatelessWidget implements AutoRouteWrapper {
  const CreacionFormPage({Key key}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) => Provider(
        create: (ctx) => CreacionFormViewModel(),
        child: this,
        dispose: (context, CreacionFormViewModel value) => value.dispose(),
      );

  @override
  Widget build(BuildContext context) {
    final viewModel =
        Provider.of<CreacionFormViewModel>(context, listen: false);

    return FormScaffold(
      title: Text('Creación de inspeccion'),
      body: ReactiveForm(
        formGroup: viewModel.form,
        child: Column(
          children: [
            PreguntaCard(
              titulo: 'Tipo de inspección',
              child: Column(
                children: [
                  ValueListenableBuilder<List<String>>(
                    valueListenable: viewModel.tiposDeInspeccion,
                    builder: (context, value, child) {
                      return ReactiveDropdownField<String>(
                        formControl: viewModel.tipoDeInspeccion,
                        items: value
                            .map((e) => DropdownMenuItem<String>(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        decoration: InputDecoration(
                          labelText: 'Seleccione el tipo de inspeccion',
                        ),
                        validationMessages: (control) => {
                          'yaExiste':
                              'Uno de los activos ya tiene asociada una inspeccion de este tipo', //TODO: decir cual
                        },
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  ReactiveValueListenableBuilder<String>(
                      formControl: viewModel.tipoDeInspeccion,
                      builder: (context, value, child) {
                        if (value.value == "otra")
                          return ReactiveTextField(
                            formControl: viewModel.nuevoTipoDeinspeccion,
                            decoration: InputDecoration(
                              labelText: 'Escriba el tipo de inspeccion',
                              prefixIcon: Icon(Icons.text_fields),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                            ),
                          );
                        return SizedBox.shrink();
                      }),
                ],
              ),
            ),
            PreguntaCard(
              titulo: 'Modelos de vehiculo',
              child: ValueListenableBuilder<List<String>>(
                  valueListenable: viewModel.modelos,
                  builder: (context, modelos, child) {
                    //Implementar de mejor manera el multiselect para que funcione
                    //con los validators de reactive Forms https://github.com/joanpablo/reactive_forms/issues/64
                    return MultiSelectDialogField(
                      buttonText:
                          Text('Modelos a los que aplica esta inspección'),
                      items: modelos.map((e) => MultiSelectItem(e, e)).toList(),
                      listType: MultiSelectListType.CHIP,
                      onConfirm: (values) {
                        viewModel.modelosSeleccionados.updateValue(values);
                        viewModel.modelosSeleccionados.markAsTouched();
                      },
                      chipDisplay: MultiSelectChipDisplay(
                        items:
                            modelos.map((e) => MultiSelectItem(e, e)).toList(),
                        onTap: (value) {
                          //TODO: opcion de quitar opciones desde el chipDisplay
                          //viewModel.modelosSeleccionados.updateValue(viewModel.modelosSeleccionados.value..remove(value));
                          /*viewModel.modelosSeleccionados.value = viewModel
                              .modelosSeleccionados.value
                              .where((e) => e != value)
                              .toList();*/
                          //viewModel.modelosSeleccionados.remove(control);
                        },
                      ),
                    );
                  }),
            ),
            PreguntaCard(
              titulo: 'Contratista',
              child: ValueListenableBuilder<List<Contratista>>(
                valueListenable: viewModel.contratistas,
                builder: (context, value, child) {
                  return ReactiveDropdownField(
                    formControl: viewModel.contratista,
                    items: value
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.nombre),
                            ))
                        .toList(),
                    decoration: InputDecoration(
                      labelText: 'Seleccione un contratista',
                    ),
                  );
                },
              ),
            ),
            PreguntaCard(
              titulo: 'periodicidad',
              descripcion: '(en dias)',
              child: ReactiveSlider(
                formControl: viewModel.periodicidad,
                max: 100.0,
                divisions: 100,
                labelBuilder: (v) => v.round().toString(),
              ),
            ),
            AnimatedList(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              initialItemCount: viewModel.bloques.controls.length,
              itemBuilder: (context, index, animation) {
                return ControlWidgetAnimado(
                  element: viewModel.bloques.controls[index],
                  index: index,
                  animation: animation,
                );
              },
            ),
            SizedBox(height: 60),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ActionButton(
              iconData: Icons.send,
              label: 'Finalizar',
              onPressed: !viewModel.form.valid
                  ? viewModel.form.markAllAsTouched
                  : () async {
                      viewModel.form.markAllAsTouched();
                      LoadingDialog.show(context);
                      await viewModel.enviar();
                      LoadingDialog.hide(context);
                      ExtendedNavigator.of(context)
                          .pop(); //TODO: mostrar mensaje de exito en la pantalla de destino
                    },
            ),
          ],
        ),
      ),
    );
  }
}
