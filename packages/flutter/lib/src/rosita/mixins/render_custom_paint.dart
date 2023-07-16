// ignore_for_file: public_member_api_docs, always_specify_types

import 'dart:html' as html;

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderCustomPaintMixin on RositaRenderMixin, RositaCanvasMixin {
  @override
  RenderCustomPaint get target => this as RenderCustomPaint;

  @override
  void rositaLayout() {
    super.rositaLayout();
    rositaPaint(target.painter);
    rositaPaint(target.foregroundPainter);
  }

  void rositaPaint(CustomPainter? painter) {
    if (!target.hasSize || !hasHtmlElement) {
      return;
    }

    final size = target.size;
    final html.CanvasElement element;

    if (identical(target.foregroundPainter, painter)) {
      element = canvasElement;
    } else {
      element = foregroundCanvasElement;
    }

    final canvas = RositaCanvas(element);
    canvas.clean(size);
    painter?.paint(canvas, size);
    canvas.checkDirty();
  }
}
