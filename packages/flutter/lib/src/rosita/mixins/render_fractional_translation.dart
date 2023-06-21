// ignore_for_file: public_member_api_docs, always_specify_types
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderFractionalTranslationMixin on RositaRenderBoxMixin {
  @override
  RenderFractionalTranslation get target => this as RenderFractionalTranslation;

  @override
  void rositaPaint() {
    final childRenderObject = findFirstChildWithHtmlElement();

    if (childRenderObject != null) {
      final style = htmlElement.style;
      final Size(:width, :height) = childRenderObject.size;
      final Offset(:dx, :dy) = target.translation;
      final x = width * dx;
      final y = height * dy;

      if (x != 0 || y != 0) {
        (style as JSObject).setProperty(
          'transform' as JSAny,
          ('translate(' as JSAny)
              .add(x as JSAny)
              .add('px,' as JSAny)
              .add(y as JSAny)
              .add('px)' as JSAny)
              .add(styleTransform),
        );
      } else {
        (style as JSObject).setProperty('transform' as JSAny, styleTransform);
      }
    }
  }
}
