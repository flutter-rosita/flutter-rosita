// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderViewportBaseMixin on RositaRenderMixin {
  @override
  RenderViewportBase get target => this as RenderViewportBase;

  @override
  void createRositaElement() {
    super.createRositaElement();

    if (target.clipBehavior != Clip.none) {
      htmlElement.style.overflow = 'hidden';
    }
  }
}
