import 'package:universal_html/html.dart' as html;

class RositaOpacityUtils {
  static void applyOpacity(html.CssStyleDeclaration style, double? opacity) {
    if (opacity == null) {
      style.display = '';
      style.opacity = '1';
    } else if (opacity > 0) {
      style.display = '';
      style.opacity = '${opacity > 0.99 ? 1 : opacity}';
    } else {
      style.display = 'none';
      style.opacity = '0';
    }
  }
}
