import 'dart:io';
import 'package:dartz/dartz.dart';
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
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:simple_tooltip/simple_tooltip.dart';

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
          side:
              BorderSide(color: Theme.of(context).backgroundColor, width: 2.0),
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
                labelText: 'Titulo de sección',
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
    final List<TipoDePregunta> itemsTipoPregunta = formGroup.parteDeCuadricula
        ? [
            TipoDePregunta.parteDeCuadriculaUnica,
            TipoDePregunta.parteDeCuadriculaMultiple
          ]
        : [TipoDePregunta.unicaRespuesta, TipoDePregunta.multipleRespuesta];
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
          ValueListenableBuilder<List<SubSistema>>(
              valueListenable: viewModel.subSistemas,
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
              "Atrás",
              'Izquierda',
              'Derecha'
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
          ReactiveDropdownField<TipoDePregunta>(
            formControl: formGroup.control('tipoDePregunta') as FormControl,
            validationMessages: (control) =>
                {'required': 'Seleccione el tipo de pregunta'},
            items: itemsTipoPregunta
                .map((e) => DropdownMenuItem<TipoDePregunta>(
                      value: e,
                      child: Text(
                          EnumToString.convertToString(e, camelCase: true)),
                    ))
                .toList(),
            decoration: const InputDecoration(
              labelText: 'Tipo de pregunta',
            ),
          ),
          const SizedBox(height: 10),
          /* if (!formGroup.parteDeCuadricula)
            Column(
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
            ), */
          if (!formGroup.parteDeCuadricula)
            Column(
              children: [
                WidgetRespuestas(formGroup: formGroup),
                BotonesDeBloque(formGroup: formGroup, nro: nro),
              ],
            )

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
    final mostrarToolTip = ValueNotifier<bool>(false);
    return ReactiveValueListenableBuilder(
        formControl: (formGroup as FormGroup).control('respuestas'),
        builder: (context, control, child) {
          return Column(
            children: [
              Text(
                'Respuestas',
                style: Theme.of(context).textTheme.headline6,
              ),
              if (control.invalid &&
                  control.errors.entries.first.key == 'minLength')
                const Text(
                  'Agregue una opción de respuesta',
                  style: TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 10),
              if ((control as FormArray).controls.isNotEmpty)
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: (control as FormArray).controls.length,
                  itemBuilder: (context, i) {
                    final element = (control as FormArray).controls[i]
                        as CreadorRespuestaFormGroup; //Las keys sirven para que flutter maneje correctamente los widgets de la lista
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      key: ValueKey(element),
                      children: [
                        Row(
                          children: [
                            ValueListenableBuilder<bool>(
                              builder:
                                  (BuildContext context, value, Widget child) {
                                return SimpleTooltip(
                                  show: value,
                                  tooltipDirection: TooltipDirection.right,
                                  content: Text(
                                    "Seleccione si el inspector puede asignar una criticidad propia al elegir esta respuesta",
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                  ),
                                  ballonPadding: const EdgeInsets.all(2),
                                  borderColor: Theme.of(context).primaryColor,
                                  borderWidth: 0,
                                  child: IconButton(
                                      iconSize: 20,
                                      icon: const Icon(
                                        Icons.info,
                                      ),
                                      onPressed: () =>
                                          mostrarToolTip.value == true
                                              ? mostrarToolTip.value = false
                                              : mostrarToolTip.value = true),
                                );
                              },
                              valueListenable: mostrarToolTip,
                            ),
                            Flexible(
                              child: ReactiveCheckboxListTile(
                                formControl: element.control('calificable')
                                    as FormControl,
                                title: const Text('Calificable'),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),
                            ),
                          ],
                        ),
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
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider();
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
/* 
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

                          /* 
                          ValueListenableBuilder<List<int>>(
                              valueListenable: viewModel.totalBloques,
                              builder: (context, value, child) {
                                return ReactiveDropdownField<String>(
                                  formControl: element.control('seccion')
                                      as FormControl<String>,
                                  validationMessages: (control) =>
                                      {'required': 'Seleccione el bloque'},
                                  items: value
                                      .map((e) => DropdownMenuItem<String>(
                                            value: e.toString(),
                                            child: Text('Ir a bloque $e'),
                                          ))
                                      .toList(),
                                  decoration: const InputDecoration(
                                    labelText: 'Seccion',
                                  ),
                                );
                              }), */
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
} */

class BotonesDeBloque extends StatelessWidget {
  final int nro;
  const BotonesDeBloque({Key key, this.formGroup, this.nro}) : super(key: key);

  final AbstractControl formGroup;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.add_circle),
          tooltip: 'Pregunta de selección',
          onPressed: () => agregarBloque(context, CreadorPreguntaFormGroup()),
        ),
        IconButton(
          icon: const Icon(Icons.calculate),
          tooltip: 'Pregunta Númerica',
          onPressed: () =>
              agregarBloque(context, CreadorPreguntaNumericaFormGroup()),
        ),
        IconButton(
          icon: const Icon(Icons.view_module),
          tooltip: 'Agregar cuadricula',
          onPressed: () =>
              agregarBloque(context, CreadorPreguntaCuadriculaFormGroup()),
        ),
        IconButton(
          icon: const Icon(Icons.format_size),
          tooltip: 'Agregar titulo',
          onPressed: () => agregarBloque(context, CreadorTituloFormGroup()),
        ),
        
        PopupMenuButton<int>(
          padding: const EdgeInsets.all(2.0),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 1,
              child: ListTile(
                /* 
                leading: const Icon(Icons.copy), */
                title: Text('Bloque número ${nro + 1}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                selected: true,
                onTap: () => {},
              ),
            ),
            PopupMenuItem(
              value: 2,
              child: ListTile(
                leading: Icon(
                  Icons.copy,
                  color: Theme.of(context).accentColor,
                ),
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
                leading: Icon(
                  Icons.paste,
                  color: Theme.of(context).accentColor,
                ),
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
                  leading: Icon(
                    Icons.delete,
                    color: Theme.of(context).accentColor,
                  ),
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
    print('aqui');
    viewModel.borrarBloque(formGroup);
    print('terminó');
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
