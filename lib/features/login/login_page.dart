import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/application/auth/auth_service.dart';
import 'package:inspecciones/domain/auth/auth_failure.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'login_control.dart';

final _loadingProvider = StateProvider((ref) => false);

class LoginPage extends StatelessWidget {
  final String? from;
  const LoginPage({Key? key, this.from}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingreso'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _LoginForm(from: from),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends ConsumerWidget {
  final String? from;
  const _LoginForm({Key? key, this.from}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final form = ref.watch(loginControlProvider);
    return ReactiveForm(
      formGroup: form,
      child: Column(
        children: [
          Image.asset("assets/images/logo-gomac-texto.png"),
          const SizedBox(
            height: 15,
          ),
          ReactiveTextField(
            textInputAction: TextInputAction.next,
            validationMessages: (control) =>
                {ValidationMessage.required: 'Ingrese el usuario'},
            formControlName: 'usuario',
            decoration: const InputDecoration(
              labelText: 'Usuario',
              fillColor: Colors.transparent,
            ),
          ),
          const SizedBox(height: 10),
          ReactiveTextField(
            textInputAction: TextInputAction.done,
            validationMessages: (control) =>
                {ValidationMessage.required: 'Ingrese la contraseña'},
            formControlName: 'password',
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Contraseña',
              fillColor: Colors.transparent,
            ),
          ),
          const SizedBox(
            height: 15,
          ),

          /// Activa el botón de iniciar sesión solo cuando se hayan llenado los dos campos.
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
                              if (from != null) context.go(from!);
                            },
                            onFailure: (failure) =>
                                _onFailure(context, ref.read, failure),
                          ),
                  child: isLoading
                      ? const SizedBox.square(
                          dimension: 20, child: CircularProgressIndicator())
                      : const Text('Entrar'),
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
      noHayInternet: () => _problemaDialog(
        context: context,
        onContinuar: () => _loginOffline(context, read),
        razon: 'No tiene conexión a internet',
      ),
      noHayConexionAlServidor: () => _problemaDialog(
        context: context,
        onContinuar: () => _loginOffline(context, read),
        razon:
            'No se puede conectar al servidor, por favor informe al encargado',
      ),
      unexpectedError: (e) => _problemaDialog(
        context: context,
        onContinuar: () => _loginOffline(context, read),
        razon: 'Ocurrió un error inesperado: $e',
      ),
    );
  }

  Future<void> _loginOffline(BuildContext context, Reader read) async {
    final authService = read(authProvider.notifier);
    return authService.login(read(loginControlProvider).getCredenciales(),
        offline: true);
  }

  /// Cuando ocurre un problema en la autenticación, el usuario puede ingresar como inspector y llenar inspecciones.
  /// Esta alerta Le informa al usuario
  Future<void> _problemaDialog({
    required BuildContext context,
    required VoidCallback onContinuar,
    required String razon,
  }) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(
              '$razon. Sin embargo puede realizar inspecciones y luego subirlas cuando tenga conexión'),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Continuar"),
              onPressed: onContinuar,
            ),
          ],
        ),
      );
}
