// ignore_for_file: public_member_api_docs, always_specify_types

import 'dart:ui';

import 'package:flutter/rosita.dart';
import 'package:universal_html/html.dart' as html;

mixin RositaCanvasMixin on RositaRenderMixin {
  html.CanvasElement? _canvasElement;

  html.CanvasElement? _foregroundCanvasElement;

  html.CanvasElement get canvasElement {
    if (_canvasElement != null) {
      // ignore: cast_nullable_to_non_nullable
      return rositaCastNullableToNonNullable ? _canvasElement as html.CanvasElement : _canvasElement!;
    }
    final canvas = _canvasElement = html.CanvasElement();
    final firstChild = htmlElement.firstChild;

    htmlElement.insertBefore(canvas, firstChild);

    return canvas;
  }

  html.CanvasElement get foregroundCanvasElement {
    if (_foregroundCanvasElement != null) {
      return rositaCastNullableToNonNullable
          // ignore: cast_nullable_to_non_nullable
          ? _foregroundCanvasElement as html.CanvasElement
          : _foregroundCanvasElement!;
    }
    final canvas = _foregroundCanvasElement = html.CanvasElement();

    htmlElement.append(canvas);

    return canvas;
  }

  RositaCanvas? _rositaCanvas;

  RositaCanvas get rositaCanvas => _rositaCanvas ??= RositaCanvas(canvasElement);

  RositaCanvas? _foregroundCanvas;

  RositaCanvas get foregroundCanvas => _foregroundCanvas ??= RositaCanvas(foregroundCanvasElement);

  void cleanAndHideRositaCanvas(Size size) {
    final rositaCanvas = _rositaCanvas;

    if (rositaCanvas != null) {
      rositaCanvas.clean(size);
      rositaCanvas.checkDirty();
    }
  }

  void cleanAndHideForegroundRositaCanvas(Size size) {
    final foregroundCanvas = _foregroundCanvas;

    if (foregroundCanvas != null) {
      foregroundCanvas.clean(size);
      foregroundCanvas.checkDirty();
    }
  }
}
