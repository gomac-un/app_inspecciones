import 'package:dartz/dartz.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/application/auth/auth_service.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/identificador_inspeccion.dart';
import 'package:inspecciones/features/llenado_inspecciones/ui/llenado_de_inspeccion_screen.dart';
import 'package:inspecciones/infrastructure/drift_database.dart';
import 'package:inspecciones/infrastructure/repositories/cuestionarios_repository.dart';
import 'package:inspecciones/infrastructure/repositories/providers.dart';
import 'package:inspecciones/presentation/widgets/alertas.dart';
import 'package:inspecciones/presentation/widgets/user_drawer.dart';

import 'edicion_form_page.dart';

final cuestionariosServidorProvider = FutureProvider.autoDispose((ref) =>
    ref.watch(cuestionariosRepositoryProvider).getListaDeCuestionariosServer());

/// Pantalla que muestra la lista de cuestionarios subidos y en proceso.
/// TODO: boton para descargarlos todos
class CuestionariosPage extends ConsumerWidget {
  const CuestionariosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(userProvider);
    if (user == null) return const Text("usuario no identificado");
    final viewModel = ref.watch(_cuestionarioListViewModelProvider);
    final cuestionariosServer = ref.watch(cuestionariosServidorProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cuestionarios'),
        ),
        drawer: const UserDrawer(),
        body: StreamBuilder<List<Cuestionario>>(
          /// Se reconstruye automaticamente con los cuestionarios que se van agregando.
          stream: viewModel.watchCuestionarios(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("error: ${snapshot.error}");
            }
            if (!snapshot.hasData) {
              return const Align(
                child: CircularProgressIndicator(),
              );
            }
            final Either<ApiFailure, List<Cuestionario>> cuestionariosRemotos =
                cuestionariosServer.when(
                    data: id,
                    error: (e, _) => Left(
                        ApiFailure.errorInesperadoDelServidor(e.toString())),
                    loading: () => const Right([]));

            final cuestionariosLocales = snapshot.data;
            final numeroDeLocales = cuestionariosLocales!.length;
            final numeroDeRemotos =
                cuestionariosRemotos.fold<int>((l) => 1, (r) => r.length);

            return ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemCount: numeroDeLocales +
                  numeroDeRemotos +
                  1, // +1 para el espacio al final
              itemBuilder: (context, index) {
                if (index < cuestionariosLocales.length) {
                  return _buildCuestionarioTile(
                      context, cuestionariosLocales[index], viewModel,
                      estaGuardado: true);
                } else {
                  if (index == numeroDeLocales + numeroDeRemotos) {
                    return const SizedBox(height: 80);
                  }
                  return cuestionariosRemotos.fold(
                      (l) => ListTile(
                            title: Text(l.toString()),
                          ),
                      (r) => _buildCuestionarioTile(
                          context, r[index - numeroDeLocales], viewModel,
                          estaGuardado: false));
                }
              },
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: !user.esAdmin
            ? null
            : const Padding(
                padding: EdgeInsets.all(8.0),
                child: FloatingActionButtonCreacionCuestionario(),
              ));
  }

  ListTile _buildCuestionarioTile(BuildContext context,
      Cuestionario cuestionario, _CuestionarioListViewModel viewModel,
      {required bool estaGuardado}) {
    return ListTile(
      onTap: !estaGuardado
          ? null
          : () => Navigator.of(context)
              .push<bool>(
                MaterialPageRoute(
                  builder: (_) =>
                      EdicionFormPage(cuestionarioId: cuestionario.id),
                ),
              )
              .then((res) => res ?? false
                  ? ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Text("Cuestionario finalizado, recuerda subirlo")))
                  : null),
      title:
          Text("${cuestionario.tipoDeInspeccion} - v${cuestionario.version}"),
      subtitle: Text(EnumToString.convertToString(cuestionario.estado)),

      /// la opcion de subir solo se esconde cuando el cuestionario esta finalizado y tambien esta subido, o si es remoto
      leading: (cuestionario.subido &&
                  cuestionario.estado == EstadoDeCuestionario.finalizado) ||
              !estaGuardado
          ? const SizedBox.shrink()
          : IconButton(
              icon: Icon(
                Icons.cloud_upload,
                color: cuestionario.estado == EstadoDeCuestionario.finalizado
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.grey,
              ),
              onPressed: () =>
                  _subirCuestionario(context, viewModel, cuestionario)),
      trailing: PopupMenuButton<AccionCuestionario>(
        onSelected: (AccionCuestionario result) {
          switch (result) {
            case AccionCuestionario.descargar:
              viewModel.descargarCuestionario(cuestionario).then((r) => r.fold(
                    (l) => ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("$l"))),
                    (r) => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Cuestionario descargado"))),
                  ));
              break;
            case AccionCuestionario.eliminar:
              _eliminarCuestionario(context, cuestionario, viewModel);
              break;
            case AccionCuestionario.subir:
              _subirCuestionario(context, viewModel, cuestionario);
              break;
            case AccionCuestionario.previsualizar:
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => InspeccionPage(
                    inspeccionId: IdentificadorDeInspeccion(
                      activo: "previsualizacion",
                      cuestionarioId: cuestionario.id,
                    ),
                  ),
                ),
              );
              break;
          }
        },
        itemBuilder: (BuildContext context) =>
            <PopupMenuEntry<AccionCuestionario>>[
          if (!estaGuardado)
            PopupMenuItem(
              value: AccionCuestionario.descargar,
              child: Text(EnumToString.convertToString(
                  AccionCuestionario.descargar,
                  camelCase: true)),
            ),
          if (!(cuestionario.subido &&
                  cuestionario.estado == EstadoDeCuestionario.finalizado) &&
              estaGuardado)
            PopupMenuItem(
              value: AccionCuestionario.subir,
              child: Text(EnumToString.convertToString(AccionCuestionario.subir,
                  camelCase: true)),
            ),
          PopupMenuItem(
            value: AccionCuestionario.previsualizar,
            child: Text(EnumToString.convertToString(
                AccionCuestionario.previsualizar,
                camelCase: true)),
          ),
          if (estaGuardado)
            PopupMenuItem(
              value: AccionCuestionario.eliminar,
              child: Text(EnumToString.convertToString(
                  AccionCuestionario.eliminar,
                  camelCase: true)),
            ),
        ],
      ),
      /*estaGuardado
          ? IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () =>
                  _eliminarCuestionario(context, cuestionario, viewModel),
            )
          : IconButton(
              icon: Icon(Icons.cloud_download_outlined,
                  color: Theme.of(context).colorScheme.secondary),
              onPressed: () => viewModel
                  .descargarCuestionario(cuestionario)
                  .then((r) => r.fold(
                        (l) => ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text("$l"))),
                        (r) => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Cuestionario descargado"))),
                      ))),*/
    );
  }

  void _subirCuestionario(
    BuildContext context,
    _CuestionarioListViewModel viewModel,
    Cuestionario cuestionario,
  ) async {
    final subida = await viewModel.subirCuestionario(cuestionario.id);

    subida.fold(
      (fail) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            fail.toString(),
          ),
        ),
      ),
      (_) => mostrarMensaje(
        context,
        TipoDeMensaje.exito,
        "El cuestionario ha sido enviado",
        ocultar: false,
      ),
    );
  }

  /// Elimina [cuestionario] y todas sus preguntas
  void _eliminarCuestionario(BuildContext context, Cuestionario cuestionario,
      _CuestionarioListViewModel viewModel) {
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Alerta"),
          content:
              const Text("¿Está seguro que desea eliminar este cuestionario?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                await viewModel.eliminarCuestionario(cuestionario);

                /// TODO: manejo de errores
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Cuestionario eliminado"),
                  duration: Duration(seconds: 3),
                ));
                Navigator.of(context).pop();
              },
              child: const Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }
}

enum AccionCuestionario {
  descargar,
  subir,
  previsualizar,
  nuevaVersion,
  eliminar,
}

final _cuestionarioListViewModelProvider = Provider((ref) =>
    _CuestionarioListViewModel(ref.watch(cuestionariosRepositoryProvider)));

class _CuestionarioListViewModel {
  final CuestionariosRepository _cuestionariosRepository;

  _CuestionarioListViewModel(this._cuestionariosRepository);

  Stream<List<Cuestionario>> watchCuestionarios() =>
      _cuestionariosRepository.getCuestionariosLocales();

  Future<Either<ApiFailure, Unit>> subirCuestionario(String cuestionarioId) =>
      _cuestionariosRepository.subirCuestionario(cuestionarioId);

  Future<void> eliminarCuestionario(Cuestionario cuestionario) =>
      _cuestionariosRepository.eliminarCuestionario(cuestionario);

  Future<Either<ApiFailure, Unit>> descargarCuestionario(
          Cuestionario cuestionario) =>
      _cuestionariosRepository.descargarCuestionario(
          cuestionarioId: cuestionario.id);
}
