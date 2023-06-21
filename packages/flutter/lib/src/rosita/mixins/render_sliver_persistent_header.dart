// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderSliverPersistentHeader on RositaRenderMixin {
  @override
  RenderSliver get target => this as RenderSliverPersistentHeader;

  @override
  void rositaLayout() {
    super.rositaLayout();

    final style = htmlElement.style;

    style.zIndex = '1';
  }
}
