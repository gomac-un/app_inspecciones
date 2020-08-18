import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'action_button.dart';
import 'widget_pregunta.dart';

class InspeccionScreen extends StatelessWidget {
  const InspeccionScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AllFieldsForm(),
    );*/
    return AllFieldsForm();
  }
}

class AllFieldsFormBloc extends FormBloc<String, String> {
  final text1 = TextFieldBloc();

  final boolean1 = BooleanFieldBloc();

  final boolean2 = BooleanFieldBloc();

  final select1 = SelectFieldBloc(
    items: ['Option 1', 'Option 2'],
  );

  final select2 = SelectFieldBloc(
    items: [
      'Opción 1',
      'Opción 2',
      'Opción 3',
      'Opción 4',
    ],
  );

  final multiSelect1 = MultiSelectFieldBloc<String, dynamic>(
    items: [
      'Opción 1',
      'Opción 2',
      'Opción 3',
      'Opción 4',
    ],
  );

  final date1 = InputFieldBloc<DateTime, Object>();

  final dateAndTime1 = InputFieldBloc<DateTime, Object>();

  final time1 = InputFieldBloc<TimeOfDay, Object>();

  AllFieldsFormBloc() {
    addFieldBlocs(fieldBlocs: [
      text1,
      boolean1,
      boolean2,
      select1,
      select2,
      multiSelect1,
      date1,
      dateAndTime1,
      time1,
    ]);
  }

  @override
  void onSubmitting() async {
    try {
      await Future<void>.delayed(Duration(milliseconds: 500));

      emitSuccess(canSubmitAgain: true);
    } catch (e) {
      emitFailure();
    }
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
            appBar:
                AppBar(title: Text('Preoperacional - doble troque (grupo)')),
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
                    onPressed: () {
                      null;
                    },
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Motor',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      PreguntaForm(
                        textoPregunta: 'Texto de la pregunta 1',
                        respuesta: TextFieldBlocBuilder(
                          textFieldBloc: formBloc.text1,
                          decoration: InputDecoration(
                            labelText: 'Respuesta tipo texto',
                            prefixIcon: Icon(Icons.text_fields),
                          ),
                        ),
                      ),
                      PreguntaForm(
                        textoPregunta: 'Texto de la pregunta 2',
                        respuesta: DropdownFieldBlocBuilder<String>(
                          selectFieldBloc: formBloc.select1,
                          decoration: InputDecoration(
                            labelText: 'Selector único',
                            prefixIcon: Icon(Icons.sentiment_satisfied),
                          ),
                          itemBuilder: (context, value) => value,
                        ),
                      ),
                      PreguntaForm(
                        textoPregunta: 'Texto pregunta 3',
                        respuesta: RadioButtonGroupFieldBlocBuilder<String>(
                          selectFieldBloc: formBloc.select2,
                          decoration: InputDecoration(
                            labelText: 'Seleccione una opción',
                            prefixIcon: SizedBox(),
                          ),
                          itemBuilder: (context, item) => item,
                        ),
                      ),
                      PreguntaForm(
                        textoPregunta: 'Texto Pregunta 4',
                        respuesta: CheckboxGroupFieldBlocBuilder<String>(
                          multiSelectFieldBloc: formBloc.multiSelect1,
                          itemBuilder: (context, item) => item,
                          decoration: InputDecoration(
                            labelText: 'Seleccione varias opciones',
                            prefixIcon: SizedBox(),
                          ),
                        ),
                      ),
                      DateTimeFieldBlocBuilder(
                        dateTimeFieldBloc: formBloc.date1,
                        format: DateFormat('dd-mm-yyyy'),
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                        decoration: InputDecoration(
                          labelText: 'Solo fecha',
                          prefixIcon: Icon(Icons.calendar_today),
                          helperText: 'Date',
                        ),
                      ),
                      DateTimeFieldBlocBuilder(
                        dateTimeFieldBloc: formBloc.dateAndTime1,
                        canSelectTime: true,
                        format: DateFormat('dd-mm-yyyy  hh:mm'),
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                        decoration: InputDecoration(
                          labelText: 'fecha y hora',
                          prefixIcon: Icon(Icons.date_range),
                          helperText: 'Date and Time',
                        ),
                      ),
                      TimeFieldBlocBuilder(
                        timeFieldBloc: formBloc.time1,
                        format: DateFormat('hh:mm a'),
                        initialTime: TimeOfDay.now(),
                        decoration: InputDecoration(
                          labelText: 'solo hora',
                          prefixIcon: Icon(Icons.access_time),
                        ),
                      ),
                      SwitchFieldBlocBuilder(
                        booleanFieldBloc: formBloc.boolean2,
                        body: Container(
                          alignment: Alignment.centerLeft,
                          child: Text('Activar opción'),
                        ),
                      ),
                      CheckboxFieldBlocBuilder(
                        booleanFieldBloc: formBloc.boolean1,
                        body: Container(
                          alignment: Alignment.centerLeft,
                          child: Text('funciona correctamente?'),
                        ),
                      ),
                      SizedBox(height: 30),
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
