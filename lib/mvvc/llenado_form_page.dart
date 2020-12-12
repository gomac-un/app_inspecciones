import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/injection.dart';
import 'package:inspecciones/mvvc/llenado_controls.dart';
import 'package:kt_dart/kt.dart';
import 'package:moor_db_viewer/moor_db_viewer.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'package:inspecciones/presentation/widgets/action_button.dart';
import 'package:inspecciones/presentation/widgets/widgets.dart';

import 'package:inspecciones/mvvc/llenado_form_view_model.dart';
import 'package:inspecciones/mvvc/llenado_cards.dart';
import 'package:inspecciones/mvvc/form_scaffold.dart';

class LlenadoFormPage extends StatelessWidget implements AutoRouteWrapper {
  final String vehiculo;
  final int cuestionarioId;

  const LlenadoFormPage({
    Key key,
    this.vehiculo,
    this.cuestionarioId,
  }) //! eliminar valores por defecto y tirar error si son nulos
  : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) => Provider(
        create: (ctx) => LlenadoFormViewModel(
            '1', 1), //LlenadoFormViewModel(vehiculo, cuestionarioId),
        child: this,
        dispose: (context, LlenadoFormViewModel value) => value.form.dispose(),
      );

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LlenadoFormViewModel>(context, listen: false);

    return FormScaffold(
      title: Text('Llenado de inspeccion'),
      body: ReactiveForm(
        formGroup: viewModel.form,
        child: Column(
          children: [
            ValueListenableBuilder<bool>(
                valueListenable: viewModel.cargada,
                builder: (context, cargada, child) {
                  if (!cargada) return CircularProgressIndicator();
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: viewModel.bloques.controls.length,
                    itemBuilder: (context, i) {
                      final element = viewModel.bloques.controls[i];
                      if (element is TituloFormGroup) {
                        return TituloCard(formGroup: element);
                      }
                      if (element is RespuestaSeleccionSimpleFormGroup) {
                        return SeleccionSimpleCard(formGroup: element);
                      }
                      if (element is RespuestaCuadriculaFormArray) {
                        return CuadriculaCard(formArray: element);
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
            RaisedButton(
              onPressed: getIt<Database>().dbdePrueba,
              child: Text("reiniciar DB"),
            ),
            RaisedButton(
              onPressed: () {
                final kt = listOf();
                final kt1 = listOf("a");
                print(kt.map((e) => "o").toString());
              },
              child: Text("run test"),
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
