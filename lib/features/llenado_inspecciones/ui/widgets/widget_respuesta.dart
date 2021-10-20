import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/core/entities/app_image.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_multi_image_picker/reactive_multi_image_picker.dart';

import '../../control/controlador_de_pregunta.dart';
import '../../control/controlador_llenado_inspeccion.dart';
import '../../control/providers.dart';
import '../../domain/inspeccion.dart';
import 'widget_criticidad_inspector.dart';

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
        if (control.pregunta.calificable)
          WidgetCriticidadInspector(control.criticidadInspectorControl),
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
        ReactiveMultiImagePicker<AppImage, AppImage>(
          formControl: control.fotosBaseControl,
          //valueAccessor: FileValueAccessor(),
          decoration: const InputDecoration(labelText: 'Fotos base'),
          maxImages: 3,
          imageBuilder: (image) => image.when(
            remote: (url) => Image.network(url),
            mobile: (path) => Image.file(File(path)),
            web: (path) => Image.network(path),
          ),
          xFileConverter: (file) =>
              kIsWeb ? AppImage.web(file.path) : AppImage.mobile(file.path),
        ),
        Consumer(builder: (context, ref, _) {
          final estadoDeInspeccion =
              ref.watch(estadoDeInspeccionProvider).state;
          // si la criticidad de la respuesta no esta definida entonces por
          // defecto decimos que es 1
          final criticidadRespuesta =
              ref.watch(criticidadRespuestaProvider(control)) ?? 1;
          final mostrarReparacion = criticidadRespuesta > 0 &&
              estadoDeInspeccion != EstadoDeInspeccion.borrador;

          final reparado = ref.watch(reparadoProvider(control.reparadoControl));

          if (!mostrarReparacion) {
            return const SizedBox.shrink();
          } else {
            return Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  horizontalTitleGap: 0,
                  leading:
                      ReactiveCheckbox(formControl: control.reparadoControl),
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
                                formControl:
                                    control.observacionReparacionControl,
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
                                textCapitalization:
                                    TextCapitalization.sentences,
                              ),
                              ReactiveMultiImagePicker<AppImage, AppImage>(
                                formControl: control.fotosReparacionControl,
                                //valueAccessor: FileValueAccessor(),
                                decoration: const InputDecoration(
                                    labelText: 'Fotos reparacion'),
                                maxImages: 3,
                                imageBuilder: (image) => image.when(
                                  remote: (url) => Image.network(url),
                                  mobile: (path) => Image.file(File(path)),
                                  web: (path) => Image.network(path),
                                ),
                                xFileConverter: (file) => kIsWeb
                                    ? AppImage.web(file.path)
                                    : AppImage.mobile(file.path),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ],
            );
          }
        })
      ],
    );
  }
}
