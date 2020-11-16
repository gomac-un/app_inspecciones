import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import 'package:inspecciones/infrastructure/moor_database_llenado.dart';

import 'package:inspecciones/application/crear_cuestionario_form/llenar_cuestionario_form_bloc.dart';

import 'package:inspecciones/presentation/widgets/widgets.dart';
import 'package:inspecciones/presentation/widgets/llenado_widgets.dart';
import 'package:inspecciones/presentation/widgets/action_button.dart';

class LlenarCuestionarioFormPage extends StatelessWidget {
  final LlenarCuestionarioFormBloc _formBloc;
  LlenarCuestionarioFormPage(this._formBloc, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor, //Colors.lightBlue,
      appBar: AppBar(title: Text('Llenado de inspección')),
      body: FormBlocListener<LlenarCuestionarioFormBloc, String, String>(
        formBloc: _formBloc,
        onSubmitting: (context, state) {
          LoadingDialog.show(context);
        },
        onSuccess: (context, state) {
          LoadingDialog.hide(context);
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(state.successResponse ?? "exito"),
            duration: Duration(seconds: 3),
          ));
          /*Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => SuccessScreen())
                  );*/
          Navigator.of(context).pop();
        },
        onFailure: (context, state) {
          LoadingDialog.hide(context);

          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Error: ' + state.toString() /*.failureResponse*/),
            duration: Duration(seconds: 20),
          ));
        },
        child: BlocBuilder<LlenarCuestionarioFormBloc, FormBlocState>(
            cubit: _formBloc,
            builder: (context, state) {
              if (state is FormBlocLoading) {
                return Center(child: CircularProgressIndicator());
              } else {
                return SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        //Estados del form
                        /*
                BlocBuilder<LlenarCuestionarioFormBloc,
                    FormBlocState<String, String>>(
                  /*listenWhen: (previousState, state) =>
                        state is FormBlocLoading,*/
                  builder: (context, state) {
                    if (state is FormBlocLoading) {
                      return Text('Loading...');
                    } else if (state is FormBlocLoaded) {
                      return Text('Loaded: \n' + state.toString());
                    } else {
                      return Text('other state\n' + state.toString());
                    }
                  },
                ),*/

                        if (_formBloc.bloques != null &&
                            _formBloc.bloques.isNotEmpty)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _formBloc.bloques.length,
                            itemBuilder: (context, i) {
                              if ((_formBloc.bloques[i]).pregunta == null) {
                                return TituloCard(bloque: _formBloc.bloques[i]);
                              } else {
                                return RespuestaCard(
                                    bloc: _formBloc.blocsRespuestas[i]);
                              }
                            },
                          ),

                        SizedBox(height: 60),
                      ],
                    ),
                  ),
                );
              }
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ActionButton(
              iconData: Icons.archive,
              label: 'Guardar borrador',
              onPressed: _formBloc.submit,
            ),
            ActionButton(
              iconData: Icons.send,
              label: 'Enviar',
              onPressed: () {
                _formBloc.finalizarInspeccion();
              },
            ),
          ],
        ),
      ),
    );
  }
}
