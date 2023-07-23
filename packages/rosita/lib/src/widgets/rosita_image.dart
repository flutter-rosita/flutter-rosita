// ignore_for_file: public_member_api_docs

import 'dart:html' as html;

import 'package:flutter/widgets.dart';
import 'package:rosita/rosita.dart';


class RositaImage extends LeafRenderObjectWidget {
  const RositaImage({super.key, required this.src});

  final String src;

  @override
  RenderRositaImage createRenderObject(BuildContext context) {
    return RenderRositaImage(src: src);
  }

  @override
  void updateRenderObject(BuildContext context, RenderRositaImage renderObject) {
    renderObject.src = src;
  }
}

class RenderRositaImage extends RositaRenderBox {
  RenderRositaImage({String? src}) : _src = src;

  String? get src => _src;
  String? _src;

  set src(String? value) {
    if (value == _src) {
      return;
    }
    _src = value;
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

    imageElement.style.width = '100%';
    imageElement.style.height = '100%';

    htmlElement.append(imageElement);

    return imageElement;
  }

  @override
  void rositaPaint() {
    if (src != null) {
      imageElement.src = src;
    }
  }
}
