import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:inspecciones/application/auth/auth_bloc.dart';
import 'package:inspecciones/infrastructure/repositories/credenciales.dart';
import 'package:inspecciones/injection.dart';
import 'package:inspecciones/mvvc/common_widgets.dart';
import 'package:inspecciones/mvvc/form_scaffold.dart';
import 'package:inspecciones/presentation/widgets/loading_dialog.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Pantalla de inicio de sesión.
class LoginPage extends StatelessWidget implements AutoRouteWrapper {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) => Provider(
        create: (ctx) => getIt<LoginControl>(),
        dispose: (context, LoginControl value) => value.dispose(),
        child: this,
      );

  @override
  Widget build(BuildContext context) {
    final form = context.read<LoginControl>();

    /// Se usa OrientationBuilder para adecuar la imagen del logo a los diferentes tamaños de pantalla.
    /// TODO: Emular este comportamiento usando menos codigo.
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        final queryData = MediaQuery.of(context);
        final ancho = queryData.size.width;
        double textSize = orientation == Orientation.portrait
            ? ancho * 0.04
            : queryData.size.height * 0.04;
        if (ancho < 600 || queryData.size.height < 600) {
          textSize = orientation == Orientation.portrait
              ? ancho * 0.05
              : queryData.size.height * 0.05;
        }
        return FormScaffold(
          title: Text(
            'Ingreso',
            style: TextStyle(fontSize: textSize - 5),
          ),
          body: ReactiveForm(
              formGroup: form,
              child: PreguntaCard(
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/logo-gomac-texto.png",
                      width: orientation == Orientation.portrait
                          ? ancho * 0.8
                          : ancho * 0.4,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          right: ancho * 0.05, left: ancho * 0.05),
                      child: ReactiveTextField(
                        textInputAction: TextInputAction.next,
                        validationMessages: (control) =>
                            {ValidationMessage.required: 'Ingrese el usuario'},
                        formControlName: 'usuario',
                        style: TextStyle(fontSize: textSize.toDouble()),
                        decoration: InputDecoration(
                          labelText: 'Usuario',
                          labelStyle:
                              TextStyle(fontSize: textSize.toDouble() - 5),
                          fillColor: Colors.transparent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(
                          right: ancho * 0.05, left: ancho * 0.05),
                      child: ReactiveTextField(
                        textInputAction: TextInputAction.done,
                        validationMessages: (control) => {
                          ValidationMessage.required: 'Ingrese la contraseña'
                        },
                        style: TextStyle(fontSize: textSize.toDouble()),
                        formControlName: 'password',
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          labelStyle:
                              TextStyle(fontSize: textSize.toDouble() - 5),
                          fillColor: Colors.transparent,
                        ),
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
                          minWidth: ancho * 0.15,
                          height: orientation == Orientation.portrait
                              ? ancho * 0.1
                              : queryData.size.height * 0.1,
                          child: OutlinedButton(
                            onPressed:
                                form.valid ? () => form.submit(context) : null,
                            child: Text('Entrar',
                                style: TextStyle(fontSize: textSize - 5)),
                          ),
                        );
                      },
                    ),

                    /// Muestra y esconde el dialog de carga cuando se necesite
                    BlocListener<AuthBloc, AuthState>(
                      listenWhen: (previus, current) =>
                          previus.loading != current.loading,
                      listener: (context, state) {
                        if (state.loading) {
                          LoadingDialog.show(context);
                        } else {
                          LoadingDialog.hide(context);
                        }
                      },
                      child: Container(),
                    ),

                    /// muestra los dialogs para los errores de login
                    BlocListener<AuthBloc, AuthState>(
                      listenWhen: (previus, current) =>
                          previus.failure != current.failure,
                      listener: (context, state) {
                        onContinuar() async {
                          final authBloc = context.read<AuthBloc>();
                          final appIdStatus =
                              await authBloc.getOrRegisterAppId();
                          appIdStatus.fold(
                            (failure) => showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: const Text(
                                    'Debe tener conexión a internet para ingresar por primera vez'),
                                actions: [
                                  TextButton(
                                      child: const Text("Aceptar"),
                                      onPressed: () =>
                                          Navigator.of(context).pop()),
                                ],
                              ),
                            ),
                            (appid) => authBloc.add(
                              AuthEvent.loggingIn(
                                  credenciales: form.getCredenciales(),
                                  offline: true),
                            ),
                          );
                        }

                        state.failure.fold(
                          () => null,
                          (failure) => failure.when(
                            usuarioOPasswordInvalidos: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: const Text(
                                      "Usuario o contraseña invalidos"),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text("ok"),
                                    )
                                  ],
                                ),
                              );
                            },
                            noHayInternet: () => problemaDialog(
                              context: context,
                              onContinuar: onContinuar,
                              razon: 'No tiene conexión a internet',
                            ),
                            noHayConexionAlServidor: () => problemaDialog(
                              context: context,
                              onContinuar: onContinuar,
                              razon:
                                  'No se puede conectar al servidor, por favor informe al encargado',
                            ),
                            unexpectedError: (e) => problemaDialog(
                              context: context,
                              onContinuar: onContinuar,
                              razon: 'Ocurrió un error desconocido: $e',
                            ),
                          ),
                        );
                      },
                      child: Container(),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }
}

/// View model para el login
@injectable
class LoginControl extends FormGroup {
  LoginControl()
      : super({
          'usuario': fb.control('', [Validators.required]),
          'password': fb.control('', [Validators.required]),
        });

  Future submit(BuildContext context) async {
    /// [authBloc] maneja el estado del login.
    final authBloc = context.read<AuthBloc>();
    final credenciales = getCredenciales();
    authBloc.add(AuthEvent.loggingIn(credenciales: credenciales));

    /// Se realiza el proceso de autenticación, y se procesa de acuerdo al estado que lance [autenticate]
  }

  Credenciales getCredenciales() {
    return Credenciales(
      username: value['usuario'] as String,
      password: value['password'] as String,
    );
  }
}

/// Cuando ocurre un problema en la autenticación, el usuario puede ingresar como inspector y llenar inspecciones.
/// Esta alerta Le informa al usuario
Future problemaDialog({
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
