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

        (style as JSObject).setProperty('borderTop'.toJS, _mapBorderSide(top));
        (style as JSObject).setProperty('borderRight'.toJS, _mapBorderSide(right));
        (style as JSObject).setProperty('borderBottom'.toJS, _mapBorderSide(bottom));
        (style as JSObject).setProperty('borderLeft'.toJS, _mapBorderSide(left));

        firstChildStyle?.left = '${-left.width}px';
        firstChildStyle?.top = '${-top.width}px';
      case BorderDirectional():
        final BorderDirectional(:top, :start, :bottom, :end) = border;

        (style as JSObject).setProperty('borderTop'.toJS, _mapBorderSide(top));
        (style as JSObject).setProperty('borderBottom'.toJS, _mapBorderSide(bottom));

        (style as JSObject).setProperty('borderLeft'.toJS, _mapBorderSide(start));
        (style as JSObject).setProperty('borderRight'.toJS, _mapBorderSide(end));
    }
  }

  static JSAny _mapBorderSide(BorderSide side) {
    return (side.width.toJS)
        .add('px '.toJS)
        .add(_mapBorderStyle(side.style))
        .add(' '.toJS)
        .add(side.color.toStyleJSAny());
  }

  static JSAny _mapBorderStyle(BorderStyle style) => switch (style) {
        BorderStyle.solid => 'solid'.toJS,
        BorderStyle.none => 'none'.toJS,
      };
}
