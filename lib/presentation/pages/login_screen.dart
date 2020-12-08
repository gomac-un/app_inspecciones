import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:form_bloc/form_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspecciones/infrastructure/database/usuario.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/presentation/pages/prueba.dart';
import 'package:inspecciones/presentation/pages/borradores_screen.dart';
import 'package:provider/provider.dart';
import '../../injection.dart';
import '../../router.gr.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: LoginForm(),
    );
  }
}

/*class MiError  implements FieldBlocValidatorsErrors{
   MiError._();
    static const String validar_doc = 'validar_doc - Validator Error';
}*/
class MisValidaciones {
  static bool validar_doc(String doc, String cont) {
    var docu = Usuario.getUsers().where((usu) => (usu.documento == doc));
    print('documento registrado');
    print(docu);
    if (docu.isEmpty) {
      return false;
    } else {
      if (docu.elementAt(0).contrasena != cont) {
        return false;
      }
    }
    return true;
  }

  static bool isContratista(String documento) {
    var docu = Usuario.getUsers().where((usu) => (usu.documento == documento));
    if (docu.elementAt(0).isContratista) {
      return true;
    }
    return false;
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
/* 
  final showSuccessResponse = BooleanFieldBloc(); */

  LoginFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        documento,
        password,
        /*       showSuccessResponse, */
      ],
    );
  }

  @override
  void onSubmitting() async {
    print(documento.value);
    print(password.value);
    /* print(showSuccessResponse.value); */
    print('mival');
    print(MisValidaciones.validar_doc(documento.value, password.value));
    await Future<void>.delayed(Duration(seconds: 1));
    if (/* showSuccessResponse.value &  */ MisValidaciones.validar_doc(
        documento.value, password.value)) {
      pantallaMostrar();
    } else {
      emitFailure(failureResponse: 'Ha ocurrido un error!');
    }
  }

  void pantallaMostrar() async {
    if (MisValidaciones.isContratista(documento.value)) {
      print('pantallaMostrar');
      print(MisValidaciones.isContratista(documento.value));
      emitSuccess(successResponse: 'Pantalla de contratista');
    } else {
      emitSuccess(successResponse: 'Pantalla de inspector');
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
            /* appBar: AppBar(title: Text('Ingreso')), */
            body: Padding(
              padding: const EdgeInsets.only(top: 30, left: 8),
              child: FormBlocListener<LoginFormBloc, String, String>(
                onSubmitting: (context, state) {
                  LoadingDialog.show(context);
                },
                onSuccess: (context, state) {
                  LoadingDialog.hide(context);
                  var x = Text(state.successResponse);
                  if (x.data == "Pantalla de inspector") {
                    print(x.data);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (_) => Provider(
                            create: (_) => Usuario(
                                loginFormBloc.documento.value, null, null),
                            child: BorradoresPage(getIt<Database>()))));
                    /* Navigator.of(context).pushReplacementNamed(
                      Routes.borradoresPage,
                      arguments: BorradoresPageArguments(db: getIt<Database>()),
                    ); */
                  } else {
                    print(x.data);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (_) => Provider(
                            create: (_) => Usuario(
                                loginFormBloc.documento.value, null, null),
                            child: ContratistaScreen())));
                  }
                  /*  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => SuccessScreen())); */
                  /* Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text(state.successResponse))); */
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
                      /*  SizedBox(
                        width: 250,
                        child: CheckboxFieldBlocBuilder(
                          booleanFieldBloc: loginFormBloc.showSuccessResponse,
                          body: Container(
                            alignment: Alignment.centerLeft,
                            child: Text('Ingreso exitoso'),
                          ),
                        ),
                      ), */
                      RaisedButton(
                        onPressed: loginFormBloc.submit,
                        child: Text('Ingresar'),
                      ),
                    ],
                  ),
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

/* class SuccessScreen extends StatelessWidget {
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
