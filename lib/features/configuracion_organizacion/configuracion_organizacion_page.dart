import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/domain/auth/auth_failure.dart';
import 'package:inspecciones/presentation/widgets/app_image_multi_image_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'configuracion_organizacion_control.dart';

final _loadingProvider = StateProvider((ref) => false);

//TODO: link
// industria
class ConfiguracionOrganizacionPage extends StatelessWidget {
  const ConfiguracionOrganizacionPage({Key? key}) : super(key: key);

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
            child: const Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: ConfOrgForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ConfOrgForm extends ConsumerWidget {
  const ConfOrgForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final form = ref.watch(configuracionOrganizacionProvider);
    return ReactiveForm(
      formGroup: form.control,
      child: Column(
        children: [
          AppImageImagePicker(
            formControl: form.logoControl,
            label: 'Logo',
          ),
          ReactiveTextField(
            textInputAction: TextInputAction.next,
            formControl: form.nombreControl,
            decoration: const InputDecoration(
              labelText: 'Nombre de la organización',
              fillColor: Colors.transparent,
            ),
          ),

          const SizedBox(
            height: 15,
          ),

          /// Activa el botón de iniciar sesión solo cuando el formulario sea valido.
          ReactiveFormConsumer(
            builder: (context, _, child) {
              return Consumer(builder: (context, ref, _) {
                final loadingCtrl = ref.watch(_loadingProvider);
                final isLoading = loadingCtrl.state;
                return ElevatedButton(
                  onPressed: !form.nombreControl.valid || isLoading
                      ? null
                      : () => form.submit(
                            onStart: () => loadingCtrl.state = true,
                            onFinish: () => loadingCtrl.state = false,
                            onSuccess: () {
                              //TODO: implementar
                            },
                            onFailure: (failure) =>
                                _onFailure(context, ref.read, failure),
                          ),
                  child: isLoading
                      ? const SizedBox.square(
                          dimension: 20, child: CircularProgressIndicator())
                      : const Text('Finalizar'),
                );
              });
            },
          ),

          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Future<void> _onFailure(
      BuildContext context, Reader read, AuthFailure failure) async {
    failure.when(
      usuarioOPasswordInvalidos: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: const Text("Usuario o contraseña invalidos"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("ok"),
              )
            ],
          ),
        );
      },
      noHayInternet: () => _mostrarError(
        context: context,
        mensaje: 'No tiene conexión a internet',
      ),
      noHayConexionAlServidor: () => _mostrarError(
        context: context,
        mensaje:
            'No se puede conectar al servidor, por favor informe al encargado',
      ),
      unexpectedError: (e) => _mostrarError(
        context: context,
        mensaje: 'Ocurrió un error inesperado: $e',
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
                      onPressed: Navigator.of(context).pop, child: Text('ok'))
                ],
              ));
}
