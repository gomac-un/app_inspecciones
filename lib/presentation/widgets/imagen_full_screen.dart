import 'dart:io';

import 'package:flutter/material.dart';

/// Muestra [foto] en pantalla completa
class FotoFullScreen extends StatelessWidget {
  final File foto;
  final int tag;
  const FotoFullScreen(this.foto, this.tag);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: tag,
            child: InteractiveViewer(child: Image.file(foto)),
          ),
        ),
      ),
    );
  }
}
