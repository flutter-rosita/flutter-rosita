// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderColoredBoxMixin on RositaRenderMixin {
  Color get color;

  @override
  void rositaLayout() {
    super.rositaLayout();

    htmlElement.style.backgroundColor = color.toHexString();
  }
}
