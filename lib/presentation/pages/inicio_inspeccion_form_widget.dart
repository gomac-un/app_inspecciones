import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/injection.dart';
import 'package:inspecciones/router.gr.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class InicioInspeccionForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ValueNotifier<List<CuestionarioDeModelo>>([]),
      builder: (context, child) {
        final tiposDeInspeccion =
            Provider.of<ValueNotifier<List<CuestionarioDeModelo>>>(context);
        return ReactiveFormBuilder(
          form: () {
            final tipoInspeccionCtrl =
                fb.control<CuestionarioDeModelo>(null, [Validators.required]);
            return fb.group({
              'activo': fb.control<String>('', [Validators.required])
                ..valueChanges.listen((activo) async {
                  final res = await getIt<Database>()
                      .llenadoDao
                      .cuestionariosParaVehiculo(activo);
                  tiposDeInspeccion.value = res;

                  tipoInspeccionCtrl.value = res.length > 0 ? res.first : null;
                }),
              'tipoDeInspeccion': tipoInspeccionCtrl,
            });
          },
          builder: (context, form, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ReactiveTextField(
                  formControlName: 'activo',
                  decoration: InputDecoration(
                    labelText: 'Escriba el ID del vehiculo',
                    prefixIcon: Icon(Icons.directions_car),
                  ),
                ),
                SizedBox(height: 10),
                ValueListenableBuilder(
                  valueListenable: tiposDeInspeccion,
                  builder: (context, value, child) => ReactiveDropdownField(
                    formControlName: 'tipoDeInspeccion',
                    items: tiposDeInspeccion.value
                        .map((e) => DropdownMenuItem(
                            value: e, child: Text(e.tipoDeInspeccion)))
                        .toList(),
                    decoration: InputDecoration(
                      labelText: 'Seleccione una opción',
                    ),
                  ),
                  /*
                      //TODO: mejorar la usabilidad usando este tipo de dropdown con busqueda
                      ReactiveDropdownSearch<CuestionarioDeModelo>(
                    formControlName: 'tipoDeInspeccion',
                    items: tiposDeInspeccion.value,
                    itemAsString: (e) => e.tipoDeInspeccion,
                    label: "Tipo de inspección",
                    hint: "Seleccione el tipo de inspección",
                  ),*/
                ),
                _MySubmitButton(),
              ],
            );
          },
        );
      },
    );
  }
}

class _MySubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final form = ReactiveForm.of(context) as FormGroup;
    return RaisedButton(
      child: Text('Inspeccionar'),
      onPressed: form.valid
          ? () => _onPressed(
                context,
                form.control('activo').value,
                form.control('tipoDeInspeccion').value.cuestionarioId,
              )
          : null,
    );
  }

  void _onPressed(BuildContext context, String activo, int cuestionarioId) {
    ExtendedNavigator.of(context).pop(
      LlenadoFormPageArguments(
        vehiculo: activo,
        cuestionarioId: cuestionarioId,
      ),
    );
  }
}
