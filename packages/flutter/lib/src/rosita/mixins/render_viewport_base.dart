// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderViewportBaseMixin on RositaRenderMixin {
  @override
  RenderViewportBase get target => this as RenderViewportBase;

  bool _hasVisualOverflow = false;

  @override
  void rositaPaint() {
    rositaCheckVisualOverflow();
  }

  void rositaCheckVisualOverflow() {
    // ignore: INVALID_USE_OF_PROTECTED_MEMBER
    final hasVisualOverflow = target.hasVisualOverflow && target.clipBehavior != Clip.none;

    if (_hasVisualOverflow != hasVisualOverflow) {
      _hasVisualOverflow = hasVisualOverflow;

      htmlElement.style.overflow = hasVisualOverflow ? 'hidden' : '';
    }
  }
}
