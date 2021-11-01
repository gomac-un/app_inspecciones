import 'package:flutter/widgets.dart';

extension PaddingX on Widget {
  Widget padding(EdgeInsetsGeometry padding) => Padding(
        padding: padding,
        child: this,
      );
}
