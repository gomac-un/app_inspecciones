import 'dart:io';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/mvvc/common_widgets.dart';
import 'package:inspecciones/mvvc/creacion_controls.dart';
import 'package:inspecciones/mvvc/creacion_cuadricula_card.dart';
import 'package:inspecciones/mvvc/creacion_form_view_model.dart';
import 'package:inspecciones/mvvc/creacion_numerica_card.dart';
import 'package:inspecciones/presentation/widgets/images_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

//TODO: Unificar las cosas en común de los dos tipos de pregunta: las de seleccion y la numéricas.
class CreadorTituloCard extends StatelessWidget {
  final CreadorTituloFormGroup formGroup;
  final int nro;
  const CreadorTituloCard({Key key, this.formGroup, this.nro})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      //TODO: destacar mejor los titulos
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Theme.of(context).accentColor, width: 2.0),
          borderRadius: BorderRadius.circular(4.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ReactiveTextField(
              style: Theme.of(context).textTheme.headline5,
              formControl: formGroup.control('titulo') as FormControl,
              validationMessages: (control) =>
                  {'required': 'El titulo no debe ser vacío'},
              decoration: const InputDecoration(
                labelText: 'Titulo',
              ),
            ),
            const SizedBox(height: 10),
            ReactiveTextField(
              style: Theme.of(context).textTheme.bodyText2,
              formControl: formGroup.control('descripcion') as FormControl,
              decoration: const InputDecoration(
                labelText: 'Descripción',
              ),
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 50,
            ),
            BotonesDeBloque(
              formGroup: formGroup,
              nro: nro,
            ),
          ],
        ),
      ),
    );
  }
}

class CreadorNumericaCard extends StatelessWidget {
  final CreadorPreguntaNumericaFormGroup formGroup;
  final int nro;

  const CreadorNumericaCard({Key key, this.formGroup, this.nro})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreguntaCard(
        titulo: 'Pregunta numérica',
        child: Column(
          children: [
            TipoPreguntaCard(formGroup: formGroup),
            const SizedBox(height: 20),
            CriticidadCard(formGroup: formGroup),
            const SizedBox(height: 20),
            BotonesDeBloque(formGroup: formGroup, nro: nro),
          ],
        ));
  }
}

class CreadorSeleccionSimpleCard extends StatelessWidget {
  final CreadorPreguntaFormGroup formGroup;
  final int nro;

  const CreadorSeleccionSimpleCard({Key key, this.formGroup, this.nro})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CreacionFormViewModel>(context);
    return PreguntaCard(
      titulo: 'Pregunta de selección',
      child: Column(
        children: [
          ReactiveTextField(
            formControl: formGroup.control('titulo') as FormControl,
            validationMessages: (control) =>
                {'required': 'El titulo no debe estar vacío'},
            decoration: const InputDecoration(
              labelText: 'Título',
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
                );
              }),
          const SizedBox(height: 10),
          ReactiveDropdownField<String>(
            formControl: formGroup.control('posicion') as FormControl,
            items: [
              "No aplica",
              "Adelante",
              "Atrás"
            ] //TODO: definir si quemar estas opciones aqui o dejarlas en la DB
                .map((e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),
                    ))
                .toList(),
            decoration: const InputDecoration(
              labelText: 'Posición',
            ),
          ),
          InputDecorator(
            decoration: const InputDecoration(
                labelText: 'Criticidad de la pregunta', filled: false),
            child: ReactiveSlider(
              //TODO: consultar de nuevo como se manejara la criticad

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
          ReactiveDropdownField<TipoDePregunta>(
            formControl: formGroup.control('tipoDePregunta') as FormControl,
            validationMessages: (control) =>
                {'required': 'Seleccione el tipo de pregunta'},
            items: [
              TipoDePregunta.unicaRespuesta,
              TipoDePregunta.multipleRespuesta,
            ]
                .map((e) => DropdownMenuItem<TipoDePregunta>(
                      value: e,
                      child: Text(
                          EnumToString.convertToString(e, camelCase: true)),
                    ))
                .toList(),
            decoration: const InputDecoration(
              labelText: 'Tipo de pregunta',
            ),
            onChanged: (value) {
              formGroup.tipoUnicaRespuesta.value = value;
            },
          ),
          const SizedBox(height: 10),
          ValueListenableBuilder<TipoDePregunta>(
            valueListenable: formGroup.tipoUnicaRespuesta,
            builder: (BuildContext context, value, Widget child) {
              if (value == TipoDePregunta.unicaRespuesta) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¿Es una pregunta condicional?',
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.right,
                    ),
                    ReactiveRadioListTile(
                      formControl:
                          formGroup.control('condicional') as FormControl<bool>,
                      title: const Text('Si'),
                      controlAffinity: ListTileControlAffinity.leading,
                      value: true,
                    ),

                    ReactiveRadioListTile(
                      formControl:
                          formGroup.control('condicional') as FormControl<bool>,
                      title: const Text('No'),
                      controlAffinity: ListTileControlAffinity.leading,
                      value: false,
                    ),

                    // ignore: prefer_const_literals_to_create_immutables
                  ],
                );
              }
              return Divider();
            },
          ),

          ReactiveValueListenableBuilder(
            formControl: formGroup.control('condicional') as FormControl<bool>,
            builder: (context, AbstractControl<bool> control, child) {
              if (control.value) {
                return Column(
                  children: [
                    WidgetRespuestaCondicional(formGroup: formGroup),
                    BotonesDeBloque(formGroup: formGroup, nro: nro),
                  ],
                );
              }

              return Column(
                children: [
                  WidgetRespuestas(formGroup: formGroup),
                  BotonesDeBloque(formGroup: formGroup, nro: nro),
                ],
              );
            },
          ),

          // Muestra las observaciones de la reparacion solo si reparado es true
        ],
      ),
    );
  }
}

class WidgetRespuestas extends StatelessWidget {
  const WidgetRespuestas({
    Key key,
    @required this.formGroup,
  }) : super(key: key);

  final ConRespuestas formGroup;

  @override
  Widget build(BuildContext context) {
    return ReactiveValueListenableBuilder(
        formControl: (formGroup as FormGroup).control('respuestas'),
        builder: (context, control, child) {
          return Column(
            children: [
              Text(
                'Respuestas',
                style: Theme.of(context).textTheme.headline6,
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
                        as CreadorRespuestaFormGroup;
                    element.control('seccion').removeError('required');
                    //Las keys sirven para que flutter maneje correctamente los widgets de la lista
                    return Column(
                      key: ValueKey(element),
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ReactiveTextField(
                                formControl:
                                    element.control('texto') as FormControl,
                                validationMessages: (control) =>
                                    {'required': 'Este valor es requerido'},
                                decoration: const InputDecoration(
                                  labelText: 'Respuesta',
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              tooltip: 'Borrar respuesta',
                              onPressed: () =>
                                  formGroup.borrarRespuesta(element),
                            ),
                          ],
                        ),
                        ReactiveSlider(
                          formControl: element.control('criticidad')
                              as FormControl<double>,
                          max: 4,
                          divisions: 4,
                          labelBuilder: (v) => v.round().toString(),
                          activeColor: Colors.red,
                        ),
                      ],
                    );
                  },
                ),
              OutlineButton(
                onPressed: () {
                  formGroup.agregarRespuesta();
                  control.markAsTouched();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.add),
                    Text("Agregar respuesta"),
                  ],
                ),
              ),
            ],
          );
        });
  }
}

class WidgetRespuestaCondicional extends StatelessWidget {
  const WidgetRespuestaCondicional({
    Key key,
    @required this.formGroup,
  }) : super(key: key);

  final ConRespuestas formGroup;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CreacionFormViewModel>(context);
    return ReactiveValueListenableBuilder(
        formControl: (formGroup as FormGroup).control('respuestas'),
        builder: (context, control, child) {
          return Column(
            children: [
              Text(
                'Respuestas',
                style: Theme.of(context).textTheme.headline6,
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
                        as CreadorRespuestaFormGroup;
                    //Las keys sirven para que flutter maneje correctamente los widgets de la lista
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Column(
                        key: ValueKey(element),
                        children: [
                          Divider(color: Colors.grey[700], height: 5),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ReactiveTextField(
                                    formControl:
                                        element.control('texto') as FormControl,
                                    validationMessages: (control) =>
                                        {'required': 'Este valor es requerido'},
                                    decoration: const InputDecoration(
                                      labelText: 'Respuesta',
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  tooltip: 'Borrar respuesta',
                                  onPressed: () =>
                                      formGroup.borrarRespuesta(element),
                                ),
                              ],
                            ),
                          ),
                          ReactiveSlider(
                            formControl: element.control('criticidad')
                                as FormControl<double>,
                            max: 4,
                            divisions: 4,
                            labelBuilder: (v) => v.round().toString(),
                            activeColor: Colors.red,
                          ),

                          //TODO: Que cuando se elimine el bloque el valor por defecto vuelva a null, así no se envía el valor de un bloque que no existe
                          ValueListenableBuilder<List<String>>(
                              valueListenable: viewModel.totalBloques,
                              builder: (context, value, child) {
                                return ReactiveDropdownField<String>(
                                  formControl:
                                      element.control('seccion') as FormControl,
                                  validationMessages: (control) =>
                                      {'required': 'Seleccione el bloque'},
                                  items: value
                                      .map((e) => DropdownMenuItem<String>(
                                            value: e,
                                            child: Text('Ir a bloque $e'),
                                          ))
                                      .toList(),
                                  decoration: const InputDecoration(
                                    labelText: 'Seccion',
                                  ),
                                );
                              }),
                        ],
                      ),
                    );
                  },
                ),
              OutlineButton(
                onPressed: () {
                  formGroup.agregarRespuesta();
                  control.markAsTouched();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.add),
                    Text("Agregar respuesta"),
                  ],
                ),
              ),
            ],
          );
        });
  }
}

class BotonesDeBloque extends StatelessWidget {
  final int nro;
  const BotonesDeBloque({Key key, this.formGroup, this.nro}) : super(key: key);

  final AbstractControl formGroup;

  @override
  Widget build(BuildContext context) {
    return Row(
      //TODO: estilizar mejor estos iconos
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          tooltip: 'agregar pregunta',
          onPressed: () => agregarBloque(context, CreadorPreguntaFormGroup()),
        ),
        IconButton(
          icon: const Icon(Icons.calculate),
          tooltip: 'Pregunta Númerica',
          onPressed: () =>
              agregarBloque(context, CreadorPreguntaNumericaFormGroup()),
        ),
        IconButton(
          icon: const Icon(Icons.format_size),
          tooltip: 'agregar titulo',
          onPressed: () => agregarBloque(context, CreadorTituloFormGroup()),
        ),
        IconButton(
          icon: const Icon(Icons.view_module),
          tooltip: 'agregar cuadricula',
          onPressed: () =>
              agregarBloque(context, CreadorPreguntaCuadriculaFormGroup()),
        ),
        PopupMenuButton<int>(
          padding: const EdgeInsets.all(2.0),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 1,
              child: ListTile(
                /* 
                leading: const Icon(Icons.copy), */
                title: Text('Bloque numero ${nro + 1}'),
                selected: true,
                onTap: () => {},
              ),
            ),
            PopupMenuItem(
              value: 2,
              child: ListTile(
                leading: const Icon(Icons.copy),
                title: Text('Copiar bloque',
                    style: TextStyle(color: Colors.grey[800])),
                selected: true,
                onTap: () => {
                  copiarBloque(context),
                  Scaffold.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Bloque Copiado'),
                    ),
                  ),
                  Navigator.pop(context),
                },
              ),
            ),
            PopupMenuItem(
              value: 3,
              child: ListTile(
                leading: const Icon(Icons.paste),
                title: Text('Pegar bloque',
                    style: TextStyle(color: Colors.grey[800])),
                selected: true,
                onTap: () => {
                  pegarBloque(context),
                  Scaffold.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Bloque Pegado'),
                    ),
                  ),
                  Navigator.pop(context),
                },
              ),
            ),
            PopupMenuItem(
              value: 4,
              child: ListTile(
                  leading: const Icon(Icons.delete),
                  selected: true,
                  title: Text('Borrar bloque',
                      style: TextStyle(color: Colors.grey[800])),
                  onTap: () => {
                        borrarBloque(context),
                        Scaffold.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Bloque eliminado'),
                          ),
                        ),
                        Navigator.pop(context),
                      }),
            ),
          ],
        ),
      ],
    );
  }

  void copiarBloque(BuildContext context) {
    final viewModel =
        Provider.of<CreacionFormViewModel>(context, listen: false);
    viewModel.bloqueCopiado = formGroup as Copiable;
  }

  Future<void> pegarBloque(BuildContext context) async {
    final viewModel =
        Provider.of<CreacionFormViewModel>(context, listen: false);
    agregarBloque(context, await viewModel.bloqueCopiado.copiar());
  }

  void borrarBloque(BuildContext context) {
    final viewModel =
        Provider.of<CreacionFormViewModel>(context, listen: false);

    final index = (formGroup.parent as FormArray).controls.indexOf(formGroup);
    if (index == 0) return; //no borre el primer titulo
    AnimatedList.of(context).removeItem(
      index,
      (context, animation) => ControlWidgetAnimado(
        element: formGroup,
        index: index,
        animation: animation,
      ),
    );
    viewModel.borrarBloque(formGroup);
  }

  void agregarBloque(BuildContext context, AbstractControl nuevo) {
    final viewModel =
        Provider.of<CreacionFormViewModel>(context, listen: false);
    AnimatedList.of(context).insertItem(
        (formGroup.parent as FormArray).controls.indexOf(formGroup) + 1);
    viewModel.agregarBloqueDespuesDe(bloque: nuevo, despuesDe: formGroup);
  }
}

class ControlWidget extends StatelessWidget {
  final AbstractControl element;
  final int index;

  const ControlWidget(this.element, this.index, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (element is CreadorTituloFormGroup) {
      return CreadorTituloCard(
          key: ValueKey(
              element), //Las keys hacen que flutter borre correctamente las cards
          formGroup: element as CreadorTituloFormGroup,
          nro: index);
    }
    if (element is CreadorPreguntaFormGroup) {
      return CreadorSeleccionSimpleCard(
          key: ValueKey(element),
          formGroup: element as CreadorPreguntaFormGroup,
          nro: index);
    }
    if (element is CreadorPreguntaCuadriculaFormGroup) {
      return CreadorCuadriculaCard(
          key: ValueKey(element),
          formGroup: element as CreadorPreguntaCuadriculaFormGroup,
          nro: index);
    }
    if (element is CreadorPreguntaNumericaFormGroup) {
      return CreadorNumericaCard(
        formGroup: element as CreadorPreguntaNumericaFormGroup,
        nro: index,
      );
    }
    return Text("error: el bloque $index no tiene una card que lo renderice");
  }
}

class ControlWidgetAnimado extends StatelessWidget {
  final Animation<double> animation;
  final int index;
  const ControlWidgetAnimado({
    Key key,
    @required this.element,
    this.animation,
    this.index,
  }) : super(key: key);

  final AbstractControl element;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      child: ControlWidget(
        element,
        index,
      ),
    );
  }
}
