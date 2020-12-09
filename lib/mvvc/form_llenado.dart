import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:inspecciones/mvvc/form_llenado_view_model.dart';
import 'package:inspecciones/mvvc/cards.dart';
import 'package:inspecciones/mvvc/form_scaffold.dart';

class FormLlenado extends StatelessWidget implements AutoRouteWrapper {
  final String vehiculo;
  final int cuestionarioId;

  const FormLlenado({Key key, this.vehiculo, this.cuestionarioId})
      : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) => Provider(
        create: (ctx) => FormLlenadoViewModel(vehiculo, cuestionarioId),
        child: this,
        dispose: (context, FormLlenadoViewModel value) => value.form.dispose(),
      );

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<FormLlenadoViewModel>(context, listen: false);

    return FormScaffold(
      title: Text('Llenado de inspeccion'),
      body: ReactiveForm(
        formGroup: viewModel.form,
        child: Column(
          children: [
            ListView.builder(
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
            ),
            RaisedButton(
              child: Text('print form'),
              onPressed: () => print(viewModel.form.value),
            ),
          ],
        ),
      ),
    );
  }
}
