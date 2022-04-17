import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:inspecciones/utils/hooks.dart';

import '../../control/controlador_llenado_inspeccion.dart';

class FilterWidget extends HookWidget {
  final ControladorLlenadoInspeccion controladorInspeccion;

  const FilterWidget(
    this.controladorInspeccion, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filtrosDisponibles = [FiltroPreguntas.todas];
    final int criticas =
        useValueStream(controladorInspeccion.controladoresCriticos).length;
    if (criticas != 0) {
      filtrosDisponibles.add(FiltroPreguntas.criticas);
    }
    final invalidas = controladorInspeccion.controladores
        .any((element) => !element.esValido());
    if (invalidas) {
      filtrosDisponibles.add(FiltroPreguntas.invalidas);
    }

    final filtro = useValueStream(controladorInspeccion.filtroPreguntas);
    return DropdownButtonHideUnderline(
      child: DropdownButton<FiltroPreguntas>(
        value: filtro,
        items: filtrosDisponibles
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(EnumToString.convertToString(e, camelCase: true)),
                ))
            .toList(),
        selectedItemBuilder: (_) => filtrosDisponibles
            .map((e) => Center(
                  child: Text(
                    EnumToString.convertToString(e, camelCase: true),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ))
            .toList(),
        iconEnabledColor: Theme.of(context).colorScheme.onPrimary,
        alignment: AlignmentDirectional.centerEnd,
        icon: const Icon(Icons.filter_list),
        onChanged: (value) {
          if (value != null) {
            controladorInspeccion.filtroPreguntas.value = value;
          }
        },
      ),
    );
  }
}
