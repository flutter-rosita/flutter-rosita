// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderViewportBaseMixin on RositaRenderMixin {
  @override
  RenderViewportBase get target => this as RenderViewportBase;

  @override
  void rositaLayout() {
    super.rositaLayout();

    switch (target.axis) {
      case Axis.vertical:
        htmlElement.style.top = '${-target.offset.pixels}px';
      case Axis.horizontal:
        htmlElement.style.left = '${-target.offset.pixels}px';
    }
  }
}
