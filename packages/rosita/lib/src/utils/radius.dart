import 'package:flutter/rendering.dart';
import 'package:universal_html/html.dart' as html;

class RositaRadiusUtils {
  static void applyBorderRadius(html.HtmlElement element, BorderRadiusGeometry? borderRadius) {
    if (borderRadius != null) {
      final radius = borderRadius.resolve(null);

      if (radius.topLeft == radius.topRight &&
          radius.topRight == radius.bottomRight &&
          radius.bottomRight == radius.bottomLeft) {
        element.style.borderRadius = '${radius.topLeft.x}px';
        return;
      }

      element.style.borderRadius =
          '${radius.topLeft.x}px ${radius.topRight.x}px ${radius.bottomRight.x}px ${radius.bottomLeft.x}px';
    }
  }
}
