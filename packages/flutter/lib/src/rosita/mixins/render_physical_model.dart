// ignore_for_file: public_member_api_docs, always_specify_types
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderPhysicalModelMixin on RositaRenderMixin {
  @override
  RenderPhysicalModel get target => this as RenderPhysicalModel;

  @override
  void rositaPaint() {
    final style = htmlElement.style;

    (style as JSObject).setProperty('backgroundColor' as JSAny, target.color.toStyleJSAny());

    RositaRadiusUtils.applyBorderRadius(style, target.borderRadius);
  }
}
