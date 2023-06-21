// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';
import 'package:rosita/rosita.dart';
import 'package:universal_html/html.dart' as html;

class RositaImage extends LeafRenderObjectWidget {
  const RositaImage.asset(
    String name, {
    super.key,
    this.borderRadius,
    this.fit,
    this.alignment = Alignment.center,
    String? package,
  }) : src = package == null ? 'assets/$name' : 'assets/packages/$package/$name';

  const RositaImage.network(
    String url, {
    super.key,
    this.borderRadius,
    this.fit,
    this.alignment = Alignment.center,
  }) : src = url;

  final String src;
  final AlignmentGeometry alignment;
  final BorderRadiusGeometry? borderRadius;
  final BoxFit? fit;

  @override
  RenderRositaImage createRenderObject(BuildContext context) {
    return RenderRositaImage(
      src: src,
      borderRadius: borderRadius,
      fit: fit,
      alignment: alignment,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderRositaImage renderObject) {
    renderObject
      ..src = src
      ..borderRadius = borderRadius
      ..fit = fit
      ..alignment = alignment;
  }
}

class RenderRositaImage extends RositaRenderBox {
  RenderRositaImage({
    String? src,
    BorderRadiusGeometry? borderRadius,
    BoxFit? fit,
    AlignmentGeometry? alignment,
  })  : _src = src,
        _borderRadius = borderRadius,
        _fit = fit,
        _alignment = alignment;

  html.ImageElement get imageElement => htmlElement as html.ImageElement;

  @override
  html.HtmlElement? createRositaElement() {
    final imageElement = html.ImageElement();
    final style = imageElement.style;

    imageElement.src = src;

    RositaRadiusUtils.applyBorderRadius(style, borderRadius);
    RositaBoxFitUtils.applyBoxFitToObjectFit(style, fit);
    RositaBoxFitUtils.applyAlignmentToObjectPosition(style, alignment);

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

  BorderRadiusGeometry? get borderRadius => _borderRadius;
  BorderRadiusGeometry? _borderRadius;

  set borderRadius(BorderRadiusGeometry? value) {
    if (value == _borderRadius) {
      return;
    }
    _borderRadius = value;
    RositaRadiusUtils.applyBorderRadius(imageElement.style, value);
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
    final biggestSize = constraints.biggest;

    size = biggestSize.isFinite
        ? biggestSize
        : Size(
            biggestSize.width == double.infinity ? biggestSize.height : biggestSize.width,
            biggestSize.height == double.infinity ? biggestSize.width : biggestSize.height,
          );
  }

  @override
  void rositaPaint() {}
}
