import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/features/configuracion_organizacion/domain/entities.dart';
import 'package:inspecciones/presentation/extensions.dart';
import 'package:inspecciones/presentation/widgets/app_image_multi_image_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'configuracion_organizacion_control.dart';
import 'organizacion_profile_page.dart';

final _loadingProvider = StateProvider((ref) => false);

class ConfiguracionOrganizacionPage extends StatelessWidget {
  /// si es null, la organizacion es nueva
  final Organizacion? organizacion;
  const ConfiguracionOrganizacionPage({Key? key, this.organizacion})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("configuración de organización"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ConfOrgForm(
                  organizacion: organizacion,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ConfOrgForm extends ConsumerWidget {
  final Organizacion? organizacion;
  const ConfOrgForm({Key? key, this.organizacion}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final form = ref.watch(configuracionOrganizacionProvider(organizacion));
    return ReactiveForm(
      formGroup: form.control,
      child: Column(
        children: [
          ReactiveTextField(
            textInputAction: TextInputAction.next,
            formControl: form.nombreControl,
            decoration: const InputDecoration(labelText: 'Nombre'),
          ).padding(const EdgeInsets.symmetric(vertical: 4.0)),
          AppImageImagePicker(
            formControl: form.logoControl,
            label: 'Logo',
          ).padding(const EdgeInsets.symmetric(vertical: 4.0)),
          ReactiveTextField(
            textInputAction: TextInputAction.next,
            formControl: form.linkControl,
            decoration: const InputDecoration(labelText: 'Link'),
          ).padding(const EdgeInsets.symmetric(vertical: 4.0)),
          ReactiveTextField(
            textInputAction: TextInputAction.done,
            formControl: form.acercaControl,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(labelText: 'Acerca'),
          ).padding(const EdgeInsets.symmetric(vertical: 4.0)),

          /// Activa el botón de iniciar sesión solo cuando el formulario sea valido.
          ReactiveFormConsumer(
            builder: (context, _, child) {
              return Consumer(builder: (context, ref, _) {
                final loadingCtrl = ref.watch(_loadingProvider);
                final isLoading = loadingCtrl.state;
                return ElevatedButton(
                  onPressed: !form.control.valid || isLoading
                      ? null
                      : () => form.submit(
                            onStart: () => loadingCtrl.state = true,
                            onFinish: () => loadingCtrl.state = false,
                            onSuccess: () => showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: const Text('Guardado'),
                                          content: const Text(
                                              'Se ha guardado la organización'),
                                          actions: [
                                            TextButton(
                                              child: const Text('Ok'),
                                              onPressed:
                                                  Navigator.of(context).pop,
                                            )
                                          ],
                                        ))
                                .then(
                                    (_) => ref.refresh(miOrganizacionProvider))
                                .then((_) => Navigator.of(context).pop()),
                            onFailure: (failure) => _mostrarError(
                                context: context, mensaje: failure.toString()),
                          ),
                  child: isLoading
                      ? const SizedBox.square(
                          dimension: 20, child: CircularProgressIndicator())
                      : organizacion != null
                          ? const Text('Finalizar')
                          : const Text('Guardar'),
                );
              });
            },
          ),
        ],
      ),
    );
  }

  Future<void> _mostrarError(
          {required BuildContext context, required String mensaje}) =>
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: Text(mensaje),
                actions: [
                  TextButton(
                      onPressed: Navigator.of(context).pop,
                      child: const Text('ok'))
                ],
              ));
}
