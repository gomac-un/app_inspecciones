import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/application/auth/auth_service.dart';
import 'package:inspecciones/domain/auth/auth_failure.dart';
import 'package:inspecciones/infrastructure/repositories/credenciales.dart';
import 'package:inspecciones/presentation/pages/borradores_screen.dart';
import 'package:inspecciones/presentation/widgets/loading_dialog.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Pantalla de inicio de sesión.
class LoginPage extends ConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final form = ref.watch(loginControlProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingreso'),
      ),
      body: SingleChildScrollView(
        child: ReactiveForm(
            formGroup: form,
            child: Card(
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
                      return ButtonTheme(
                        buttonColor: Theme.of(context).colorScheme.secondary,
                        child: OutlinedButton(
                          onPressed: !form.valid
                              ? null
                              : () => form.submit(
                                    onStart: () => LoadingDialog.show(context),
                                    onFinish: () => LoadingDialog.hide(context),
                                    onSuccess: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const BorradoresPage())),
                                    onFailure: (failure) =>
                                        _onFailure(context, ref.read, failure),
                                  ),
                          child: const Text('Entrar'),
                        ),
                      );
                    },
                  ),

                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            )),
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
        onContinuar: () => _appIdValidation(context, read),
        razon: 'No tiene conexión a internet',
      ),
      noHayConexionAlServidor: () => _problemaDialog(
        context: context,
        onContinuar: () => _appIdValidation(context, read),
        razon:
            'No se puede conectar al servidor, por favor informe al encargado',
      ),
      unexpectedError: (e) => _problemaDialog(
        context: context,
        onContinuar: () => _appIdValidation(context, read),
        razon: 'Ocurrió un error inesperado: $e',
      ),
    );
  }

  _appIdValidation(BuildContext context, Reader read) async {
    final authService = read(authProvider.notifier);
    final appIdStatus = await authService.getOrRegisterAppId();
    appIdStatus.fold(
      (failure) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text(
              'Debe tener conexión a internet para ingresar por primera vez'),
          actions: [
            TextButton(
                child: const Text("Aceptar"),
                onPressed: () => Navigator.of(context).pop()),
          ],
        ),
      ),
      (appid) => authService.login(read(loginControlProvider).getCredenciales(),
          offline: true),
    );
  }

  /// Cuando ocurre un problema en la autenticación, el usuario puede ingresar como inspector y llenar inspecciones.
  /// Esta alerta Le informa al usuario
  _problemaDialog({
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

final loginControlProvider = Provider((ref) => LoginControl(ref.read));

/// View model para el login
class LoginControl extends FormGroup {
  final Reader read;
  LoginControl(this.read)
      : super({
          'usuario': fb.control('', [Validators.required]),
          'password': fb.control('', [Validators.required]),
        });

  Future<void> submit({
    VoidCallback? onStart,
    VoidCallback? onFinish,
    VoidCallback? onSuccess,
    void Function(AuthFailure failure)? onFailure,
  }) async {
    try {
      onStart?.call();

      final credenciales = getCredenciales();
      final authService = read(authProvider.notifier);
      authService.login(credenciales,
          offline: false, onSuccess: onSuccess, onFailure: onFailure);
    } catch (exception, stack) {
      onFailure?.call(AuthFailure.unexpectedError(exception));
    } finally {
      onFinish?.call();
    }
  }

  Credenciales getCredenciales() {
    return Credenciales(
      username: value['usuario'] as String,
      password: value['password'] as String,
    );
  }
}
