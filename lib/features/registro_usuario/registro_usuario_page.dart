import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/domain/auth/auth_failure.dart';
import 'package:inspecciones/presentation/widgets/user_drawer.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'registro_usuario_control.dart';

final _loadingProvider = StateProvider((ref) => false);

/// Pantalla de inicio de sesión.
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
                child: RegistroForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RegistroForm extends ConsumerWidget {
  const RegistroForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final form = ref.watch(registroUsuarioProvider);
    return ReactiveForm(
      formGroup: form,
      child: Column(
        children: [
          const Text(
              "Por favor llene el formulario para comenzar a usar la aplicación de inspecciones:"),
          ReactiveTextField(
            textInputAction: TextInputAction.next,
            formControlName: 'nombre',
            decoration: const InputDecoration(
              labelText: 'Nombre(s)',
              fillColor: Colors.transparent,
            ),
          ),
          ReactiveTextField(
            textInputAction: TextInputAction.next,
            formControlName: 'apellido',
            decoration: const InputDecoration(
              labelText: 'Apellido(s)',
              fillColor: Colors.transparent,
            ),
          ),
          const SizedBox(height: 10),
          ReactiveTextField(
            textInputAction: TextInputAction.next,
            formControlName: 'password',
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Ingrese su contraseña',
              fillColor: Colors.transparent,
            ),
          ),
          ReactiveTextField(
            textInputAction: TextInputAction.done,
            formControlName: 'password_conf',
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Confirme su contraseña',
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
                  onPressed: !form.valid || isLoading
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
