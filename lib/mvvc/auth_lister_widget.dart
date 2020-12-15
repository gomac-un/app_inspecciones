import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspecciones/application/auth/auth_bloc.dart';
import 'package:inspecciones/router.gr.dart';

/// escuha eventos del authbloc para realizar la navegacion de acuerdo a estos
class AuthListener extends StatelessWidget {
  final Widget child;

  const AuthListener({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (BuildContext context, state) {
        if (state is Uninitialized)
          ExtendedNavigator.of(context).replace(Routes.splashPage);
        if (state is Unauthenticated)
          ExtendedNavigator.of(context).replace(Routes.loginScreen);
        if (state is Authenticated)
          ExtendedNavigator.of(context).replace(Routes.homeScreen);
      },
      child: child,
    );
  }
}
