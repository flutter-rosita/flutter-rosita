// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rosita.dart';

mixin RositaRenderTheaterMixin on RositaRenderMixin {
  int get skipCount;

  @override
  void rositaLayout() {
    super.rositaLayout();

    final children = htmlElement.children;

    for (int i = 0; i < children.length; i++) {
      children[i].style.display = skipCount > i ? 'none' : '';
    }
  }
}
