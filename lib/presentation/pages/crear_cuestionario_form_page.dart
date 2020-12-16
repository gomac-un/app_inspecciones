import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:inspecciones/application/crear_cuestionario_form/bloque_field_bloc.dart';

import 'package:inspecciones/application/crear_cuestionario_form/crear_cuestionario_app.dart';
import 'package:inspecciones/application/crear_cuestionario_form/crear_cuestionario_form_bloc.dart';
import 'package:inspecciones/application/crear_cuestionario_form/pregunta_field_bloc.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';

import 'package:inspecciones/presentation/widgets/pregunta_quemada.dart';

import 'package:inspecciones/presentation/widgets/widgets.dart';

import '../widgets/creacion_widgets.dart';
import '../widgets/llenado_widgets.dart';

import '../widgets/action_button.dart';

class CrearCuestionarioFormPage extends StatelessWidget {
  const CrearCuestionarioFormPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final formBloc = BlocProvider.of<CrearCuestionarioFormBloc>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: Text('Creación de inspección')),
      body: FormBlocListener<CrearCuestionarioFormBloc, String, String>(
        onSubmitting: (context, state) {
          LoadingDialog.show(context);
        },
        onSuccess: (context, state) {
          LoadingDialog.hide(context);
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(state.successResponse),
            duration: Duration(seconds: 3),
          ));
          Navigator.of(context).pop();
          //Navigator.of(context).pushReplacement(
          //MaterialPageRoute(builder: (_) => SuccessScreen()));
        },
        onFailure: (context, state) {
          LoadingDialog.hide(context);

          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Error: ' + state.failureResponse),
            duration: Duration(seconds: 20),
          ));
        },
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                PreguntaQuemada(
                  textoPregunta: 'Tipo de inspección',
                  respuesta: Column(
                    children: [
                      RadioButtonGroupFieldBlocBuilder<String>(
                        selectFieldBloc: formBloc.tiposDeInspeccion,
                        decoration: InputDecoration(
                          labelText: 'Seleccione una opción',
                          prefixIcon: SizedBox(),
                          border: InputBorder.none,
                        ),
                        itemBuilder: (context, item) => item.toString(),
                      ),
                      TextFieldBlocBuilder(
                        textFieldBloc: formBloc.nuevoTipoDeinspeccion,
                        decoration: InputDecoration(
                          labelText: 'escriba el tipo de inspeccion',
                          prefixIcon: Icon(Icons.text_fields),
                        ),
                      ),
                    ],
                  ),
                ),
                PreguntaQuemada(
                  textoPregunta: 'Modelos de vehiculo',
                  respuesta: CheckboxGroupFieldBlocBuilder<String>(
                    multiSelectFieldBloc: formBloc.clasesDeModelos,
                    itemBuilder: (context, item) => item.toString(),
                    decoration: InputDecoration(
                      hintText:
                          'Seleccione los modelos de vehiculo \n a los que aplica esta inspeccion',
                      hintStyle: new TextStyle(
                        fontSize: 18.0,
                        color: new Color(0xFF18776A),
                      ),
                      prefixIcon: SizedBox(),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                PreguntaQuemada(
                  textoPregunta: 'Contratista',
                  respuesta: DropdownFieldBlocBuilder<Contratista>(
                    selectFieldBloc: formBloc.contratista,
                    decoration: InputDecoration(
                      labelText: 'Seleccione el contratista autorizado',
                      prefixIcon: SizedBox(),
                    ),
                    itemBuilder: (context, item) => item.nombre,
                  ),
                ),
                PreguntaQuemada(
                  textoPregunta: "Periodicidad",
                  respuesta: TextFieldBlocBuilder(
                    textFieldBloc: formBloc.periodicidad,
                    decoration: InputDecoration(
                      labelText: 'escriba la periodicidad en dias',
                      prefixIcon: Icon(Icons.filter_2),
                    ),
                  ),
                ),
                BlocBuilder<ListFieldBloc<BloqueFieldBloc>,
                    ListFieldBlocState<BloqueFieldBloc>>(
                  cubit: formBloc.bloques,
                  builder: (context, state) {
                    if (state.fieldBlocs.isNotEmpty) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.fieldBlocs.length,
                        itemBuilder: (context, i) {
                          if (state.fieldBlocs[i] is PreguntaFieldBloc) {
                            return CrearPreguntaCard(
                              preguntaIndex: i,
                              preguntaField: state.fieldBlocs[i],
                              onRemovePregunta: () => formBloc.removeBloque(i),
                              onAddRespuesta: () =>
                                  formBloc.addRespuestaToPregunta(i),
                            );
                          } else /*if (state.fieldBlocs[i] is BloqueFieldBloc)*/ {
                            return CrearTituloCard(
                              bloqueIndex: i,
                              bloqueField: state.fieldBlocs[i],
                              onRemoveBloque: () => formBloc.removeBloque(i),
                            );
                          }
                        },
                      );
                    }
                    return Container();
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: formBloc.addPregunta,
                      child: Text('agregar pregunta'),
                    ),
                    RaisedButton(
                      onPressed: formBloc.addTitulo,
                      child: Text('agregar Título'),
                    ),
                  ],
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
              onPressed: () {
                formBloc.submit();
              },
            ),
            ActionButton(
              iconData: Icons.send,
              label: 'Enviar',
              onPressed: () {
                print("TODO");
              },
            ),
          ],
        ),
      ),
    );
  }
}
