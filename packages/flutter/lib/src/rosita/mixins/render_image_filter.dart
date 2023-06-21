// ignore_for_file: public_member_api_docs, always_specify_types

import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/rosita.dart';

mixin RositaRenderImageFilterMixin on RositaRenderMixin {
  bool get enabled;

  ImageFilter get imageFilter;

  @override
  void rositaPaint() {
    final filter = imageFilter;
    final style = htmlElement.style;

    if (enabled) {
      switch (filter) {
        case RositaBlurImageFilter():
          style.filter = 'blur(${math.max(filter.sigmaX, filter.sigmaY)}px)';
          return;
      }
    }

    style.filter = '';
  }
}
