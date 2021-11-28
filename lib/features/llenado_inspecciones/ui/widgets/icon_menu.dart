import 'package:flutter/material.dart';

class IconsMenu {
  static const items = <IconMenu>[
    reparar,
    finalizar,
    informacion,
  ];
  static const reparar = IconMenu(
    text: 'Reparar',
    icon: Icons.home_repair_service,
  );
  static const finalizar = IconMenu(
    text: 'Finalizar',
    icon: Icons.done,
  );
  static const informacion = IconMenu(
    text: 'Informacion',
    icon: Icons.privacy_tip_outlined,
  );
}

class IconMenu {
  final String text;
  final IconData icon;
  const IconMenu({
    required this.text,
    required this.icon,
  });
}
