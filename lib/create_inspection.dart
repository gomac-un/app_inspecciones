import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'action_button.dart';
import 'widget_pregunta.dart';

class CreateInspectionScreen extends StatelessWidget {
  const CreateInspectionScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AllFieldsForm(),
    );*/
    return AllFieldsForm();
  }
}

class RespuestaFieldBloc extends GroupFieldBloc {
  final TextFieldBloc texto;
  final TextFieldBloc criticidad;

  RespuestaFieldBloc({
    @required this.texto,
    @required this.criticidad,
    String name,
  }) : super([texto, criticidad], name: name);
}

class PreguntaFieldBloc extends GroupFieldBloc {
  final TextFieldBloc titulo;
  final TextFieldBloc descripcion;
  final TextFieldBloc criticidad;
  final SelectFieldBloc sistema;
  final SelectFieldBloc tiposDePregunta;

  /*final sistema = SelectFieldBloc(
      name: 'sistema', items: ['carroceria', 'direccion', 'motor']);*/

  /*final tiposDePregunta = SelectFieldBloc<String, dynamic>(
    name: 'tipoDePregunta',
    validators: [FieldBlocValidators.required],
    items: [
      'unicaRespuesta',
      'multipleRespuesta',
      'binaria',
      'fecha',
      'rangoNumerico',
    ],
  );*/
  final ListFieldBloc<RespuestaFieldBloc> respuestas;

  PreguntaFieldBloc({
    @required this.titulo,
    @required this.descripcion,
    @required this.criticidad,
    @required this.respuestas,
    this.sistema,
    this.tiposDePregunta,
    String name,
  }) : super([
          titulo,
          descripcion,
          criticidad,
          respuestas,
          sistema,
          tiposDePregunta,
        ], name: name) {
    //AddFieldBlocs(step: 0, fieldBlocs: [sistema, tiposDePregunta]); TODO: make this work
  }
}

class AllFieldsFormBloc extends FormBloc<String, String> {
  final nuevoTipoDeinspeccion = TextFieldBloc(name: 'nuevoTipoDeInspeccion');

  final tiposDeInspeccion = SelectFieldBloc(
    name: 'tipoDeInspeccion',
    validators: [FieldBlocValidators.required],
    items: [
      'Preoperacional',
      'Fugas lixiviado',
      'Prueba velocímetro',
      'otra',
    ],
  );

  final tiposDeActivo = MultiSelectFieldBloc<String, dynamic>(
    name: 'tipoDeActivo',
    items: [
      'doble troque',
      'moto',
      'van',
    ],
  );

  final periodicidad = TextFieldBloc(
    name: 'periodicidad',
    validators: [
      (String n) =>
          double.parse(n, (e) => null) != null ? null : "debe ser numerico"
    ],
  );
  final preguntas = ListFieldBloc<PreguntaFieldBloc>(name: 'preguntas');

  AllFieldsFormBloc() {
    addFieldBlocs(fieldBlocs: [
      tiposDeInspeccion,
      tiposDeActivo,
      periodicidad,
      preguntas
    ]);
    tiposDeInspeccion.onValueChanges(
      onData: (previous, current) async* {
        removeFieldBlocs(
          fieldBlocs: [
            nuevoTipoDeinspeccion,
          ],
        );

        if (current.value == 'otra') {
          addFieldBlocs(fieldBlocs: [
            nuevoTipoDeinspeccion,
          ]);
        }
      },
    );
  }

  void addPregunta() {
    preguntas.addFieldBloc(PreguntaFieldBloc(
      name: 'pregunta',
      titulo: TextFieldBloc(name: 'titulo'),
      descripcion: TextFieldBloc(name: 'descripcion'),
      criticidad: TextFieldBloc(name: 'criticidad'),
      respuestas: ListFieldBloc(name: 'respuestas'),
      sistema: SelectFieldBloc<String, dynamic>(
          name: 'sistema', items: ['carroceria', 'direccion', 'motor']),
      tiposDePregunta: SelectFieldBloc<String, dynamic>(
        name: 'tipoDePregunta',
        validators: [FieldBlocValidators.required],
        items: [
          'unicaRespuesta',
          'multipleRespuesta',
          'binaria',
          'fecha',
          'rangoNumerico',
        ],
      ),
    ));
  }

  void removePregunta(int index) {
    preguntas.removeFieldBlocAt(index);
  }

  void addRespuestaToPregunta(int preguntaIndex) {
    preguntas.value[preguntaIndex].respuestas.addFieldBloc(RespuestaFieldBloc(
      name: "respuesta",
      texto: TextFieldBloc(name: "texto"),
      criticidad: TextFieldBloc(name: "criticidad"),
    ));
  }

  void removeRespuestaFromPregunta(
      {@required int preguntaIndex, @required int respuestaIndex}) {
    preguntas.value[preguntaIndex].respuestas.removeFieldBlocAt(respuestaIndex);
  }

  @override
  void onSubmitting() async {
    try {
      await Future<void>.delayed(Duration(milliseconds: 500));

      emitSuccess(
        canSubmitAgain: true,
        successResponse: JsonEncoder.withIndent('    ').convert(
          state.toJson(),
        ),
      );
    } catch (e) {
      emitFailure();
    }
  }

  @override
  Future<void> close() {
    nuevoTipoDeinspeccion.close();
    return super.close();
  }
}

class AllFieldsForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AllFieldsFormBloc(),
      child: Builder(
        builder: (context) {
          final formBloc = BlocProvider.of<AllFieldsFormBloc>(context);

          return Scaffold(
            appBar: AppBar(title: Text('Creación de inspección')),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ActionButton(
                    iconData: Icons.archive,
                    label: 'Guardar borrador',
                    onPressed: () {},
                  ),
                  ActionButton(
                    iconData: Icons.send,
                    label: 'Enviar',
                    onPressed: () {
                      formBloc.submit();
                    },
                  ),
                ],
              ),
            ),
            body: FormBlocListener<AllFieldsFormBloc, String, String>(
              onSubmitting: (context, state) {
                LoadingDialog.show(context);
              },
              onSuccess: (context, state) {
                LoadingDialog.hide(context);
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(state.successResponse),
                  duration: Duration(seconds: 20),
                ));
                //Navigator.of(context).pushReplacement(
                //MaterialPageRoute(builder: (_) => SuccessScreen()));
              },
              onFailure: (context, state) {
                LoadingDialog.hide(context);

                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text(state.failureResponse)));
              },
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      PreguntaCreateForm(
                        textoPregunta: 'Tipo de inspección',
                        respuesta: Column(
                          children: [
                            RadioButtonGroupFieldBlocBuilder<String>(
                              selectFieldBloc: formBloc.tiposDeInspeccion,
                              decoration: InputDecoration(
                                labelText: 'Seleccione una opción',
                                prefixIcon: SizedBox(),
                              ),
                              itemBuilder: (context, item) => item,
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
                      PreguntaCreateForm(
                        textoPregunta: 'Tipos de vehiculo',
                        respuesta: CheckboxGroupFieldBlocBuilder<String>(
                          multiSelectFieldBloc: formBloc.tiposDeActivo,
                          itemBuilder: (context, item) => item,
                          decoration: InputDecoration(
                            labelText:
                                'Seleccione los tipos de vehiculo a los que aplica esta inspeccion',
                            prefixIcon: SizedBox(),
                          ),
                        ),
                      ),
                      PreguntaCreateForm(
                        textoPregunta: "Periodicidad",
                        respuesta: TextFieldBlocBuilder(
                          textFieldBloc: formBloc.periodicidad,
                          decoration: InputDecoration(
                            labelText: 'escriba la periodicidad en dias',
                            prefixIcon: Icon(Icons.filter_2),
                          ),
                        ),
                      ),
                      BlocBuilder<ListFieldBloc<PreguntaFieldBloc>,
                          ListFieldBlocState<PreguntaFieldBloc>>(
                        cubit: formBloc.preguntas,
                        builder: (context, state) {
                          if (state.fieldBlocs.isNotEmpty) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.fieldBlocs.length,
                              itemBuilder: (context, i) {
                                return PreguntaCard(
                                  preguntaIndex: i,
                                  preguntaField: state.fieldBlocs[i],
                                  onRemovePregunta: () =>
                                      formBloc.removePregunta(i),
                                  onAddRespuesta: () =>
                                      formBloc.addRespuestaToPregunta(i),
                                );
                              },
                            );
                          }
                          return Container();
                        },
                      ),
                      RaisedButton(
                        //color: Colors.blue[100],
                        onPressed: formBloc.addPregunta,
                        child: Text('agregar pregunta'),
                      ),
                      SizedBox(height: 60),
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

class PreguntaCard extends StatelessWidget {
  final int preguntaIndex;
  final PreguntaFieldBloc preguntaField;

  final VoidCallback onRemovePregunta;
  final VoidCallback onAddRespuesta;

  const PreguntaCard({
    Key key,
    @required this.preguntaIndex,
    @required this.preguntaField,
    @required this.onRemovePregunta,
    @required this.onAddRespuesta,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      //color: Colors.blue[100],
      //margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Pregunta #${preguntaIndex + 1}',
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: onRemovePregunta,
                ),
              ],
            ),
            TextFieldBlocBuilder(
              textFieldBloc: preguntaField.titulo,
              decoration: InputDecoration(
                labelText: 'Titulo',
              ),
            ),
            TextFieldBlocBuilder(
              textFieldBloc: preguntaField.descripcion,
              decoration: InputDecoration(
                labelText: 'Descripcion',
              ),
            ),
            DropdownFieldBlocBuilder<String>(
              selectFieldBloc: preguntaField.tiposDePregunta,
              decoration: InputDecoration(
                labelText: 'Tipo de respuesta',
                prefixIcon: SizedBox(),
              ),
              itemBuilder: (context, item) => item,
            ),
            RadioButtonGroupFieldBlocBuilder<String>(
              selectFieldBloc: preguntaField.sistema,
              decoration: InputDecoration(
                labelText: 'Seleccione un sistema',
                prefixIcon: SizedBox(),
              ),
              itemBuilder: (context, item) => item,
            ),
            TextFieldBlocBuilder(
              textFieldBloc: preguntaField.criticidad,
              decoration: InputDecoration(
                labelText: 'criticidad',
              ),
            ),
            Text(
              'Foto guia',
              style: TextStyle(color: Colors.red),
            ),
            BlocBuilder<ListFieldBloc<RespuestaFieldBloc>,
                ListFieldBlocState<RespuestaFieldBloc>>(
              cubit: preguntaField.respuestas,
              builder: (context, state) {
                if (state.fieldBlocs.isNotEmpty) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: state.fieldBlocs.length,
                    itemBuilder: (context, i) {
                      final respuestaFieldBloc = state.fieldBlocs[i];
                      return Card(
                        //color: Colors.blue[50],
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFieldBlocBuilder(
                                textFieldBloc: respuestaFieldBloc.texto,
                                decoration: InputDecoration(
                                  labelText: 'Respuesta #${i + 1}',
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextFieldBlocBuilder(
                                textFieldBloc: respuestaFieldBloc.criticidad,
                                decoration: InputDecoration(
                                  labelText: 'criticidad',
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () =>
                                  preguntaField.respuestas.removeFieldBlocAt(i),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
                return Container();
              },
            ),
            RaisedButton(
              //color: Colors.white,
              onPressed: onAddRespuesta,
              child: Text('agregar respuesta'),
            ),
          ],
        ),
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
              'Success',
              style: TextStyle(fontSize: 54, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            RaisedButton.icon(
              onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => AllFieldsForm())),
              icon: Icon(Icons.replay),
              label: Text('AGAIN'),
            ),
          ],
        ),
      ),
    );
  }
}
