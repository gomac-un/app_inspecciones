import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:inspecciones/domain/core/enums.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/mvvc/common_widgets.dart';
import 'package:inspecciones/mvvc/creacion_controls.dart';
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
      shape: new RoundedRectangleBorder(
          side:
              new BorderSide(color: Theme.of(context).accentColor, width: 2.0),
          borderRadius: BorderRadius.circular(4.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ReactiveTextField(
              style: Theme.of(context).textTheme.headline5,
              formControl: formGroup.control('titulo'),
              decoration: InputDecoration(
                labelText: 'Titulo',
              ),
            ),
            SizedBox(height: 10),
            ReactiveTextField(
              style: Theme.of(context).textTheme.bodyText2,
              formControl: formGroup.control('descripcion'),
              decoration: InputDecoration(
                labelText: 'Descripción',
              ),
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

class CreadorSeleccionSimpleCard extends StatelessWidget {
  final CreadorPreguntaSeleccionSimpleFormGroup formGroup;

  const CreadorSeleccionSimpleCard({Key key, this.formGroup}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CreacionFormViewModel>(context);
    return PreguntaCard(
      titulo: 'Pregunta de seleccion',
      child: Column(
        children: [
          ReactiveTextField(
            formControl: formGroup.control('titulo'),
            decoration: InputDecoration(
              labelText: 'Titulo',
            ),
          ),
          SizedBox(height: 10),
          ReactiveTextField(
            formControl: formGroup.control('descripcion'),
            decoration: InputDecoration(
              labelText: 'Descripción',
            ),
          ),
          SizedBox(height: 10),
          ValueListenableBuilder<List<Sistema>>(
            valueListenable: viewModel.sistemas,
            builder: (context, value, child) {
              return ReactiveDropdownField<Sistema>(
                formControl: formGroup.control('sistema'),
                items: value
                    .map((e) => DropdownMenuItem<Sistema>(
                          value: e,
                          child: Text(e.nombre),
                        ))
                    .toList(),
                decoration: InputDecoration(
                  labelText: 'Sistema',
                ),
              );
            },
          ),
          SizedBox(height: 10),

          ValueListenableBuilder<List<SubSistema>>(
              valueListenable: formGroup.subSistemas,
              builder: (context, value, child) {
                return ReactiveDropdownField<SubSistema>(
                  formControl: formGroup.control('subSistema'),
                  items: value
                      .map((e) => DropdownMenuItem<SubSistema>(
                            value: e,
                            child: Text(e.nombre),
                          ))
                      .toList(),
                  decoration: InputDecoration(
                    labelText: 'Subsistema',
                  ),
                );
              }),

          SizedBox(height: 10),
          ReactiveDropdownField<String>(
            formControl: formGroup.control('posicion'),
            items: ["no aplica", "adelante", "atras"]
                .map((e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),
                    ))
                .toList(),
            decoration: InputDecoration(
              labelText: 'Posicion',
            ),
          ),
          InputDecorator(
            decoration: InputDecoration(labelText: 'criticidad', filled: false),
            child: ReactiveSlider(
              //TODO: consultar de nuevo como se manejara la criticad

              formControl: formGroup.control('criticidad'),
              max: 4,
              divisions: 4,
              labelBuilder: (v) => v.round().toString(),
              activeColor: Colors.red,
            ),
          ),
          FormBuilderImagePicker(
            formArray: formGroup.control('fotosGuia'),
            decoration: const InputDecoration(
              labelText: 'Fotos guia',
            ),
          ),
          ReactiveDropdownField<TipoDePregunta>(
            formControl: formGroup.control('tipoDePregunta'),
            items: [
              TipoDePregunta.unicaRespuesta,
              TipoDePregunta.multipleRespuesta
            ]
                .map((e) => DropdownMenuItem<TipoDePregunta>(
                      value: e,
                      child: Text(
                          EnumToString.convertToString(e, camelCase: true)),
                    ))
                .toList(),
            decoration: InputDecoration(
              labelText: 'Tipo de pregunta',
            ),
          ),
          SizedBox(height: 10),
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
              SizedBox(height: 10),
              if ((control as FormArray).controls.length > 0)
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
                                formControl: element.control('texto'),
                                decoration: InputDecoration(
                                  labelText: 'Respuesta',
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              tooltip: 'borrar respuesta',
                              onPressed: () =>
                                  formGroup.borrarRespuesta(element),
                            ),
                          ],
                        ),
                        ReactiveSlider(
                          formControl: element.control('criticidad'),
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add),
                    Text("Agregar respuesta"),
                  ],
                ),
                onPressed: formGroup.agregarRespuesta,
              ),
            ],
          );
        });
  }
}

class CreadorCuadriculaCard extends StatelessWidget {
  final CreadorPreguntaCuadriculaFormGroup formGroup;

  const CreadorCuadriculaCard({Key key, this.formGroup}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CreacionFormViewModel>(context);
    return PreguntaCard(
      titulo: 'Pregunta tipo cuadricula',
      child: Column(
        children: [
          ReactiveTextField(
            formControl: formGroup.control('titulo'),
            decoration: InputDecoration(
              labelText: 'Titulo',
            ),
          ),
          SizedBox(height: 10),
          ReactiveTextField(
            formControl: formGroup.control('descripcion'),
            decoration: InputDecoration(
              labelText: 'Descripción',
            ),
          ),
          SizedBox(height: 10),
          ValueListenableBuilder<List<Sistema>>(
            valueListenable: viewModel.sistemas,
            builder: (context, value, child) {
              return ReactiveDropdownField<Sistema>(
                formControl: formGroup.control('sistema'),
                items: value
                    .map((e) => DropdownMenuItem<Sistema>(
                          value: e,
                          child: Text(e.nombre),
                        ))
                    .toList(),
                decoration: InputDecoration(
                  labelText: 'Sistema',
                ),
              );
            },
          ),
          SizedBox(height: 10),
          ValueListenableBuilder<List<SubSistema>>(
              valueListenable: formGroup.subSistemas,
              builder: (context, value, child) {
                return ReactiveDropdownField<SubSistema>(
                  formControl: formGroup.control('subSistema'),
                  items: value
                      .map((e) => DropdownMenuItem<SubSistema>(
                            value: e,
                            child: Text(e.nombre),
                          ))
                      .toList(),
                  decoration: InputDecoration(
                    labelText: 'Subsistema',
                  ),
                );
              }),
          SizedBox(height: 10),
          ReactiveDropdownField<String>(
            formControl: formGroup.control('posicion'),
            items: ["no aplica", "adelante", "atras"]
                .map((e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),
                    ))
                .toList(),
            decoration: InputDecoration(
              labelText: 'Posicion',
            ),
          ),
          SizedBox(height: 10),
          WidgetPreguntas(formGroup: formGroup),
          WidgetRespuestas(formGroup: formGroup),
          BotonesDeBloque(formGroup: formGroup),
        ],
      ),
    );
  }
}

class WidgetPreguntas extends StatelessWidget {
  const WidgetPreguntas({
    Key key,
    @required this.formGroup,
  }) : super(key: key);

  final CreadorPreguntaCuadriculaFormGroup formGroup;

  @override
  Widget build(BuildContext context) {
    return ReactiveValueListenableBuilder(
        formControl: (formGroup as FormGroup).control('preguntas'),
        builder: (context, control, child) {
          return Column(
            children: [
              Text(
                'Preguntas',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 10),
              if ((control as FormArray).controls.length > 0)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: (control as FormArray).controls.length,
                  itemBuilder: (context, i) {
                    final element = (control as FormArray).controls[i]
                        as CreadorSubPreguntaCuadriculaFormGroup;
                    //Las keys sirven para que flutter maneje correctamente los widgets de la lista
                    return Column(
                      key: ValueKey(element),
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  ReactiveTextField(
                                    formControl: element.control('titulo'),
                                    decoration: InputDecoration(
                                      labelText: 'Titulo',
                                    ),
                                  ),
                                  ReactiveTextField(
                                    formControl: element.control('descripcion'),
                                    decoration: InputDecoration(
                                      labelText: 'Descripcion',
                                    ),
                                  ),
                                  //TODO: submenu para agregar sistemas,subsistemas y fotos para cada pregunta
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              tooltip: 'borrar pregunta',
                              onPressed: () =>
                                  formGroup.borrarPregunta(element),
                            ),
                          ],
                        ),
                        ReactiveSlider(
                          formControl: element.control('criticidad'),
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add),
                    Text("Agregar pregunta"),
                  ],
                ),
                onPressed: formGroup.agregarPregunta,
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
    final viewModel = Provider.of<CreacionFormViewModel>(context);
    return ButtonBar(
      //TODO: estilizar mejor estos iconos
      alignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.add_circle_outline),
          tooltip: 'agregar pregunta',
          onPressed: () => agregar(
              context, viewModel, CreadorPreguntaSeleccionSimpleFormGroup()),
        ),
        IconButton(
          icon: Icon(Icons.format_size),
          tooltip: 'agregar titulo',
          onPressed: () =>
              agregar(context, viewModel, CreadorTituloFormGroup()),
        ),
        IconButton(
          icon: Icon(Icons.view_module),
          tooltip: 'agregar cuadricula',
          onPressed: () =>
              agregar(context, viewModel, CreadorPreguntaCuadriculaFormGroup()),
        ),
        IconButton(
          icon: Icon(Icons.delete),
          tooltip: 'borrar bloque',
          onPressed: () {
            final index =
                (formGroup.parent as FormArray).controls.indexOf(formGroup);
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
          },
        ),
        if (nro != null) Text('${nro + 1}'),
      ],
    );
  }

  void agregar(BuildContext context, CreacionFormViewModel viewModel,
      AbstractControl nuevo) {
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
          key: ValueKey(element), formGroup: element, nro: index);
    }
    if (element is CreadorPreguntaSeleccionSimpleFormGroup) {
      return CreadorSeleccionSimpleCard(
          key: ValueKey(element), formGroup: element);
    }
    if (element is CreadorPreguntaCuadriculaFormGroup) {
      return CreadorCuadriculaCard(key: ValueKey(element), formGroup: element);
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
