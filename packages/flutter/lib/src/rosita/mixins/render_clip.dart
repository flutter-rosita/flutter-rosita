// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderClipRectMixin on RositaRenderMixin {
  @override
  RenderClipRect get target => this as RenderClipRect;
}

mixin RositaRenderClipRRectMixin on RositaRenderMixin {
  @override
  RenderClipRRect get target => this as RenderClipRRect;

  @override
  void rositaPaint() {
    if (target.clipBehavior != Clip.none) {
      RositaRadiusUtils.applyClipBorderRadius(htmlElement, target.borderRadius);
    }
  }
}

mixin RositaRenderClipOvalMixin on RositaRenderMixin {
  @override
  RenderClipOval get target => this as RenderClipOval;

  @override
  void rositaPaint() {
    if (target.clipBehavior != Clip.none) {
      final x = target.size.width / 2;
      final y = target.size.height / 2;
      final ellipticalRadius = Radius.elliptical(x, y);

      RositaRadiusUtils.applyClipBorderRadius(
        htmlElement,
        BorderRadius.all(ellipticalRadius),
      );
    }
  }
}

mixin RositaRenderClipPathMixin on RositaRenderMixin {
  @override
  RenderClipPath get target => this as RenderClipPath;

  @override
  void rositaPaint() {
    if (target.clipBehavior != Clip.none) {
      final clipper = target.clipper;

      if (clipper is ShapeBorderClipper) {
        final shape = clipper.shape;

        if (shape is RoundedRectangleBorder) {
          RositaRadiusUtils.applyClipBorderRadius(htmlElement, shape.borderRadius);
        }
      }
    }
  }
}
