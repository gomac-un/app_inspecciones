import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:inspecciones/application/crear_cuestionario_form/bloques_de_formulario.dart';

import 'package:inspecciones/infrastructure/moor_database.dart';

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
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor, //Colors.lightBlue,
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
                return Scrollbar(
                  child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          if (_formBloc.bloques != null &&
                              _formBloc.bloques.isNotEmpty &&
                              !(state is FormBlocRevisando))
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _formBloc.bloques.length,
                              itemBuilder: (context, i) {
                                final element = _formBloc.bloques[i];
                                if (element is Titulo) {
                                  return TituloCard(
                                    titulo: element.titulo,
                                    descripcion: element.descripcion,
                                  );
                                }
                                if (element is BloqueConPreguntaRespondidaExt) {
                                  return RespuestaCard(bloc: element.bloc);
                                }
                                if (element is PreguntaTipoCuadricula) {
                                  return Text("cuadricula"); //TODO
                                }
                              },
                            ),
                          if (state is FormBlocRevisando)
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _formBloc.bloques.length,
                              itemBuilder: (context, i) {
                                final element = _formBloc.bloques[i];
                                if (element is BloqueConPreguntaRespondidaExt &&
                                    element.bloc.criticidad > 0) {
                                  return RespuestaCard(bloc: element.bloc);
                                }
                                if (element is PreguntaTipoCuadricula) {
                                  return Text("cuadricula"); //TODO
                                }
                                return Container();
                              },
                            ),
                          SizedBox(height: 60),
                        ],
                      ),
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
              onPressed: () async {
                LoadingDialog.show(context);
                await _formBloc.guardarEnLocal(esBorrador: true);
                LoadingDialog.hide(context);
                Navigator.of(context).pop();

                /*Scaffold.of(ExtendedNavigator.of(context).parent.context)
                    .showSnackBar(SnackBar(
                  content: Text("Borrador guardado"),
                  duration: Duration(seconds: 3),
                ));*/
              },
            ),
            ActionButton(
              iconData: Icons.send,
              label: 'Enviar',
              onPressed: _formBloc.enviar,
            ),
          ],
        ),
      ),
    );
  }
}
