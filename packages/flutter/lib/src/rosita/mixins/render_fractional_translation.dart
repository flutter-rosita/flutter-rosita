// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderFractionalTranslationMixin on RositaRenderBoxMixin {
  @override
  RenderFractionalTranslation get target => this as RenderFractionalTranslation;

  @override
  void rositaPaint() {
    final childRenderObject = findFirstChildWithHtmlElement();

    if (childRenderObject != null) {
      final Size(:width, :height) = childRenderObject.size;
      final Offset(:dx, :dy) = target.translation;

      htmlElement.style.left = '${width * dx}px';
      htmlElement.style.top = '${height * dy}px';
    }
  }
}
