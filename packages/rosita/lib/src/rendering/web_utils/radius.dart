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
        (style as JSObject).setProperty('borderRadius' as JSAny,
            (radius.topLeft.x == 0 ? '' : (radius.topLeft.x as JSAny).add('px' as JSAny)) as JSAny);
        return;
      }

      (style as JSObject).setProperty(
          'borderRadius' as JSAny,
          (radius.topLeft.x as JSAny)
              .add('px ' as JSAny)
              .add(radius.topRight.x as JSAny)
              .add('px ' as JSAny)
              .add(radius.bottomRight.x as JSAny)
              .add('px ' as JSAny)
              .and(radius.bottomLeft.x as JSAny)
              .add('px' as JSAny));
    }
  }

  static void applyClipBorderRadius(web.CSSStyleDeclaration style, BorderRadiusGeometry? borderRadius) {
    if (borderRadius != null) {
      applyBorderRadius(style, borderRadius);

      style.overflow = 'hidden';
    }
  }
}
