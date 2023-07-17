// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderOffstageMixin on RositaRenderMixin {
  @override
  RenderOffstage get target => this as RenderOffstage;

  @override
  void rositaLayout() {
    super.rositaLayout();

    if (target.offstage) {
      htmlElement.style.display = 'none';
    } else {
      htmlElement.style.display = '';
    }
  }
}
