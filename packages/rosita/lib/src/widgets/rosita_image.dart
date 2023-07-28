// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';
import 'package:rosita/rosita.dart';
import 'package:universal_html/html.dart' as html;

class RositaImage extends LeafRenderObjectWidget {
  const RositaImage({
    super.key,
    required this.src,
    this.borderRadius,
  });

  final String src;
  final BorderRadiusGeometry? borderRadius;

  @override
  RenderRositaImage createRenderObject(BuildContext context) {
    return RenderRositaImage(src: src, borderRadius: borderRadius);
  }

  @override
  void updateRenderObject(BuildContext context, RenderRositaImage renderObject) {
    renderObject
      ..src = src
      ..borderRadius = borderRadius;
  }
}

class RenderRositaImage extends RositaRenderBox {
  RenderRositaImage({
    String? src,
    BorderRadiusGeometry? borderRadius,
  })  : _src = src,
        _borderRadius = borderRadius;

  String? get src => _src;
  String? _src;

  set src(String? value) {
    if (value == _src) {
      return;
    }
    _src = value;
    markNeedsPaint();
  }

  BorderRadiusGeometry? get borderRadius => _borderRadius;
  BorderRadiusGeometry? _borderRadius;

  set borderRadius(BorderRadiusGeometry? value) {
    if (value == _borderRadius) {
      return;
    }
    _borderRadius = value;
    markNeedsPaint();
  }

  @override
  void performLayout() {
    size = constraints.biggest;
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

      RositaRadiusUtils.applyBorderRadius(imageElement, borderRadius);
    }
  }
}
