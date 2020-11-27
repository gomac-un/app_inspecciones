import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inspecciones/presentation/widgets/imagen_full_screen.dart';

class ImageShower extends StatelessWidget {
  final double imageWidth;
  final double imageHeight;
  final EdgeInsets imageMargin;
  final List<File> imagenes;

  const ImageShower(
      {Key key,
      this.imageWidth = 130,
      this.imageHeight = 130,
      this.imageMargin,
      this.imagenes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 8),
          Container(
            height: imageHeight,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ...(imagenes.map<Widget>((item) {
                  return Stack(
                    alignment: Alignment.topRight,
                    children: <Widget>[
                      Container(
                        width: imageWidth,
                        height: imageHeight,
                        margin: imageMargin,
                        /*child: kIsWeb
                                ? Image.memory(item, fit: BoxFit.cover)
                                : item is String
                                    ? Image.network(item, fit: BoxFit.cover)
                                    : Image.file(item, fit: BoxFit.cover),*/
                        child: //TODO: arreglar cuando se implemente el web
                            /*kIsWeb
                                      ? Image.memory(item, fit: BoxFit.cover)
                                      : item.value is String
                                          ? Image.network(item.value,
                                              fit: BoxFit.cover)
                                          :*/
                            item is File
                                ? GestureDetector(
                                    child: Hero(
                                      tag: item.hashCode,
                                      child:
                                          Image.file(item, fit: BoxFit.cover),
                                    ),
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (_) {
                                        return FotoFullScreen(
                                            item, item.hashCode);
                                      }));
                                    },
                                  )
                                : item,
                      ),
                    ],
                  );
                }).toList()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
