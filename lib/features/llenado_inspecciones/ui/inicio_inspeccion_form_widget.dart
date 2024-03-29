import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/domain/inspecciones/inspecciones_failure.dart';
import 'package:inspecciones/infrastructure/repositories/inspecciones_remote_repository.dart';
import 'package:inspecciones/infrastructure/repositories/providers.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../domain/cuestionario.dart';
import '../domain/identificador_inspeccion.dart';
import '../infrastructure/inspecciones_repository.dart';

class InicioInspeccionController {
  final InspeccionesRemoteRepository _remoteRepository;
  final InspeccionesRepository _localRepository;

  final tiposDeInspeccionDisponibles = ValueNotifier<List<Cuestionario>>([]);

  late final activoControl = fb.control<String>('', [Validators.required])
    ..valueChanges.listen((activo) async {
      /// A medida que se escribe se va consultando cuestionarios le aplican.

      if (activo == null) {
        tiposDeInspeccionDisponibles.value = [];
        return;
      }
      final res = await _localRepository.cuestionariosParaActivo(activo);
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

  InicioInspeccionController(this._remoteRepository, this._localRepository);

  Future<void> buscarYDescargarInspeccionRemota({
    Function(ApiFailure f)? onError,
    Function(IdentificadorDeInspeccion f)? onSuccess,
  }) async {
    final inspeccionId = int.parse(codigoInspeccionControl.value!);
    final res = await _remoteRepository.descargarInspeccion(inspeccionId);

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

  void dispose() {
    tiposDeInspeccionDisponibles.dispose();
    controlLocal.dispose();
    controlPendiente.dispose();
  }
}

final inicioDeInspeccionProvider = Provider.autoDispose((ref) {
  final res = InicioInspeccionController(
    ref.watch(inspeccionesRemoteRepositoryProvider),
    ref.watch(inspeccionesRepositoryProvider),
  );
  ref.onDispose(res.dispose);
  return res;
});

enum TipoDeCarga {
  local,
  remota,
}
final tipoDeCargaProvider = StateProvider((ref) => TipoDeCarga.local);

class InicioInspeccionForm extends ConsumerWidget {
  const InicioInspeccionForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final tipoDeCarga = ref.watch(tipoDeCargaProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// Crea una nueva inpección
        RadioListTile<TipoDeCarga>(
          value: TipoDeCarga.local,
          groupValue: tipoDeCarga,
          title: const Text('Llenar una nueva inspección'),
          onChanged: (v) {
            ref.read(tipoDeCargaProvider.notifier).state = v!;
          },
        ),

        /// Activa TextField para que ponga el codigo de la inspeccion desde el server.
        RadioListTile<TipoDeCarga>(
          value: TipoDeCarga.remota,
          groupValue: tipoDeCarga,
          title: const Text('Terminar inspección iniciada por otro usuario'),
          onChanged: (v) {
            ref.read(tipoDeCargaProvider.notifier).state = v!;
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
        autofocus: true,
        decoration: const InputDecoration(
          labelText: 'Escriba el identificador del activo',
          prefixIcon: Icon(Icons.view_in_ar_outlined),
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
      ? apiFailure.maybeWhen(
          errorInesperadoDelServidor: (m) =>
              'No se pudo encontrar la inspección, asegúrese de escribir el código correctamente: $m',
          orElse: () => 'error: $apiFailure',
        )
      : f!.toString();
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
