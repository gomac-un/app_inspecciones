import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:inspecciones/application/auth/auth_bloc.dart';
import 'package:inspecciones/infrastructure/repositories/api_model.dart';
import 'package:inspecciones/infrastructure/repositories/user_repository.dart';
import 'package:inspecciones/injection.dart';
import 'package:inspecciones/mvvc/common_widgets.dart';
import 'package:inspecciones/mvvc/form_scaffold.dart';
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
    final authBloc = Provider.of<AuthBloc>(context);
    final form = Provider.of<LoginControl>(context);
    return FormScaffold(
      title: const Text('Ingreso'),
      body: ReactiveForm(
          formGroup: form,
          child: PreguntaCard(
            child: Column(
              children: [
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
                  builder: (context, form, child) {
                    return OutlineButton(
                      onPressed: form.valid
                          ? () => authBloc.add(
                                AuthEvent.loggingIn(
                                  login: UserLogin(
                                    documento: form.value['usuario'] as String,
                                    password: form.value['password'] as String,
                                  ),
                                ),
                              )
                          : null,
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
}
