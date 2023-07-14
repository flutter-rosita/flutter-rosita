// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderParagraphMixin on RositaRenderMixin {
  @override
  RenderParagraph get target => this as RenderParagraph;

  @override
  void rositaLayout() {
    super.rositaLayout();

    final text = target.text;

    if (target.hasSize && text is TextSpan) {
      final string = text.text;

      if (string == null) {
        return;
      }

      htmlElement.innerText = string;

      final style = text.style;

      if (style == null) {
        return;
      }

      htmlElement.style.color = style.color?.toHexString();
      htmlElement.style.fontFamily = "'${style.fontFamily}'";

      if (style.fontSize != null) {
        htmlElement.style.fontSize = '${style.fontSize!}px';
      }
      if (style.height != null) {
        htmlElement.style.height = '${style.height!}px';
      }
      if (style.fontWeight != null) {
        htmlElement.style.width = switch (style.fontWeight!) {
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
      }
    }
  }
}
