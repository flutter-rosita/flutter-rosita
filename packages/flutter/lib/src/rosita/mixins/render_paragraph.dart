// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';
import 'package:web/web.dart' as web;

mixin RositaRenderParagraphMixin on RositaRenderMixin {
  @override
  RenderParagraph get target => this as RenderParagraph;

  @override
  void rositaPaint() {
    final text = target.text;

    htmlElement.innerHTML = '';

    RositaTextUtils.applyTextStyle(
      htmlElement.style,
      textAlign: target.textAlign,
    );

    _appendTextSpan(text, htmlElement);
  }

  void _appendTextSpan(InlineSpan text, web.HTMLElement parent) {
    final style = text.style;

    final element = web.HTMLSpanElement();

    if (text is TextSpan && text.text != null) {
      element.text = text.text!;
    } else {
      element.text = ' ';
    }

    RositaTextUtils.applyTextStyle(
      element.style,
      textStyle: style,
      textScaler: target.textScaler,
    );

    parent.append(element);

    if (text is TextSpan && text.children != null) {
      for (final child in text.children!) {
        _appendTextSpan(child, element);
      }
    }
  }
}
