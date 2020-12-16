import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:inspecciones/application/crear_cuestionario_form/pregunta_field_bloc.dart';
import 'package:inspecciones/application/crear_cuestionario_form/respuesta_field_bloc.dart';
import 'package:inspecciones/domain/core/enums.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'images_picker.dart';
import 'package:inspecciones/application/crear_cuestionario_form/bloque_field_bloc.dart';
import 'package:inspecciones/application/crear_cuestionario_form/crear_cuestionario_app.dart';

class CrearPreguntaCard extends StatelessWidget {
  final int preguntaIndex;
  final PreguntaFieldBloc preguntaField;

  final VoidCallback onRemovePregunta;
  final VoidCallback onAddRespuesta;

  const CrearPreguntaCard({
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
            DropdownFieldBlocBuilder<Sistema>(
              selectFieldBloc: preguntaField.sistema,
              decoration: InputDecoration(
                labelText: 'Seleccione un sistema',
                prefixIcon: SizedBox(),
              ),
              itemBuilder: (context, item) => item.nombre,
            ),
            DropdownFieldBlocBuilder<SubSistema>(
              selectFieldBloc: preguntaField.subsistema,
              decoration: InputDecoration(
                labelText: 'Seleccione un subsistema',
                prefixIcon: SizedBox(),
              ),
              itemBuilder: (context, item) => item.nombre,
            ),
            DropdownFieldBlocBuilder<String>(
              selectFieldBloc: preguntaField.posicion,
              decoration: InputDecoration(
                labelText: 'Seleccione una posicion',
                prefixIcon: SizedBox(),
              ),
              itemBuilder: (context, item) => item,
            ),
            DropdownFieldBlocBuilder<int>(
              selectFieldBloc: preguntaField.criticidad,
              decoration: InputDecoration(
                labelText: 'criticidad pregunta',
                prefixIcon: SizedBox(),
              ),
              itemBuilder: (context, item) => item.toString(),
            ),
            FormBuilderImagePicker(
              imagenesFieldBlocs: preguntaField.imagenes,
              decoration: const InputDecoration(
                labelText: 'Fotos guia',
              ),
            ),
            DropdownFieldBlocBuilder<TipoDePregunta>(
              selectFieldBloc: preguntaField.tiposDePregunta,
              decoration: InputDecoration(
                labelText: 'Tipo de respuesta',
                prefixIcon: SizedBox(),
              ),
              itemBuilder: (context, item) => item.toString().split(".").last,
            ),
            BlocBuilder<SelectFieldBloc, SelectFieldBlocState>(
              cubit: preguntaField.tiposDePregunta,
              builder: (context, state) {
                if (state.value == TipoDePregunta.unicaRespuesta ||
                    state.value == TipoDePregunta.multipleRespuesta) {
                  return Column(
                    children: [
                      RespuestasWidget(preguntaField: preguntaField),
                      RaisedButton(
                        //color: Colors.white,
                        onPressed: onAddRespuesta,
                        child: Text('agregar respuesta'),
                      ),
                    ],
                  );
                } else if (state.value == TipoDePregunta.rangoNumerico) {
                  return Column(
                    children: [
                      Text('Valores para la criticidad'),
                      TextFieldBlocBuilder(
                        textFieldBloc: preguntaField.valorMedio,
                        decoration: InputDecoration(
                          labelText: 'escriba el valor medio',
                          prefixIcon: Icon(Icons.filter_2),
                        ),
                      ),
                      TextFieldBlocBuilder(
                        textFieldBloc: preguntaField.limiteInferior,
                        decoration: InputDecoration(
                          labelText: 'escriba el limite inferior',
                          prefixIcon: Icon(Icons.filter_2),
                        ),
                      ),
                      TextFieldBlocBuilder(
                        textFieldBloc: preguntaField.limiteSuperior,
                        decoration: InputDecoration(
                          labelText: 'escriba el limite superior',
                          prefixIcon: Icon(Icons.filter_2),
                        ),
                      ),
                    ],
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class RespuestasWidget extends StatelessWidget {
  final PreguntaFieldBloc preguntaField;
  RespuestasWidget({
    Key key,
    @required this.preguntaField,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListFieldBloc<OpcionDeRespuestaFieldBloc>,
        ListFieldBlocState<OpcionDeRespuestaFieldBloc>>(
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
                      child: DropdownFieldBlocBuilder<int>(
                        selectFieldBloc: respuestaFieldBloc.criticidad,
                        decoration: InputDecoration(
                          labelText: 'criticidad',
                          prefixIcon: SizedBox(),
                        ),
                        itemBuilder: (context, item) => item.toString(),
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
    );
  }
}

class CrearTituloCard extends StatelessWidget {
  final int bloqueIndex;
  final BloqueFieldBloc bloqueField;

  final VoidCallback onRemoveBloque;

  const CrearTituloCard(
      {Key key,
      @required this.bloqueIndex,
      @required this.bloqueField,
      @required this.onRemoveBloque})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: TextFieldBlocBuilder(
                    textFieldBloc: bloqueField.titulo,
                    style: Theme.of(context).textTheme.headline5,
                    decoration: InputDecoration(
                      labelText: 'Titulo',
                      labelStyle: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: onRemoveBloque,
                ),
              ],
            ),
            TextFieldBlocBuilder(
              textFieldBloc: bloqueField.descripcion,
              decoration: InputDecoration(
                labelText: 'Descripcion',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
