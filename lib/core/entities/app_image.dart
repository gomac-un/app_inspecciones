import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
export 'package:flutter/foundation.dart' show kIsWeb;

part 'app_image.freezed.dart';

@freezed
class AppImage with _$AppImage {
  const factory AppImage.remote(String url) = RemoteImage;
  const factory AppImage.mobile(String path) = MobileImage;
  const factory AppImage.web(String path) = WebImage;
}

typedef ListImages = IList<AppImage>;
