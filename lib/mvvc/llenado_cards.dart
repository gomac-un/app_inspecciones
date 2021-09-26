import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/mvvc/common_widgets.dart';
import 'package:inspecciones/mvvc/llenado_controls.dart';
import 'package:inspecciones/mvvc/llenado_form_view_model.dart';
import 'package:inspecciones/presentation/widgets/reactive_filter_chip_selection.dart';
import 'package:inspecciones/presentation/widgets/reactive_multiselect_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_multi_image_picker/reactive_multi_image_picker.dart';

/// Cuando se selecciona una respuesta a la que se le pueda asignar una gravedad propia
/// Se muestra esta Card
class CalificacionCard extends StatelessWidget {
  final bool controlRespuesta;
  final FormControl<double> controlCalificacion;

  const CalificacionCard(
      {Key? key, this.controlRespuesta, this.controlCalificacion})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (controlRespuesta ?? false) {
      return Column(children: [
        const SizedBox(height: 10),
        const Text('Criticidad', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Text(
          'Asigne una criticidad dependiendo del estado de la falla',
          style: Theme.of(context).textTheme.caption,
          textAlign: TextAlign.center,
        ),
        Row(
          children: [
            IconButton(
              iconSize: 20,
              icon: const Icon(
                Icons.info,
              ),
              onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text(
                      'Nivel de gravedad de la falla',
                      textAlign: TextAlign.center,
                    ),
                    content: Text(
                      "Cada opción representa un porcentaje de la gravedad de la falla así:\n\n-Criticidad 1 representa el 55%\n-Criticidad 2 representa el 70%\n-Criticidad 3 representa el 80%\n-Criticidad 4 representa el 100%",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Aceptar',
                          /* style: TextStyle(
                                color: Theme.of(context).accentColor) */
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
            Expanded(
              child: ReactiveSlider(
                formControl: controlCalificacion,
                min: 1,
                max: 4,
                divisions: 3,
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

/// Widget que reúne los Widgets comúnes a la respuesta de las preguntas
class RespuestaBaseForm extends StatelessWidget {
  final FormControl<String> controlObservacion;
  final FormArray<File> fotosControl;

  const RespuestaBaseForm(
      {Key? key, this.controlObservacion, this.fotosControl})
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
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization
              .sentences, /* 
            readOnly: readOnly, */
          /*  enableInteractiveSelection: !readOnly, */
        ),
        const SizedBox(height: 10),
        //TODO: mostrar los botones de agregar imagenes y el checkbox de
        //reparación de una manera mas optima, no uno en cada fila
        ReactiveMultiImagePicker(
          formControl: fotosControl,
          decoration: const InputDecoration(
            labelText: 'Fotos base',
          ),
          /*  readOnly: readOnly, */
        ),
      ],
    );
  }
}

/// Form que recoge los widgets necesarios para la reparación de las novedades
class ReparacionForm extends StatelessWidget {
  final FormControl<bool> controlReparado;
  final FormControl<String> observacionControl;
  final FormArray<File> fotosControl;
  const ReparacionForm(
      {Key? key,
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
              /// Si está reparado y no ha agregado observaciones y fotos.
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
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ReactiveMultiImagePicker(
                    formControl: fotosControl,
                    /* formGroup.control('fotosReparacion') as FormArray<File>, */
                    decoration: const InputDecoration(
                      labelText: 'Fotos de la reparación',
                    ),
                  ),
                ],
              );
            } else {
              /// Si habían errores y se corrigieron se remueven para que permita la finalización
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

/// Card que devuelve los titulos de la inspección.
class TituloCard extends StatelessWidget {
  /// Datos
  final TituloFormGroup formGroup;

  const TituloCard({
    Key? key,
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

/// Card para las preguntas numericas.
class NumericaCard extends StatelessWidget {
  /// Validación.
  final RespuestaNumericaFormGroup formGroup;
  final bool readOnly;
  const NumericaCard({Key? key, this.formGroup, this.readOnly = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LlenadoFormViewModel>(context);

    /// Criticidad definida de la pregunta si es borrador, en otro caso, devuelve la
    /// criticidad total de la pregunta (criticidad de la pregunta * criticidad de la respuesta)
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
      criticidad: criticidad.toDouble(),
      posicion:
          '${formGroup.pregunta.eje}, ${formGroup.pregunta.lado}, ${formGroup.pregunta.posicionZ}',
      estado: mensajeCriticidad,
      child: Column(
        children: [
          if (formGroup.pregunta.fotosGuia.size > 0)
            ImagesPreviewer(
              items: formGroup.pregunta.fotosGuia
                  .map((e) => File(e))
                  .iter
                  .toList(),
            ),
          ReactiveTextField(
            formControl: formGroup.control('valor') as FormControl,
            validationMessages: (control) =>
                {'required': 'Escriba la respuesta'},
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Ej. 45.65",
            ),
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

/// Card correspondiente a las preguntas de selección.
class SeleccionSimpleCard extends StatelessWidget {
  /// Validaciones.
  final RespuestaSeleccionSimpleFormGroup formGroup;
  final bool readOnly;

  const SeleccionSimpleCard({
    Key? key,
    this.formGroup,
    this.readOnly,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LlenadoFormViewModel>(context);

    /// Criticidad definida de la pregunta si es borrador, en otro caso, devuelve la
    /// criticidad total de la pregunta (criticidad de la pregunta * criticidad de la respuesta)
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
      criticidad: criticidad.toDouble(),
      posicion:
          '${formGroup.pregunta.pregunta.eje}, ${formGroup.pregunta.pregunta.lado}, ${formGroup.pregunta.pregunta.posicionZ}',
      estado: mensajeCriticidad,
      child: Builder(
        builder: (BuildContext context) {
          /// El DropDown que se muestra es diferente dependiendo del tipo de pregunta.
          ///
          /// Para las de tipo unico, el control del formGroup es 'respuestas'.
          /// Para las de tipo multiple, el control del formGroup es 'respMultiple'.
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
                  builder: (context, control, child) => CalificacionCard(
                    controlRespuesta: control.value?.calificable ?? false,
                    controlCalificacion: formGroup.control('calificacion')
                        as FormControl<double>,
                  ),
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
                ReactiveFilterChipSelection<OpcionDeRespuesta,
                    OpcionDeRespuesta>(
                  validationMessages: (control) =>
                      {'minLength': 'Elija una opción'},

                  decoration: const InputDecoration(
                    labelText: 'Seleccione entre las opciones',
                  ),
                  posibleItems: formGroup.pregunta.opcionesDeRespuesta,
                  labelAccesor: (opcion) => opcion.texto,

                  /// Se usa el control 'respuestas', solo para mostrarlos en los chips.
                  /// De aquí en adelante, se usa respMultiple para poder manejar como
                  /// respuestas independientes, con sus respectivas fotos y observaciones.
                  formControl: formGroup.control('respuestas')
                      as FormControl<List<OpcionDeRespuesta>>,
                ),
              ReactiveValueListenableBuilder(
                formControl: formGroup.control('respMultiple'),
                builder: (context, control, child) {
                  formGroup.control('fotosReparacion').removeError('required');
                  formGroup
                      .control('observacionReparacion')
                      .removeError('required');
                  return Column(children: [
                    /// Esta lista se va construyendo de acuerdo a las respuestas que se vayan seleccionando.
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

/// Card que maneja las preguntas de tipo cuadricula.
class CuadriculaCard extends StatelessWidget {
  /// Validaciones.
  final RespuestaCuadriculaFormArray formArray;
  final bool readOnly;

  const CuadriculaCard({Key? key, this.formArray, this.readOnly})
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
          //TODO: el ancho minimo de cada columna debe ser el ancho de la palabra
          //mas larga del titulo de la pregunta para evitar que se corten
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

/// Muestra reactiveCheckBox o ReactiveRadio dependiendo de si es cuadricula con selección unica o multiple.
class WidgetSeleccion extends StatefulWidget {
  final RespuestaSeleccionSimpleFormGroup pregunta;
  final OpcionDeRespuesta opcion;
  const WidgetSeleccion({Key? key, this.pregunta, this.opcion})
      : super(key: key);

  @override
  _WidgetSeleccionState createState() => _WidgetSeleccionState();
}

class _WidgetSeleccionState extends State<WidgetSeleccion> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    if (widget.pregunta.pregunta.pregunta.tipo ==
        TipoDePregunta.parteDeCuadriculaMultiple) {
      final control = (widget.pregunta.control('respuestas')
              as FormControl<List<OpcionDeRespuesta>>)
          .value;
      final controlito = widget.pregunta.control('respMultiple') as FormArray;
      _isSelected = control?.contains(widget.opcion) ?? false;
      return Checkbox(
        value: _isSelected,
        onChanged: (newValue) {
          setState(() {
            _isSelected = newValue;
          });

          /// Cuando cambia el valor, si es una respuesta que no estaba seleccionada,
          /// Se agrega al nuevo control para mostrar.
          /// Ademas se agrega a los controles, para poder tener registro de los datos.
          if (newValue) {
            if (!control?.contains(widget.opcion) ?? false) {
              control.add(widget.opcion);
            }
            controlito.add(
              LlenadoOpcionFormGroup(
                  opcion: widget.opcion,
                  respuesta: widget.pregunta.respuesta
                      ?.firstWhere(
                          (x) => x.opcionesDeRespuesta == widget.opcion,
                          orElse: () => RespuestaConOpcionesDeRespuesta(
                              crearRespuestaPorDefecto(
                                  widget.pregunta.pregunta.pregunta.id),
                              null))
                      ?.respuesta),
            );
          } else {
            (widget.pregunta.control('respuestas')
                    as FormControl<List<OpcionDeRespuesta>>)
                .value
                .remove(widget.opcion);
            controlito.clear();
            controlito.addAll(control
                .map(
                  (e) => LlenadoOpcionFormGroup(
                      opcion: e,
                      respuesta: widget.pregunta.respuesta
                          ?.firstWhere(
                              (x) => x.opcionesDeRespuesta == widget.opcion,
                              orElse: () => RespuestaConOpcionesDeRespuesta(
                                  crearRespuestaPorDefecto(
                                      widget.pregunta.pregunta.pregunta.id),
                                  null))
                          ?.respuesta),
                )
                .toList());
          }
        },
      );
    } else {
      return ReactiveRadio(
        value: widget.opcion,
        formControl: widget.pregunta.control('respuestas')
            as FormControl<OpcionDeRespuesta>,
      );
    }
  }
}
