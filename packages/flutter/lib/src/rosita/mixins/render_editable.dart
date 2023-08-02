// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderEditableMixin on RositaRenderMixin, RositaCanvasMixin {
  @override
  RenderEditable get target => this as RenderEditable;

  void rositaPaintTextPainter(TextPainter textPainter, Offset offset) {
    final size = target.size;
    final canvas = rositaCanvas;
    canvas.clean(size);
    textPainter.paint(canvas, offset);
    canvas.checkDirty();
  }
}
