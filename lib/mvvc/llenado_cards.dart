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
import 'package:simple_tooltip/simple_tooltip.dart';

class CalificacionCard extends StatelessWidget {
  final bool controlRespuesta;
  final FormControl<double> controlCalificacion;

  const CalificacionCard(
      {Key key, this.controlRespuesta, this.controlCalificacion})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final mostrarToolTip = ValueNotifier<bool>(false);
    if (controlRespuesta ?? false) {
      return Column(children: [
        const SizedBox(height: 10),
        const Text('Criticidad', style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            ValueListenableBuilder<bool>(
              builder: (BuildContext context, value, Widget child) {
                return SimpleTooltip(
                  show: value,
                  tooltipDirection: TooltipDirection.right,
                  content: Text(
                    "Asigne una criticidad dependiendo del estado de la falla, siendo 0 la menor y 4 la mayor",
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  ballonPadding: const EdgeInsets.all(2),
                  borderColor: Theme.of(context).primaryColor,
                  borderWidth: 0,
                  child: IconButton(
                      iconSize: 20,
                      icon: const Icon(
                        Icons.info,
                      ),
                      onPressed: () => mostrarToolTip.value == true
                          ? mostrarToolTip.value = false
                          : mostrarToolTip.value = true),
                );
              },
              valueListenable: mostrarToolTip,
            ),
            Expanded(
              child: ReactiveSlider(
                formControl: controlCalificacion,
                max: 4,
                divisions: 4,
                labelBuilder: (v) => v.round().toString(),
                activeColor: Colors.red,
              ),
            ),
          ],
        ),
      ]);
    }
    return const SizedBox.shrink();
  }
}

class RespuestaBaseForm extends StatelessWidget {
  final FormControl<String> controlObservacion;
  final FormArray<File> fotosControl;

  const RespuestaBaseForm({Key key, this.controlObservacion, this.fotosControl})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        ReactiveTextField(
          formControl: controlObservacion,
          decoration: const InputDecoration(
            labelText: 'Observaciones',
            prefixIcon: Icon(Icons.remove_red_eye),
          ),
          keyboardType: TextInputType.multiline,
          maxLines: null,
          textInputAction:
              TextInputAction.next, /* 
            readOnly: readOnly, */
          /*  enableInteractiveSelection: !readOnly, */
        ),
        const SizedBox(height: 10),
        //TODO: mostrar los botones de agregar imagenes y el checkbox de
        //reparación de una manera mas optima, no uno en cada fila
        FormBuilderImagePicker(
          formArray: fotosControl,
          decoration: const InputDecoration(
            labelText: 'Fotos base',
          ),
          /*  readOnly: readOnly, */
        ),
      ],
    );
  }
}

class ReparacionForm extends StatelessWidget {
  final FormControl<bool> controlReparado;
  final FormControl<String> observacionControl;
  final FormArray<File> fotosControl;
  const ReparacionForm(
      {Key key,
      this.controlReparado,
      this.observacionControl,
      this.fotosControl})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        ReactiveCheckboxListTile(
          formControl: controlReparado,
          title: const Text('Reparado'),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        // Muestra las observaciones de la reparacion solo si reparado es true
        ReactiveValueListenableBuilder(
          formControl: controlReparado,
          builder: (context, AbstractControl<bool> control, child) {
            if (control.value) {
              final observacion = observacionControl.value;
              if (observacion.length <= 1) {
                observacionControl.setErrors({'required': true});
              }
              final fotos = fotosControl.value;
              if (fotos.isEmpty) {
                fotosControl.setErrors({'required': true});
              }
              return Column(
                children: [
                  ReactiveTextField(
                    validationMessages: (control) =>
                        {'required': 'Escriba la observacion'},
                    formControl: observacionControl,
                    /*  formGroup.control('observacionReparacion') as FormControl, */
                    decoration: const InputDecoration(
                      labelText: 'Observaciones de la reparación',
                      prefixIcon: Icon(Icons.remove_red_eye),
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FormBuilderImagePicker(
                    formArray: fotosControl,
                    /* formGroup.control('fotosReparacion') as FormArray<File>, */
                    decoration: const InputDecoration(
                      labelText: 'Fotos de la reparación',
                    ),
                  ),
                ],
              );
            } else {
              observacionControl.removeError('required');
              fotosControl.removeError('required');
              return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }
}

class TituloCard extends StatelessWidget {
  final TituloFormGroup formGroup;

  const TituloCard({
    Key key,
    this.formGroup,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
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
            readOnly: false,
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
          RespuestaBaseForm(
            controlObservacion:
                formGroup.control('observacion') as FormControl<String>,
            fotosControl: formGroup.control('fotosBase') as FormArray<File>,
          ),
          if (viewModel.estado.value == EstadoDeInspeccion.enReparacion)
            ReparacionForm(
              controlReparado:
                  formGroup.control('reparado') as FormControl<bool>,
              observacionControl: formGroup.control('observacionReparacion')
                  as FormControl<String>,
              fotosControl:
                  formGroup.control('fotosReparacion') as FormArray<File>,
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
      child: Builder(
        builder: (BuildContext context) {
          if ([
            TipoDePregunta.unicaRespuesta,
            TipoDePregunta.parteDeCuadriculaUnica
          ].contains(formGroup.pregunta.pregunta.tipo)) {
            return Column(
              children: [
                if (formGroup.pregunta.pregunta.tipo ==
                    TipoDePregunta.unicaRespuesta)
                  ReactiveDropdownField<OpcionDeRespuesta>(
                    validationMessages: (control) =>
                        {'required': 'Elija una opción'},
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
                  ),
                ReactiveValueListenableBuilder<OpcionDeRespuesta>(
                  formControl: formGroup.control('respuestas')
                      as AbstractControl<OpcionDeRespuesta>,
                  builder: (BuildContext context,
                      AbstractControl<OpcionDeRespuesta> control,
                      Widget child) {
                    return CalificacionCard(
                      controlRespuesta: control?.value?.calificable ?? false,
                      controlCalificacion: formGroup.control('calificacion')
                          as FormControl<double>,
                    );
                  },
                ),
                RespuestaBaseForm(
                  controlObservacion:
                      formGroup.control('observacion') as FormControl<String>,
                  fotosControl:
                      formGroup.control('fotosBase') as FormArray<File>,
                ),
                if (viewModel.estado.value == EstadoDeInspeccion.enReparacion &&
                    formGroup.criticidad > 0)
                  ReparacionForm(
                    controlReparado:
                        formGroup.control('reparado') as FormControl<bool>,
                    fotosControl:
                        formGroup.control('fotosReparacion') as FormArray<File>,
                    observacionControl:
                        formGroup.control('observacionReparacion')
                            as FormControl<String>,
                  ),
              ],
            );
          }
          return Column(
            children: [
              if (formGroup.pregunta.pregunta.tipo ==
                  TipoDePregunta.multipleRespuesta)
                ReactiveMultiSelectDialogField<OpcionDeRespuesta>(
                  validationMessages: (control) =>
                      {'minLength': 'Elija una opción'},
                  buttonText: const Text('Seleccione entre las opciones'),
                  items: formGroup.pregunta.opcionesDeRespuesta
                      .map((e) => MultiSelectItem(e, e.texto))
                      .toList(),
                  formControl: formGroup.control('respuestas')
                      as FormControl<List<OpcionDeRespuesta>>,
                  onTap: () => FocusScope.of(context).unfocus(),
                ),
              ReactiveValueListenableBuilder(
                formControl: formGroup.control('respMultiple'),
                builder: (context, control, child) {
                  formGroup.control('fotosReparacion').removeError('required');
                  formGroup
                      .control('observacionReparacion')
                      .removeError('required');
                  return Column(children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: (control as FormArray).controls.length,
                      itemBuilder: (context, i) {
                        final element = (control as FormArray).controls[i]
                            as LlenadoOpcionFormGroup;
                        if (viewModel.estado.value ==
                                EstadoDeInspeccion.enReparacion &&
                            (element.control('respuesta').value
                                        as OpcionDeRespuesta)
                                    .criticidad ==
                                0) {
                          return const SizedBox.shrink();
                        } //Las keys sirven para que flutter maneje correctamente los widgets de la lista
                        return ExpansionTile(
                          tilePadding:
                              const EdgeInsets.only(left: 5, bottom: 10),
                          trailing: const Icon(
                            Icons.add,
                            color: Colors.black, /* color: Colors.white, */
                          ),
                          title: Text((element.control('respuesta').value
                                      as OpcionDeRespuesta)
                                  ?.texto ??
                              ''),
                          childrenPadding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          children: [
                            Builder(
                              builder: (BuildContext context) {
                                return CalificacionCard(
                                  controlRespuesta: element
                                          .control('calificable')
                                          .value as bool ??
                                      false,
                                  controlCalificacion:
                                      element.control('calificacion')
                                          as FormControl<double>,
                                );
                              },
                            ),
                            const Divider(),
                            RespuestaBaseForm(
                              controlObservacion: element.control('observacion')
                                  as FormControl<String>,
                              fotosControl: element.control('fotosBase')
                                  as FormArray<File>,
                            ),
                            if (viewModel.estado.value ==
                                EstadoDeInspeccion.enReparacion)
                              ReparacionForm(
                                controlReparado: element.control('reparado')
                                    as FormControl<bool>,
                                fotosControl: element.control('fotosReparacion')
                                    as FormArray<File>,
                                observacionControl:
                                    element.control('observacionReparacion')
                                        as FormControl<String>,
                              ),
                            const SizedBox(height: 20),
                          ],
                        );
                      },
                    ),
                  ]);
                },
              ),
            ],
          );
        },
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
    final media = MediaQuery.of(context).size;
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
                  if (e.errors.isNotEmpty) {
                    icon = const Icon(Icons.assignment_late_rounded,
                        color: Colors.red);
                  } else {
                    icon = Icon(Icons.assignment_late_rounded,
                        color: viewModel.estado.value ==
                                    EstadoDeInspeccion.enReparacion &&
                                e.criticidad > 0 &&
                                reparacion.value != true
                            ? Colors.black
                            : Colors.green);
                  }
                } else {
                  if (e.errors.isNotEmpty) {
                    icon = const Icon(
                      Icons.remove_red_eye,
                      color: Colors.red,
                    );
                  } else {
                    icon = const Icon(Icons.remove_red_eye);
                  }
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
                                child: SizedBox(
                                  width: media.width * 0.7,
                                  child: SeleccionSimpleCard(
                                    formGroup: e,
                                    readOnly: readOnly,
                                  ),
                                ),
                              ),
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
      final controlito = pregunta.control('respMultiple') as FormArray;
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
            controlito.add(
              LlenadoOpcionFormGroup(
                  opcion: opcion,
                  respuesta: pregunta.respuesta
                      ?.firstWhere((x) => x.opcionesDeRespuesta == opcion,
                          orElse: () => RespuestaConOpcionesDeRespuesta(
                              crearRespuestaPorDefecto(
                                  pregunta.pregunta.pregunta.id),
                              null))
                      ?.respuesta),
            );
          } else {
            (pregunta.control('respuestas')
                    as FormControl<List<OpcionDeRespuesta>>)
                .value
                .remove(opcion);
            controlito.clear();
            controlito.addAll(control
                .map(
                  (e) => LlenadoOpcionFormGroup(
                      opcion: e,
                      respuesta: pregunta.respuesta
                          ?.firstWhere((x) => x.opcionesDeRespuesta == opcion,
                              orElse: () => RespuestaConOpcionesDeRespuesta(
                                  crearRespuestaPorDefecto(
                                      pregunta.pregunta.pregunta.id),
                                  null))
                          ?.respuesta),
                )
                .toList());
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
