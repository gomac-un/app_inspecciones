import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/cuestionario.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/identificador_inspeccion.dart';
import 'package:inspecciones/features/llenado_inspecciones/infrastructure/inspecciones_repository.dart';
import 'package:reactive_forms/reactive_forms.dart';

class InicioInspeccionController {
  final InspeccionesRepository repository;
  final tiposDeInspeccionDisponibles = ValueNotifier<List<Cuestionario>>([]);

  late final activoControl =
      fb.control<String>('', [Validators.required, Validators.number])
        ..valueChanges.listen((activo) async {
          /// A medida que se escribe un activo diferente, se va consultando
          /// que tipos de inspeccion le aplican.

          if (activo == null) {
            tiposDeInspeccionDisponibles.value = [];
            return;
          }
          final res = await repository.cuestionariosParaActivo(activo);
          res.fold((f) {
            developer.log(f.toString()); // TODO: como mostrar un error aqui?
            tiposDeInspeccionDisponibles.value = [];
            tipoInspeccionControl.value = null; // se necesita?
          }, (l) {
            tiposDeInspeccionDisponibles.value = l;

            tipoInspeccionControl.value = l.isNotEmpty ? l.first : null;
          });
        });
  final tipoInspeccionControl =
      fb.control<Cuestionario?>(null, [Validators.required]);

  final codigoInspeccionControl = fb.control<String>('', [Validators.required]);

  late final FormGroup controlLocal = fb.group({
    'activo': activoControl,
  })
    ..addAll({
      'tipoDeInspeccion': tipoInspeccionControl
    }); //TODO: reportar el bug de reactive_forms

  late final controlPendiente = fb.group({
    'codigoInsp': codigoInspeccionControl,
  });

  InicioInspeccionController(this.repository);

  Future<void> buscarYDescargarInspeccionRemota({
    Function(ApiFailure f)? onError,
    Function(IdentificadorDeInspeccion f)? onSuccess,
  }) async {
    final inspeccionId = int.parse(codigoInspeccionControl.value!);
    final res = await repository.cargarInspeccionRemota(inspeccionId);

    res.fold(
      (f) => onError?.call(f),
      (c) async {
        onSuccess?.call(c);
      },
    );
  }

  IdentificadorDeInspeccion getArgumentosParaLocal() =>
      IdentificadorDeInspeccion(
        activo: activoControl.value!,
        cuestionarioId: tipoInspeccionControl.value!.id,
      );
}

final inicioDeInspeccionProvider = Provider((ref) =>
    InicioInspeccionController(ref.watch(inspeccionesRepositoryProvider)));

enum TipoDeCarga {
  local,
  remota,
}
final tipoDeCargaProvider = StateProvider((ref) => TipoDeCarga.local);

/// Alerta que salta cuando se presiona el boton de iniciar inspeccion
class InicioInspeccionForm extends ConsumerWidget {
  const InicioInspeccionForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final tipoDeCarga = ref.watch(tipoDeCargaProvider).state;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// Crea una nueva inpección
        RadioListTile<TipoDeCarga>(
          value: TipoDeCarga.local,
          groupValue: tipoDeCarga,
          title: const Text('Llenar una nueva inspección'),
          onChanged: (v) {
            ref.read(tipoDeCargaProvider).state = v!;
          },
        ),

        /// Activa TextField para que ponga el codigo de la inspeccion desde el server.
        RadioListTile<TipoDeCarga>(
          value: TipoDeCarga.remota,
          groupValue: tipoDeCarga,
          title: const Text('Terminar inspección iniciada por otro usuario'),
          onChanged: (v) {
            ref.read(tipoDeCargaProvider).state = v!;
          },
        ),
        _buildForm(tipoDeCarga),
      ],
    );
  }

  Widget _buildForm(TipoDeCarga tipoDeCarga) {
    switch (tipoDeCarga) {
      case TipoDeCarga.local:
        return const CargaLocalForm();
      case TipoDeCarga.remota:
        return const CargarRemotaForm();
    }
  }
}

class CargaLocalForm extends ConsumerWidget {
  const CargaLocalForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final controller = ref.watch(inicioDeInspeccionProvider);
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
        valueListenable: controller.tiposDeInspeccionDisponibles,
        builder: (context, value, child) => ReactiveDropdownField(
          formControl: controller.tipoInspeccionControl,
          items: value
              .map((e) =>
                  DropdownMenuItem(value: e, child: Text(e.tipoDeInspeccion)))
              .toList(),
          decoration: const InputDecoration(
            labelText: 'Seleccione el tipo de inspección',
          ),
        ), //TODO: mejorar la usabilidad usando un widget que permita buscar
      ),
      ReactiveValueListenableBuilder(
        formControl: controller.controlLocal,
        builder: (context, _, __) => ElevatedButton(
          onPressed: controller.controlLocal.valid
              ? () => Navigator.of(context).pop(
                    controller.getArgumentosParaLocal(),
                  )
              : null,
          child: const Text('Inspeccionar'),
        ),
      ),
    ]);
  }
}

class CargarRemotaForm extends ConsumerWidget {
  const CargarRemotaForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final controller = ref.watch(inicioDeInspeccionProvider);
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
        ReactiveValueListenableBuilder(
          formControl: controller.controlPendiente,
          builder: (context, _, __) => ElevatedButton(
            key: const ValueKey("remoto"),
            onPressed: controller.controlPendiente.valid
                ? () => controller.buscarYDescargarInspeccionRemota(
                      onError: (f) => _mostrarError(context, null, f),
                      onSuccess: (arg) => Navigator.of(context).pop(
                          arg), // Se abre la pantalla de llenado de inspección normal
                    )
                : null,
            child: const Text('Inspeccionar'),
          ),
        ),
      ],
    );
  }
}

_mostrarError(
    BuildContext context,
    InspeccionesFailure? f, //¿Por qué no dejarla simplemente como ApiFailure?
    ApiFailure? apiFailure) {
  // TODO: cuando se use freezed
  final text = apiFailure != null
      ? apiFailure.when(
          pageNotFound: () =>
              'No se pudo encontrar la inspección, asegúrese de escribir el código correctamente',
          noHayConexionAlServidor: () => "No hay conexión al servidor",
          noHayInternet: () => "Verifique su conexión a internet",
          serverError: (msg) => "Error interno: $msg",
          credencialesException: () =>
              'Error inesperado: intente inciar sesión nuevamente')
      : f!.msg;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Text(text),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Aceptar'),
        )
      ],
    ),
  );
}
