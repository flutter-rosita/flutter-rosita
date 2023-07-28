import 'package:universal_html/html.dart' as html;

class RositaOpacityUtils {
  static void applyOpacity(html.HtmlElement element, double? opacity) {
    if (opacity == null) {
      element.style.display = '';
      element.style.opacity = '1';
    } else if (opacity > 0) {
      element.style.display = '';
      element.style.opacity = '${opacity > 0.99 ? 1 : opacity}';
    } else {
      element.style.display = 'none';
      element.style.opacity = '0';
    }
  }
}
