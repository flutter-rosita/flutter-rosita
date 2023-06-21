part of '../web_rendering.dart';

class RositaOpacityUtils {
  static void applyOpacity(web.CSSStyleDeclaration style, double? opacity) {
    if (opacity == null) {
      style.display = '';
      style.opacity = '1';
    } else if (opacity > 0) {
      style.display = '';
      (style as JSObject).setProperty('opacity' as JSAny, opacity > 0.99 ? '1' as JSAny : opacity as JSAny);
    } else {
      style.display = 'none';
      style.opacity = '0';
    }
  }
}
