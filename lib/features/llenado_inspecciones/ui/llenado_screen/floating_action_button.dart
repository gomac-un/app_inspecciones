import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'paginador.dart';

final showFABProvider = StateProvider((ref) => true);

class FABNavigation extends ConsumerWidget {
  final Widget botonGuardar;

  const FABNavigation({Key? key, required this.botonGuardar}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final pageController = ref.watch(llenadoPageControllerProvider);
    final position = pageController.position;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(
          flex: 2,
          child: SizedBox(width: 1),
        ),
        //if (pageController.page!.round() != 0)
        if (position.hasPixels && position.pixels != position.minScrollExtent)
          FloatingActionButton(
            heroTag: 'back',
            onPressed: () => pageController.previousPage(
                duration: const Duration(milliseconds: 800),
                curve: Curves.ease),
            child: const Icon(Icons.navigate_before_outlined),
          ),
        const SizedBox(
          width: 10,
        ),
        if (position.hasPixels && position.pixels != position.maxScrollExtent)
          FloatingActionButton(
            heroTag: 'next',
            onPressed: () => pageController.nextPage(
                duration: const Duration(milliseconds: 800),
                curve: Curves.ease),
            child: const Icon(Icons.navigate_next_outlined),
          ),
        const Expanded(
          flex: 1,
          child: SizedBox(width: 1),
        ),
        botonGuardar,
      ],
    );
  }
}
