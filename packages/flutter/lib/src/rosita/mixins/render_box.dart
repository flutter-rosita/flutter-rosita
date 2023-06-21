// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderBoxMixin on RositaRenderMixin {
  @override
  RenderBox get target => this as RenderBox;

  @override
  void rositaLayout() {
    super.rositaLayout();

    if (target.hasSize) {
      htmlElement.style.width = '${target.size.width}px';
      htmlElement.style.height = '${target.size.height}px';

      final parentData = target.parentData;

      if (parentData is BoxParentData) {
        final offset = parentData.offset;

        htmlElement.style.left = '${offset.dx}px';
        htmlElement.style.top = '${offset.dy}px';
      } else if (parentData != null) {
        assert(() {
          // ignore: avoid_print
          // print('RositaRenderBoxMixin not handled: ${toString()}, parentData: $parentData');
          return true;
        }());
      }
    }
  }
}
