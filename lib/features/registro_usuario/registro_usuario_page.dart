import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/core/entities/app_image.dart';
import 'package:inspecciones/domain/auth/auth_failure.dart';
import 'package:inspecciones/presentation/widgets/app_image_multi_image_picker.dart';
import 'package:inspecciones/presentation/widgets/user_drawer.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_multi_image_picker/reactive_multi_image_picker.dart';

import 'registro_usuario_control.dart';

//TODO: aceptar politica de proteccion de datos
// celular para recuperar contraseña

final _loadingProvider = StateProvider((ref) => false);

class RegistroUsuarioPage extends StatelessWidget {
  const RegistroUsuarioPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de usuario'),
      ),
      drawer: const UserDrawer(),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: const Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: _RegistroForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RegistroForm extends ConsumerWidget {
  const _RegistroForm({Key? key}) : super(key: key);

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

extension PaddingX on Widget {
  Widget padding(EdgeInsetsGeometry padding) => Padding(
        padding: padding,
        child: this,
      );
}
