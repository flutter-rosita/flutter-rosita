import 'package:flutter/rendering.dart';

class RositaImageUtils {
  static String buildImageProviderPath(ImageProvider? image) {
    return switch (image) {
      NetworkImage() => image.url,
      AssetImage() => 'assets/${image.keyName}',
      _ => '',
    };
  }
}
