// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderFittedBoxMixin on RositaRenderMixin {
  @override
  RenderFittedBox get target => this as RenderFittedBox;

  @override
  void rositaPaint() {
    final firstChild = findFirstChildWithHtmlElement();
    final childHtmlElement = firstChild != null && firstChild.hasHtmlElement ? firstChild.htmlElement : null;

    if (firstChild != null && childHtmlElement != null) {
      final size = target.size;
      final childSize = firstChild.size;

      final scale = size.width / childSize.width;

      final childStyle = childHtmlElement.style;

      childStyle.transform = 'scale($scale,$scale)';
      childStyle.transformOrigin = 'top left';
    }
  }
}
