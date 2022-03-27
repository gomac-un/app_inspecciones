import 'package:dartz/dartz.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/identificador_inspeccion.dart';
import 'package:inspecciones/features/llenado_inspecciones/ui/llenado_de_inspeccion_screen.dart';
import 'package:inspecciones/infrastructure/drift_database.dart';
import 'package:inspecciones/infrastructure/repositories/cuestionarios_repository.dart';
import 'package:inspecciones/infrastructure/repositories/providers.dart';
import 'package:inspecciones/presentation/widgets/alertas.dart';

import 'edicion_form_page.dart';

class ListaCuestionariosLocales extends ConsumerWidget {
  const ListaCuestionariosLocales({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final viewModel = ref.watch(_cuestionarioListViewModelProvider);
    return StreamBuilder<List<Cuestionario>>(
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
        final cuestionarios = snapshot.data;

        return ListView.separated(
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
          itemCount: cuestionarios!.length + 1, // +1 para el espacio al final
          itemBuilder: (context, index) {
            if (index < cuestionarios.length) {
              return _buildCuestionarioTile(
                  context, cuestionarios[index], viewModel);
            } else {
              return const SizedBox(height: 80);
            }
          },
        );
      },
    );
  }

  ListTile _buildCuestionarioTile(BuildContext context,
      Cuestionario cuestionario, _CuestionarioListViewModel viewModel) {
    return ListTile(
      onTap: () => Navigator.of(context)
          .push<bool>(
            MaterialPageRoute(
              builder: (_) => EdicionFormPage(cuestionarioId: cuestionario.id),
            ),
          )
          .then((res) => res ?? false
              ? ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Cuestionario finalizado, recuerda subirlo")))
              : null),
      title:
          Text("${cuestionario.tipoDeInspeccion} - v${cuestionario.version}"),
      subtitle: Text(EnumToString.convertToString(cuestionario.estado)),

      /// la opcion de subir solo se esconde cuando el cuestionario esta finalizado y tambien esta subido
      leading: (cuestionario.subido &&
              cuestionario.estado == EstadoDeCuestionario.finalizado)
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
      trailing: PopupMenuButton<_AccionCuestionarioLocal>(
        onSelected: (_AccionCuestionarioLocal result) {
          switch (result) {
            case _AccionCuestionarioLocal.subir:
              _subirCuestionario(context, viewModel, cuestionario);
              break;
            case _AccionCuestionarioLocal.previsualizar:
              _previsualizarCuestionario(context, cuestionario);
              break;
            case _AccionCuestionarioLocal.nuevaVersion:
              _duplicarCuestionario(context, cuestionario, viewModel);
              break;
            case _AccionCuestionarioLocal.eliminar:
              _eliminarCuestionario(context, cuestionario, viewModel);
              break;
          }
        },
        itemBuilder: (BuildContext context) =>
            <PopupMenuEntry<_AccionCuestionarioLocal>>[
          if (!(cuestionario.subido &&
              cuestionario.estado == EstadoDeCuestionario.finalizado))
            const PopupMenuItem(
              value: _AccionCuestionarioLocal.subir,
              child: Text('subir'),
            ),
          const PopupMenuItem(
            value: _AccionCuestionarioLocal.previsualizar,
            child: Text('previsualizar'),
          ),
          const PopupMenuItem(
            value: _AccionCuestionarioLocal.nuevaVersion,
            child: Text('nueva versión'),
          ),
          const PopupMenuItem(
            value: _AccionCuestionarioLocal.eliminar,
            child: Text('eliminar'),
          ),
        ],
      ),
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

  void _duplicarCuestionario(BuildContext context, Cuestionario cuestionario,
      _CuestionarioListViewModel viewModel) async {
    await viewModel.duplicarCuestionario(cuestionario);

    /// TODO: manejo de errores
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Cuestionario duplicado"),
      duration: Duration(seconds: 3),
    ));
  }

  void _previsualizarCuestionario(
    BuildContext context,
    Cuestionario cuestionario,
  ) =>
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
}

enum _AccionCuestionarioLocal {
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

  Future<void> duplicarCuestionario(Cuestionario cuestionario) =>
      _cuestionariosRepository.duplicarCuestionario(cuestionario);
}
