import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/injection.dart';
import 'package:inspecciones/mvvc/common_widgets.dart';
import 'package:inspecciones/mvvc/creacion_cards.dart';
import 'package:inspecciones/mvvc/creacion_controls.dart';
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
                        if (value.value == "otro")
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
            ReactiveValueListenableBuilder(
                formControl: viewModel.bloques,
                builder: (context, control, child) {
                  if (viewModel.bloques.controls.length == 0)
                    return BotonesDeBloque();
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: viewModel.bloques.controls.length,
                    itemBuilder: (context, i) {
                      final element = viewModel.bloques.controls[i];
                      //Las keys sirven para que flutter maneje correctamente los widgets de la lista
                      if (element is CreadorTituloFormGroup) {
                        return CreadorTituloCard(
                            key: ValueKey(element), formGroup: element, nro: i);
                      }
                      if (element is CreadorPreguntaSeleccionSimpleFormGroup) {
                        return CreadorSeleccionSimpleCard(
                            key: ValueKey(element), formGroup: element);
                      }
                      if (element is CreadorPreguntaCuadriculaFormGroup) {
                        return CreadorCuadriculaCard(
                            key: ValueKey(element), formGroup: element);
                      }
                      return Text(
                          "error: el bloque $i no tiene una card que lo renderice");
                    },
                  );
                }),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MoorDbViewer(getIt<Database>())));
              },
              child: Text("ver BD"),
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
