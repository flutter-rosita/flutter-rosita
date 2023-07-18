// ignore_for_file: public_member_api_docs, always_specify_types

import 'dart:html' as html;

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderParagraphMixin on RositaRenderMixin {
  @override
  RenderParagraph get target => this as RenderParagraph;

  @override
  void rositaPaint() {
    final text = target.text;

    if (target.hasSize) {
      htmlElement.style.textAlign = _mapTextAlign(target.textAlign);
      htmlElement.style.textOverflow = _mapTextOverflow(target.overflow);
      htmlElement.style.overflowX = _mapOverflow(target.overflow);
      htmlElement.style.wordWrap = 'break-word';

      if (target.maxLines == 1) {
        htmlElement.style.whiteSpace = 'nowrap';
      } else if (target.maxLines != null) {
        htmlElement.style.overflowY = 'clip';
      }

      htmlElement.innerHtml = '';

      _appendTextSpan(text, htmlElement);
    }
  }

  void _appendTextSpan(InlineSpan text, html.HtmlElement parent) {
    final style = text.style;

    final element = html.SpanElement();

    if (text is TextSpan && text.text != null) {
      element.text = text.text;
    } else {
      element.text = ' ';
    }

    if (style != null) {
      if (style.color != null) {
        element.style.color = style.color?.toHexString();
      }
      if (style.fontFamily != null) {
        element.style.fontFamily = "'${style.fontFamily}'";
      }
      if (style.fontSize != null) {
        element.style.fontSize = '${style.fontSize}px';
      }
      if (style.fontSize != null && style.height != null) {
        element.style.lineHeight = '${(style.fontSize! * style.height!).round()}px';
      }
      if (style.fontWeight != null) {
        element.style.fontWeight = _mapFontWeight(style.fontWeight!);
      }
    }

    parent.append(element);

    if (text is TextSpan && text.children != null) {
      for (final child in text.children!) {
        _appendTextSpan(child, element);
      }
    }
  }

  String _mapFontWeight(FontWeight weight) => switch (weight) {
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

  String _mapTextAlign(TextAlign align) => switch (align) {
        TextAlign.left => 'left',
        TextAlign.right => 'right',
        TextAlign.center => 'center',
        TextAlign.justify => 'justify',
        TextAlign.start => 'start',
        TextAlign.end => 'end',
      };

  String _mapTextOverflow(TextOverflow overflow) => switch (overflow) {
        TextOverflow.clip => 'clip',
        TextOverflow.ellipsis => 'ellipsis',
        _ => '',
      };

  String _mapOverflow(TextOverflow overflow) => switch (overflow) {
        TextOverflow.clip || TextOverflow.ellipsis => 'clip',
        _ => '',
      };
}
