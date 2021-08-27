import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/presentation/pages/ayuda_screen.dart';
import 'package:inspecciones/presentation/widgets/images_picker.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'creacion_form_view_model.dart';

/// Reúne todos los widgets comunes a la creación o llenado de inspecciones.
///
/// Si varios tipos de preguntas usan los mismos Widgets, se pueden añadir aquí
//TODO: Refactorizar en llenado_card o creacion_card si hay algún widget que añadir
class PreguntaCard extends StatelessWidget {
  final Widget child;
  final String titulo;
  final String descripcion;
  final String posicion;

  /// Criticidad de la pregunta.
  final double criticidad;

  /// Para el mensaje de criticidad, puede ser total (Si la inspeccion esta finalizada) o parcial (en cualquier otro caso)
  final String estado;

  const PreguntaCard(
      {Key key,
      this.child,
      this.titulo,
      this.descripcion,
      this.criticidad,
      this.estado,
      this.posicion})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (titulo != null)
              Column(
                children: [
                  Text(
                    titulo,
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                  const Divider(
                    height: 10,
                    color: Colors.black,
                  ),
                ],
              ),
            const SizedBox(height: 5),
            if (posicion != null)
              Text(
                posicion,
                style: const TextStyle(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 5),
            if (descripcion != null)
              Text(
                descripcion,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            const SizedBox(height: 10),
            child,
            if (criticidad != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    criticidad > 0
                        ? Icons.warning_amber_rounded
                        : Icons.remove_red_eye,
                    color: criticidad > 0 ? Colors.red : Colors.green[200],
                    size: 25, /* color: Colors.white, */
                  ),
                  Text(
                    '$estado: ${criticidad.toStringAsFixed(1)}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// Recoge los widgets que son comunes a las preguntas: titulo, descripción, sistema y subsistema, posicion, criticidad y fortosGuia
class CamposComunes extends StatelessWidget {
  final FormGroup formGroup;
  final ValueNotifier<List<SubSistema>> subsistemas;
  final bool cuadricula;
  const CamposComunes(
      {Key key, this.formGroup, this.subsistemas, this.cuadricula})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CreacionFormViewModel>(context);
    return Column(
      children: [
        ReactiveTextField(
          formControl: formGroup.control('titulo') as FormControl,
          validationMessages: (control) =>
              {'required': 'El titulo no debe estar vacío'},
          decoration: const InputDecoration(
            labelText: 'Título',
          ),
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
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
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 10),

        /// Se puede elegir a que sistema está asociado la pregunta, dependiendo de ese sistema elegido, se cargan los subsistemas
        ValueListenableBuilder<List<Sistema>>(
          valueListenable: viewModel.sistemas,
          builder: (context, value, child) {
            return ReactiveDropdownField<Sistema>(
              formControl: formGroup.control('sistema') as FormControl,
              validationMessages: (control) =>
                  {'required': 'Seleccione el sistema'},
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
            valueListenable: subsistemas,
            builder: (context, value, child) {
              return ReactiveDropdownField<SubSistema>(
                formControl: formGroup.control('subSistema') as FormControl,
                validationMessages: (control) =>
                    {'required': 'Seleccione el subsistema'},
                items: value
                    .map((e) => DropdownMenuItem<SubSistema>(
                          value: e,
                          child: Text(e.nombre),
                        ))
                    .toList(),
                decoration: const InputDecoration(
                  labelText: 'Subsistema',
                ),
                onTap: () {
                  FocusScope.of(context)
                      .unfocus(); // para que no salte el teclado si tenia un textfield seleccionado
                },
              );
            }),
        const SizedBox(height: 5),
        const Divider(height: 15, color: Colors.black),
        Row(
          children: [
            const Expanded(
              flex: 3,
              child: Text(
                'Posición',
                textAlign: TextAlign.start,
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => AyudaPage()));
                },
                child: const Text(
                  '¿Necesitas ayuda?',
                  textAlign: TextAlign.end,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 5),
        ReactiveDropdownField<String>(
          formControl: formGroup.control('eje') as FormControl,
          validationMessages: (control) =>
              {'required': 'Este valor es requerido'},
          items: viewModel
              .ejes //TODO: definir si quemar estas opciones aqui o dejarlas en la DB
              .map((e) => DropdownMenuItem<String>(
                    value: e,
                    child: Text(e),
                  ))
              .toList(),
          decoration: const InputDecoration(
            labelText: 'Posición Y',
          ),
          onTap: () {
            FocusScope.of(context)
                .unfocus(); // para que no salte el teclado si tenia un textfield seleccionado
          },
        ),
        const SizedBox(height: 10),
        ReactiveDropdownField<String>(
          formControl: formGroup.control('lado') as FormControl,
          validationMessages: (control) =>
              {'required': 'Este valor es requerido'},
          items: viewModel
              .lados //TODO: definir si quemar estas opciones aqui o dejarlas en la DB
              .map((e) => DropdownMenuItem<String>(
                    value: e,
                    child: Text(e),
                  ))
              .toList(),
          decoration: const InputDecoration(
            labelText: 'Posición X',
          ),
          onTap: () {
            FocusScope.of(context)
                .unfocus(); // para que no salte el teclado si tenia un textfield seleccionado
          },
        ),
        const SizedBox(height: 10),
        ReactiveDropdownField<String>(
          formControl: formGroup.control('posicionZ') as FormControl,
          validationMessages: (control) =>
              {'required': 'Este valor es requerido'},
          items: viewModel
              .posZ //TODO: definir si quemar estas opciones aqui o dejarlas en la DB
              .map((e) => DropdownMenuItem<String>(
                    value: e,
                    child: Text(e),
                  ))
              .toList(),
          decoration: const InputDecoration(
            labelText: 'Posición Z',
          ),
          onTap: () {
            FocusScope.of(context)
                .unfocus(); // para que no salte el teclado si tenia un textfield seleccionado
          },
        ),
        const SizedBox(height: 10),
        if (cuadricula != null)
          Column(
            children: [
              InputDecorator(
                decoration: const InputDecoration(
                    labelText: 'Criticidad de la pregunta', filled: false),
                child: ReactiveSlider(
                  formControl:
                      formGroup.control('criticidad') as FormControl<double>,
                  max: 4,
                  divisions: 4,
                  labelBuilder: (v) => v.round().toString(),
                  activeColor: Colors.red,
                ),
              ),
              FormBuilderImagePicker(
                formArray: formGroup.control('fotosGuia') as FormArray<File>,
                decoration: const InputDecoration(
                  labelText: 'Fotos guía',
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
      ],
    );
  }
}
