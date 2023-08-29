// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderSliverMixin on RositaRenderMixin {
  @override
  RenderSliver get target => this as RenderSliver;

  Offset? _localOffset;

  @override
  void rositaLayout() {
    super.rositaLayout();

    final target = this.target;
    final parentData = target.parentData;
    final style = htmlElement.style;

    if (parentData is SliverPhysicalParentData) {
      if (target.constraints.remainingPaintExtent == 0) {
        style.display = 'none';
      } else {
        style.display = '';
      }

      final forward = target.constraints.growthDirection == GrowthDirection.forward;
      final axis = target.constraints.axis;
      final parent = this.parent;

      Offset parentOffset = Offset.zero;

      if (parent is RenderSliverEdgeInsetsPadding) {
        final parentParentData = parent.parentData;

        if (parentParentData is SliverPhysicalParentData) {
          parentOffset = parentParentData.paintOffset;
        }
      }

      final double top;
      final double left;

      switch (axis) {
        case Axis.vertical:
          final offset = (forward ? parentData.paintOffset.dy : 0) - target.constraints.scrollOffset + parentOffset.dy;

          if (forward) {
            top = offset;
          } else {
            top = target.constraints.remainingPaintExtent - offset;
          }

          left = parentData.paintOffset.dx + parentOffset.dx;

        case Axis.horizontal:
          final offset = (forward ? parentData.paintOffset.dx : 0) - target.constraints.scrollOffset + parentOffset.dx;

          if (forward) {
            left = offset;
          } else {
            left = target.constraints.remainingPaintExtent - offset;
          }

          top = parentData.paintOffset.dy + parentOffset.dy;
      }

      final offset = Offset(left, top);

      if (_localOffset != offset) {
        _localOffset = offset;

        style.left = '${offset.dx}px';
        style.top = '${offset.dy}px';

        RositaScrollUtils.onScroll();
      }
    } else if (parentData != null) {
      assert(() {
        if (parentData.runtimeType != ParentData) {
          // ignore: avoid_print
          print(
              'RositaRenderSliverMixin not handled: ${toString()}, parentData: $parentData, runType: ${parentData.runtimeType}');
        }
        return true;
      }());
    }
  }
}
