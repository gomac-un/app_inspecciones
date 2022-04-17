import 'package:flutter/material.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/domain.dart';

class IconsMenu {
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
  static List<IconMenu> getItems(
      EstadoDeInspeccion estado, String activo, int criticas) {
    if (activo == "previsualizacion") return [informacion];
    if (criticas == 0) return [finalizar, informacion];
    switch (estado) {
      case EstadoDeInspeccion.enReparacion:
        return [finalizar, informacion];
      case EstadoDeInspeccion.finalizada:
        return [informacion];
      default:
        return [reparar, finalizar, informacion];
    }
  }
}

class IconMenu {
  final String text;
  final IconData icon;
  const IconMenu({
    required this.text,
    required this.icon,
  });
}
