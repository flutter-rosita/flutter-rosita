import 'package:flutter/rendering.dart';
import 'package:rosita/rosita.dart';
import 'package:universal_html/html.dart' as html;

class RositaBorderUtils {
  static void applyBorderStyle(html.HtmlElement element, BoxBorder? border) {
    switch (border) {
      case Border():
        final Border(:top, :right, :bottom, :left) = border;

        element.style.borderTop = _mapBorderSide(top);
        element.style.borderRight = _mapBorderSide(right);
        element.style.borderBottom = _mapBorderSide(bottom);
        element.style.borderLeft = _mapBorderSide(left);
      case BorderDirectional():
        final BorderDirectional(:top, :start, :bottom, :end) = border;

        element.style.borderTop = _mapBorderSide(top);
        element.style.borderStart = _mapBorderSide(start);
        element.style.borderBottom = _mapBorderSide(bottom);
        element.style.borderEnd = _mapBorderSide(end);
    }
  }

  static String _mapBorderSide(BorderSide side) {
    return '${side.width}px ${_mapBorderStyle(side.style)} ${side.color.toStyleString()}';
  }

  static String _mapBorderStyle(BorderStyle style) => switch (style) {
        BorderStyle.solid => 'solid',
        BorderStyle.none => 'none',
      };
}
