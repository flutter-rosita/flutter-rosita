// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderFractionalTranslationMixin on RositaRenderMixin {
  @override
  RenderFractionalTranslation get target => this as RenderFractionalTranslation;

  @override
  // ignore: must_call_super
  void rositaLayout() {}

  @override
  void rositaPaint() {
    final Size(:width, :height) = target.size;

    htmlElement.style.width = '${width}px';
    htmlElement.style.height = '${height}px';

    final Offset(:dx, :dy) = target.translation;

    htmlElement.style.left = '${width * dx}px';
    htmlElement.style.top = '${height * dy}px';
  }
}
