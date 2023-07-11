// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderFractionalTranslationMixin on RositaRenderMixin {
  @override
  RenderFractionalTranslation get target => this as RenderFractionalTranslation;

  @override
  void rositaLayout() {
    super.rositaLayout();

    if (target.hasSize) {
      htmlElement.style.left = '${target.size.width * target.translation.dx}px';
      htmlElement.style.top = '${target.size.height * target.translation.dy}px';
    }
  }
}