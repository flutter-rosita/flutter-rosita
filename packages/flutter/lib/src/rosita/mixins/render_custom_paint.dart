// ignore_for_file: public_member_api_docs, always_specify_types

import 'dart:html' as html;

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderCustomPaintMixin on RositaRenderMixin {
  @override
  RenderCustomPaint get target => this as RenderCustomPaint;

  @override
  void rositaLayout() {
    super.rositaLayout();

    if (target.hasSize && hasHtmlElement) {
      final size = target.size;

      final painter = target.painter;
      final foregroundPainter = target.foregroundPainter;

      if (painter != null) {
        final canvas = RositaCanvas(canvasElement);
        canvas.clean();
        painter.paint(canvas, size);
      }

      if (foregroundPainter != null) {
        final canvas = RositaCanvas(foregroundCanvasElement);
        canvas.clean();
        foregroundPainter.paint(canvas, size);
      }
    }
  }

  html.CanvasElement? _canvasElement;

  html.CanvasElement get canvasElement {
    if (_canvasElement != null) {
      return _canvasElement!;
    }
    final canvas = _canvasElement = html.CanvasElement();

    canvas.style.width = '${target.size.width}px';
    canvas.style.height = '${target.size.height}px';

    final firstChild = htmlElement.firstChild;

    htmlElement.insertBefore(canvas, firstChild);

    return canvas;
  }

  html.CanvasElement? _foregroundCanvasElement;

  html.CanvasElement get foregroundCanvasElement {
    if (_foregroundCanvasElement != null) {
      return _foregroundCanvasElement!;
    }
    final canvas = _foregroundCanvasElement = html.CanvasElement();

    canvas.style.width = '${target.size.width}px';
    canvas.style.height = '${target.size.height}px';

    htmlElement.append(canvas);

    return canvas;
  }
}
