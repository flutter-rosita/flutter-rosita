// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderCustomPaintMixin on RositaRenderMixin, RositaCanvasMixin {
  @override
  RenderCustomPaint get target => this as RenderCustomPaint;

  @override
  void rositaPaint() {
    final size = target.size;

    if (target.painter != null) {
      rositaPainterPaint(rositaCanvas, target.painter!, size);
    } else {
      cleanAndHideRositaCanvas(size);
    }

    if (target.foregroundPainter != null) {
      rositaPainterPaint(foregroundCanvas, target.foregroundPainter!, size);
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
