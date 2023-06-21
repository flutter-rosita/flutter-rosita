// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderTransform on RositaRenderMixin {
  @override
  RenderTransform get target => this as RenderTransform;

  @override
  void rositaLayout() {
    super.rositaLayout();

    final origin = target.origin;

    if (target.hasSize && origin != null) {
      htmlElement.style.left = '${origin.dx}px';
      htmlElement.style.top = '${origin.dy}px';
    }
  }
}
