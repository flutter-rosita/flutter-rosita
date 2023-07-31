// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:rosita/rosita.dart';
import 'package:universal_html/html.dart' as html;

class RositaTextUtils {
  static void applyTextStyle(
    html.HtmlElement element, {
    TextStyle? style,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
  }) {
    if (textAlign != null) element.style.textAlign = _mapTextAlign(textAlign);
    if (overflow != null) {
      element.style.textOverflow = _mapTextOverflow(overflow);
      element.style.overflowX = _mapOverflow(overflow);
    }
    if (maxLines == 1) {
      element.style.whiteSpace = 'nowrap';
    } else if (maxLines != null) {
      element.style.overflowY = 'clip';
    }

    if (style != null) {
      if (style.color != null) {
        element.style.color = style.color.toHexString();
      }
      if (style.fontFamily != null) {
        element.style.fontFamily = "'${style.fontFamily}'";
      }
      if (style.fontSize != null) {
        element.style.fontSize = '${style.fontSize!.floor()}px';
      }
      if (style.fontSize != null && style.height != null) {
        element.style.lineHeight = '${(style.fontSize! * style.height!).round()}px';
      }
      if (style.fontWeight != null) {
        element.style.fontWeight = mapFontWeight(style.fontWeight!);
      }
      if (style.fontStyle != null) {
        element.style.fontStyle = maFontStyle(style.fontStyle!);
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

  static String _mapTextOverflow(TextOverflow overflow) => switch (overflow) {
        TextOverflow.clip => 'clip',
        TextOverflow.ellipsis => 'ellipsis',
        _ => '',
      };

  static String _mapOverflow(TextOverflow overflow) => switch (overflow) {
        TextOverflow.clip || TextOverflow.ellipsis => 'clip',
        _ => '',
      };
}
