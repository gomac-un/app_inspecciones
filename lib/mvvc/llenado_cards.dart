import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/mvvc/common_widgets.dart';
import 'package:inspecciones/mvvc/llenado_controls.dart';
import 'package:inspecciones/mvvc/llenado_form_view_model.dart';
import 'package:inspecciones/mvvc/reactive_multiselect_dialog_field.dart';
import 'package:inspecciones/presentation/widgets/image_shower.dart';
import 'package:inspecciones/presentation/widgets/images_picker.dart';
import 'package:kt_dart/kt.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:checkbox_formfield/checkbox_formfield.dart';

class TituloCard extends StatelessWidget {
  final TituloFormGroup formGroup;

  const TituloCard({
    Key key,
    this.formGroup,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      //TODO: destacar mejor los titulos
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
          borderRadius: BorderRadius.circular(4.0)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              formGroup.titulo.titulo,
              style: Theme.of(context).textTheme.headline5,
            ),
            Text(
              formGroup.titulo.descripcion,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
      ),
    );
  }
}

class NumericaCard extends StatelessWidget {
  final RespuestaNumericaFormGroup formGroup;
  final bool readOnly;
  const NumericaCard({Key key, this.formGroup, this.readOnly = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LlenadoFormViewModel>(context);
    final criticidad = viewModel.estado.value == EstadoDeInspeccion.borrador
        ? formGroup.pregunta.criticidad
        : formGroup.criticidad;
    final mensajeCriticidad =
        viewModel.estado.value == EstadoDeInspeccion.borrador
            ? 'Criticidad pregunta'
            : 'Criticidad total pregunta';
    return PreguntaCard(
      titulo: formGroup.pregunta.titulo,
      descripcion: formGroup.pregunta.descripcion,
      criticidad: criticidad,
      estado: mensajeCriticidad,
      child: Column(
        children: [
          if (formGroup.pregunta.fotosGuia.size > 0)
            ImageShower(
              imagenes: formGroup.pregunta.fotosGuia
                  .map((e) => File(e))
                  .iter
                  .toList(),
            ),

          ReactiveTextField(
            formControl: formGroup.control('valor') as FormControl,
            validationMessages: (control) =>
                {'required': 'El valor no puede estar vacio'},
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Escriba la respuesta",
            ),
            readOnly: readOnly,
            enableInteractiveSelection: !readOnly,
            onTap: () => {
              if (readOnly == true)
                {
                  (formGroup.control('valor') as FormControl)
                      .removeError('required'),
                }
            },
          ),
          const SizedBox(height: 10),
          ReactiveTextField(
            formControl: formGroup.control('observacion') as FormControl,
            decoration: const InputDecoration(
              labelText: 'Observaciones',
              prefixIcon: Icon(Icons.remove_red_eye),
            ),
            keyboardType: TextInputType.multiline,
            maxLines: null,
            textInputAction: TextInputAction.next,
            readOnly: readOnly,
            enableInteractiveSelection: !readOnly,
          ),
          //TODO: mostrar los botones de agregar imagenes y el checkbox de
          //reparación de una manera mas optima, no uno en cada fila
          FormBuilderImagePicker(
            formArray: formGroup.control('fotosBase') as FormArray<File>,
            decoration: const InputDecoration(
              labelText: 'Fotos base',
            ),
            readOnly: readOnly,
          ),
          if (viewModel.estado.value == EstadoDeInspeccion.reparacion)
            ReactiveCheckboxListTile(
              formControl: formGroup.control('reparado') as FormControl,
              title: const Text('Reparado'),
              controlAffinity: ListTileControlAffinity.leading,
            ),
          // Muestra las observaciones de la reparacion solo si reparado es true
          if (viewModel.estado.value == EstadoDeInspeccion.reparacion)
            ReactiveValueListenableBuilder(
              formControl: formGroup.control('reparado') as FormControl<bool>,
              builder: (context, AbstractControl<bool> control, child) {
                if (control.value) {
                  final observacion = formGroup
                      .control('observacionReparacion')
                      .value as String;
                  if (observacion.length <= 1) {
                    formGroup
                        .control('observacionReparacion')
                        .setErrors({'required': true});
                  }
                  final fotos =
                      formGroup.control('fotosReparacion').value as List;
                  if (fotos.isEmpty) {
                    formGroup
                        .control('fotosReparacion')
                        .setErrors({'required': true});
                  }
                  return Column(
                    children: [
                      ReactiveTextField(
                        formControl: formGroup.control('observacionReparacion')
                            as FormControl,
                        decoration: const InputDecoration(
                          labelText: 'Observaciones de la reparación',
                          prefixIcon: Icon(Icons.remove_red_eye),
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        textInputAction: TextInputAction.next,
                      ),
                      FormBuilderImagePicker(
                        formArray: formGroup.control('fotosReparacion')
                            as FormArray<File>,
                        decoration: const InputDecoration(
                          labelText: 'Fotos de la reparación',
                        ),
                      ),
                    ],
                  );
                } else {
                  formGroup
                      .control('observacionReparacion')
                      .removeError('required');
                  formGroup.control('fotosReparacion').removeError('required');
                  return const SizedBox.shrink();
                }
              },
            ),
        ],
      ),
    );
  }
}

class SeleccionSimpleCard extends StatelessWidget {
  final RespuestaSeleccionSimpleFormGroup formGroup;
  final bool readOnly;

  const SeleccionSimpleCard({
    Key key,
    this.formGroup,
    this.readOnly,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LlenadoFormViewModel>(context);
    final criticidad = viewModel.estado.value == EstadoDeInspeccion.borrador
        ? formGroup.pregunta.pregunta.criticidad
        : formGroup.criticidad;
    final mensajeCriticidad =
        viewModel.estado.value == EstadoDeInspeccion.borrador
            ? 'Criticidad pregunta'
            : 'Criticidad total pregunta';
    return PreguntaCard(
      titulo: formGroup.pregunta.pregunta.titulo,
      descripcion: formGroup.pregunta.pregunta.descripcion,
      criticidad: criticidad,
      estado: mensajeCriticidad,
      child: Column(
        children: [
          if (formGroup.pregunta.pregunta.fotosGuia.size > 0)
            ImageShower(
              imagenes: formGroup.pregunta.pregunta.fotosGuia
                  .map((e) => File(e))
                  .iter
                  .toList(),
            ),
          if (formGroup.pregunta.pregunta.tipo == TipoDePregunta.unicaRespuesta)
            ReactiveDropdownField<OpcionDeRespuesta>(
              formControl: formGroup.control('respuestas') as FormControl<
                  OpcionDeRespuesta>, //La de seleccion unica usa el control de la primer pregunta de la lista
              items: formGroup.pregunta.opcionesDeRespuesta
                  .map((e) => DropdownMenuItem<OpcionDeRespuesta>(
                      value: e, child: Text(e.texto)))
                  .toList(),
              decoration: const InputDecoration(
                labelText: 'Seleccione una opción',
              ),
              onTap: () {
                FocusScope.of(context)
                    .unfocus(); // para que no salte el teclado si tenia un textfield seleccionado
              },
              /* onChanged: (value) {
                if (formGroup.pregunta.pregunta.esCondicional == true) {
                  viewModel.borrarBloque(
                    formGroup.bloque.nOrden,
                    formGroup.seccion,
                  );
                }
              }, */
              readOnly: readOnly,
            ),
          if (formGroup.pregunta.pregunta.tipo ==
              TipoDePregunta.multipleRespuesta)
            ReactiveMultiSelectDialogField<OpcionDeRespuesta>(
              buttonText: const Text('Seleccione entre las opciones'),
              items: formGroup.pregunta.opcionesDeRespuesta
                  .map((e) => MultiSelectItem(e, e.texto))
                  .toList(),
              formControl: formGroup.control('respuestas')
                  as FormControl<List<OpcionDeRespuesta>>,
              onTap: () => FocusScope.of(context).unfocus(),
              /* onChanged: (value) {
                if (formGroup.pregunta.pregunta.esCondicional == true) {
                  viewModel.borrarBloque(
                    formGroup.bloque.nOrden,
                    formGroup.seccion,
                  );
                }
              }, */
            ),
          const SizedBox(height: 10),
          ReactiveTextField(
            formControl: formGroup.control('observacion') as FormControl,
            decoration: const InputDecoration(
              labelText: 'Observaciones',
              prefixIcon: Icon(Icons.remove_red_eye),
            ),
            keyboardType: TextInputType.multiline,
            maxLines: null,
            textInputAction: TextInputAction.next,
            readOnly: readOnly,
          ),
          //TODO: mostrar los botones de agregar imagenes y el checkbox de
          //reparación de una manera mas optima, no uno en cada fila
          FormBuilderImagePicker(
            formArray: formGroup.control('fotosBase') as FormArray<File>,
            decoration: const InputDecoration(
              labelText: 'Fotos base',
            ),
            readOnly: readOnly,
          ),
          if (viewModel.estado.value == EstadoDeInspeccion.reparacion)
            ReactiveCheckboxListTile(
              formControl: formGroup.control('reparado') as FormControl,
              title: const Text('Reparado'),
              controlAffinity: ListTileControlAffinity.leading,
            ),
          // Muestra las observaciones de la reparacion solo si reparado es true
          if (viewModel.estado.value == EstadoDeInspeccion.reparacion)
            ReactiveValueListenableBuilder(
              formControl: formGroup.control('reparado') as FormControl<bool>,
              builder: (context, AbstractControl<bool> control, child) {
                if (control.value) {
                  final observacion = formGroup
                      .control('observacionReparacion')
                      .value as String;
                  if (observacion.length <= 1) {
                    formGroup
                        .control('observacionReparacion')
                        .setErrors({'required': true});
                  }
                  final fotos =
                      formGroup.control('fotosReparacion').value as List;
                  if (fotos.isEmpty) {
                    formGroup
                        .control('fotosReparacion')
                        .setErrors({'required': true});
                  }
                  return Column(
                    children: [
                      ReactiveTextField(
                        formControl: formGroup.control('observacionReparacion')
                            as FormControl,
                        decoration: const InputDecoration(
                          labelText: 'Observaciones de la reparación',
                          prefixIcon: Icon(Icons.remove_red_eye),
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        textInputAction: TextInputAction.next,
                      ),
                      FormBuilderImagePicker(
                        formArray: formGroup.control('fotosReparacion')
                            as FormArray<File>,
                        decoration: const InputDecoration(
                          labelText: 'Fotos de la reparación',
                        ),
                      ),
                    ],
                  );
                } else {
                  formGroup
                      .control('observacionReparacion')
                      .removeError('required');
                  formGroup.control('fotosReparacion').removeError('required');
                  return const SizedBox.shrink();
                }
              },
            ),
        ],
      ),
    );
  }
}

class CuadriculaCard extends StatelessWidget {
  final RespuestaCuadriculaFormArray formArray;
  final bool readOnly;

  const CuadriculaCard({Key key, this.formArray, this.readOnly})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LlenadoFormViewModel>(context);
    final numeroDeColumnas = formArray.cuadricula.opcionesDeRespuesta.length;
    return PreguntaCard(
      titulo: formArray.cuadricula.cuadricula.titulo,
      descripcion: formArray.cuadricula.cuadricula.descripcion,
      child: Column(
        children: [
          Table(
            border: const TableBorder(
                horizontalInside: BorderSide(color: Colors.black26)),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: {
              0: const FlexColumnWidth(2),
              numeroDeColumnas + 1: const FlexColumnWidth(0.5),
            },
            children: [
              TableRow(
                children: [
                  const SizedBox.shrink(),
                  ...formArray.cuadricula.opcionesDeRespuesta.map(
                    (e) => Text(
                      e.texto,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox.shrink(),
                ],
              ),
              ...formArray.controls.map((d) {
                final e = d as RespuestaSeleccionSimpleFormGroup;
                /*final ctrlPregunta =
                    e.control('respuestas') ;*/
                final reparacion = e.control('reparado') as FormControl<bool>;
                Widget icon;
                if (viewModel.estado.value != EstadoDeInspeccion.borrador &&
                    e.criticidad > 0) {
                  icon = Icon(Icons.assignment_late_rounded,
                      color: viewModel.estado.value ==
                                  EstadoDeInspeccion.reparacion &&
                              e.criticidad > 0 &&
                              reparacion.value != true
                          ? Colors.red
                          : Colors.green);
                } else {
                  icon = const Icon(Icons.remove_red_eye);
                }
                return TableRow(
                  children: [
                    Text(e.pregunta.pregunta.titulo),
                    ...formArray.cuadricula.opcionesDeRespuesta
                        .map((res) => WidgetSeleccion(pregunta: e, opcion: res))
                        .toList(),

                    IconButton(
                      icon: icon,
                      onPressed: () async {
                        //FocusScope.of(context).unfocus();
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Provider(
                              create: (_) => viewModel,
                              child: SingleChildScrollView(
                                  child: SeleccionSimpleCard(
                                formGroup: e,
                                readOnly: readOnly,
                              )),
                            ),
                            actions: [
                              OutlineButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("ok"),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    //TODO: agregar controles para agregar fotos y reparaciones, tal vez con popups
                  ],
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }
}

class WidgetSeleccion extends StatefulWidget {
  final RespuestaSeleccionSimpleFormGroup pregunta;
  final OpcionDeRespuesta opcion;
  const WidgetSeleccion({Key key, this.pregunta, this.opcion})
      : super(key: key);

  @override
  _WidgetSeleccionState createState() =>
      _WidgetSeleccionState(pregunta, opcion);
}

class _WidgetSeleccionState extends State<WidgetSeleccion> {
  final RespuestaSeleccionSimpleFormGroup pregunta;
  final OpcionDeRespuesta opcion;
  bool _isSelected = false;

  _WidgetSeleccionState(this.pregunta, this.opcion);
  @override
  Widget build(BuildContext context) {
    if (pregunta.pregunta.pregunta.tipo ==
        TipoDePregunta.parteDeCuadriculaMultiple) {
      final control = (pregunta.control('respuestas')
              as FormControl<List<OpcionDeRespuesta>>)
          .value;
      _isSelected = control.contains(opcion);
      return Checkbox(
        value: _isSelected,
        onChanged: (bool newValue) {
          setState(() {
            _isSelected = newValue;
          });
          if (newValue) {
            if (!control.contains(opcion)) {
              control.add(opcion);
            }
          } else {
            (pregunta.control('respuestas')
                    as FormControl<List<OpcionDeRespuesta>>)
                .value
                .remove(opcion);
          }
        },
      );
    } else {
      return ReactiveRadio(
        value: opcion,
        formControl:
            pregunta.control('respuestas') as FormControl<OpcionDeRespuesta>,
      );
    }
  }
}
