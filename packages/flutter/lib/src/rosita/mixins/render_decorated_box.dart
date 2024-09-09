// ignore_for_file: public_member_api_docs, always_specify_types

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';
import 'package:web/web.dart' as web;

mixin RositaRenderDecoratedBoxMixin on RositaRenderMixin {
  @override
  RenderDecoratedBox get target => this as RenderDecoratedBox;

  web.HTMLElement? _foregroundHtmlElement;

  web.HTMLElement get foregroundHtmlElement {
    if (_foregroundHtmlElement != null) {
      return _foregroundHtmlElement!;
    }

    final foregroundHtmlElement = web.HTMLDivElement();

    foregroundHtmlElement.style
      ..width = '100%'
      ..height = '100%'
      ..left = '0px'
      ..top = '0px';

    _foregroundHtmlElement = foregroundHtmlElement;

    htmlElement.append(foregroundHtmlElement);

    return foregroundHtmlElement;
  }

  @override
  void rositaDetach() {
    _foregroundHtmlElement?.remove();
    _foregroundHtmlElement = null;
  }

  @override
  void rositaPaint() {
    final target = this.target;
    final decoration = target.decoration;
    final web.HTMLElement targetHtmlElement = switch (target.position) {
      DecorationPosition.background => htmlElement,
      DecorationPosition.foreground => foregroundHtmlElement,
    };
    final style = targetHtmlElement.style;

    if (decoration is BoxDecoration) {
      _shadowsStyle(style, decoration.boxShadow);
      _fillStyle(style, decoration.color, decoration.image, decoration.gradient);

      if (decoration.borderRadius != null) {
        RositaRadiusUtils.applyBorderRadius(style, decoration.borderRadius);
      } else {
        style.borderRadius = decoration.shape == BoxShape.circle ? '100%' : '';
      }

      final border = decoration.border;

      if (border != null) {
        final firstChild = targetHtmlElement.firstChild as web.HTMLElement?;

        RositaBorderUtils.applyBorderStyle(style, firstChild?.style, border, target.configuration.textDirection);
      }
    } else if (decoration is ShapeDecoration) {
      _shadowsStyle(style, decoration.shadows);
      _fillStyle(style, decoration.color, decoration.image, decoration.gradient);

      final path = decoration.getClipPath(
        decoration.padding.resolve(TextDirection.ltr).topLeft & target.size,
        TextDirection.ltr,
      );

      RositaPathUtils.applyCustomClipperPath(style, path);
    }
  }

  void _fillStyle(web.CSSStyleDeclaration style, Color? color, DecorationImage? image, Gradient? gradient) {
    (style as JSObject).setProperty('background' as JSAny, color.toStyleJSAny());

    if (image != null) {
      style.backgroundImage = 'url(${RositaImageUtils.buildImageProviderPath(image.image)})';
      RositaBoxFitUtils.applyBoxFitToBackgroundSize(style, image.fit);
      RositaBoxFitUtils.applyAlignmentToBackgroundPosition(style, image.alignment);
    }

    if (gradient != null) {
      final Gradient(:colors, :stops) = gradient;

      final stringBuffer = StringBuffer();

      for (int i = 0; i < colors.length; i++) {
        final color = colors[i];
        final stop = stops != null ? stops[i] : null;

        if (i > 0) {
          stringBuffer.write(',');
        }

        stringBuffer.write(color.toStyleString());

        if (stop != null) {
          stringBuffer.write(' ${stop * 100}%');
        }
      }

      if (gradient is LinearGradient) {
        final LinearGradient(:begin, :end) = gradient;
        final angle = RositaAlignmentUtils.getAngleDeg(begin, end);

        style.background = 'linear-gradient($angle,$stringBuffer)';
      } else if (gradient is RadialGradient) {
        style.background = 'radial-gradient($stringBuffer)';
      } else if (gradient is SweepGradient) {
        style.background = 'conic-gradient($stringBuffer)';
      }
    }
  }

  void _shadowsStyle(web.CSSStyleDeclaration style, List<BoxShadow>? shadows) {
    if (shadows != null && shadows.isNotEmpty) {
      final stringBuffer = StringBuffer();

      for (int i = 0; i < shadows.length; i++) {
        final shadow = shadows[i];

        stringBuffer.write(
            '${shadow.offset.dx}px ${shadow.offset.dy}px ${shadow.blurRadius}px ${shadow.spreadRadius}px ${shadow.color.toStyleString()}');
      }

      style.boxShadow = stringBuffer.toString();
    } else {
      style.boxShadow = '';
    }
  }
}
