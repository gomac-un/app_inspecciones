import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/infrastructure/repositories/inspecciones_repository.dart';
import 'package:inspecciones/injection.dart';
import 'package:inspecciones/router.gr.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Alerta que salta cuando se presiona el boton de iniciar inspeccion
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
              /// A medida que se escribe un activo diferente, se va consultando
              /// que tipos de inspeccion le aplican.
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
              'codigoInsp': fb.control<String>(null),
              'tipoDeInspeccion': tipoInspeccionCtrl,
              'pendiente': fb.control<bool>(false),
            });
          },
          builder: (context, form, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Crea una nueva inpección
                ReactiveRadioListTile(
                  value: false,
                  formControlName: 'pendiente',
                  title: const Text('Llenar una nueva inspección'),
                ),

                /// Activa TextField para que ponga el codigo de la inspeccion desde el server.
                ReactiveRadioListTile(
                  value: true,
                  formControlName: 'pendiente',
                  title: const Text(
                      'Terminar inspección iniciada por otro usuario'),
                ),
                ReactiveValueListenableBuilder<bool>(
                  formControlName: 'pendiente',
                  builder: (context, control, child) {
                    if (!control.value) {
                      return Column(children: [
                        const SizedBox(height: 10),
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
                      ]);
                    }
                    return const SizedBox.shrink();
                  },
                ),
                ReactiveValueListenableBuilder<bool>(
                  formControlName: 'pendiente',
                  builder: (context, control, child) {
                    if (control.value) {
                      return Column(
                        children: [
                          const SizedBox(height: 10),
                          ReactiveTextField(
                            formControlName: 'codigoInsp',
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Código de la inspección',
                              prefixIcon: Icon(Icons.directions_car),
                            ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                ReactiveValueListenableBuilder<bool>(
                  formControlName: 'pendiente',
                  builder: (context, control, child) {
                    if (control.value) {
                      return _BotonContinuarInspeccion(repository);
                    }
                    return _BotonInicioInspeccion();
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
      color: Theme.of(context).accentColor,
      onPressed: form.control('codigoInsp').value != null &&
              (form.control('codigoInsp').value as String).isNotEmpty
          ? () async {
              /// Se descarga inspección con id=[form.control('id').value ] desde el server
              int activoId;
              int cuestionarioId;
              final res = await repository
                  .getInspeccionServidor(
                      int.parse(form.control('codigoInsp').value as String))
                  .then((res) => res.fold(
                          (fail) => fail.when(
                              pageNotFound: () =>
                                  'No se pudo encontrar la inspección, asegúrese de escribir el código correctamente',
                              noHayConexionAlServidor: () =>
                                  "No hay conexión al servidor",
                              noHayInternet: () =>
                                  "Verifique su conexión a internet",
                              serverError: (msg) => "Error interno: $msg",
                              credencialesException: () =>
                                  'Error inesperado: intente inciar sesión nuevamente'),
                          (dic) async {
                        activoId = dic['activo'] as int;
                        cuestionarioId = dic['cuestionario'] as int;
                        await repository.marcarInspeccionParaTerminar(int.parse(
                            form.control('codigoInsp').value as String));
                        return "exito";
                      }));

              /// Si hay un error muestra alerta.
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
                /// En caso de exito, se debe hacer esta consulta para obtener la insp
                /// que se descargo desde la bd

                /// Se abre la pantalla de llenado de inspección normal
                ExtendedNavigator.of(context).pop(
                  LlenadoFormPageArguments(
                      activo: activoId, cuestionarioId: cuestionarioId),
                );
              }
            }
          : null,
      child: const Text('Inspeccionar'),
    );
  }
}

/// Este botón es para iniciar una inspección desde 0
class _BotonInicioInspeccion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final form = ReactiveForm.of(context) as FormGroup;
    return RaisedButton(
      color: Theme.of(context).accentColor,
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
