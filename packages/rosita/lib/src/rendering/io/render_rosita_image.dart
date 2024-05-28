part of '../io_rendering.dart';

class RenderRositaImage extends RositaRenderBox {
  RenderRositaImage({
    this.src,
    this.borderRadius,
    this.fit,
    this.alignment,
    this.onLoad,
    this.onError,
  });

  String? src;

  BorderRadiusGeometry? borderRadius;

  BoxFit? fit;

  AlignmentGeometry? alignment;

  VoidCallback? onLoad;

  VoidCallback? onError;
}
