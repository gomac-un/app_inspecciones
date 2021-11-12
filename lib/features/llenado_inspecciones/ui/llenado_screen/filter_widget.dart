import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../control/controlador_llenado_inspeccion.dart';

class FilterWidget extends ConsumerWidget {
  const FilterWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<FiltroPreguntas>(
        value: ref.watch(filtroPreguntasProvider),
        items: ref
            .watch(filtroDisponibleProvider)
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(EnumToString.convertToString(e, camelCase: true)),
                ))
            .toList(),
        selectedItemBuilder: (_) => ref
            .watch(filtroDisponibleProvider)
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
            ref.read(filtroPreguntasProvider.notifier).state = value;
          }
        },
      ),
    );
  }
}
