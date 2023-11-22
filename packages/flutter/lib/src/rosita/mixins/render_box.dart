// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderBoxMixin on RositaRenderMixin {
  @override
  RenderBox get target => this as RenderBox;

  Offset? _localOffset;

  Offset? get localOffset => _localOffset;

  String _styleTransform = '';

  String get styleTransform => _styleTransform;

  set styleTransform(String value) => _styleTransform = value;

  @override
  void rositaLayout() {
    super.rositaLayout();

    final target = this.target;
    final size = target.size;
    final style = htmlElement.style;

    style.width = '${size.width}px';
    style.height = '${size.height}px';

    final offset = _getRenderObjectOffset(target, size) + _calculateParenOffset(target);

    style.transform = 'translate(${offset.dx}px,${offset.dy}px)$_styleTransform';

    _localOffset = offset;
  }

  Offset _calculateParenOffset(RenderObject object) {
    Offset parentOffset = Offset.zero;

    RenderObject? element = object.parent;

    while (element != null) {
      if (element.hasHtmlElement) {
        break;
      }

      parentOffset += _getRenderObjectOffset(element, element is RenderBox ? element.size : Size.zero);

      element = element.parent;
    }

    return parentOffset;
  }

  Offset _getRenderObjectOffset(RenderObject object, Size size) {
    final parentData = object.parentData;

    if (parentData is BoxParentData) {
      return parentData.offset;
    } else if (parentData is SliverLogicalParentData) {
      double offset = parentData.layoutOffset ?? 0.0;

      final crossAxisOffset = parentData is SliverGridParentData ? parentData.crossAxisOffset : null;

      final parent = object.parent;
      RenderObject? element = parent;

      while (element != null && (element is! RenderViewportBase)) {
        element = element.parent;
        final parentData = element?.parentData;

        if (parentData is SliverLogicalContainerParentData) {
          offset += parentData.layoutOffset ?? 0;
        }
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
    } else if (parentData is TextParentData) {
      return parentData.offset ?? Offset.zero;
    } else if (parentData is SliverPhysicalParentData) {
      return Offset.zero;
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
