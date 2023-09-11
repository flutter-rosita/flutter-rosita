// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaPaintRenderObjectMixin on RenderBox, RositaCanvasMixin {
  @override
  void rositaPaint() {
    final canvas = rositaCanvas;
    final context = RositaPaintingContext(canvas);

    canvas.clean(size);
    target.paint(context, Offset.zero);
    canvas.checkDirty();
  }
}
