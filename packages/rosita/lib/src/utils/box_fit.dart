import 'package:flutter/rendering.dart';
import 'package:universal_html/html.dart' as html;

class RositaBoxFitUtils {
  static void applyBoxFitToObjectFit(html.HtmlElement element, BoxFit? fit) {
    switch (fit) {
      case BoxFit.fitWidth:
        element.style.width = '100%';
      case BoxFit.fitHeight:
        element.style.height = '100%';
      default:
        element.style.objectFit = _mapperBoxFitToObjectFit(fit);
    }
  }

  static String _mapperBoxFitToObjectFit(BoxFit? fit) {
    return switch (fit) {
      BoxFit.fill => 'fill',
      BoxFit.contain => 'contain',
      BoxFit.cover => 'cover',
      BoxFit.none => 'none',
      BoxFit.scaleDown => 'scale-down',
      _ => '',
    };
  }

  static void applyBoxFitToBackgroundSize(html.HtmlElement element, BoxFit? fit) {
    element.style.backgroundSize = _mapperBoxFitToBackgroundSize(fit);
  }

  static String _mapperBoxFitToBackgroundSize(BoxFit? fit) {
    return switch (fit) {
      BoxFit.fitWidth => '100% auto',
      BoxFit.fitHeight => 'auto 100%',
      BoxFit.fill => '100% 100%',
      BoxFit.contain => 'contain',
      BoxFit.cover => 'cover',
      _ => '',
    };
  }

  static void applyAlignmentToObjectPosition(html.HtmlElement element, AlignmentGeometry? alignment) {
    element.style.objectPosition = _mapperAlignmentGeometry(alignment);
  }

  static void applyAlignmentToBackgroundPosition(html.HtmlElement element, AlignmentGeometry? alignment) {
    element.style.backgroundPosition = _mapperAlignmentGeometry(alignment);
  }

  static String _mapperAlignmentGeometry(AlignmentGeometry? alignment) {
    final align = alignment?.resolve(TextDirection.ltr); // TODO

    return switch (align) {
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
