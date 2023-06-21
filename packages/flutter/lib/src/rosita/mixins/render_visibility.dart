// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';

mixin RositaRenderVisibilityMixin on RenderObject {
  bool get visible;

  @override
  void rositaPaint() {
    final visible = this.visible;
    final style = htmlElement.style;

    if (visible) {
      style.display = '';
    } else {
      style.display = 'none';
    }
  }
}
