import 'package:flutter/material.dart';
import 'package:go_router/src/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/presentation/extensions.dart';
import 'package:inspecciones/presentation/widgets/app_image_multi_image_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'registro_usuario_control.dart';

final _loadingProvider = StateProvider((ref) => false);

class RegistroUsuarioPage extends StatelessWidget {
  final int organizacionId;
  const RegistroUsuarioPage({Key? key, required this.organizacionId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de usuario'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _RegistroForm(
                  organizacionId: organizacionId,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RegistroForm extends ConsumerWidget {
  final int organizacionId;
  const _RegistroForm({Key? key, required this.organizacionId})
      : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final form = ref.watch(registroUsuarioProvider);
    return ReactiveForm(
      formGroup: form.control,
      child: Column(
        children: [
          const Text(
                  "Por favor llene el formulario para comenzar a usar la aplicación de inspecciones:")
              .padding(const EdgeInsets.symmetric(vertical: 8.0)),
          ReactiveTextField(
            textInputAction: TextInputAction.next,
            formControl: form.nombreControl,
            decoration: const InputDecoration(labelText: 'Nombre(s)'),
          ).padding(const EdgeInsets.symmetric(vertical: 4.0)),
          ReactiveTextField(
            textInputAction: TextInputAction.next,
            formControl: form.apellidoControl,
            decoration: const InputDecoration(labelText: 'Apellido(s)'),
          ).padding(const EdgeInsets.symmetric(vertical: 4.0)),
          ReactiveTextField(
            textInputAction: TextInputAction.next,
            formControl: form.emailControl,
            decoration: const InputDecoration(labelText: 'correo electrónico'),
          ).padding(const EdgeInsets.symmetric(vertical: 4.0)),
          ReactiveTextField(
            textInputAction: TextInputAction.next,
            formControl: form.celularControl,
            decoration: const InputDecoration(labelText: 'celular'),
          ).padding(const EdgeInsets.symmetric(vertical: 4.0)),
          ReactiveTextField(
            textInputAction: TextInputAction.next,
            formControl: form.usernameControl,
            decoration: const InputDecoration(
                labelText: 'nombre de usuario (opcional)'),
          ).padding(const EdgeInsets.symmetric(vertical: 4.0)),
          ReactiveTextField(
            textInputAction: TextInputAction.next,
            formControl: form.passwordControl,
            obscureText: true,
            decoration:
                const InputDecoration(labelText: 'Ingrese su contraseña'),
          ).padding(const EdgeInsets.symmetric(vertical: 4.0)),
          ReactiveTextField(
            textInputAction: TextInputAction.done,
            formControl: form.passwordConfControl,
            obscureText: true,
            decoration:
                const InputDecoration(labelText: 'Confirme su contraseña'),
          ).padding(const EdgeInsets.symmetric(vertical: 4.0)),
          AppImageImagePicker(
            formControl: form.fotoControl,
            label: 'Foto (opcional)',
          ),
          ReactiveCheckboxListTile(
            formControl: form.aceptoControl,
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text('Acepto la política de protección de datos'),
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
                  onPressed: !form.control.valid || isLoading
                      ? null
                      : () => form.submit(
                            onStart: () => loadingCtrl.state = true,
                            onFinish: () => loadingCtrl.state = false,
                            onSuccess: (username) =>
                                _onSuccess(context, username),
                            onFailure: (failure) =>
                                _onFailure(context, ref.read, failure),
                            organizacionId: organizacionId,
                          ),
                  child: isLoading
                      ? const SizedBox.square(
                          dimension: 20, child: CircularProgressIndicator())
                      : const Text('Finalizar'),
                );
              });
            },
          ),
        ],
      ),
    );
  }

  Future<void> _onSuccess(BuildContext context, username) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Usuario creado'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Su nombre de usuario es $username'),
                const Text('Ahora puede iniciar sesión'),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => context.goNamed('organizacion'),
                  child: const Text('ok'))
            ],
          ));

  Future<void> _onFailure(
          BuildContext context, Reader read, ApiFailure failure) =>
      _mostrarError(context: context, mensaje: failure.mensaje);

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
