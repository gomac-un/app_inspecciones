/*import 'package:flutter/material.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LoginForm(),
    );
  }
}

class LoginFormBloc extends FormBloc<String, String> {
  final documento = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final password = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final showSuccessResponse = BooleanFieldBloc();

  LoginFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        documento,
        password,
        showSuccessResponse,
      ],
    );
  }

  @override
  void onSubmitting() async {
    print(documento.value);
    print(password.value);
    print(showSuccessResponse.value);

    await Future<void>.delayed(Duration(seconds: 1));

    if (showSuccessResponse.value) {
      emitSuccess();
    } else {
      emitFailure(failureResponse: 'Ha ocurrido un error!');
    }
  }
}

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginFormBloc(),
      child: Builder(
        builder: (context) {
          final loginFormBloc = context.bloc<LoginFormBloc>();

          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(title: Text('Ingreso')),
            body: FormBlocListener<LoginFormBloc, String, String>(
              onSubmitting: (context, state) {
                LoadingDialog.show(context);
              },
              onSuccess: (context, state) {
                LoadingDialog.hide(context);

                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => SuccessScreen()));
              },
              onFailure: (context, state) {
                LoadingDialog.hide(context);

                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text(state.failureResponse)));
              },
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    TextFieldBlocBuilder(
                      textFieldBloc: loginFormBloc.documento,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Documento',
                        prefixIcon: Icon(Icons.card_membership),
                      ),
                    ),
                    TextFieldBlocBuilder(
                      textFieldBloc: loginFormBloc.password,
                      suffixButton: SuffixButton.obscureText,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: CheckboxFieldBlocBuilder(
                        booleanFieldBloc: loginFormBloc.showSuccessResponse,
                        body: Container(
                          alignment: Alignment.centerLeft,
                          child: Text('Ingreso exitoso'),
                        ),
                      ),
                    ),
                    RaisedButton(
                      onPressed: loginFormBloc.submit,
                      child: Text('Ingresar'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key key}) => showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(key: key),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  LoadingDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Card(
          child: Container(
            width: 80,
            height: 80,
            padding: EdgeInsets.all(12.0),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  SuccessScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.tag_faces, size: 100),
            SizedBox(height: 10),
            Text(
              'Éxito',
              style: TextStyle(fontSize: 54, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            RaisedButton.icon(
              onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => LoginForm())),
              icon: Icon(Icons.replay),
              label: Text('Otra vez'),
            ),
          ],
        ),
      ),
    );
  }
}
*/
