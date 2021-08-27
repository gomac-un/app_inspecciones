import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/infrastructure/repositories/inspecciones_repository.dart';
import 'package:inspecciones/injection.dart';

import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

///  Control encargado de manejar las preguntas de tipo selección
@injectable
class InicioInspeccionController {
  final InspeccionesRepository repository;
  final tiposDeInspeccionDisponibles = ValueNotifier<List<Cuestionario>>([]);

  late final activoControl =
      fb.control<String>('', [Validators.required, Validators.number])
        ..valueChanges.listen((activo) async {
          final activoParsed = int.tryParse(activo!);
          if (activoParsed == null) {
            tiposDeInspeccionDisponibles.value = [];
            return;
          }
          final res = await repository.cuestionariosParaActivo(activoParsed);
          tiposDeInspeccionDisponibles.value = res;

          tipoInspeccionControl.value = res.isNotEmpty ? res.first : null;
        });
  final tipoInspeccionControl =
      fb.control<Cuestionario?>(null, [Validators.required]);
  final codigoInspeccionControl = fb.control<String>('');
  final pendienteControl = fb.control<bool>(false);

  late final control = fb.group({
    /// A medida que se escribe un activo diferente, se va consultando
    /// que tipos de inspeccion le aplican.
    'activo': activoControl,
    'tipoDeInspeccion': tipoInspeccionControl,
    'codigoInsp': codigoInspeccionControl,
    'pendiente': pendienteControl,
  });

  InicioInspeccionController(this.repository);
}

/// Alerta que salta cuando se presiona el boton de iniciar inspeccion
class InicioInspeccionForm extends StatelessWidget {
  const InicioInspeccionForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => getIt<InicioInspeccionController>(),
      builder: (context, __) {
        final controller = context.watch<InicioInspeccionController>();
        return ReactiveForm(
          formGroup: controller.control,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Crea una nueva inpección
              ReactiveRadioListTile(
                value: false,
                formControl: controller.pendienteControl,
                title: const Text('Llenar una nueva inspección'),
              ),

              /// Activa TextField para que ponga el codigo de la inspeccion desde el server.
              ReactiveRadioListTile(
                value: true,
                formControl: controller.pendienteControl,
                title:
                    const Text('Terminar inspección iniciada por otro usuario'),
              ),
              ReactiveValueListenableBuilder<bool>(
                formControl: controller.pendienteControl,
                builder: (context, control, child) {
                  if (!control.value!) {
                    return Column(children: [
                      const SizedBox(height: 10),
                      ReactiveTextField(
                        formControl: controller.activoControl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Escriba el ID del vehiculo',
                          prefixIcon: Icon(Icons.directions_car),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ValueListenableBuilder<List<Cuestionario>>(
                        valueListenable:
                            controller.tiposDeInspeccionDisponibles,
                        builder: (context, value, child) =>
                            ReactiveDropdownField(
                          formControl: controller.tipoInspeccionControl,
                          items: value
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
                formControl: controller.pendienteControl,
                builder: (context, control, child) {
                  if (control.value!) {
                    return Column(
                      children: [
                        const SizedBox(height: 10),
                        ReactiveTextField(
                          formControl: controller.codigoInspeccionControl,
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
                formControl: controller.pendienteControl,
                builder: (context, control, child) {
                  if (control.value!) {
                    return _BotonContinuarInspeccion(controller.repository);
                  }
                  return _BotonInicioInspeccion();
                },
              ),
            ],
          ),
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
    final controller = context.watch<InicioInspeccionController>();
    final codigoInspeccion = controller.codigoInspeccionControl.value;
    return ElevatedButton(
      onPressed: codigoInspeccion != null && codigoInspeccion.isNotEmpty
          ? () async {
              /// Se descarga inspección con id=[form.control('id').value ] desde el server

              final res = await repository
                  .getInspeccionServidor(int.parse(codigoInspeccion));
              final txtres = res.fold(
                  (fail) => fail.when(
                      pageNotFound: () =>
                          'No se pudo encontrar la inspección, asegúrese de escribir el código correctamente',
                      noHayConexionAlServidor: () =>
                          "No hay conexión al servidor",
                      noHayInternet: () => "Verifique su conexión a internet",
                      serverError: (msg) => "Error interno: $msg",
                      credencialesException: () =>
                          'Error inesperado: intente inciar sesión nuevamente'),
                  (u) {
                return "exito";
              });

              /// Si hay un error muestra alerta.
              if (txtres != 'exito') {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Text(txtres),
                    actions: [
                      TextButton(
                        onPressed: Navigator.of(context).pop,
                        child: const Text('Aceptar'),
                      )
                    ],
                  ),
                );
              } else {
                /// En caso de exito, se debe hacer esta consulta para obtener la insp
                /// que se descargo desde la bd
                final inspeccion = await repository
                    .getInspeccionParaTerminar(int.parse(codigoInspeccion));

                /// Se abre la pantalla de llenado de inspección normal

                Navigator.of(context).pop(ArgumentosLlenado(
                  activo: inspeccion
                      .activoId, // por validatos se debe tener esto como numerico y no nulo
                  cuestionarioId: inspeccion.cuestionarioId,
                ));
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
    final controller = context.watch<InicioInspeccionController>();
    return ElevatedButton(
      onPressed: controller.control.errors.isEmpty
          ? () => Navigator.of(context).pop(
                //TODO: mirar si podemos hacer push en vez de pop
                ArgumentosLlenado(
                  activo: int.parse(controller.activoControl
                      .value!), // por validatos se debe tener esto como numerico y no nulo
                  cuestionarioId: controller.tipoInspeccionControl.value!.id,
                ),
              )
          : null,
      child: const Text('Inspeccionar'),
    );
  }
}

@immutable
class ArgumentosLlenado {
  final int activo;
  final int cuestionarioId;

  const ArgumentosLlenado({required this.activo, required this.cuestionarioId});
}
