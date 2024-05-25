import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:universal_html/html.dart' as html;

class RositaImageUtils {
  static String buildImageProviderPath(ImageProvider? image) {
    return switch (image) {
      NetworkImage() => image.url,
      AssetImage() => 'assets/${image.keyName}',
      _ => '',
    };
  }

  static Future<String?> buildImageBlobPath(ui.Image image) async {
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final buffer = byteData?.buffer;

    if (buffer != null) {
      return html.Url.createObjectUrlFromBlob(html.Blob([buffer.asUint8List()], 'image/png'));
    }

    return null;
  }

  static Future<String?> buildMemoryImageBlobPath(MemoryImage image) async {
    return html.Url.createObjectUrlFromBlob(html.Blob([image.bytes]));
  }

  static void revokeBlobObjectUrl(String url) {
    return html.Url.revokeObjectUrl(url);
  }

  static bool imageIsComplete(String src) {
    final imageElement = html.ImageElement();
    imageElement.src = src;

    return imageElement.complete ?? false;
  }
}
