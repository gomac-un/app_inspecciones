import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SimpleFutureProviderRefreshableBuilder<F, T> extends ConsumerWidget {
  final AutoDisposeFutureProvider<Either<F, T>> provider;
  final Widget Function(BuildContext context, T data) builder;
  const SimpleFutureProviderRefreshableBuilder(
      {Key? key, required this.provider, required this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final organizacion = ref.watch(provider);
    return RefreshIndicator(
        onRefresh: () async => ref.refresh(provider),
        child: ScrollableWithAllAvailableSpace(
          child: organizacion.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Text(e.toString()),
            data: (d) =>
                d.fold((l) => Text(l.toString()), (r) => builder(context, r)),
          ),
        ));
  }
}

class ScrollableWithAllAvailableSpace extends StatelessWidget {
  final Widget child;
  const ScrollableWithAllAvailableSpace({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (child is ListView) {
      return child;
    } //TODO: mirar que otros widgets son excepciones
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: child),
      );
    });
  }
}
