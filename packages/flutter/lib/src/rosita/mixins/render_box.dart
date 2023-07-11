// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderBoxMixin on RositaRenderMixin {
  @override
  RenderBox get target => this as RenderBox;

  @override
  void rositaLayout() {
    super.rositaLayout();

    if (target.hasSize) {
      final size = target.size;
      htmlElement.style.width = '${size.width}px';
      htmlElement.style.height = '${size.height}px';

      final parentData = target.parentData;

      if (parentData is BoxParentData) {
        final offset = parentData.offset;

        htmlElement.style.left = '${offset.dx}px';
        htmlElement.style.top = '${offset.dy}px';
      } else if (parentData is SliverMultiBoxAdaptorParentData) {
        final offset = parentData.layoutOffset;

        final crossAxisOffset = parentData is SliverGridParentData ? parentData.crossAxisOffset : null;

        if (offset != null) {
          AbstractNode? element = parent;

          while (element != null && (element is! RenderViewportBase && element is! RenderSliverList)) {
            element = element.parent;
          }

          if (element is RenderSliverList) {
            _mapScrollAxisStyle(
              axis: element.constraints.axis,
              forward: element.constraints.growthDirection == GrowthDirection.forward,
              offset: offset,
              crossAxisOffset: crossAxisOffset,
              size: size,
            );
          } else if (element is RenderViewportBase) {
            _mapScrollAxisStyle(
              axis: element.axis,
              forward: true,
              offset: offset,
              crossAxisOffset: crossAxisOffset,
              size: size,
            );
          }
        }
      } else if (parentData != null) {
        assert(() {
          if (parentData.runtimeType != ParentData) {
            // ignore: avoid_print
            print(
                'RositaRenderBoxMixin not handled: ${toString()}, parentData: $parentData, runType: ${parentData.runtimeType}');
          }
          return true;
        }());
      }
    }
  }

  void _mapScrollAxisStyle({
    required Axis axis,
    required bool forward,
    required double offset,
    required double? crossAxisOffset,
    required Size size,
  }) {
    switch (axis) {
      case Axis.vertical:
        htmlElement.style.top = forward ? '${offset}px' : '${0 - offset - size.height}px';

        if (crossAxisOffset != null) {
          htmlElement.style.left = '${crossAxisOffset}px';
        }
      case Axis.horizontal:
        htmlElement.style.left = forward ? '${offset}px' : '${0 - offset - size.width}px';

        if (crossAxisOffset != null) {
          htmlElement.style.top = '${crossAxisOffset}px';
        }
    }
  }
}
