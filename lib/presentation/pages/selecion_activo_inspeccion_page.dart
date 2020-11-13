import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import 'package:inspecciones/infrastructure/moor_database_llenado.dart';

import 'package:inspecciones/application/crear_cuestionario_form/llenar_cuestionario_form_bloc.dart';
import 'package:inspecciones/presentation/widgets/pregunta_quemada.dart';

import 'package:inspecciones/presentation/widgets/widgets.dart';
import 'package:inspecciones/presentation/widgets/llenado_widgets.dart';
import 'package:inspecciones/presentation/widgets/action_button.dart';

class SeleccionActivoInspeccionPage extends StatelessWidget {
  SeleccionActivoInspeccionPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final formBloc = BlocProvider.of<LlenarCuestionarioFormBloc>(context);
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(title: Text('Llenado de inspección')),
      body: FormBlocListener<LlenarCuestionarioFormBloc, String, String>(
        onSubmitting: (context, state) {
          LoadingDialog.show(context);
        },
        onSuccess: (context, state) {
          LoadingDialog.hide(context);
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(state.successResponse),
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
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                //InputFieldBloc();
                /*
                      CanShowFieldBlocBuilder(
                        //TODO: usarlo para crear el widget de fotos
                        fieldBloc: formBloc.nuevoTipoDeinspeccion,
                        builder: (context, canShow) {
                          return Text('Conditional Label $canShow');
                        },
                      ),*/
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

                PreguntaQuemada(
                  textoPregunta: "ID del vehiculo",
                  respuesta: TextFieldBlocBuilder(
                    textFieldBloc: formBloc.vehiculo,
                    decoration: InputDecoration(
                      labelText: 'Escriba el ID del vehiculo',
                      prefixIcon: Icon(Icons.directions_car),
                    ),
                  ),
                ),
                PreguntaQuemada(
                  textoPregunta: 'Tipo de inspección',
                  respuesta:
                      RadioButtonGroupFieldBlocBuilder<CuestionarioDeModelo>(
                    selectFieldBloc: formBloc.tiposDeInspeccion,
                    decoration: InputDecoration(
                      labelText: 'Seleccione una opción',
                      prefixIcon: SizedBox(),
                      border: InputBorder.none,
                    ),
                    itemBuilder: (context, item) => item.tipoDeInspeccion,
                  ),
                ),

                BlocBuilder<SelectFieldBloc, SelectFieldBlocState>(
                  cubit: formBloc.tiposDeInspeccion,
                  builder: (context, state) {
                    if (state.extraData != null && state.extraData.isNotEmpty) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.extraData.length,
                        itemBuilder: (context, i) {
                          if ((state.extraData[i]
                                      as BloqueConPreguntaRespondida)
                                  .pregunta ==
                              null) {
                            return TituloCard(bloque: state.extraData[i]);
                          } else {
                            return RespuestaCard(
                                bloc: formBloc.blocsRespuestas[i]);
                          }
                        },
                      );
                    }
                    return Container();
                  },
                ),
                SizedBox(height: 60),
              ],
            ),
          ),
        ),
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
              onPressed: formBloc.submit,
            ),
            ActionButton(
              iconData: Icons.send,
              label: 'Enviar',
              onPressed: () {
                formBloc.finalizarInspeccion();
              },
            ),
          ],
        ),
      ),
    );
  }
}
