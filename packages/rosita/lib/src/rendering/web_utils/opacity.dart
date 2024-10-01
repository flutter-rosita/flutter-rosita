part of '../web_rendering.dart';

class RositaOpacityUtils {
  static void applyOpacity(web.CSSStyleDeclaration style, double? opacity) {
    final alpha = opacity != null ? ui.Color.getAlphaFromOpacity(opacity) : 255;

    if (alpha == 255) {
      style.display = '';
      style.opacity = '1';
    } else if (alpha == 0) {
      style.display = 'none';
      style.opacity = '0';
    } else {
      style.display = '';
      (style as JSObject).setProperty('opacity' as JSAny, opacity as JSAny);
    }
  }
}
