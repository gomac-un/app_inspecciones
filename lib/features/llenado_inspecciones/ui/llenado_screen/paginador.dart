import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/features/llenado_inspecciones/control/controlador_de_pregunta.dart';

import '../../control/controlador_llenado_inspeccion.dart';
import '../../domain/bloque.dart';
import '../../domain/bloques/titulo.dart';
import '../pregunta_card_factory.dart';
import 'list_view_bloques.dart';

final llenadoPageControllerProvider =
    ChangeNotifierProvider.autoDispose((ref) => PageController());

final pageStorageBucketProvider =
    Provider.autoDispose((ref) => PageStorageBucket());

//TODO: separar la responsabilidad de paginar y de filtrar en widges diferentes
class PaginadorYFiltradorDePreguntas extends ConsumerWidget {
  final ControladorLlenadoInspeccion control;
  final PreguntaCardFactory factory;

  const PaginadorYFiltradorDePreguntas(this.control,
      {Key? key, required this.factory})
      : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final filtro = ref.watch(filtroPreguntasProvider);

    switch (filtro) {
      case FiltroPreguntas.todas:
        return _buildInspeccionPaginada();
      case FiltroPreguntas.criticas:
        return _buildInspeccionEnUnaSolaPagina(
            control.controladores.where((c) => c.criticidadCalculada > 0));
      case FiltroPreguntas.invalidas:
        return _buildInspeccionEnUnaSolaPagina(
            control.controladores.where((c) => !c.esValido()));
    }
  }

  Widget _buildInspeccionEnUnaSolaPagina(
          Iterable<ControladorDePregunta> controladoresFiltrados) =>
      ListViewPreguntas(
        widgets: _buildCardsFromControladores(controladoresFiltrados),
      );

  Widget _buildInspeccionPaginada() {
    final bloquesPaginados =
        _paginarBloquesPorTitulo(control.cuestionario.bloques);

    /// TODO: agregar la posibilidad de filtrar en este metodo
    final widgetsPaginados =
        bloquesPaginados.map((pag) => _buildCardsFromBloques(pag)).toList();

    return Consumer(builder: (context, ref, _) {
      return PageStorage(
          bucket: ref.watch(pageStorageBucketProvider),
          child: PageView.builder(
            controller: ref.watch(llenadoPageControllerProvider),
            itemCount: widgetsPaginados.length,
            itemBuilder: (context, i) => ListViewPreguntas(
              key: PageStorageKey(i),
              widgets: widgetsPaginados[i],
            ),
          ));
    });
  }

  List<Widget> _buildCardsFromBloques(Iterable<Bloque> bloquesFiltrados) =>
      bloquesFiltrados
          .map(
            (b) => factory.crearCard(b,
                controlador: control.controladores
                    .singleWhereOrNull((e) => e.pregunta == b),
                nOrden: _getNroOrdenBloque(b)),
          )
          .toList();

  List<Widget> _buildCardsFromControladores(
          Iterable<ControladorDePregunta> controladoresFiltrados) =>
      controladoresFiltrados
          .map(
            (c) => factory.crearCard(c.pregunta,
                controlador: c, nOrden: _getNroOrdenBloque(c.pregunta)),
          )
          .toList();

  int _getNroOrdenBloque(Bloque b) => control.cuestionario.bloques.indexOf(b);

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
