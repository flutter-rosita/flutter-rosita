// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rosita.dart';
import 'package:universal_html/html.dart' as html;

mixin RositaCanvasMixin on RositaRenderMixin {
  html.CanvasElement? _canvasElement;

  html.CanvasElement? _foregroundCanvasElement;

  html.CanvasElement get canvasElement {
    if (_canvasElement != null) {
      return _canvasElement!;
    }
    final canvas = _canvasElement = html.CanvasElement();
    final firstChild = htmlElement.firstChild;

    htmlElement.insertBefore(canvas, firstChild);

    return canvas;
  }

  html.CanvasElement get foregroundCanvasElement {
    if (_foregroundCanvasElement != null) {
      return _foregroundCanvasElement!;
    }
    final canvas = _foregroundCanvasElement = html.CanvasElement();

    htmlElement.append(canvas);

    return canvas;
  }
}
