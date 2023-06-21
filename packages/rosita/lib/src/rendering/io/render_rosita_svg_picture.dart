part of '../io_rendering.dart';

class RenderRositaSvgPicture extends RositaRenderBox {
  RenderRositaSvgPicture({
    this.src,
    this.width,
    this.height,
    this.fit,
    this.alignment,
    this.color,
  });

  String? src;

  double? width;

  double? height;

  BoxFit? fit;

  AlignmentGeometry? alignment;

  Color? color;
}
