import 'package:flutter/rendering.dart';
import 'package:universal_html/html.dart' as html;

class RositaRadiusUtils {
  static bool _isAllEquals(BorderRadius borderRadius) {
    return borderRadius.topLeft.x == borderRadius.topRight.x &&
        borderRadius.topRight.x == borderRadius.bottomRight.x &&
        borderRadius.bottomRight.x == borderRadius.bottomLeft.x;
  }

  static void applyBorderRadius(html.CssStyleDeclaration style, BorderRadiusGeometry? borderRadius) {
    if (borderRadius != null) {
      final radius = borderRadius.resolve(null);

      if (_isAllEquals(radius)) {
        style.borderRadius = radius.topLeft.x == 0 ? '' : '${radius.topLeft.x}px';
        return;
      }

      style.borderRadius =
          '${radius.topLeft.x}px ${radius.topRight.x}px ${radius.bottomRight.x}px ${radius.bottomLeft.x}px';
    }
  }

  static void applyClipBorderRadius(html.CssStyleDeclaration style, BorderRadiusGeometry? borderRadius) {
    if (borderRadius != null) {
      final radius = borderRadius.resolve(null);

      if (_isAllEquals(radius)) {
        style.clipPath = radius.topLeft.x == 0 ? '' : 'inset(0px round ${radius.topLeft.x}px)';
        return;
      }

      style.clipPath =
          'inset(0px round ${radius.topLeft.x}px ${radius.topRight.x}px ${radius.bottomRight.x}px ${radius.bottomLeft.x}px)';
    }
  }

  static void applyCustomClipper(html.CssStyleDeclaration style, CustomClipper? clipper, Size size) {
    if (clipper is ShapeBorderClipper) {
      final shape = clipper.shape;

      switch (shape) {
        case RoundedRectangleBorder():
          RositaRadiusUtils.applyClipBorderRadius(style, shape.borderRadius);
        case StadiumBorder():
          RositaRadiusUtils.applyClipBorderRadius(
            style,
            BorderRadius.all(
              Radius.circular(size.shortestSide / 2),
            ),
          );
      }
    }
  }
}
