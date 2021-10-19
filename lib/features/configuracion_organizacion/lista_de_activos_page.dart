import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListaDeActivosPage extends StatelessWidget {
  const ListaDeActivosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 2,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) => ListTile(
        title: Hero(tag: "nombre$index", child: Text('Activo $index')),
        subtitle: const Text('agrupamiento'),
      ),
    );
  }
}
