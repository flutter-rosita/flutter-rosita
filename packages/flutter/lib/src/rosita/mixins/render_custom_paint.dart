// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';
import 'package:universal_html/html.dart' as html;

mixin RositaRenderCustomPaintMixin on RositaRenderMixin, RositaCanvasMixin {
  @override
  RenderCustomPaint get target => this as RenderCustomPaint;

  @override
  void rositaPaint() {
    rositaPainterPaint(canvasElement, target.painter);
    rositaPainterPaint(foregroundCanvasElement, target.foregroundPainter);
  }

  void rositaPainterPaint(html.CanvasElement element, CustomPainter? painter) {
    final size = target.size;
    final canvas = RositaCanvas(element);
    canvas.clean(size);
    painter?.paint(canvas, size);
    canvas.checkDirty();
  }
}
