import 'dart:io';
import 'package:flutter/material.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/mvvc/creacion_controls.dart';
import 'package:inspecciones/mvvc/creacion_form_view_model.dart';
import 'package:inspecciones/presentation/widgets/images_picker.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class PreguntaCard extends StatelessWidget {
  final Widget child;
  final String titulo;
  final String descripcion;

  const PreguntaCard({Key key, this.child, this.titulo, this.descripcion})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (titulo != null)
              Text(
                titulo,
                style: Theme.of(context).textTheme.headline6,
              ),
            if (descripcion != null)
              Text(
                descripcion,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}

class TipoPreguntaCard extends StatelessWidget {
  final CreadorPreguntaNumericaFormGroup formGroup;

  const TipoPreguntaCard({Key key, this.formGroup}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CreacionFormViewModel>(context);
    return Column(
      children: [
        ReactiveTextField(
          formControl: formGroup.control('titulo') as FormControl,
          decoration: const InputDecoration(
            labelText: 'Titulo',
          ),
        ),
        const SizedBox(height: 10),
        ReactiveTextField(
          formControl: formGroup.control('descripcion') as FormControl,
          decoration: const InputDecoration(
            labelText: 'Descripción',
          ),
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 50,
        ),
        const SizedBox(height: 10),
        ValueListenableBuilder<List<Sistema>>(
          valueListenable: viewModel.sistemas,
          builder: (context, value, child) {
            return ReactiveDropdownField<Sistema>(
              formControl: formGroup.control('sistema') as FormControl,
              items: value
                  .map((e) => DropdownMenuItem<Sistema>(
                        value: e,
                        child: Text(e.nombre),
                      ))
                  .toList(),
              decoration: const InputDecoration(
                labelText: 'Sistema',
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        ValueListenableBuilder<List<SubSistema>>(
            valueListenable: formGroup.subSistemas,
            builder: (context, value, child) {
              return ReactiveDropdownField<SubSistema>(
                formControl: formGroup.control('subSistema') as FormControl,
                items: value
                    .map((e) => DropdownMenuItem<SubSistema>(
                          value: e,
                          child: Text(e.nombre),
                        ))
                    .toList(),
                decoration: const InputDecoration(
                  labelText: 'Subsistema',
                ),
              );
            }),
        const SizedBox(height: 10),
        ReactiveDropdownField<String>(
          formControl: formGroup.control('posicion') as FormControl,
          items: [
            "no aplica",
            "adelante",
            "atras"
          ] //TODO: definir si quemar estas opciones aqui o dejarlas en la DB
              .map((e) => DropdownMenuItem<String>(
                    value: e,
                    child: Text(e),
                  ))
              .toList(),
          decoration: const InputDecoration(
            labelText: 'Posicion',
          ),
        ),
        InputDecorator(
          decoration:
              const InputDecoration(labelText: 'criticidad', filled: false),
          child: ReactiveSlider(
            //TODO: consultar de nuevo como se manejara la criticad

            formControl: formGroup.control('criticidad') as FormControl<double>,
            max: 4,
            divisions: 4,
            labelBuilder: (v) => v.round().toString(),
            activeColor: Colors.red,
          ),
        ),
        FormBuilderImagePicker(
          formArray: formGroup.control('fotosGuia') as FormArray<File>,
          decoration: const InputDecoration(
            labelText: 'Fotos guia',
          ),
        ),
      ],
    );
  }
}
