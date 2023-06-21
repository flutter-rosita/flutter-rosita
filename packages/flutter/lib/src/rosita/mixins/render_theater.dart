// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rosita.dart';
import 'package:web/web.dart' as web;

mixin RositaRenderTheaterMixin on RositaRenderMixin {
  int get skipCount;

  @override
  void rositaLayout() {
    super.rositaLayout();

    final children = htmlElement.children;

    for (int i = 0; i < children.length; i++) {
      (children.item(i)! as web.HTMLElement).style.display = skipCount > i ? 'none' : '';
    }
  }
}
