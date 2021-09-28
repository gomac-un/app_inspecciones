import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'floating_action_button.dart';

/// provee un [scrollController] para cada pagina de preguntas representadas por un
/// [List<Widget>], el [scrollController] generado va escondiendo y mostrando el
/// FAB cuando cambia de direccion
final listViewPreguntasScrollControllerProvider =
    Provider.family<ScrollController, List<Widget>>((ref, list) {
  final scrollController = ScrollController();

  scrollController.addListener(() {
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      ref.watch(showFABProvider).state = false;
    }
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      ref.watch(showFABProvider).state = true;
    }
  });
  return scrollController;
});

class ListViewPreguntas extends ConsumerWidget {
  const ListViewPreguntas({
    Key? key,
    required this.widgets,
  }) : super(key: key);

  final List<Widget> widgets;

  @override
  Widget build(BuildContext context, ref) {
    final controller =
        ref.watch(listViewPreguntasScrollControllerProvider(widgets));
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Expanded(
              child: Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  controller: controller,
                  itemCount: widgets.length,
                  itemBuilder: (_, j) => widgets[j],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
