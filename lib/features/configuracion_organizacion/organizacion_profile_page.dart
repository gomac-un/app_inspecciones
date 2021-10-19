import 'package:flutter/material.dart';

import 'configuracion_organizacion_page.dart';
import 'widgets/profile_widget.dart';

class OrganizacionProfilePage extends StatelessWidget {
  const OrganizacionProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ProfileWidget(
          imagePath:
              "https://media-exp1.licdn.com/dms/image/C4E0BAQF84UhDY_5h-w/company-logo_200_200/0/1615608683611?e=2159024400&v=beta&t=scH2oRc6wLO_1QOGX6-fj5mBxG5pyNZ65vLKQyyNSaA",
          onClicked: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const ConfiguracionOrganizacionPage())),
        ),
        const SizedBox(height: 24),
        buildName(),
        const SizedBox(height: 24),
        Center(child: buildUpgradeButton()),
        const SizedBox(height: 24),
        const NumbersWidget(),
        const SizedBox(height: 48),
        buildAbout(),
      ],
    );
  }

  Widget buildName() => Column(
        children: const [
          Text(
            'Gomac',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          SizedBox(height: 4),
          Text(
            'gomac@gmail.com', //email
            style: TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildUpgradeButton() => ElevatedButton(
        child: const Text('Mejorar plan'),
        onPressed: () {},
      );

  Widget buildAbout() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Acerca de',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "detalles de la organizacion",
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );
}

class NumbersWidget extends StatelessWidget {
  const NumbersWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buildButton(context, '4.8', 'Ranking'),
          buildDivider(),
          buildButton(context, '35', 'Inspecciones'),
          buildDivider(),
          buildButton(context, '50', 'Reparaciones'),
        ],
      );
  Widget buildDivider() => const SizedBox(
        height: 24,
        child: VerticalDivider(),
      );

  Widget buildButton(BuildContext context, String value, String text) =>
      MaterialButton(
        padding: const EdgeInsets.symmetric(vertical: 4),
        onPressed: () {},
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const SizedBox(height: 2),
            Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
}
