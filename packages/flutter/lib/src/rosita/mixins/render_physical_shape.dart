// ignore_for_file: public_member_api_docs, always_specify_types

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderPhysicalShapeMixin on RositaRenderMixin {
  @override
  RenderPhysicalShape get target => this as RenderPhysicalShape;

  @override
  void rositaPaint() {
    final style = htmlElement.style;

    (style as JSObject).setProperty('backgroundColor' as JSAny, target.color.toStyleJSAny());

    final clipper = target.clipper;

    RositaPathUtils.applyCustomClipper(style, clipper, target.size);
  }
}
