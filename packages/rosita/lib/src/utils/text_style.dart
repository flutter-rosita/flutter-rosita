// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:rosita/rosita.dart';
import 'package:universal_html/html.dart' as html;

class RositaTextUtils {
  static void applyTextStyle(
    html.CssStyleDeclaration style, {
    TextStyle? textStyle,
    TextAlign? textAlign,
  }) {
    if (textAlign != null) style.textAlign = _mapTextAlign(textAlign);
    if (textStyle != null) {
      if (textStyle.color != null) {
        style.color = textStyle.color.toStyleString();
      }
      if (textStyle.fontFamily != null) {
        style.fontFamily = "'${textStyle.fontFamily}'";
      }
      if (textStyle.fontSize != null) {
        style.fontSize = '${textStyle.fontSize!.floor()}px';
      }
      if (textStyle.fontSize != null && textStyle.height != null) {
        style.lineHeight = '${(textStyle.fontSize! * textStyle.height!).round()}px';
      }
      if (textStyle.fontWeight != null) {
        style.fontWeight = mapFontWeight(textStyle.fontWeight!);
      }
      if (textStyle.fontStyle != null) {
        style.fontStyle = maFontStyle(textStyle.fontStyle!);
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

  static String maFontStyle(FontStyle value) => switch (value) {
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
