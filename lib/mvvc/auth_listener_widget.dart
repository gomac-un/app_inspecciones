import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspecciones/application/auth/auth_bloc.dart';
import 'package:inspecciones/router.gr.dart';

/// Escucha eventos del authbloc y realiza la navegacion (login o pantalla de usuario)
/// automaticamente.
/*class AuthListener extends StatelessWidget {
  final Widget child;
  final AppRouter router;

  const AuthListener({Key? key, required this.child, required this.router})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (BuildContext context, state) {
        state.map(
            initial: (_) => router.replace(
                const SplashRoute()), // TODO: mirar si debe ser replace

            /// Si se desea cambiar la pantalla inicial que se ve al iniciar sesión, se debe reemplazar aquí
            authenticated: (u) => {
              final 
            }
                ? navState.pushReplacementNamed(Routes.borradoresPage)
                : navState.pushReplacementNamed(Routes.sincronizacionPage),
            unauthenticated: (_) =>
                navState.pushReplacementNamed(Routes.loginScreen),
            loading: (_) {});
      },
      child: child,
    );
  }
}
*/