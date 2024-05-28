part of '../web_rendering.dart';

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
      return web.URL.createObjectURL(web.Blob(buffer.asUint8List() as JSArray<web.BlobPart>, web.BlobPropertyBag(type: 'image/png')));
    }

    return null;
  }

  static Future<String?> buildMemoryImageBlobPath(MemoryImage image) async {
    return web.URL.createObjectURL(web.Blob(image.bytes as JSArray<web.BlobPart>));
  }

  static void revokeBlobObjectUrl(String url) {
    return web.URL.revokeObjectURL(url);
  }

  static bool imageIsComplete(String src) {
    final imageElement = web.HTMLImageElement();
    imageElement.src = src;

    return imageElement.complete;
  }
}
