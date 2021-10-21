import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:textfield_tags/textfield_tags.dart';

class ActivoController {
  final _tagsActivo = {"modelo:kenworth"};
  late final tagsControl = fb.control<Set<String>>(_tagsActivo);
  void guardar() => print("guardando: ${tagsControl.value}");
  void dispose() {
    tagsControl.dispose();
  }
}

final _activosProvider = Provider.autoDispose((ref) => [1, 2]);
final _activosControllersProvider = Provider.autoDispose((ref) {
  final controllers =
      ref.watch(_activosProvider).map((e) => ActivoController()).toList();
  ref.onDispose(() {
    for (var c in controllers) {
      c.dispose();
    }
  });
  return controllers;
});

class ListaDeActivosPage extends ConsumerWidget {
  const ListaDeActivosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final controls = ref.watch(_activosControllersProvider);
    return ListView.separated(
      itemCount: 2,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final controller = controls[index];
        return ListTile(
          title: Hero(tag: "nombre$index", child: Text('Activo $index')),
          trailing: IconButton(
            icon: const Icon(Icons.save_outlined),
            onPressed: controller.guardar,
          ),
          subtitle: ReactiveTextFieldTags(
              formControl: controller.tagsControl,
              validator: (String tag) {
                if (tag.isEmpty) return "ingrese algo";

                final splited = tag.split(":");

                if (splited.length == 1) {
                  return "agregue : para separar la etiqueta";
                }

                if (splited.length > 2) return "solo se permite un :";

                if (splited[0].isEmpty || splited[1].isEmpty) {
                  return "agregue texto antes y despues de :";
                }

                return null;
              }),
        );
      },
    );
  }
}
