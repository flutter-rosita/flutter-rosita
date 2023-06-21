part of '../web_rendering.dart';

class RositaBoxFitUtils {
  static void applyBoxFitToObjectFit(web.CSSStyleDeclaration style, BoxFit? fit) {
    switch (fit) {
      case BoxFit.fitWidth:
        style.width = '100%';
      case BoxFit.fitHeight:
        style.height = '100%';
      default:
        style.objectFit = _mapperBoxFitToObjectFit(fit);
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

  static Future<void> applyBoxFitToBackgroundSize(web.CssStyleDeclaration style, BoxFit? fit) async {
    style.backgroundSize = _mapperBoxFitToBackgroundSize(fit);
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

  static void applyAlignmentToObjectPosition(web.CSSStyleDeclaration style, AlignmentGeometry? alignment) {
    style.objectPosition = _mapperAlignmentGeometry(alignment);
  }

  static void applyAlignmentToBackgroundPosition(web.CSSStyleDeclaration style, AlignmentGeometry? alignment) {
    style.backgroundPosition = _mapperAlignmentGeometry(alignment);
  }

  static String _mapperAlignmentGeometry(AlignmentGeometry? alignment) {
    final align = alignment?.resolve(TextDirection.ltr); // TODO

    return switch (align) {
      null => '',
      Alignment.topLeft => 'top left',
      Alignment.topCenter => 'top',
      Alignment.topRight => 'top right',
      Alignment.centerLeft => 'left',
      Alignment.center => 'center',
      Alignment.centerRight => 'right',
      Alignment.bottomLeft => 'bottom left',
      Alignment.bottomCenter => 'bottom',
      Alignment.bottomRight => 'bottom right',
      _ => '${align.x * 50 + 50}% ${align.y * 50 + 50}%',
    };
  }
}
