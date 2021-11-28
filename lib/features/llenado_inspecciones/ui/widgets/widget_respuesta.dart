import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/bloques/pregunta.dart';
import 'package:inspecciones/presentation/widgets/app_image_multi_image_picker.dart';
import 'package:inspecciones/utils/hooks.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../control/controlador_de_pregunta.dart';
import '../../domain/inspeccion.dart';

class WidgetRespuesta extends StatelessWidget {
  final ControladorDePregunta control;

  const WidgetRespuesta(
    this.control, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ReactiveTextField(
          formControl: control.observacionControl,
          decoration: const InputDecoration(
            labelText: 'Observaciones',
            prefixIcon: Icon(Icons.remove_red_eye),
          ),
          maxLines: null,
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
        ),
        AppImageMultiImagePicker(
          formControl: control.fotosBaseControl,
          label: 'Fotos base',
          maxImages: 3,
        ),
        _ReparacionWidget(control: control)
      ],
    );
  }
}

class _ReparacionWidget extends HookWidget {
  const _ReparacionWidget({
    Key? key,
    required this.control,
  }) : super(key: key);

  final ControladorDePregunta<Pregunta<Respuesta>, AbstractControl> control;

  @override
  Widget build(BuildContext context) {
    final estadoDeInspeccion =
        useValueStream(control.controlInspeccion.estadoDeInspeccion);

    final criticidadRespuesta = useValueStream(control.criticidadRespuesta);

    final mostrarReparacion = (criticidadRespuesta ?? 0) > 0 &&
        estadoDeInspeccion != EstadoDeInspeccion.borrador;

    final reparado = useControlValue(control.reparadoControl)!;

    if (!mostrarReparacion) {
      return const SizedBox.shrink();
    } else {
      return Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            horizontalTitleGap: 0,
            leading: ReactiveCheckbox(formControl: control.reparadoControl),
            title: const Text("reparado"),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: SizedBox(
              height: reparado ? null : 0,
              child: reparado
                  ? Column(
                      children: [
                        ReactiveTextField(
                          formControl: control.observacionReparacionControl,
                          validationMessages: (control) => {
                            ValidationMessage.required:
                                'La observación es requerida'
                          },
                          decoration: const InputDecoration(
                            labelText: 'Observaciones reparación',
                            prefixIcon: Icon(Icons.remove_red_eye),
                          ),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        AppImageMultiImagePicker(
                          formControl: control.fotosReparacionControl,
                          label: 'Fotos reparacion',
                          maxImages: 3,
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      );
    }
  }
}
