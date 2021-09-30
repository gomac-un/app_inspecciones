import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../control/controlador_llenado_inspeccion.dart';
import '../../domain/bloque.dart';
import '../../domain/bloques/titulo.dart';
import '../pregunta_card_factory.dart';
import 'filter_widget.dart';
import 'list_view_bloques.dart';

//TODO: separar la responsabilidad de paginar y de filtrar en widges diferentes
class PaginadorYFiltradorDePreguntas extends ConsumerWidget {
  final ControladorLlenadoInspeccion control;

  const PaginadorYFiltradorDePreguntas(this.control, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final factory = ref.watch(preguntaCardFactoryProvider);
    final filtro = ref.watch(filtroPreguntasProvider).state;

    final List<Widget> widgets;
    final bool paginar;
    switch (filtro) {
      case FiltroPreguntas.todas:
        widgets = control.cuestionario.bloques
            .map(
              (b) => factory.crearCard(
                b,
                control.controladores.singleWhereOrNull((e) => e.pregunta == b),
              ),
            )
            .toList();
        paginar = true;
        break;
      case FiltroPreguntas.criticas:
        widgets = control.controladores
            .where((c) => c.criticidadCalculada > 0)
            .map((c) => factory.crearCard(c.pregunta, c))
            .toList();
        paginar = false;
        break;
      case FiltroPreguntas.invalidas:
        widgets = control.controladores
            .where((c) => !c.esValido())
            .map((c) => factory.crearCard(c.pregunta, c))
            .toList();
        paginar = false;
        break;
    }

    final bloquesPaginados =
        _paginarBloquesPorTitulo(control.cuestionario.bloques);

    return paginar
        ? PageView.builder(
            controller: ref.watch(llenadoPageControllerProvider),
            itemCount: bloquesPaginados.length,
            itemBuilder: (context, i) {
              final widgets = bloquesPaginados[i]
                  .map(
                    (b) => factory.crearCard(
                      b,
                      control.controladores
                          .singleWhereOrNull((e) => e.pregunta == b),
                    ),
                  )
                  .toList();
              return ListViewPreguntas(widgets: widgets);
            },
          )
        : ListViewPreguntas(widgets: widgets);
  }

  static List<List<Bloque>> _paginarBloquesPorTitulo(List<Bloque> bloques) {
    List<Bloque> bloquesPagina = [];
    List<List<Bloque>> bloquesPaginados = [];
    for (final bloque in bloques) {
      if (bloque is Titulo) {
        if (bloquesPagina.isNotEmpty) bloquesPaginados.add(bloquesPagina);
        bloquesPagina = [bloque];
      } else {
        bloquesPagina.add(bloque);
      }
    }
    bloquesPaginados.add(bloquesPagina);
    return bloquesPaginados;
  }
}

extension NullableWhere<E> on Iterable<E> {
  E? singleWhereOrNull(bool Function(E element) test) {
    try {
      return singleWhere(test);
    } catch (e) {
      return null;
    }
  }
}
