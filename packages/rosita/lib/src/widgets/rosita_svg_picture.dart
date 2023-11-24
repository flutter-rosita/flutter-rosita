import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:rosita/rosita.dart';
import 'package:universal_html/html.dart' as html;

class RositaSvgPicture extends LeafRenderObjectWidget {
  const RositaSvgPicture.asset(
    String name, {
    super.key,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.width,
    this.height,
    String? package,
  }) : src = package == null ? 'assets/$name' : 'assets/packages/$package/$name';

  const RositaSvgPicture.network(
    String url, {
    super.key,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.width,
    this.height,
  }) : src = url;

  final AlignmentGeometry alignment;
  final BoxFit fit;
  final String? src;
  final double? width;
  final double? height;

  @override
  RenderRositaSvgPicture createRenderObject(BuildContext context) {
    return RenderRositaSvgPicture(
      src: src,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderRositaSvgPicture renderObject) {
    renderObject
      ..src = src
      ..width = width
      ..height = height
      ..fit = fit
      ..alignment = alignment;
  }
}

class RenderRositaSvgPicture extends RositaRenderBox {
  RenderRositaSvgPicture({
    String? src,
    double? width,
    double? height,
    BoxFit? fit,
    AlignmentGeometry? alignment,
  })  : _src = src,
        _width = width,
        _height = height,
        _fit = fit,
        _alignment = alignment;

  html.ImageElement get imageElement => htmlElement as html.ImageElement;

  @override
  html.HtmlElement? createRositaElement() {
    final imageElement = html.ImageElement();
    final style = imageElement.style;

    imageElement.src = src;

    RositaBoxFitUtils.applyBoxFitToObjectFit(style, fit);
    RositaBoxFitUtils.applyAlignmentToObjectPosition(style, alignment);

    imageElement.width = width?.toInt();
    imageElement.height = height?.toInt();

    return imageElement;
  }

  String? get src => _src;
  String? _src;

  set src(String? value) {
    if (value == _src) {
      return;
    }
    _src = value;
    imageElement.src = value;
  }

  double? get width => _width;
  double? _width;

  set width(double? value) {
    if (value == _width) {
      return;
    }
    _width = value;
    imageElement.width = value?.toInt();
  }

  double? get height => _height;
  double? _height;

  set height(double? value) {
    if (value == _height) {
      return;
    }
    _height = value;
    imageElement.height = value?.toInt();
  }

  BoxFit? get fit => _fit;
  BoxFit? _fit;

  set fit(BoxFit? value) {
    if (value == _fit) {
      return;
    }
    _fit = value;
    RositaBoxFitUtils.applyBoxFitToObjectFit(imageElement.style, value);
  }

  AlignmentGeometry? get alignment => _alignment;
  AlignmentGeometry? _alignment;

  set alignment(AlignmentGeometry? value) {
    if (value == _alignment) {
      return;
    }
    _alignment = value;
    RositaBoxFitUtils.applyAlignmentToObjectPosition(imageElement.style, value);
  }

  @override
  void performLayout() {
    size = Size(
      clampDouble(width ?? double.infinity, constraints.minWidth, constraints.maxWidth),
      clampDouble(height ?? double.infinity, constraints.minHeight, constraints.maxHeight),
    );
  }

  @override
  void rositaPaint() {}
}
