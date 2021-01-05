import 'dart:io';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/mvvc/common_widgets.dart';
import 'package:inspecciones/mvvc/creacion_controls.dart';
import 'package:inspecciones/mvvc/creacion_cuadricula_card.dart';
import 'package:inspecciones/mvvc/creacion_form_view_model.dart';
import 'package:inspecciones/presentation/widgets/images_picker.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

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

  const CreadorNumericaCard({Key key, this.formGroup}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreguntaCard(
        titulo: 'Pregunta numérica',
        child: Column(
          children: [
            TipoPreguntaCard(
              formGroup: formGroup,
            ),
            BotonesDeBloque(formGroup: formGroup),
          ],
        ));
  }
} 

class CreadorSeleccionSimpleCard extends StatelessWidget {
  final CreadorPreguntaFormGroup formGroup;

  const CreadorSeleccionSimpleCard({Key key, this.formGroup}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CreacionFormViewModel>(context);
    return PreguntaCard(
      titulo: 'Pregunta de seleccion',
      child: Column(
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
              "No aplica",
              "Adelante",
              "Atras"
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
              labelText: 'Fotos guia',
            ),
          ),
          ReactiveDropdownField<TipoDePregunta>(
            formControl: formGroup.control('tipoDePregunta') as FormControl,
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
          ),
          const SizedBox(height: 10),
          WidgetRespuestas(formGroup: formGroup),
          BotonesDeBloque(formGroup: formGroup),
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
                                decoration: const InputDecoration(
                                  labelText: 'Respuesta',
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              tooltip: 'borrar respuesta',
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
        IconButton(
          icon: const Icon(Icons.copy),
          tooltip: 'copiar bloque',
          onPressed: () => copiarBloque(context),
        ),
        IconButton(
          icon: const Icon(Icons.paste),
          tooltip: 'pegar bloque',
          onPressed: () => pegarBloque(context),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          tooltip: 'borrar bloque',
          onPressed: () => borrarBloque(context),
        ),
        if (nro != null) Text('${nro + 1}'),
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
          formGroup: element as CreadorPreguntaFormGroup);
    }
    if (element is CreadorPreguntaCuadriculaFormGroup) {
      return CreadorCuadriculaCard(
          key: ValueKey(element),
          formGroup: element as CreadorPreguntaCuadriculaFormGroup);
    }
     if (element is CreadorPreguntaNumericaFormGroup) {
      return CreadorNumericaCard(
        formGroup: element as CreadorPreguntaNumericaFormGroup,
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
