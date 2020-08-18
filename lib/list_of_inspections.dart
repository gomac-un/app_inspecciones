import 'package:flutter/material.dart';
import 'inspeccion_screen.dart';

class ListOfInspectionsScreen extends StatelessWidget {
  void _pushScreen(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccion de inspección'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Preoperacional'),
            onTap: () => _pushScreen(context, InspeccionScreen()),
          ),
          ListTile(
            title: Text('Fugas lixiviado'),
            onTap: () => _pushScreen(context, InspeccionScreen()),
          ),
          ListTile(
            title: Text('Prueba velocímetro'),
            onTap: () => _pushScreen(context, InspeccionScreen()),
          ),
        ],
      ),
    );
  }
}
