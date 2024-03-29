import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/features/configuracion_organizacion/administrador_de_etiquetas.dart';
import 'package:inspecciones/features/configuracion_organizacion/domain/entities.dart';
import 'package:inspecciones/presentation/widgets/app_image_multi_image_picker.dart';
import 'package:inspecciones/presentation/widgets/reactive_textfield_tags.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'creacion_controls.dart';
import 'creacion_form_controller.dart';
import 'creador_cuadricula_card.dart';
import 'creador_numerica_card.dart';
import 'creador_seleccion_simple_card.dart';
import 'creador_titulo_card.dart';

final numeroDeBloqueProvider =
    Provider<int>((ref) => throw Exception("numero de bloque no definido"));

/// Definición de los Widgets usados en los bloques de la creación de cuestionarios.
///
/// Los formGroups se definen en [creacion_controls.dart] y son los encargados de hacer las validaciones.

/// Widget que elige que Card mostrar dependiendo de tipo de formGroup que sea [controller]
///
///Se usa en la animatedList de creacion_form_page.dart.
class ControlWidget extends StatelessWidget {
  final CreacionController controller;

  const ControlWidget(this.controller, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = this.controller;
    //pendejada para que dart pueda hacer el cast con los ifs solamente
    if (controller is CreadorTituloController) {
      return CreadorTituloCard(
          //Las keys se necesitan cuando tenemos una lista dinamica de elementos
          // del mismo tipo en flutter
          key: ValueKey(controller),
          controller: controller);
    }
    if (controller is CreadorPreguntaController) {
      return CreadorSeleccionSimpleCard(
          key: ValueKey(controller), controller: controller);
    }
    if (controller is CreadorPreguntaCuadriculaController) {
      return CreadorCuadriculaCard(
          key: ValueKey(controller), controller: controller);
    }
    if (controller is CreadorPreguntaNumericaController) {
      return CreadorNumericaCard(
          key: ValueKey(controller), preguntaController: controller);
    }
    return Text(
        "error: el bloque $controller no tiene una card que lo renderice, por favor informe de este error");
  }
}

class ControlWidgetAnimado extends StatelessWidget {
  final Animation<double> animation;
  final CreacionController controller;

  const ControlWidgetAnimado({
    Key? key,
    required this.controller,
    required this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      child: ControlWidget(controller),
    );
  }
}

class CamposGenerales extends StatelessWidget {
  final CamposGeneralesPreguntaController controller;
  const CamposGenerales({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Como es de selección, se asegura que los unicos tipos de pregunta que pueda seleccionar el creador
    /// sean de unica o multiple respuesta

    return Column(
      children: [
        ReactiveTextField(
          formControl: controller.tituloControl,
          validationMessages: (control) =>
              {ValidationMessage.required: 'El titulo no debe estar vacío'},
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
          formControl: controller.descripcionControl,
          decoration: const InputDecoration(
            labelText: 'Descripción',
          ),
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 50,
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 10),
        Consumer(builder: (context, ref, _) {
          final todasLasJerarquias =
              ref.watch(listaEtiquetasDePreguntasProvider).asData?.value ??
                  const <Jerarquia>[];

          return ReactiveTextFieldTags(
            decoration: const InputDecoration(labelText: "etiquetas"),
            formControl: controller.etiquetasControl,
            optionsBuilder: (TextEditingValue val) => controller
                .getEtiquetasDisponibles(todasLasJerarquias)
                .where((e) =>
                    e.clave.toLowerCase().contains(val.text.toLowerCase())),
            onMenu: () {
              showDialog(
                context: context,
                builder: (_) => const MenuDeEtiquetas(TipoDeEtiqueta.pregunta),
              );
            },
          );
        }),
        const SizedBox(height: 10),
        InputDecorator(
          decoration: const InputDecoration(
              labelText: 'Criticidad de la pregunta', filled: false),
          child: ReactiveSlider(
            formControl: controller.criticidadControl,
            max: 4,
            divisions: 4,
            labelBuilder: (v) => v.round().toString(),
            activeColor: Colors.red,
          ),
        ),
        AppImageMultiImagePicker(
          formControl: controller.fotosGuiaControl,
          label: 'Fotos guía',
          maxImages: 3,
        ),
      ],
    );
  }
}

/// Reune todas las acciones comunes a todos los bloques, incluye agregar nuevo
/// tipo de pregunta, agregar titulo, copiar y pegar bloque
class BotonesDeBloque extends ConsumerWidget {
  const BotonesDeBloque({
    Key? key,
    required this.controllerActual,
  }) : super(key: key);

  final CreacionController controllerActual;

  @override
  Widget build(BuildContext context, ref) {
    if (controllerActual.control.disabled) return const SizedBox.shrink();
    final formController = ref.watch(
        creacionFormControllerProvider(ref.watch(cuestionarioIdProvider)));
    final animatedList = SliverAnimatedList.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// Añade control [CreadorPreguntaFormGroup()] al control 'bloques' del
        /// cuestionario y muestra widget [CreadorSeleccionSimpleCard]
        IconButton(
          icon: const Icon(Icons.add_circle),
          tooltip: 'Pregunta de selección',
          onPressed: () => agregarBloque(
            formController,
            animatedList,
            //TODO: mover a logica de creacion al [formController]
            CreadorPreguntaController(),
          ),
        ),

        /// Añade control [CreadorPreguntaNumericaFormGroup()] al control 'bloques' del cuestionario y muestra widget [CreadorNumericaCard]
        IconButton(
          icon: const Icon(Icons.calculate),
          tooltip: 'Pregunta Numérica',
          onPressed: () => agregarBloque(
            formController,
            animatedList,
            CreadorPreguntaNumericaController(),
          ),
        ),

        /// Añade control [CreadorPreguntaCuadriculaFormGroup()] al control 'bloques' del cuestionario y muestra widget [CreadorCuadriculaCard]
        IconButton(
          icon: const Icon(Icons.view_module),
          tooltip: 'Agregar cuadricula',
          onPressed: () => agregarBloque(
            formController,
            animatedList,
            CreadorPreguntaCuadriculaController(),
          ),
        ),

        /// Añade control [CreadorTituloFormGroup()] al control 'bloques' del cuestionario y muestra widget [CreadorTituloCard]
        IconButton(
          icon: const Icon(Icons.format_size),
          tooltip: 'Agregar titulo',
          onPressed: () => agregarBloque(
            formController,
            animatedList,
            CreadorTituloController(),
          ),
        ),

        /// Muestra numero de bloque y las opciones de copiar, pegar y borrar bloque
        Consumer(builder: (_, ref, __) {
          return PopupMenuButton<int>(
            padding: const EdgeInsets.all(2.0),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: ListTile(
                  /* 
                    leading: const Icon(Icons.copy), */
                  title: Text(
                    'Bloque número ${ref.watch(numeroDeBloqueProvider) + 1}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  selected: true,
                  onTap: () => {},
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: ListTile(
                  leading: Icon(
                    Icons.copy,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  title: Text('Copiar bloque',
                      style: TextStyle(color: Colors.grey[800])),
                  selected: true,
                  onTap: () => {
                    copiarBloque(formController),
                    ScaffoldMessenger.of(context).showSnackBar(
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
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  title: Text('Pegar bloque',
                      style: TextStyle(color: Colors.grey[800])),
                  selected: true,
                  onTap: () => {
                    pegarBloque(formController, animatedList),
                    ScaffoldMessenger.of(context).showSnackBar(
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
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    selected: true,
                    title: Text('Borrar bloque',
                        style: TextStyle(color: Colors.grey[800])),
                    onTap: () => {
                          borrarBloque(formController, animatedList),
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Bloque eliminado'),
                            ),
                          ),
                          Navigator.pop(context),
                        }),
              ),
            ],
          );
        }),
      ],
    );
  }

  /// Estos metodos son usados para mostrar en la UI, pero tambien acceden a los controles de [viewModel]
  /// Copia bloque.
  void copiarBloque(CreacionFormController formController) {
    formController.bloqueCopiado = controllerActual;
  }

  /// Pega bloque despues del bloque actual [formGroup]
  Future<void> pegarBloque(CreacionFormController formController,
      SliverAnimatedListState animatedList) async {
    final bloqueCopiado = formController.bloqueCopiado;
    if (bloqueCopiado != null) {
      agregarBloque(formController, animatedList, bloqueCopiado.copy());
    }
  }

  /// Borra el bloque seleccionado [formGroup]
  void borrarBloque(CreacionFormController formController,
      SliverAnimatedListState animatedList) {
    final index = formController.controllersBloques.indexOf(controllerActual);
    if (index == 0) return; //no borre el primer titulo
    /// Elimina de la lista en la pantalla
    animatedList.removeItem(
      index,
      (context, animation) => ControlWidgetAnimado(
        controller: controllerActual,
        animation: animation,
      ),
    );

    /// Elimina el control de los bloques de [viewModel]
    formController.borrarBloque(controllerActual);
  }

  /// Agrega un bloque despues del seleccionado
  void agregarBloque(
    CreacionFormController formController,
    SliverAnimatedListState animatedList,
    CreacionController nuevo,
  ) {
    /// Lo inserta en la lista de la UI
    animatedList.insertItem(
        formController.controllersBloques.indexOf(controllerActual) + 1);

    /// Lo elimina de los controles de [formController]
    formController.agregarBloqueDespuesDe(
      bloque: nuevo,
      despuesDe: controllerActual,
    );
  }
}
