import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspecciones/application/auth/auth_bloc.dart';
import 'package:inspecciones/router.gr.dart';

/// Escucha eventos del authbloc y realiza la navegacion (login o pantalla de usuario)
/// automaticamente.
class AuthListener extends StatelessWidget {
  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;

  const AuthListener({Key key, this.child, this.navigatorKey})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (BuildContext context, state) {
        final navState = navigatorKey.currentState;
        state.map(
            initial: (_) => navState.pushReplacementNamed(Routes.splashPage),

            /// Si se desea cambiar la pantalla inicial que se ve al iniciar sesión, se debe reemplazar aquí
            authenticated: (u) => u.sincronizado != null
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
