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

class LoginScreen extends StatelessWidget implements AutoRouteWrapper {
  @override
  Widget wrappedRoute(BuildContext context) => Provider(
        create: (ctx) => getIt<LoginControl>(),
        dispose: (context, LoginControl value) => value.dispose(),
        child: this,
      );
  @override
  Widget build(BuildContext context) {
    final form = Provider.of<LoginControl>(context);
    return FormScaffold(
      title: const Text('Ingreso'),
      body: ReactiveForm(
          formGroup: form,
          child: PreguntaCard(
            child: Column(
              children: [
                Image.asset(
                  "assets/images/logo-gomac-texto.png",
                ),
                ReactiveTextField(
                  formControlName: 'usuario',
                  decoration: const InputDecoration(
                    labelText: 'Usuario',
                  ),
                ),
                const SizedBox(height: 10),
                ReactiveTextField(
                  formControlName: 'password',
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                  ),
                ),
                const SizedBox(height: 10),
                ReactiveFormConsumer(
                  builder: (context, _, child) {
                    return OutlineButton(
                      onPressed: form.valid ? () => form.submit(context) : null,
                      child: const Text('Entrar'),
                    );
                  },
                ),
              ],
            ),
          )),
    );
  }
}

@injectable
class LoginControl extends FormGroup {
  final UserRepository userRepository;

  LoginControl({@required this.userRepository})
      : super({
          'usuario': fb.control('', [Validators.required]),
          'password': fb.control('', [Validators.required]),
        });

  Future submit(BuildContext context) async {
    final authBloc = Provider.of<AuthBloc>(context, listen: false);

    final login = UserLogin(
      username: value['usuario'] as String,
      password: value['password'] as String,
    );

    LoadingDialog.show(context);
    final autenticate = await userRepository.authenticateUser(userLogin: login);
    LoadingDialog.hide(context);

    autenticate.fold(
      (failure) => failure.when(noHayInternet: () {
        problemaDialog(
          context,
          authBloc,
          login,
          razon: 'No tiene conexión a internet',
        );
      }, noHayConexionAlServidor: () {
        problemaDialog(
          context,
          authBloc,
          login,
          razon:
              'No se puede conectar al servidor, por favor informe al encargado',
        );
      }, serverError: () {
        problemaDialog(
          context,
          authBloc,
          login,
          razon: 'Ocurrió un error desconocido',
        );
      }, usuarioOPasswordInvalidos: () {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  content: const Text("Usuario o contraseña invalidos"),
                  actions: [
                    FlatButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("ok"))
                  ],
                ));
      }),
      (usuario) {
        authBloc.add(AuthEvent.loggingIn(usuario: usuario));
      },
    );
  }

  Future problemaDialog(
      BuildContext context, AuthBloc authBloc, UserLogin login,
      {@required String razon}) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(
            '$razon. Sin embargo puede realizar inspecciones y luego subirlas cuando tenga conexión'),
        actions: [
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancelar"),
          ),
          FlatButton(
              onPressed: () => authBloc.add(
                    AuthEvent.loggingIn(
                      usuario: Usuario(
                        documento: login.username,
                        password: login.password,
                        esAdmin: false,
                      ),
                    ),
                  ),
              child: const Text("continuar"))
        ],
      ),
    );
  }
}
