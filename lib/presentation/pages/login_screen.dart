import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:inspecciones/application/auth/auth_bloc.dart';
import 'package:inspecciones/application/auth/usuario.dart';
import 'package:inspecciones/infrastructure/repositories/api_model.dart';
import 'package:inspecciones/infrastructure/repositories/user_repository.dart';
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
    final form = Provider.of<LoginControl>(context);

    /// Se usa OrientationBuilder para adecuar la imagen del logo a los diferentes tamaños de pantalla
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
                            {'required': 'Ingrese el usuario'},
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
                        validationMessages: (control) =>
                            {'required': 'Ingrese la contraseña'},
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
                          buttonColor: Theme.of(context).accentColor,
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

/// Validaciones para el login
@injectable
class LoginControl extends FormGroup {
  final UserRepository userRepository;

  LoginControl(this.userRepository)
      : super({
          'usuario': fb.control('', [Validators.required]),
          'password': fb.control('', [Validators.required]),
        });

  Future submit(BuildContext context) async {
    /// [authBloc] maneja el estado del login.
    final authBloc = Provider.of<AuthBloc>(context, listen: false);
    final login = UserLogin(
      username: value['usuario'] as String,
      password: value['password'] as String,
    );

    /// Se realiza el proceso de autenticación, y se procesa de acuerdo al estado que lance [autenticate]
    LoadingDialog.show(context);
    final autenticate = await userRepository.authenticateUser(userLogin: login);
    LoadingDialog.hide(context);

    autenticate.fold(
      (failure) => failure.when(
        usuarioOPasswordInvalidos: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    content: const Text("Usuario o contraseña invalidos"),
                    actions: [
                      TextButton(
                          onPressed: () => context.router.pop(),
                          child: const Text("ok"))
                    ],
                  ));
        },
        noHayInternet: () {
          problemaDialog(
            context,
            authBloc,
            login,
            razon: 'No tiene conexión a internet',
            userRepository: userRepository,
          );
        },
        noHayConexionAlServidor: () {
          problemaDialog(
            context,
            authBloc,
            login,
            razon:
                'No se puede conectar al servidor, por favor informe al encargado',
          );
        },
        serverError: () {
          problemaDialog(
            context,
            authBloc,
            login,
            razon: 'Ocurrió un error desconocido',
          );
        },
      ),
      (usuario) {
        authBloc.add(AuthEvent.loggingIn(usuario: usuario));
      },
    );
  }

  /// Cuando ocurre un problema en la autenticación, el usuario puede ingresar como inspector y llenar inspecciones.
  /// Esta alerta Le informa al usuario
  Future problemaDialog(
      BuildContext context, AuthBloc authBloc, UserLogin login,
      {required String razon, UserRepository userRepository}) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(
            '$razon. Sin embargo puede realizar inspecciones y luego subirlas cuando tenga conexión'),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () => context.router
                .pop(), //TODO: mirar si el router hace el pop correctamente o se debe usar Navigator.of(context).pop()
          ),
          TextButton(
              child: const Text("Continuar"),
              onPressed: () {
                if (userRepository.getAppId() != null) {
                  authBloc.add(
                    AuthEvent.loggingIn(loginData: login),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: const Text(
                          'Debe tener conexión a internet para ingresar por primera vez'),
                      actions: [
                        TextButton(
                            child: const Text("Aceptar"),
                            onPressed: () => context.router.pop()),
                      ],
                    ),
                  );
                }
              })
        ],
      ),
    );
  }
}
