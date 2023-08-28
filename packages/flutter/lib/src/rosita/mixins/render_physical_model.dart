// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderPhysicalModelMixin on RositaRenderMixin {
  @override
  RenderPhysicalModel get target => this as RenderPhysicalModel;

  @override
  void rositaPaint() {
    final style = htmlElement.style;

    style.backgroundColor = target.color.toStyleString();

    RositaRadiusUtils.applyBorderRadius(style, target.borderRadius);
  }
}
