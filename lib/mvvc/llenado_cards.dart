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

class TituloCard extends StatelessWidget {
  final TituloFormGroup formGroup;

  const TituloCard({Key key, this.formGroup}) : super(key: key);
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
  const NumericaCard({Key key, this.formGroup}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LlenadoFormViewModel>(context);
    return PreguntaCard(
      titulo: formGroup.pregunta.titulo,
      descripcion: formGroup.pregunta.descripcion,
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
          ),
          //TODO: mostrar los botones de agregar imagenes y el checkbox de
          //reparación de una manera mas optima, no uno en cada fila
          FormBuilderImagePicker(
            formArray: formGroup.control('fotosBase') as FormArray<File>,
            decoration: const InputDecoration(
              labelText: 'Fotos base',
            ),
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
                      /*  FormBuilderImagePicker(
                        formArray: formGroup.control('fotosReparacion')
                            as FormArray<File>,
                        decoration: const InputDecoration(
                          labelText: 'Fotos de la reparación',
                        ),
                      ), */
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
        ],
      ),
    );
  }
}

class SeleccionSimpleCard extends StatelessWidget {
  final RespuestaSeleccionSimpleFormGroup formGroup;
  
  const SeleccionSimpleCard({Key key, this.formGroup,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //TODO: Tengo que arreglar esto, pero es un machetazo para poder probar las inspecciones de preguntas condicionales. El problema es la forma en la que se está haciendo la consulta en llenado_dao, estaban saliendo repetidas las opciones.
    final List<OpcionDeRespuesta> listaOpcionesDeRespuesta = [];
    void obtenerListas() {
      formGroup.pregunta.opcionesDeRespuesta.forEach((u) => {
            if (listaOpcionesDeRespuesta.contains(u)){
            }
            else{
              listaOpcionesDeRespuesta.add(u),
            }
          });
      
    }
    obtenerListas();

    final viewModel = Provider.of<LlenadoFormViewModel>(context);
    return PreguntaCard(
      titulo: formGroup.pregunta.pregunta.titulo,
      descripcion: formGroup.pregunta.pregunta.descripcion,
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
              items: listaOpcionesDeRespuesta
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
              onChanged: (value) {
                if(formGroup.pregunta.pregunta.esCondicional == true){
                  viewModel.borrarBloque(formGroup.bloque.nOrden, formGroup.seccion,);
                }
                
              },
            ),
          if (formGroup.pregunta.pregunta.tipo ==
              TipoDePregunta.multipleRespuesta)
            ReactiveMultiSelectDialogField<OpcionDeRespuesta>(
              buttonText: const Text('Seleccione entre las opciones'),
              items: listaOpcionesDeRespuesta
                  .map((e) => MultiSelectItem(e, e.texto))
                  .toList(),
              formControl: formGroup.control('respuestas')
                  as FormControl<List<OpcionDeRespuesta>>,
              onTap: () => FocusScope.of(context).unfocus(),
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
          ),
          //TODO: mostrar los botones de agregar imagenes y el checkbox de
          //reparación de una manera mas optima, no uno en cada fila
          FormBuilderImagePicker(
            formArray: formGroup.control('fotosBase') as FormArray<File>,
            decoration: const InputDecoration(
              labelText: 'Fotos base',
            ),
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
                }
                return const SizedBox.shrink();
              },
            ),
        ],
      ),
    );
  }
}

class CuadriculaCard extends StatelessWidget {
  final RespuestaCuadriculaFormArray formArray;

  const CuadriculaCard({Key key, this.formArray}) : super(key: key);
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
                return TableRow(
                  children: [
                    Text(e.pregunta.pregunta.titulo),
                    ...formArray.cuadricula.opcionesDeRespuesta
                        .map((res) => ReactiveRadio(
                              value: res,
                              formControl:
                                  e.control('respuestas') as FormControl,
                            ))
                        .toList(),
                    IconButton(
                      icon: viewModel.estado.value !=
                                  EstadoDeInspeccion.borrador &&
                              e.criticidad > 0
                          ? const Icon(
                              Icons.broken_image,
                              color: Colors.red,
                            )
                          : const Icon(Icons.remove_red_eye),
                      onPressed: () async {
                        //FocusScope.of(context).unfocus();
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Provider(
                              create: (_) => viewModel,
                              child: SingleChildScrollView(
                                  child: SeleccionSimpleCard(formGroup: e)),
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
