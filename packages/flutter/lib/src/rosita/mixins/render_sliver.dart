// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderSliverMixin on RositaRenderMixin {
  @override
  RenderSliver get target => this as RenderSliver;

  @override
  void rositaLayout() {
    super.rositaLayout();

    final parentData = target.parentData;
    if (parentData is SliverPhysicalParentData) {
      if (target.constraints.remainingPaintExtent == 0) {
        htmlElement.style.display = 'none';
      } else {
        htmlElement.style.display = '';
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

      switch (axis) {
        case Axis.vertical:
          final double delta;
          final offset = parentData.paintOffset.dy - target.constraints.scrollOffset + parentOffset.dy;


          if (forward) {
            delta = offset;
          } else {
            delta = target.constraints.remainingPaintExtent - offset;
          }

          htmlElement.style.top = '${delta}px';
          htmlElement.style.left = '${parentData.paintOffset.dx + parentOffset.dx}px';
        case Axis.horizontal:
          final double delta;
          final offset = parentData.paintOffset.dx - target.constraints.scrollOffset + parentOffset.dx;

          if (forward) {
            delta = offset;
          } else {
            delta = target.constraints.remainingPaintExtent - offset;
          }

          htmlElement.style.top = '${parentData.paintOffset.dy + parentOffset.dy}px';
          htmlElement.style.left = '${delta}px';
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
