// ignore_for_file: public_member_api_docs, always_specify_types

import 'dart:ui';

import 'package:flutter/rosita.dart';
import 'package:web/web.dart' as web;

mixin RositaCanvasMixin on RositaRenderMixin {
  bool get rositaNeededCheckRectOverflow => false;

  web.HTMLCanvasElement? _canvasElement;

  web.HTMLCanvasElement? _foregroundCanvasElement;

  web.HTMLCanvasElement get canvasElement {
    if (_canvasElement != null) {
      // ignore: cast_nullable_to_non_nullable
      return rositaCastNullableToNonNullable ? _canvasElement as web.HTMLCanvasElement : _canvasElement!;
    }
    final canvas = _canvasElement = web.HTMLCanvasElement();
    final firstChild = htmlElement.firstChild;

    htmlElement.insertBefore(canvas, firstChild);

    return canvas;
  }

  web.HTMLCanvasElement get foregroundCanvasElement {
    if (_foregroundCanvasElement != null) {
      return rositaCastNullableToNonNullable
          // ignore: cast_nullable_to_non_nullable
          ? _foregroundCanvasElement as web.HTMLCanvasElement
          : _foregroundCanvasElement!;
    }
    final canvas = _foregroundCanvasElement = web.HTMLCanvasElement();

    htmlElement.append(canvas);

    return canvas;
  }

  RositaCanvas? _rositaCanvas;

  RositaCanvas get rositaCanvas => _rositaCanvas ??= RositaCanvas(
        canvasElement,
        neededCheckRectOverflow: rositaNeededCheckRectOverflow,
      );

  RositaCanvas? _foregroundCanvas;

  RositaCanvas get foregroundCanvas => _foregroundCanvas ??= RositaCanvas(
        foregroundCanvasElement,
        neededCheckRectOverflow: rositaNeededCheckRectOverflow,
      );

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

  @override
  void rositaDetach() {
    _rositaCanvas = null;
    _foregroundCanvas = null;
    _canvasElement = null;
    _foregroundCanvasElement = null;
  }
}
