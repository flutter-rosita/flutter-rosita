// ignore_for_file: public_member_api_docs, unnecessary_overrides

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderShiftedBox on RositaRenderMixin {
  @override
  RenderShiftedBox get target => this as RenderShiftedBox;

  @override
  void rositaLayout() {
    super.rositaLayout();

    // print('RositaRenderShiftedBox: child ${target.child}, parentData: ${target.child?.parentData}');

    /*
    final RenderBox? child = target.child;
    if (child != null && child.hasSize) {
      final BoxParentData childParentData = child.parentData! as BoxParentData;
      final offset = childParentData.offset;

      htmlElement.style.left = '${offset.dx}px';
      htmlElement.style.top = '${offset.dy}px';

    }*/
  }
}
