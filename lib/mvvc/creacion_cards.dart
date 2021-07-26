import 'dart:io';
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

/// Definición de los Widgets usados en los bloques de la creación de cuestionarios.
///
/// Los formGroups se definen en [creacion_controls.dart] y son los encargados de hacer las validaciones.

/// Cuando en el formulario se presiona añadir titulo, este es el widget que se muestra
class CreadorTituloCard extends StatelessWidget {
  final CreadorTituloFormGroup formGroup;

  /// Numero de bloque que se muestra en PopUpMenu.
  /// Ver [BotonesDeBloque]
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
              textCapitalization: TextCapitalization.sentences,
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
              textCapitalization: TextCapitalization.sentences,
            ),

            /// Row con widgets que permiten añadir o pegar otro bloque debajo del actual.
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

//TODO: Unificar las cosas en común de los dos tipos de pregunta: las de seleccion y la numéricas.
/// Widget usado para la creación de preguntas numericas
class CreadorNumericaCard extends StatelessWidget {
  final CreadorPreguntaNumericaFormGroup formGroup;

  /// Numero de bloque
  final int nro;

  const CreadorNumericaCard({Key key, this.formGroup, this.nro})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreguntaCard(
        titulo: 'Pregunta numérica',
        child: Column(
          children: [
            /// Intento de unificar los widgets de cada pregunta
            TipoPreguntaCard(formGroup: formGroup),
            const SizedBox(height: 20),

            /// Widget para añadir los rangos y su respectiva criticidad
            CriticidadCard(formGroup: formGroup),
            const SizedBox(height: 20),

            /// Row con widgets que permiten añadir o pegar otro bloque debajo del actual.
            BotonesDeBloque(formGroup: formGroup, nro: nro),
          ],
        ));
  }
}

/// Widget  usado en la creación de preguntas de selección
class CreadorSeleccionSimpleCard extends StatelessWidget {
  /// Validaciones y métodos utiles
  final CreadorPreguntaFormGroup formGroup;

  /// Numero de bloque
  final int nro;

  const CreadorSeleccionSimpleCard({Key key, this.formGroup, this.nro})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Se accede a este provider del formulario base de creación para poder cargar los subsistemas de acuerdo al sistema elegido
    final viewModel = Provider.of<CreacionFormViewModel>(context);

    /// Como es de selección, se asegura que los unicos tipos de pregunta que pueda seleccionar el creador
    /// sean de unica o multiple respuesta
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
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
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
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 10),

          /// Cuando cambia el valor de sistema en el formulario base, los subsistemas tambien se actualizan
          /// Este ValueListenableBuilder, escucha esos cambios y actualiza las opciones de susbsistema en cada preguta
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
                  onTap: () {
                    FocusScope.of(context)
                        .unfocus(); // para que no salte el teclado si tenia un textfield seleccionado
                  },
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
            onTap: () {
              FocusScope.of(context)
                  .unfocus(); // para que no salte el teclado si tenia un textfield seleccionado
            },
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
            onTap: () {
              FocusScope.of(context)
                  .unfocus(); // para que no salte el teclado si tenia un textfield seleccionado
            },
          ),
          const SizedBox(height: 10),

          /// Este widget ([CreadorSeleccionSimpleCard]) también es usado cuando se añade una pregunta (fila) a una cuadricula
          /// para añadir los detalles (fotosGuia, descripcion...) por lo cual hay que hacer está validación
          /// para que al ser parte de cuadricula no de la opción de añadir respuestas o más bloques.
          if (!formGroup.parteDeCuadricula)
            Column(
              children: [
                WidgetRespuestas(formGroup: formGroup),
                BotonesDeBloque(formGroup: formGroup, nro: nro),
              ],
            )
        ],
      ),
    );
  }
}

/// Widget usado para añadir las opciones de respuesta a las preguntas de cuadricula o de selección
class WidgetRespuestas extends StatelessWidget {
  const WidgetRespuestas({
    Key key,
    @required this.formGroup,
  }) : super(key: key);

  final ConRespuestas formGroup;

  @override
  Widget build(BuildContext context) {
    /// mostrar Tooltip con descripcion de lo que significa que una opcion de respuesta sea calificable
    final mostrarToolTip = ValueNotifier<bool>(false);

    /// Como las respuestas se van añadiendo dinámicamente, este  ReactiveValueListenableBuilder escucha, por decirlo asi,
    /// el length del control respuestas [formControl], así cada que se va añadiendo una opción, se muestra el nuevo widget en la UI
    return ReactiveValueListenableBuilder(
        formControl: (formGroup as FormGroup).control('respuestas'),
        builder: (context, control, child) {
          return Column(
            children: [
              Text(
                'Respuestas',
                style: Theme.of(context).textTheme.headline6,
              ),

              /// Si no se ha añadido ninguna opción de respuesta
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
                                keyboardType: TextInputType.multiline,
                                maxLines: 3,
                                textCapitalization:
                                    TextCapitalization.sentences,
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

              /// Se muestra este botón por defecto, al presionarlo se añade un nuevo control al FormArray [formGroup.control('respuestas')]
              /// Y así se va actualizando la lista
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

/// Reúne todas las acciones comunes a todos los bloques, incluye agregar nuevo tipo de pregunta, agregar titulo, copiar y pegar bloque
class BotonesDeBloque extends StatelessWidget {
  /// Numero de bloque
  final int nro;
  const BotonesDeBloque({Key key, this.formGroup, this.nro}) : super(key: key);

  final AbstractControl formGroup;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// Añade control [CreadorPreguntaFormGroup()] al control 'bloques' del cuestionario y muestra widget [CreadorSeleccionSimpleCard]
        IconButton(
          icon: const Icon(Icons.add_circle),
          tooltip: 'Pregunta de selección',
          onPressed: () => agregarBloque(context, CreadorPreguntaFormGroup()),
        ),

        /// Añade control [CreadorPreguntaNumericaFormGroup()] al control 'bloques' del cuestionario y muestra widget [CreadorNumericaCard]
        IconButton(
          icon: const Icon(Icons.calculate),
          tooltip: 'Pregunta Númerica',
          onPressed: () =>
              agregarBloque(context, CreadorPreguntaNumericaFormGroup()),
        ),

        /// Añade control [CreadorPreguntaCuadriculaFormGroup()] al control 'bloques' del cuestionario y muestra widget [CreadorCuadriculaCard]
        IconButton(
          icon: const Icon(Icons.view_module),
          tooltip: 'Agregar cuadricula',
          onPressed: () =>
              agregarBloque(context, CreadorPreguntaCuadriculaFormGroup()),
        ),

        /// Añade control [CreadorTituloFormGroup()] al control 'bloques' del cuestionario y muestra widget [CreadorTituloCard]
        IconButton(
          icon: const Icon(Icons.format_size),
          tooltip: 'Agregar titulo',
          onPressed: () => agregarBloque(context, CreadorTituloFormGroup()),
        ),

        /// Muestra numero de bloque y las opciones de copiar, pegar y borrar bloque
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

  /// Estos metodos son usados para mostrar en la UI, pero tambien acceden a los controles de [viewModel]
  /// Copia bloque.
  void copiarBloque(BuildContext context) {
    final viewModel =
        Provider.of<CreacionFormViewModel>(context, listen: false);
    viewModel.bloqueCopiado = formGroup as Copiable;
  }

  /// Pega bloque despues del bloque actual [formGroup]
  Future<void> pegarBloque(BuildContext context) async {
    final viewModel =
        Provider.of<CreacionFormViewModel>(context, listen: false);
    agregarBloque(context, await viewModel.bloqueCopiado.copiar());
  }

  /// Borra el bloque seleccionado [formGroup]
  void borrarBloque(BuildContext context) {
    final viewModel =
        Provider.of<CreacionFormViewModel>(context, listen: false);

    final index = (formGroup.parent as FormArray).controls.indexOf(formGroup);
    if (index == 0) return; //no borre el primer titulo
    /// Elimina de la lista en la pantalla
    AnimatedList.of(context).removeItem(
      index,
      (context, animation) => ControlWidgetAnimado(
        element: formGroup,
        index: index,
        animation: animation,
      ),
    );

    /// Elimina el control de los bloques de [viewModel]
    viewModel.borrarBloque(formGroup);
  }

  /// Agrega un bloque despues del seleccionado
  void agregarBloque(BuildContext context, AbstractControl nuevo) {
    final viewModel =
        Provider.of<CreacionFormViewModel>(context, listen: false);

    /// Lo inserta en la lista de la UI
    AnimatedList.of(context).insertItem(
        (formGroup.parent as FormArray).controls.indexOf(formGroup) + 1);

    /// Lo elimina de los controles de [viewModel]
    viewModel.agregarBloqueDespuesDe(bloque: nuevo, despuesDe: formGroup);
  }
}

/// Widget que elige que Card mostrar dependiendo de tipo de formGroup que sea [element]
///
///Se usa en la animatedList de creacion_form_page.dart.
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
