import 'dart:io';

import 'package:flutter/material.dart';

class FotoFullScreen extends StatelessWidget {
  final File foto;
  final int tag;
  FotoFullScreen(this.foto, this.tag);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: tag,
            child: Image.file(foto),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
