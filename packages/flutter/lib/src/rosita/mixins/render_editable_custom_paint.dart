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
    if (target.hasSize) {
      _paint();
    }
  }

  void _paint() {
    final RenderEditable? parent = this.parent;
    final RenderEditablePainter? painter = this.painter;
    if (painter != null && parent != null) {
      final size = target.size;
      final canvas = RositaCanvas(canvasElement);
      canvas.clean(size);
      painter.paint(canvas, size, parent);
      canvas.checkDirty();
    }
  }
}
