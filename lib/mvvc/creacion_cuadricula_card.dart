import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/mvvc/common_widgets.dart';
import 'package:inspecciones/mvvc/creacion_cards.dart';
import 'package:inspecciones/mvvc/creacion_controls.dart';
import 'package:inspecciones/mvvc/creacion_form_view_model.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CreadorCuadriculaCard extends StatelessWidget {
  final CreadorPreguntaCuadriculaFormGroup formGroup;
  final int nro;

  const CreadorCuadriculaCard({Key key, this.formGroup, this.nro})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CreacionFormViewModel>(context);
    return PreguntaCard(
      titulo: 'Pregunta tipo cuadricula',
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
          ValueListenableBuilder<List<SubSistema>>(
              valueListenable: viewModel.subSistemas,
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
            items:  [
              "No aplica",
              "Adelante",
              "Atrás",
              'Izquierda',
              'Derecha'
            ] 
                .map((e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),
                    ))
                .toList(),
            decoration: const InputDecoration(
              labelText: 'Posicion',
            ),
          ),
          const SizedBox(height: 10),
          ReactiveDropdownField<TipoDePregunta>(
            formControl: formGroup.control('tipoDePregunta') as FormControl,
            validationMessages: (control) =>
                {'required': 'Seleccione el tipo de pregunta'},
            items: [
              TipoDePregunta.parteDeCuadriculaUnica,
              TipoDePregunta.parteDeCuadriculaMultiple,
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
          WidgetPreguntas(formGroup: formGroup),
          WidgetRespuestas(formGroup: formGroup),
          BotonesDeBloque(formGroup: formGroup, nro: nro),
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
    final media = MediaQuery.of(context).size;
    return ReactiveValueListenableBuilder(
        formControl: formGroup.control('preguntas'),
        builder: (context, control, child) {
          return Column(
            children: [
              Text(
                'Preguntas',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 10),
              if ((control as FormArray).controls.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: (control as FormArray).controls.length,
                  itemBuilder: (context, i) {
                    final element = (control as FormArray).controls[i]
                        as CreadorPreguntaFormGroup;
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
                                    formControl: element.control('titulo')
                                        as FormControl,
                                    decoration: const InputDecoration(
                                      labelText: 'Titulo',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.fullscreen),
                                  tooltip: 'Más detalles',
                                  onPressed: () async {
                                    final maincontext = context;
                                    showDialog(
                                      context: maincontext,
                                      builder: (context) => AlertDialog(
                                        content: SingleChildScrollView(
                                            child: Provider(
                                          create: (_) => Provider.of<
                                                  CreacionFormViewModel>(
                                              maincontext),
                                          // ignore: sized_box_for_whitespace
                                          child: SizedBox(
                                            width: media.width * 0.7,
                                            child: CreadorSeleccionSimpleCard(
                                              formGroup: element,
                                            ),
                                          ),
                                        )),
                                        actions: [
                                          OutlineButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: const Text("Ok"),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  tooltip: 'Borrar pregunta',
                                  onPressed: () =>
                                      formGroup.borrarPregunta(element),
                                ),
                              ],
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
                onPressed: formGroup.agregarPregunta,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.add),
                    Text("Agregar pregunta"),
                  ],
                ),
              ),
            ],
          );
        });
  }
}

