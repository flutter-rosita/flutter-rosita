// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderCustomPaintMixin on RositaRenderMixin, RositaCanvasMixin {
  @override
  RenderCustomPaint get target => this as RenderCustomPaint;

  @override
  void rositaPaint() {
    final target = this.target;
    final size = target.size;
    final painter = target.painter;

    if (painter != null) {
      rositaPainterPaint(rositaCanvas, painter, size);
    } else {
      cleanAndHideRositaCanvas(size);
    }

    final foregroundPainter = target.foregroundPainter;

    if (foregroundPainter != null) {
      rositaPainterPaint(foregroundCanvas, foregroundPainter, size);
    } else {
      cleanAndHideForegroundRositaCanvas(size);
    }
  }

  void rositaPainterPaint(RositaCanvas canvas, CustomPainter painter, Size size) {
    canvas.clean(size);
    painter.paint(canvas, size);
    canvas.checkDirty();
  }
}
