import 'package:dartz/dartz.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/infrastructure/drift_database.dart';
import 'package:inspecciones/infrastructure/repositories/cuestionarios_repository.dart';
import 'package:inspecciones/infrastructure/repositories/providers.dart';
import 'package:inspecciones/presentation/widgets/alertas.dart';
import 'package:inspecciones/presentation/widgets/user_drawer.dart';

import 'edicion_form_page.dart';

final cuestionariosServidorProvider = FutureProvider.autoDispose((ref) =>
    ref.watch(cuestionariosRepositoryProvider).getListaDeCuestionariosServer());

/// Pantalla que muestra la lista de cuestionarios subidos y en proceso.
class CuestionariosPage extends ConsumerWidget {
  const CuestionariosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final viewModel = ref.watch(_cuestionarioListViewModelProvider);
    final cuestionariosServer = ref.watch(cuestionariosServidorProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cuestionarios'),
        ),
        drawer: const UserDrawer(),
        body: StreamBuilder<List<Cuestionario>>(
          /// Se reconstruye automaticamente con los cuestionarios que se van agregando.
          stream: viewModel.getCuestionarios(),
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
                      esLocal: true);
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
                          esLocal: false));
                }
              },
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: const Padding(
          padding: EdgeInsets.all(8.0),
          child: FloatingActionButtonCreacionCuestionario(),
        ));
  }

  ListTile _buildCuestionarioTile(BuildContext context,
      Cuestionario cuestionario, _CuestionarioListViewModel viewModel,
      {required bool esLocal}) {
    return ListTile(
      onTap: !esLocal
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
      tileColor: Theme.of(context).cardColor,
      title:
          Text("${cuestionario.tipoDeInspeccion} - v${cuestionario.version}"),
      subtitle:
          Text('Estado: ${EnumToString.convertToString(cuestionario.estado)}'),

      /// Si no se ha subido apaarece la opción de subir.
      leading: !cuestionario.subido
          ? IconButton(
              icon: Icon(
                Icons.cloud_upload,
                color: cuestionario.estado == EstadoDeCuestionario.finalizado
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.grey,
              ),
              onPressed: () async {
                /// Solo permite subirlo si está finalizado.
                switch (cuestionario.estado) {
                  case EstadoDeCuestionario.finalizado:
                    _subirCuestionarioFinalizado(
                        context, viewModel, cuestionario);
                    break;
                  case EstadoDeCuestionario.borrador:
                    _alertarNoSubirBorrador(context);
                    break;
                }
              })
          : const SizedBox.shrink(),
      trailing: esLocal

          /// Los cuestionarios subidos ya no se pueden borrar
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
                      ))),
    );
  }

  Future<dynamic> _alertarNoSubirBorrador(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Advertencia'),
        content: const Text(
            "Aún no ha finalizado este cuestionario, no puede ser enviado."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Aceptar"),
          ),
        ],
      ),
    );
  }

  void _subirCuestionarioFinalizado(
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

/// Botón de creación de cuestionarios
class FloatingActionButtonCreacionCuestionario extends StatelessWidget {
  const FloatingActionButtonCreacionCuestionario({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        final res = await Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => const EdicionFormPage(),
          ),
        );
        // muestra el mensaje que viene desde la pantalla de llenado
        if (res ?? false) {
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(const SnackBar(
                content: Text("Cuestionario finalizado, recuerda subirlo")));
        }
      },
      icon: const Icon(Icons.add),
      label: const Text("Cuestionario"),
    );
  }
}

final _cuestionarioListViewModelProvider = Provider((ref) =>
    _CuestionarioListViewModel(ref.watch(cuestionariosRepositoryProvider)));

class _CuestionarioListViewModel {
  final CuestionariosRepository _cuestionariosRepository;

  _CuestionarioListViewModel(this._cuestionariosRepository);

  Stream<List<Cuestionario>> getCuestionarios() =>
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