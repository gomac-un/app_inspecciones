import 'package:flutter/material.dart';

class IconsMenu {
  static const items = <IconMenu>[
    Reparar,
    Finalizar,
    Informacion,
  ];
  static const Reparar = IconMenu(
    text: 'Reparar',
    icon: Icons.home_repair_service,
  );
  static const Finalizar = IconMenu(
    text: 'Finalizar',
    icon: Icons.done,
  );
  static const Informacion = IconMenu(
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
