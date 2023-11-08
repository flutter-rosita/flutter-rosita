// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderEditableCustomPaintMixin on RositaRenderMixin, RositaCanvasMixin {
  @override
  RenderBox get target => this as RenderBox;

  @override
  RenderEditable? get parent;

  RenderEditablePainter? get painter;

  @override
  void rositaPaint() {
    final RenderEditable? parent = this.parent;
    final RenderEditablePainter? painter = this.painter;
    final size = target.size;

    if (painter != null && parent != null) {
      final canvas = rositaCanvas;

      canvas.paintCallback(size, (_) => painter.paint(canvas, size, parent));
    } else {
      cleanAndHideRositaCanvas(size);
    }
  }
}
