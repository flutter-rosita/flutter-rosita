import 'package:flutter/widgets.dart';
import 'package:rosita/rosita.dart';

class RositaSvgPicture extends LeafRenderObjectWidget {
  const RositaSvgPicture.asset(
    String name, {
    super.key,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.color,
    this.width,
    this.height,
    String? package,
  }) : src = package == null ? 'assets/$name' : 'assets/packages/$package/$name';

  const RositaSvgPicture.network(
    String url, {
    super.key,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.color,
    this.width,
    this.height,
  }) : src = url;

  final AlignmentGeometry alignment;
  final BoxFit fit;
  final String? src;
  final double? width;
  final double? height;
  final Color? color;

  @override
  RenderRositaSvgPicture createRenderObject(BuildContext context) {
    return RenderRositaSvgPicture(
      src: src,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      color: color,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderRositaSvgPicture renderObject) {
    renderObject
      ..src = src
      ..width = width
      ..height = height
      ..fit = fit
      ..alignment = alignment
      ..color = color;
  }
}
