import 'package:flutter/widgets.dart';
import 'package:rosita/rosita.dart';
import 'package:universal_html/html.dart' as html;

class RositaSvgPicture extends LeafRenderObjectWidget {
  const RositaSvgPicture.asset(
    String assetsName, {
    super.key,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.width,
    this.height,
  }) : src = 'assets/$assetsName';

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

  String? get src => _src;
  String? _src;

  set src(String? value) {
    if (value == _src) {
      return;
    }
    _src = value;
    markNeedsPaint();
  }

  double? get width => _width;
  double? _width;

  set width(double? value) {
    if (value == _width) {
      return;
    }
    _width = value;
    markNeedsPaint();
  }

  double? get height => _height;
  double? _height;

  set height(double? value) {
    if (value == _height) {
      return;
    }
    _height = value;
    markNeedsPaint();
  }

  BoxFit? get fit => _fit;
  BoxFit? _fit;

  set fit(BoxFit? value) {
    if (value == _fit) {
      return;
    }
    _fit = value;
    markNeedsPaint();
  }

  AlignmentGeometry? get alignment => _alignment;
  AlignmentGeometry? _alignment;

  set alignment(AlignmentGeometry? value) {
    if (value == _alignment) {
      return;
    }
    _alignment = value;
    markNeedsPaint();
  }

  @override
  void performLayout() {
    final biggestSize = constraints.biggest;

    size = biggestSize.isFinite
        ? biggestSize
        : Size(
            biggestSize.width == double.infinity ? biggestSize.height : biggestSize.width,
            biggestSize.height == double.infinity ? biggestSize.width : biggestSize.height,
          );
  }

  html.ImageElement? _imageElement;

  html.ImageElement get imageElement {
    _imageElement ??= html.ImageElement();

    final imageElement = _imageElement!;

    htmlElement.append(imageElement);

    return imageElement;
  }

  @override
  void rositaPaint() {
    if (src != null) {
      imageElement.src = src;

      if (width != null) {
        imageElement.width = width!.toInt();
      }

      if (height != null) {
        imageElement.height = height!.toInt();
      }

      RositaBoxFitUtils.applyBoxFit(imageElement, fit);
      RositaBoxFitUtils.applyAlignment(imageElement, alignment);
    }
  }
}
