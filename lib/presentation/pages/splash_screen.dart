import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspecciones/application/auth/auth_bloc.dart';
import 'package:inspecciones/mvvc/auth_listener_widget.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authbloc = Provider.of<AuthBloc>(context);
    /*return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        state.map(
          initial: (_) {},
          authenticated: (_) =>
              ExtendedNavigator.of(context).replace(Routes.notesOverviewPage),
          unauthenticated: (_) =>
              ExtendedNavigator.of(context).replace(Routes.signInPage),
        );
      },
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );*/
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            CircularProgressIndicator(),
            FlatButton(
                onPressed: () {
                  authbloc.add(AppStarted());
                },
                child: Text("emit appstarted"))
          ],
        ),
      ),
    );
  }
}
