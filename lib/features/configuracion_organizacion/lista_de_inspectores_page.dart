import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'inspector_profile_page.dart';

class ListaDeInspectoresPage extends StatelessWidget {
  const ListaDeInspectoresPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 2,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) => ListTile(
        leading: CircleAvatar(child: Text(index.toString())),
        title: Hero(tag: "nombre$index", child: Text('Persona $index')),
        subtitle: const Text('inspector'),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => InspectorProfilePage(
                  index: index,
                ))),
      ),
    );
  }
}
