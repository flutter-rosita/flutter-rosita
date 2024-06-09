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

        (style as JSObject).setProperty('borderTop' as JSAny, _mapBorderSide(top));
        (style as JSObject).setProperty('borderRight' as JSAny, _mapBorderSide(right));
        (style as JSObject).setProperty('borderBottom' as JSAny, _mapBorderSide(bottom));
        (style as JSObject).setProperty('borderLeft' as JSAny, _mapBorderSide(left));

        firstChildStyle?.left = '${-left.width}px';
        firstChildStyle?.top = '${-top.width}px';
      case BorderDirectional():
        final BorderDirectional(:top, :start, :bottom, :end) = border;

        (style as JSObject).setProperty('borderTop' as JSAny, _mapBorderSide(top));
        (style as JSObject).setProperty('borderBottom' as JSAny, _mapBorderSide(bottom));

        (style as JSObject).setProperty('borderLeft' as JSAny, _mapBorderSide(start));
        (style as JSObject).setProperty('borderRight' as JSAny, _mapBorderSide(end));
    }
  }

  static JSAny _mapBorderSide(BorderSide side) {
    return (side.width as JSAny)
        .add('px ' as JSAny)
        .add(_mapBorderStyle(side.style))
        .add(' ' as JSAny)
        .add(side.color.toStyleJSAny());
  }

  static JSAny _mapBorderStyle(BorderStyle style) => switch (style) {
        BorderStyle.solid => 'solid' as JSAny,
        BorderStyle.none => 'none' as JSAny,
      };
}
