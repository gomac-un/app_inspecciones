import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:inspecciones/core/entities/app_image.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_multi_image_picker/reactive_multi_image_picker.dart';

class AppImageMultiImagePicker extends StatelessWidget {
  final FormControl<List<AppImage>> formControl;
  final String label;
  final int? maxImages;
  const AppImageMultiImagePicker({
    Key? key,
    required this.formControl,
    required this.label,
    this.maxImages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactiveMultiImagePicker<AppImage, AppImage>(
      formControl: formControl,
      //valueAccessor: FileValueAccessor(),
      decoration: InputDecoration(labelText: label, border: InputBorder.none),
      maxImages: maxImages,
      imageBuilder: _appImageBuilder,
      xFileConverter: _xFileConverter,
    );
  }
}

class AppImageImagePicker extends StatelessWidget {
  final FormControl<AppImage?> formControl;
  final String label;

  const AppImageImagePicker(
      {Key? key, required this.formControl, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactiveImagePicker<AppImage?, AppImage>(
      formControl: formControl,
      decoration: InputDecoration(labelText: label, border: InputBorder.none),
      imageBuilder: _appImageBuilder,
      xFileConverter: _xFileConverter,
    );
  }
}

Widget _appImageBuilder(AppImage image) => image.when(
      remote: (url) => Image.network(url),
      mobile: (path) => Image.file(File(path)),
      web: (path) => Image.network(path),
    );

AppImage _xFileConverter(XFile file) =>
    kIsWeb ? AppImage.web(file.path) : AppImage.mobile(file.path);
