import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'filter_widget.dart';

final showFABProvider = StateProvider((ref) => true);

class FABNavigation extends ConsumerWidget {
  const FABNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final pageController = ref.watch(llenadoPageControllerProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FloatingActionButton(
          heroTag: 'back',
          onPressed: () {
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
            pageController.nextPage(
                duration: const Duration(milliseconds: 800),
                curve: Curves.ease);
          },
          child: const Icon(Icons.navigate_next_outlined),
        ),
      ],
    );
  }
}
