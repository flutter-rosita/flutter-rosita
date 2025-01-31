part of '../web_rendering.dart';

class RositaRadiusUtils {
  static bool _isAllEquals(BorderRadius borderRadius) {
    return borderRadius.topLeft.x == borderRadius.topRight.x &&
        borderRadius.topRight.x == borderRadius.bottomRight.x &&
        borderRadius.bottomRight.x == borderRadius.bottomLeft.x;
  }

  static void applyBorderRadius(web.CSSStyleDeclaration style, BorderRadiusGeometry? borderRadius) {
    if (borderRadius != null) {
      final radius = borderRadius.resolve(null);

      if (_isAllEquals(radius)) {
        (style as JSObject).setProperty(
            'borderRadius'.toJS, (radius.topLeft.x == 0 ? ''.toJS : (radius.topLeft.x.toJS).add('px'.toJS)));
        return;
      }

      (style as JSObject).setProperty(
        'borderRadius'.toJS,
        '${radius.topLeft.x}px ${radius.topRight.x}px ${radius.bottomRight.x}px ${radius.bottomLeft.x}px'.toJS,
      );
    }
  }

  static void applyClipBorderRadius(web.CSSStyleDeclaration style, BorderRadiusGeometry? borderRadius) {
    if (borderRadius != null) {
      applyBorderRadius(style, borderRadius);

      style.overflow = 'hidden';
    }
  }
}
