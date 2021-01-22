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
      create: (context) => ValueNotifier<List<Cuestionario>>([]),
      builder: (context, child) {
        final tiposDeInspeccion =
            Provider.of<ValueNotifier<List<Cuestionario>>>(context);
        return ReactiveFormBuilder(
          form: () {
            final tipoInspeccionCtrl =
                fb.control<Cuestionario>(null, [Validators.required]);
            return fb.group({
              'activo': fb.control<String>('', [Validators.required])
                ..valueChanges.listen((activo) async {
                  final activoParsed = int.parse(activo, onError: (_) => null);
                  if (activoParsed == null) {
                    tiposDeInspeccion.value = [];
                    return;
                  }
                  final res = await getIt<Database>()
                      .llenadoDao
                      .cuestionariosParaActivo(activoParsed);
                  tiposDeInspeccion.value = res;

                  tipoInspeccionCtrl.value = res.isNotEmpty ? res.first : null;
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
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Escriba el ID del vehiculo',
                    prefixIcon: Icon(Icons.directions_car),
                  ),
                ),
                const SizedBox(height: 10),
                ValueListenableBuilder(
                  valueListenable: tiposDeInspeccion,
                  builder: (context, value, child) => ReactiveDropdownField(
                    formControlName: 'tipoDeInspeccion',
                    items: tiposDeInspeccion.value
                        .map((e) => DropdownMenuItem(
                            value: e, child: Text(e.tipoDeInspeccion)))
                        .toList(),
                    decoration: const InputDecoration(
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
                _BotonInicioInspeccion(),
              ],
            );
          },
        );
      },
    );
  }
}

class _BotonInicioInspeccion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final form = ReactiveForm.of(context) as FormGroup;
    return RaisedButton(
      onPressed: form.valid
          ? () => ExtendedNavigator.of(context).pop(
                LlenadoFormPageArguments(
                  activo: int.parse(form.control('activo').value as String),
                  cuestionarioId:
                      form.control('tipoDeInspeccion').value.id as int,
                ),
              )
          : null,
      child: const Text('Inspeccionar'),
    );
  }
}
