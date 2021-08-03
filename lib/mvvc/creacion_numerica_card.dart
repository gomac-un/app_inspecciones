import 'dart:io';
import 'package:flutter/material.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/mvvc/creacion_controls.dart';
import 'package:inspecciones/mvvc/creacion_form_view_model.dart';
import 'package:inspecciones/presentation/pages/ayuda_screen.dart';
import 'package:inspecciones/presentation/widgets/images_picker.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Intento de unificar los campos de las preguntas numericas y de selección.
///
/// En este momento usado para la pregunta numerica.
class TipoPreguntaCard extends StatelessWidget {
  /// Validaciones.
  final CreadorPreguntaNumericaFormGroup formGroup;

  const TipoPreguntaCard({Key key, this.formGroup}) : super(key: key);
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
            labelText: 'Titulo',
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
            valueListenable: formGroup.subSistemas,
            builder: (context, value, child) {
              return ReactiveDropdownField<SubSistema>(
                formControl: formGroup.control('subSistema') as FormControl,
                validationMessages: (control) =>
                    {'required': 'Seleccione un subsistema'},
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
        InputDecorator(
          decoration: const InputDecoration(
              labelText: 'Criticidad de la pregunta', filled: false),
          child: ReactiveSlider(
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

/// Widget usado para añadir rangos de criticidad a las preguntas numericas
class CriticidadCard extends StatelessWidget {
  const CriticidadCard({
    Key key,
    @required this.formGroup,
  }) : super(key: key);

  final Numerica formGroup;

  @override
  Widget build(BuildContext context) {
    /// Como los rangos se van añadiendo dinámicamente, este  ReactiveValueListenableBuilder escucha, por decirlo asi,
    /// el length del 'criticidadRespuesta' respuestas [formControl], así cada que se va añadiendo una criticidad, se muestra el nuevo widget en la UI
    return ReactiveValueListenableBuilder(
        formControl: (formGroup as FormGroup).control('criticidadRespuesta'),
        builder: (context, control, child) {
          return Column(
            children: [
              ExpansionTile(
                title: Text(
                  'Criticidad de las respuestas',
                  style: Theme.of(context).textTheme.headline6,
                ),
                childrenPadding: const EdgeInsets.all(5.0),
                children: [
                  Text(
                    'La criticidad de la respuesta está dada por rangos. Empiece con el menor rango posible hasta llegar al máximo.',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.subtitle1,
                      children: const <TextSpan>[
                        TextSpan(
                            text: 'Por ejemplo:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text:
                                ' Si el minimo valor que puede tomar la respuesta es -100, empiece a llenar los valores así [-100,0), [0,50), [50,100), etc.'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              if (control.invalid)
                Text(
                  control.errors.entries.first.key,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 10),
              if ((control as FormArray).controls.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: (control as FormArray).controls.length,
                  itemBuilder: (context, i) {
                    final element = (control as FormArray).controls[i]
                        as CreadorCriticidadesNumericas;
                    //Las keys sirven para que flutter maneje correctamente los widgets de la lista
                    return Column(
                      key: ValueKey(element),
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ReactiveTextField(
                                keyboardType: TextInputType.number,
                                formControl:
                                    element.control('minimo') as FormControl,
                                validationMessages: (control) =>
                                    {'required': 'Este valor es requerido'},
                                decoration: const InputDecoration(
                                  labelText: 'Valor Minimo',
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: ReactiveTextField(
                                  keyboardType: TextInputType.number,
                                  formControl:
                                      element.control('maximo') as FormControl,
                                  validationMessages: (control) => {
                                    'required': 'Este valor es requerido',
                                    'verificarRango': 'El valor debe ser mayor'
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Valor Máximo',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: ReactiveSlider(
                                formControl: element.control('criticidad')
                                    as FormControl<double>,
                                max: 4,
                                divisions: 4,
                                labelBuilder: (v) => v.round().toString(),
                                activeColor: Colors.red,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              tooltip: 'Borrar respuesta',
                              onPressed: () =>
                                  formGroup.borrarCriticidad(element),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              OutlineButton(
                onPressed: () {
                  formGroup.agregarCriticidad();
                  control.markAsTouched();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.add),
                    Text("Agregar Rango"),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
