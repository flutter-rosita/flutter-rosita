part of '../web_rendering.dart';

class RositaTextUtils {
  static void applyTextStyle(
    web.CSSStyleDeclaration style, {
    TextStyle? textStyle,
    TextAlign? textAlign,
    TextScaler? textScaler,
  }) {
    if (textAlign != null) style.textAlign = _mapTextAlign(textAlign);
    if (textStyle != null) {
      if (textStyle.color != null) {
        (style as JSObject).setProperty('color'.toJS, textStyle.color.toStyleJSAny());
      }
      if (textStyle.fontFamily != null) {
        style.fontFamily = "'${textStyle.fontFamily}'";
      }
      if (textStyle.fontSize != null) {
        double fontSize = textStyle.fontSize!;

        if (textScaler != null) {
          fontSize = textScaler.scale(fontSize);
        }

        (style as JSObject).setProperty('fontSize'.toJS, (fontSize.toJS).add('px'.toJS));
      }
      if (textStyle.fontSize != null && textStyle.height != null) {
        double fontSize = textStyle.fontSize! * textStyle.height!;

        if (textScaler != null) {
          fontSize = textScaler.scale(fontSize);
        }

        (style as JSObject).setProperty('lineHeight'.toJS, (fontSize.toJS).add('px'.toJS));
      }
      if (textStyle.fontWeight != null) {
        style.fontWeight = mapFontWeight(textStyle.fontWeight!);
      }
      if (textStyle.fontStyle != null) {
        style.fontStyle = mapFontStyle(textStyle.fontStyle!);
      }
    }
  }

  static String mapFontWeight(FontWeight weight) => switch (weight) {
        FontWeight.w100 => '100',
        FontWeight.w200 => '200',
        FontWeight.w300 => '300',
        FontWeight.w400 => '400',
        FontWeight.w500 => '500',
        FontWeight.w600 => '600',
        FontWeight.w700 => '700',
        FontWeight.w800 => '800',
        FontWeight.w900 => '900',
        _ => '',
      };

  static String mapFontStyle(FontStyle value) => switch (value) {
        FontStyle.normal => 'normal',
        FontStyle.italic => 'italic',
      };

  static String _mapTextAlign(TextAlign align) => switch (align) {
        TextAlign.left => 'left',
        TextAlign.right => 'right',
        TextAlign.center => 'center',
        TextAlign.justify => 'justify',
        TextAlign.start => 'start',
        TextAlign.end => 'end',
      };
}
