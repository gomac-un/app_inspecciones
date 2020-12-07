import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:inspecciones/router.gr.dart';
import 'injection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(
    MaterialApp(
      builder: ExtendedNavigator.builder(
        router: AutoRouter(),
        builder: (context, extendedNav) => Theme(
          data: ThemeData(
              brightness: Brightness.dark, //TODO: seleccion de tema
              scaffoldBackgroundColor: Colors.lightBlue),
          child: extendedNav,
        ),
      ), //InspeccionScreen(),
    ),
    /*MaterialApp(
      home: Testing(),
    ),*/
  );
}

class Testing extends StatelessWidget {
  const Testing({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample Code'),
      ),
      body: Table(
        border: TableBorder.all(color: Colors.black),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        // defaultColumnWidth: IntrinsicColumnWidth(), // esto es caro
        columnWidths: {0: FlexColumnWidth(2)},
        children: [
          TableRow(children: [
            Text('Cell 1'),
            Text('Cell 2'),
            Radio(value: true, groupValue: true, onChanged: (_) {}),
            Checkbox(value: true, onChanged: null)
          ]),
          TableRow(children: [
            Text('Cell 4aaaaaaaaaaaaaaaaaaaaa'),
            Text('Cell 5'),
            Text('Cell 6'),
            Checkbox(value: true, onChanged: null),
          ])
        ],
      ),
    );
  }
}
