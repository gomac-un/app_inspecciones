import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/features/creacion_cuestionarios/edicion_form_page.dart';
import 'package:inspecciones/presentation/widgets/user_drawer.dart';

import '../../core/enums.dart';
import '../../infrastructure/moor_database.dart';
import '../../viewmodel/cuestionario_list_view_model.dart';
import '../widgets/alertas.dart';

/// Pantalla que muestra la lista de cuestionarios subidos y en proceso.
class CuestionariosPage extends ConsumerWidget {
  const CuestionariosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final viewModel = ref.watch(cuestionarioListViewModelProvider);
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
            final cuestionarios = snapshot.data;

            /// no hay cuestionarios creados
            if (cuestionarios == null || cuestionarios.isEmpty) {
              return Center(
                  child: Text(
                "No tiene cuestionarios por subir",
                style: Theme.of(context).textTheme.headline5,
              ));
            }

            return ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemCount: cuestionarios.length,
              itemBuilder: (context, index) {
                final cuestionario = cuestionarios[index];
                return ListTile(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          EdicionFormPage(cuestionarioId: cuestionario.id),
                    ),
                  ),
                  tileColor: Theme.of(context).cardColor,
                  title: Text(cuestionario.tipoDeInspeccion),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Código: ${cuestionario.id}'),
                      Text(cuestionario.esLocal
                          ? 'Sin subir \nEstado: ${EnumToString.convertToString(cuestionario.estado)}'
                          : 'Subido \nEstado: ${EnumToString.convertToString(cuestionario.estado)}'),
                    ],
                  ),

                  /// Si no se ha subido apaarece la opción de subir.
                  leading: cuestionario.esLocal
                      ? IconButton(
                          icon: Icon(
                            Icons.cloud_upload,
                            color: cuestionario.estado ==
                                    EstadoDeCuestionario.finalizada
                                ? Theme.of(context).colorScheme.secondary
                                : Colors.grey,
                          ),
                          onPressed: () async {
                            /// Solo permite subirlo si está finalizado.
                            switch (cuestionario.estado) {
                              case EstadoDeCuestionario.finalizada:
                                _subirCuestionarioFinalizado(
                                    context, viewModel, cuestionario);
                                break;
                              case EstadoDeCuestionario.borrador:
                                _mostrarDialog(context);
                                break;
                            }
                          })
                      : const SizedBox.shrink(),
                  trailing: cuestionario.esLocal

                      /// Los cuestionarios subidos ya no se pueden borrar
                      ? IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _eliminarCuestionario(
                              context, cuestionario, viewModel),
                        )
                      : Icon(Icons.cloud,
                          color: Theme.of(context).colorScheme.secondary),
                );
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

  ///TODO: pensar un mejor nombre para esta funcion
  Future<dynamic> _mostrarDialog(BuildContext context) {
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
    CuestionarioListViewModel viewModel,
    Cuestionario cuestionario,
  ) async {
    final subida = await viewModel.subirCuestionario(cuestionario);

    subida.fold(
      (fail) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            fail.when(
              noHayConexionAlServidor: () => "No hay conexion al servidor",
              noHayInternet: () => "No hay internet",
              serverError: (msg) => "Error inesperado: $msg",
              credencialesException: () =>
                  'Error, intente inciar sesión nuevamente',
              pageNotFound: () =>
                  'No se pudo encontrar la página, informe al encargado',
            ),
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
      CuestionarioListViewModel viewModel) {
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
        final res = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const EdicionFormPage(),
          ),
        );
        // muestra el mensaje que viene desde la pantalla de llenado
        if (res != null) {
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text("$res")));
        }
      },
      icon: const Icon(Icons.add),
      label: const Text("Cuestionario"),
    );
  }
}
