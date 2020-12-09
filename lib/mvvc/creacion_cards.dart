import 'dart:io';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/mvvc/common_widgets.dart';
import 'package:inspecciones/mvvc/llenado_form_view_model.dart';
import 'package:inspecciones/presentation/widgets/image_shower.dart';
import 'package:inspecciones/presentation/widgets/images_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

class TituloCardl extends StatelessWidget {
  final TituloFormGroup formGroup;

  const TituloCardl({Key key, this.formGroup}) : super(key: key);
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

class SeleccionSimpleCardl extends StatelessWidget {
  final RespuestaSeleccionSimpleFormGroup formGroup;

  const SeleccionSimpleCardl({Key key, this.formGroup}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PreguntaCard(
      titulo: formGroup.pregunta.pregunta.titulo,
      descripcion: formGroup.pregunta.pregunta.descripcion,
      child: Column(
        children: [
          if (formGroup.pregunta.pregunta.fotosGuia.length > 0)
            ImageShower(
              imagenes: formGroup.pregunta.pregunta.fotosGuia
                  .map((e) => File(e))
                  .toList(),
            ),
          ReactiveDropdownField<OpcionDeRespuesta>(
            formControl: formGroup.control('respuesta'),
            items: formGroup.pregunta.opcionesDeRespuesta
                .map((e) => DropdownMenuItem<OpcionDeRespuesta>(
                    value: e, child: Text(e.texto)))
                .toList(),
            decoration: InputDecoration(
              labelText: 'Seleccione una opción',
            ),
          ),
          SizedBox(height: 10),
          ReactiveTextField(
            formControl: formGroup.control('observacion'),
            decoration: InputDecoration(
              labelText: 'Observaciones',
              prefixIcon: Icon(Icons.remove_red_eye),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
            ),
            keyboardType: TextInputType.multiline,
            maxLines: null,
            textInputAction: TextInputAction.next,
          ),
          //TODO: mostrar los botones de agregar imagenes y el checkbox de
          //reparación de una manera mas optima, no uno en cada fila
          FormBuilderImagePicker(
            formArray: formGroup.control('fotosBase'),
            decoration: const InputDecoration(
              labelText: 'Fotos base',
            ),
          ),
          ReactiveCheckboxListTile(
            formControl: formGroup.control('reparado'),
            title: Text('Reparado'),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          // Muestra las observaciones de la reparacion solo si reparado es true
          ReactiveValueListenableBuilder(
            formControl: formGroup.control('reparado') as FormControl<bool>,
            builder: (context, control, child) {
              if (control.value)
                return Column(
                  children: [
                    ReactiveTextField(
                      formControl: formGroup.control('observacionReparacion'),
                      decoration: InputDecoration(
                        labelText: 'Observaciones de la reparación',
                        prefixIcon: Icon(Icons.remove_red_eye),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      textInputAction: TextInputAction.next,
                    ),
                    FormBuilderImagePicker(
                      formArray: formGroup.control('fotosReparacion'),
                      decoration: const InputDecoration(
                        labelText: 'Fotos de la reparación',
                      ),
                    ),
                  ],
                );
              return SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

class CuadriculaCardl extends StatelessWidget {
  final RespuestaCuadriculaFormArray formArray;

  const CuadriculaCardl({Key key, this.formArray}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PreguntaCard(
      titulo: formArray.cuadricula.cuadricula.titulo,
      descripcion: formArray.cuadricula.cuadricula.descripcion,
      child: Table(
        border:
            TableBorder(horizontalInside: BorderSide(color: Colors.black26)),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        // defaultColumnWidth: IntrinsicColumnWidth(), // esto es caro
        columnWidths: {0: FlexColumnWidth(2)},
        children: [
          TableRow(
            children: [
              Text(""),
              ...formArray.cuadricula.opcionesDeRespuesta.map(
                (e) => Text(
                  e.texto,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          //IterableZip permite recorrer simultaneamente los dos arrays
          ...IterableZip([formArray.preguntasRespondidas, formArray.controls])
              .map((e) {
            final pregunta = e[0] as PreguntaConRespuestaConOpcionesDeRespuesta;
            final ctrlPregunta = e[1] as FormControl<OpcionDeRespuesta>;
            return TableRow(
              children: [
                Text(pregunta.pregunta.titulo),
                ...formArray.cuadricula.opcionesDeRespuesta
                    .map((res) => ReactiveRadio(
                          value: res,
                          formControl: ctrlPregunta,
                        ))
                    .toList(),
                //TODO: agregar controles para agregar fotos y reparaciones, tal vez con popups
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}
