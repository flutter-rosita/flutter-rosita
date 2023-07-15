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

      final offset = _getRenderObjectOffset(target, size) + _calculateParenOffset(target);

      htmlElement.style.left = '${offset.dx}px';
      htmlElement.style.top = '${offset.dy}px';
    }
  }

  Offset _calculateParenOffset(RenderObject object) {
    Offset parentOffset = Offset.zero;

    AbstractNode? element = object.parent;

    while (element != null) {
      if (element is RositaRenderMixin) {
        if (element.hasHtmlElement) {
          break;
        }

        if (element is RenderObject) {
          parentOffset += _getRenderObjectOffset(element, element is RenderBox ? element.size : Size.zero);
        }
      }

      element = element.parent;
    }

    return parentOffset;
  }

  Offset _getRenderObjectOffset(RenderObject object, Size size) {
    final parentData = object.parentData;

    if (parentData is BoxParentData) {
      return parentData.offset;
    } else if (parentData is SliverLogicalParentData) {
      final offset = parentData.layoutOffset;
      final crossAxisOffset = parentData is SliverGridParentData ? parentData.crossAxisOffset : null;

      if (offset != null) {
        final parent = object.parent;
        AbstractNode? element = parent;

        while (element != null && (element is! RenderViewportBase)) {
          element = element.parent;
        }

        final bool forward;

        if (parent is RenderSliver) {
          forward = parent.constraints.growthDirection == GrowthDirection.forward;
        } else {
          forward = false;
        }

        if (element is RenderViewportBase) {
          return _mapScrollAxisStyle(
            axis: element.axis,
            forward: forward,
            offset: offset,
            crossAxisOffset: crossAxisOffset ?? 0,
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
    return Offset.zero;
  }

  Offset _mapScrollAxisStyle({
    required Axis axis,
    required bool forward,
    required double offset,
    required double crossAxisOffset,
    required Size size,
  }) {
    switch (axis) {
      case Axis.vertical:
        return Offset(
          crossAxisOffset,
          forward ? offset : 0 - offset - size.height,
        );
      case Axis.horizontal:
        return Offset(
          forward ? offset : 0 - offset - size.width,
          crossAxisOffset,
        );
    }
  }
}
