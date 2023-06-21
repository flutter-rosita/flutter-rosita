// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';
import 'package:rosita/rosita.dart';

class RositaRichText extends LeafRenderObjectWidget {
  const RositaRichText(
    this.text, {
    super.key,
    this.style,
    this.textScaler,
    this.textAlign,
    this.textDirection,
    this.softWrap = true,
    this.overflow,
    this.maxLines,
  });

  final String? text;

  final TextStyle? style;

  final TextScaler? textScaler;

  final TextAlign? textAlign;

  final TextDirection? textDirection; // TODO: implement

  final bool softWrap;

  final TextOverflow? overflow;

  final int? maxLines;

  @override
  RositaRenderParagraph createRenderObject(BuildContext context) {
    return RositaRenderParagraph(
      text: text,
      style: style,
      textScaler: textScaler,
      textAlign: textAlign,
      softWrap: softWrap,
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RositaRenderParagraph renderObject) {
    renderObject
      ..text = text
      ..style = style
      ..textAlign = textAlign
      ..softWrap = softWrap
      ..overflow = overflow
      ..maxLines = maxLines;
  }
}
