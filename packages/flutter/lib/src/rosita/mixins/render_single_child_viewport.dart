// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderSingleChildViewport on RositaRenderMixin, RositaRenderBoxMixin {
  AxisDirection get rositaAxisDirection;

  ViewportOffset get rositaOffset;

  @override
  void rositaLayout() {
    super.rositaLayout();

    appendLocalOffset();
  }

  @override
  void rositaPaint() {
    appendLocalOffset();
  }

  void appendLocalOffset() {
    final offset = switch (rositaAxisDirection) {
          AxisDirection.up || AxisDirection.down => Offset(0, -rositaOffset.pixels),
          AxisDirection.left || AxisDirection.right => Offset(-rositaOffset.pixels, 0),
        } +
        (localOffset ?? Offset.zero);
    final Offset(:dx, :dy) = offset;

    htmlElement.style.transform = 'translate(${dx}px,${dy}px)';
  }
}
