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

  const CreadorTituloCard({Key key, this.formGroup}) : super(key: key);
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
            BotonesDeBloque(formGroup: formGroup),
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
              print('build sistema');
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
          ReactiveValueListenableBuilder<Sistema>(
              formControl: formGroup.control('sistema') as FormControl<Sistema>,
              builder: (context, sistema, child) {
                print('build listener sistema');
                return FutureBuilder<List<SubSistema>>(
                    future: viewModel.subSistemas(sistema.value),
                    builder: (context, snapshot) {
                      print('build future subsistema');
                      if (snapshot.connectionState == ConnectionState.done)
                        return ReactiveDropdownField<SubSistema>(
                          formControl: formGroup.control('subSistema'),
                          items: snapshot.data
                              .map((e) => DropdownMenuItem<SubSistema>(
                                    value: e,
                                    child: Text(e.nombre),
                                  ))
                              .toList(),
                          decoration: InputDecoration(
                            labelText: 'Subsistema',
                          ),
                        );
                      print('no construyo subsistema');
                      return CircularProgressIndicator();
                    });
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
            items: [TipoDePregunta.unicaRespuesta]
                .map((e) => DropdownMenuItem<TipoDePregunta>(
                      value: e,
                      child: Text(e.toString()),
                    ))
                .toList(),
            decoration: InputDecoration(
              labelText: 'Tipo de pregunta',
            ),
          ),
          SizedBox(height: 10),
          ReactiveValueListenableBuilder(
              formControl: formGroup.control('respuestas'),
              builder: (context, control, child) {
                return Column(
                  children: [
                    Text(
                      'Respuestas',
                      style: Theme.of(context).textTheme.headline6,
                    ),
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
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: ReactiveTextField(
                                      formControl: element.control('texto'),
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
                            ],
                          );
                        },
                      ),
                    MaterialButton(
                      child: Text("Agregar respuesta"),
                      onPressed: formGroup.agregarRespuesta,
                    ),
                  ],
                );
              }),
          BotonesDeBloque(formGroup: formGroup),
          // Muestra las observaciones de la reparacion solo si reparado es true
        ],
      ),
    );
  }
}

class BotonesDeBloque extends StatelessWidget {
  const BotonesDeBloque({
    Key key,
    this.formGroup,
  }) : super(key: key);

  final AbstractControl formGroup;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CreacionFormViewModel>(context);
    return ButtonBar(
      //TODO: estilizar mejor estos iconos
      alignment: MainAxisAlignment.start,
      children: [
        IconButton(
          icon: Icon(Icons.add_circle_outline),
          tooltip: 'agregar pregunta',
          onPressed: () => viewModel.agregarPreguntaDespuesDe(formGroup),
        ),
        IconButton(
          icon: Icon(Icons.format_size),
          tooltip: 'agregar titulo',
          onPressed: () => viewModel.agregarTituloDespuesDe(formGroup),
        ),
        IconButton(
          icon: Icon(Icons.view_module),
          tooltip: 'agregar cuadricula',
          onPressed: () => viewModel.agregarCuadriculaDespuesDe(formGroup),
        ),
        IconButton(
          icon: Icon(Icons.delete),
          tooltip: 'borrar bloque',
          onPressed: () => viewModel.borrarBloque(formGroup),
        ),
      ],
    );
  }
}

class CreadorCuadriculaCard extends StatelessWidget {
  final CreadorPreguntaCuadriculaFormArray formArray;

  const CreadorCuadriculaCard({Key key, this.formArray}) : super(key: key);
  @override
  Widget build(BuildContext context) {
/*
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
    );*/
  }
}
