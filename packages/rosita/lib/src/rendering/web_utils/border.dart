part of '../web_rendering.dart';

class RositaBorderUtils {
  static void applyBorderStyle(
    web.CSSStyleDeclaration style,
    web.CSSStyleDeclaration? firstChildStyle,
    BoxBorder border,
    TextDirection? textDirection,
  ) {
    switch (border) {
      case Border():
        final Border(:top, :right, :bottom, :left) = border;

        style.borderTop = _mapBorderSide(top);
        style.borderRight = _mapBorderSide(right);
        style.borderBottom = _mapBorderSide(bottom);
        style.borderLeft = _mapBorderSide(left);

        firstChildStyle?.left = '${-left.width}px';
        firstChildStyle?.top = '${-top.width}px';
      case BorderDirectional():
        final BorderDirectional(:top, :start, :bottom, :end) = border;

        style.borderTop = _mapBorderSide(top);
        style.borderBottom = _mapBorderSide(bottom);

        style.borderLeft = _mapBorderSide(start);
        style.borderRight = _mapBorderSide(end);
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
