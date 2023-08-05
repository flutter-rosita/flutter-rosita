import 'package:flutter/rendering.dart';
import 'package:universal_html/html.dart' as html;

class RositaBoxFitUtils {
  static void applyBoxFit(html.HtmlElement element, BoxFit? fit) {
    switch (fit) {
      case BoxFit.fitWidth:
        element.style.width = '100%';
      case BoxFit.fitHeight:
        element.style.height = '100%';
      default:
        element.style.objectFit = _mapperBoxFit(fit);
    }
  }

  static String _mapperBoxFit(BoxFit? fit) {
    return switch (fit) {
      BoxFit.fill => 'fill',
      BoxFit.contain => 'contain',
      BoxFit.cover => 'cover',
      BoxFit.none => 'none',
      BoxFit.scaleDown => 'scale-down',
      _ => '',
    };
  }

  static void applyAlignment(html.HtmlElement element, AlignmentGeometry? alignment) {
    final align = alignment?.resolve(TextDirection.ltr); // TODO

    element.style.objectPosition = switch (align) {
      null => '',
      Alignment.topLeft => 'top left',
      Alignment.topCenter => 'top',
      Alignment.topRight => 'top right',
      Alignment.centerLeft => 'left',
      Alignment.center => '',
      Alignment.centerRight => 'right',
      Alignment.bottomLeft => 'bottom left',
      Alignment.bottomCenter => 'bottom',
      Alignment.bottomRight => 'bottom right',
      _ => '${align.x * 50 + 50}% ${align.y * 50 + 50}%',
    };
  }
}
