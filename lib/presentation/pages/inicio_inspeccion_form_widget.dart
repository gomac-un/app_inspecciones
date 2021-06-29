import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/infrastructure/repositories/inspecciones_repository.dart';
import 'package:inspecciones/injection.dart';
import 'package:inspecciones/router.gr.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class InicioInspeccionForm extends StatelessWidget {
  final InspeccionesRepository repository;
  const InicioInspeccionForm(this.repository);

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
              'nueva': fb.control<bool>(false),
              'pendiente': fb.control<bool>(false),
              'id': fb.control<String>(
                null,
              ),
            });
          },
          builder: (context, form, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ReactiveValueListenableBuilder<bool>(
                  formControlName: 'pendiente',
                  builder: (BuildContext context, AbstractControl<bool> control,
                      Widget child) {
                    if (!control.value) {
                      return ReactiveCheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        formControlName: 'nueva',
                        title: const Text('Llenar una nueva inspección'),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                ReactiveValueListenableBuilder<bool>(
                    formControlName: 'nueva',
                    builder: (context, value, child) {
                      if (value.value) {
                        return Column(children: [
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
                            builder: (context, value, child) =>
                                ReactiveDropdownField(
                              formControlName: 'tipoDeInspeccion',
                              items: tiposDeInspeccion.value
                                  .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e.tipoDeInspeccion)))
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
                        ]);
                      }
                      return ReactiveCheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        formControlName: 'pendiente',
                        title: const Text(
                            'Terminar inspección iniciada por otro usuario'),
                      );
                    }),
                ReactiveValueListenableBuilder<bool>(
                  formControlName: 'pendiente',
                  builder: (BuildContext context, AbstractControl<bool> control,
                      Widget child) {
                    if (control.value) {
                      return Column(
                        children: [
                          ReactiveTextField(
                            formControlName: 'id',
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Escriba el codigo de la inspección',
                              prefixIcon: Icon(Icons.directions_car),
                            ),
                          ),
                          Builder(
                            builder: (context) {
                              return _BotonContinuarInspeccion(repository);
                            },
                          )
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// Este botón es para cuando se va a terminar una inspección que ya se había enviado al servidor
class _BotonContinuarInspeccion extends StatelessWidget {
  final InspeccionesRepository repository;
  const _BotonContinuarInspeccion(this.repository);

  @override
  Widget build(BuildContext context) {
    final form = ReactiveForm.of(context) as FormGroup;
    return RaisedButton(
      onPressed: form.control('id').value != null
          ? () async {
              final res = await repository
                  .getInspeccionServidor(
                      int.parse(form.control('id').value as String))
                  .then((res) => res.fold(
                          (fail) => fail.when(
                              pageNotFound: () =>
                                  'No se pudo encontrar la inspección, asegúrese de escribir el código correctamente',
                              noHayConexionAlServidor: () =>
                                  "No hay conexión al servidor",
                              noHayInternet: () => "No tiene conexión a internet",
                              serverError: (msg) => "Error interno: $msg",
                              credencialesException: () =>
                                  'Error inesperado: intente inciar sesión nuevamente'),
                          (u) async {
                        return "exito";
                      }));
              print(res);
              if (res != 'exito') {
                showDialog(
                  context: context,
                  child: AlertDialog(
                    content: Text(res as String),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Aceptar'),
                      )
                    ],
                  ),
                );
              } else {
                final inspec = await repository.getInspeccionParaTerminar(
                    int.parse(form.control('id').value as String));
                ExtendedNavigator.of(context).pop(
                  LlenadoFormPageArguments(
                      activo: inspec.activoId,
                      cuestionarioId: inspec.cuestionarioId),
                );
              }
            }
          : null,
      child: const Text('Inspeccionar'),
    );
  }
}

class _BotonInicioInspeccion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final form = ReactiveForm.of(context) as FormGroup;
    return RaisedButton(
      onPressed: form.errors.isEmpty
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
