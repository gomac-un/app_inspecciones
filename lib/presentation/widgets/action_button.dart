import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onPressed;
  final String? label;

  const ActionButton({
    Key? key,
    required this.iconData,
    required this.onPressed,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      label: label != null ? Text(label!) : const Text(''),
      icon: Icon(iconData),
      onPressed: onPressed,
    );
  }
}
