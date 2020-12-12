import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/injection.dart';
import 'package:inspecciones/mvvc/common_widgets.dart';
import 'package:inspecciones/mvvc/creacion_cards.dart';
import 'package:inspecciones/mvvc/creacion_form_view_model.dart';
import 'package:inspecciones/mvvc/form_scaffold.dart';
import 'package:inspecciones/presentation/widgets/action_button.dart';
import 'package:inspecciones/presentation/widgets/widgets.dart';
import 'package:moor_db_viewer/moor_db_viewer.dart';
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
                    return MultiSelectDialogField(
                      buttonText:
                          Text('Modelos a los que aplica esta inspección'),
                      items: modelos.map((e) => MultiSelectItem(e, e)).toList(),
                      listType: MultiSelectListType.CHIP,
                      onConfirm: (values) {
                        viewModel.modelosSeleccionados.updateValue(values);
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
            RaisedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MoorDbViewer(getIt<Database>())));
              },
              child: Text("ver BD"),
            ),
            RaisedButton(
              onPressed: getIt<Database>().dbdePrueba,
              child: Text("reiniciar DB"),
            ),
            /*
            RaisedButton(
              onPressed: viewModel.cargarDatos,
              child: Text("recargar creador de cuestionario"),
            ),*/
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
              iconData: Icons.archive,
              label: 'Guardar borrador',
              onPressed: () async {
                LoadingDialog.show(context);
                await viewModel.guardarEnLocal(esBorrador: true);
                LoadingDialog.hide(context);
                ExtendedNavigator.of(context)
                    .pop(); //TODO: mostrar mensaje de exito en la pantalla de destino
              },
            ),
            ActionButton(
              iconData: Icons.send,
              label: 'Finalizar',
              onPressed: viewModel.enviar,
            ),
          ],
        ),
      ),
    );
  }
}
