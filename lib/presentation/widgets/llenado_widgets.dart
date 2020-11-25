import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:inspecciones/application/crear_cuestionario_form/respuesta_field_bloc.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'images_picker.dart';

class RespuestaCard extends StatelessWidget {
  final RespuestaFieldBloc bloc;

  const RespuestaCard({Key key, this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    final String titulo = bloc.bloque.bloque.titulo;
    final String descripcion = bloc.bloque.bloque.descripcion;

    return Card(
      //margin: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              titulo,
              style: textTheme.headline6,
            ),
          ),
          Text(
            descripcion,
            style: textTheme.bodyText2,
          ),
          Image.file(File(bloc.bloque.pregunta.fotosGuia.first)),
          if (bloc.respuestas is SelectFieldBloc)
            DropdownFieldBlocBuilder(
              selectFieldBloc: bloc.respuestas,
              decoration: InputDecoration(
                labelText: 'Seleccione una opción',
                prefixIcon: SizedBox(),
              ),
              itemBuilder: (context, item) => item.texto,
            ),
          if (bloc.respuestas is MultiSelectFieldBloc)
            CheckboxGroupFieldBlocBuilder(
              multiSelectFieldBloc: bloc.respuestas,
              decoration: InputDecoration(
                labelText: 'Seleccione una o varias',
                prefixIcon: SizedBox(),
              ),
              itemBuilder: (context, item) => item.texto,
            ),
          //TODO: otras respuestas
          TextFieldBlocBuilder(
            textFieldBloc: bloc.observacion,
            decoration: InputDecoration(
              labelText: 'Observaciones',
              prefixIcon: Icon(Icons.remove_red_eye),
            ),
            keyboardType: TextInputType.multiline,
            maxLines: null,
          ),
          CheckboxFieldBlocBuilder(
            booleanFieldBloc: bloc.novedad,
            body: Text('Novedad'),
          ),
          //TODO: mostrar esto solo despues de terminar la inspeccion
          BlocBuilder(
            cubit: bloc.novedad,
            builder: (ctx, state) {
              if (state.value) {
                return TextFieldBlocBuilder(
                  textFieldBloc: bloc.observacionReparacion,
                  decoration: InputDecoration(
                    labelText: 'Observaciones de la reparación',
                    prefixIcon: Icon(Icons.remove_red_eye),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                );
              } else {
                return SizedBox();
              }
            },
          ),
          FormBuilderImagePicker(
            imagenesFieldBlocs: bloc.fotosBase,
            decoration: const InputDecoration(
              labelText: 'Fotos base',
            ),
          ),
          FormBuilderImagePicker(
            imagenesFieldBlocs: bloc.fotosReparacion,
            decoration: const InputDecoration(
              labelText: 'Fotos Reparacion',
            ),
          ),
        ],
      ),
    );
  }
}

class TituloCard extends StatelessWidget {
  final BloqueConPreguntaRespondida bloque;

  const TituloCard({Key key, this.bloque}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).primaryTextTheme;
    return Card(
      color: Theme.of(context).dividerColor,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              bloque.bloque.titulo,
              style: textTheme.headline5,
            ),
            Text(
              bloque.bloque.descripcion,
              style: textTheme.bodyText2,
            ),
          ],
        ),
      ),
    );
  }
}
