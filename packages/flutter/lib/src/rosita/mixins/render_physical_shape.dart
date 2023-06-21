// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderPhysicalShapeMixin on RositaRenderMixin {
  @override
  RenderPhysicalShape get target => this as RenderPhysicalShape;

  @override
  void rositaLayout() {
    super.rositaLayout();

    htmlElement.style.backgroundColor = target.color.toHexString();
  }
}
