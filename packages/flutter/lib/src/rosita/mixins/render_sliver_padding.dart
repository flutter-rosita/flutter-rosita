// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderSliverEdgeInsetsPaddingMixin on RositaRenderMixin {
  @override
  RenderSliverEdgeInsetsPadding get target => this as RenderSliverEdgeInsetsPadding;

  @override
  void rositaLayout() {
    super.rositaLayout();

    final padding = target.resolvedPadding;

    if (padding != null && padding != EdgeInsets.zero) {
      htmlElement.style.left = '${padding.left}px';
      htmlElement.style.right = '${padding.right}px';
      htmlElement.style.top = '${padding.top}px';
      htmlElement.style.bottom = '${padding.bottom}px';
    }
  }
}
