// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderOffstageMixin on RositaRenderMixin {
  @override
  RenderOffstage get target => this as RenderOffstage;

  @override
  void rositaLayout() {
    super.rositaLayout();

    final style = htmlElement.style;

    if (target.offstage) {
      style.display = 'none';
    } else {
      style.display = '';
    }
  }
}
