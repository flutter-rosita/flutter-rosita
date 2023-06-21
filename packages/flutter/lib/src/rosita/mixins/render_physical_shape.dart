// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderPhysicalShapeMixin on RositaRenderMixin {
  @override
  RenderPhysicalShape get target => this as RenderPhysicalShape;

  @override
  void rositaPaint() {
    final style = htmlElement.style;

    style.backgroundColor = target.color.toStyleString();

    final clipper = target.clipper;

    RositaRadiusUtils.applyCustomClipper(style, clipper, target.size);
  }
}
