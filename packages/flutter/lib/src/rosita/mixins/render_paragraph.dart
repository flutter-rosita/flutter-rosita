// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';
import 'package:universal_html/html.dart' as html;

mixin RositaRenderParagraphMixin on RositaRenderMixin {
  @override
  RenderParagraph get target => this as RenderParagraph;

  @override
  void rositaPaint() {
    final text = target.text;

    if (target.hasSize) {
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

    RositaTextUtils.applyTextStyle(
      element,
      style: style,
      textAlign: target.textAlign,
      overflow: target.overflow,
      maxLines: target.maxLines,
    );

    parent.append(element);

    if (text is TextSpan && text.children != null) {
      for (final child in text.children!) {
        _appendTextSpan(child, element);
      }
    }
  }
}
