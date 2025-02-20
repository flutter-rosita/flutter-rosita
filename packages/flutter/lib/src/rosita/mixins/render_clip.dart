// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderClipRectMixin on RositaRenderMixin {
  @override
  RenderClipRect get target => this as RenderClipRect;

  @override
  void rositaPaint() {
    final target = this.target;

    if (target.clipBehavior != Clip.none) {
      htmlElement.style.overflow = 'hidden';
    } else {
      htmlElement.style.overflow = '';
    }
  }
}

mixin RositaRenderClipRRectMixin on RositaRenderMixin {
  @override
  RenderClipRRect get target => this as RenderClipRRect;

  @override
  void rositaPaint() {
    final target = this.target;

    if (target.clipBehavior != Clip.none) {
      RositaRadiusUtils.applyClipBorderRadius(htmlElement.style, target.borderRadius);
    }
  }
}

mixin RositaRenderClipOvalMixin on RositaRenderMixin {
  @override
  RenderClipOval get target => this as RenderClipOval;

  @override
  void rositaPaint() {
    final target = this.target;

    if (target.clipBehavior != Clip.none) {
      final size = target.size;
      final x = size.width / 2;
      final y = size.height / 2;
      final ellipticalRadius = Radius.elliptical(x, y);

      RositaRadiusUtils.applyClipBorderRadius(
        htmlElement.style,
        BorderRadius.all(ellipticalRadius),
      );
    } else {
      htmlElement.style.overflow = '';
    }
  }
}

mixin RositaRenderClipPathMixin on RositaRenderMixin {
  @override
  RenderClipPath get target => this as RenderClipPath;

  @override
  void rositaPaint() {
    final target = this.target;

    if (target.clipBehavior != Clip.none) {
      final clipper = target.clipper;

      RositaPathUtils.applyCustomClipper(htmlElement.style, clipper, target.size);
    } else {
      htmlElement.style.overflow = '';
    }
  }
}
