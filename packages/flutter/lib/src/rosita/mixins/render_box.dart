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
      htmlElement.style.width = '${target.size.width}px';
      htmlElement.style.height = '${target.size.height}px';

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

          while (element != null && element is! RenderViewportBase) {
            element = element.parent;
          }

          if (element is RenderViewportBase) {
            final axis = element.axis;

            switch (axis) {
              case Axis.vertical:
                htmlElement.style.top = '${offset}px';

                if (crossAxisOffset != null) {
                  htmlElement.style.left = '${crossAxisOffset}px';
                }
              case Axis.horizontal:
                htmlElement.style.left = '${offset}px';

                if (crossAxisOffset != null) {
                  htmlElement.style.top = '${crossAxisOffset}px';
                }
            }
          }
        }
      } else if (parentData != null) {
        assert(() {
          if (parentData.runtimeType != ParentData) {
            // ignore: avoid_print
            print('RositaRenderBoxMixin not handled: ${toString()}, parentData: $parentData, runType: ${parentData
                .runtimeType}');
          }
          return true;
        }());
      }
    }
  }
}
