import 'package:flutter/rendering.dart';
import 'package:rosita/rosita.dart';
import 'package:universal_html/html.dart' as html;

class RositaBorderUtils {
  static void applyBorderStyle(html.CssStyleDeclaration style, BoxBorder? border) {
    switch (border) {
      case Border():
        final Border(:top, :right, :bottom, :left) = border;

        style.borderTop = _mapBorderSide(top);
        style.borderRight = _mapBorderSide(right);
        style.borderBottom = _mapBorderSide(bottom);
        style.borderLeft = _mapBorderSide(left);
      case BorderDirectional():
        final BorderDirectional(:top, :start, :bottom, :end) = border;

        style.borderTop = _mapBorderSide(top);
        style.borderStart = _mapBorderSide(start);
        style.borderBottom = _mapBorderSide(bottom);
        style.borderEnd = _mapBorderSide(end);
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
