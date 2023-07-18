// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderOpacityMixin on RositaRenderMixin {
  @override
  RenderOpacity get target => this as RenderOpacity;

  @override
  void rositaPaint() {
    htmlElement.style.opacity = '${target.opacity}';
  }
}

mixin RositaRenderAnimatedOpacityMixin on RositaRenderMixin {
  @override
  RenderAnimatedOpacity get target => this as RenderAnimatedOpacity;

  @override
  void rositaPaint() {
    htmlElement.style.opacity = '${target.opacity.value}';
  }
}
