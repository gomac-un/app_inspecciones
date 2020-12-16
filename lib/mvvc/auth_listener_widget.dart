import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspecciones/application/auth/auth_bloc.dart';
import 'package:inspecciones/router.gr.dart';

/// escuha eventos del authbloc para realizar la navegacion de acuerdo a estos
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
        if (state is Uninitialized)
          navState.pushReplacementNamed(Routes.splashPage);
        if (state is Unauthenticated)
          navState.pushReplacementNamed(Routes.loginScreen);
        if (state is Authenticated)
          navState.pushReplacementNamed(Routes.homeScreen);
      },
      child: child,
    );
  }
}
