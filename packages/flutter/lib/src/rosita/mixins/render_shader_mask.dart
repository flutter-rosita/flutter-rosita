// ignore_for_file: public_member_api_docs, always_specify_types

import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderShaderMaskMixin on RositaRenderMixin {
  @override
  RenderShaderMask get target => this as RenderShaderMask;

  @override
  void rositaPaint() {
    final style = htmlElement.style;

    final shader = target.shaderCallback(Offset.zero & target.size);

    switch (shader) {
      case RositaGradientLinearShader():
        final rect = Offset.zero & target.size;
        final angleDeg = RositaAlignmentUtils.getAngleDegFromRectAndOffset(rect, shader.from, shader.to);

        final colors = shader.colors;
        final length = colors.length;
        final colorStops = shader.colorStops ?? [for (int i = 0; i < length; i++) i / length];

        final stringBuffer = StringBuffer('linear-gradient($angleDeg');

        for (int i = 0; i < length; i++) {
          final color = colors[i];
          final stop = colorStops[i];

          stringBuffer.write(',${color.toStyleString()} ${stop * 100}%');
        }

        stringBuffer.write(')');

        final value = stringBuffer.toString();

        style.maskImage = value;
      case RositaGradientRadialShader():
        break;
      case RositaGradientSweepShader():
        break;
    }
  }
}
