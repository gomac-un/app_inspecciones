import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/features/llenado_inspecciones/control/controlador_llenado_inspeccion.dart';

import 'actions.dart';
import 'paginador.dart';

final showFABProvider = StateProvider((ref) => true);

class FABNavigation extends ConsumerWidget {
  final ControladorLlenadoInspeccion control;

  FABNavigation(this.control, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final pageController = ref.watch(llenadoPageControllerProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(
          flex: 2,
          child: SizedBox(width: 1),
        ),
        if (pageController.initialPage.round() != pageController.page?.round())
          FloatingActionButton(
            heroTag: 'back',
            onPressed: () {
              print(pageController.page?.round());
              print(pageController.initialPage);
              pageController.previousPage(
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.ease);
            },
            child: const Icon(Icons.navigate_before_outlined),
          ),
        const SizedBox(
          width: 10,
        ),
        FloatingActionButton(
          heroTag: 'next',
          onPressed: () {
            print(pageController.page);
            print(pageController.initialPage);
            pageController.nextPage(
                duration: const Duration(milliseconds: 800),
                curve: Curves.ease);
          },
          child: const Icon(Icons.navigate_next_outlined),
        ),
        const Expanded(
          flex: 1,
          child: SizedBox(width: 1),
        ),
        BotonGuardar(
          guardar: control.guardarInspeccion,
          icon: const Icon(Icons.save),
          tooltip: "Guardar borrador",
        ),
      ],
    );
  }
}
