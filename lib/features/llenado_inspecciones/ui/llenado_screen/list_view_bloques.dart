import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'floating_action_button.dart';

/// provee un [scrollController] para cada pagina de preguntas representadas por un
/// [List<Widget>], el [scrollController] generado va escondiendo y mostrando el
/// FAB cuando cambia de direccion

final listViewPreguntasScrollControllerProvider = ChangeNotifierProvider
    .autoDispose
    .family<ScrollController, List<Widget>>((ref, list) {
  final scrollController = ScrollController(debugLabel: list.length.toString());

  // No hay necesidad de hacer un dispose del scrollController, porque
  // [ChangeNotifierProvider] lo hace solito :3

  scrollController.addListener(() {
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      ref.read(showFABProvider).state = false;
    }
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      ref.read(showFABProvider).state = true;
    }
  });

  return scrollController;
});

class ListViewPreguntas extends HookConsumerWidget {
  const ListViewPreguntas({
    Key? key,
    required this.widgets,
  }) : super(key: key);

  final List<Widget> widgets;

  @override
  Widget build(BuildContext context, ref) {
    final controller =
        ref.watch(listViewPreguntasScrollControllerProvider(widgets));
    final bucket = useMemoized(() => PageStorageBucket());
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: SafeArea(
          child: ListView.builder(
            shrinkWrap: true,
            controller: controller,
            itemCount: widgets.length,
            itemBuilder: (_, j) =>
                // Es necesario usar otro PageStorage para que los scrollers
                // de las preguntas no afecten el scroll de las paginas
                PageStorage(bucket: bucket, child: widgets[j]),
          ),
        ),
      ),
    );
  }
}
