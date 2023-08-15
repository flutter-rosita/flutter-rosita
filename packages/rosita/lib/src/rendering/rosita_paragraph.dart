import 'package:flutter/rendering.dart';
import 'package:rosita/rosita.dart';

class RositaRenderParagraph extends RositaRenderBox {
  RositaRenderParagraph({
    String? text,
    TextStyle? style,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
  })  : _text = text,
        _style = style,
        _textAlign = textAlign,
        _overflow = overflow,
        _maxLines = maxLines;

  String? get text => _text;
  String? _text;

  set text(String? value) {
    if (value == text) {
      return;
    }
    _text = value;
    markNeedsLayout();
    markNeedsPaint();
  }

  TextStyle? get style => _style;
  TextStyle? _style;

  set style(TextStyle? value) {
    if (value == style) {
      return;
    }
    _style = value;
    markNeedsLayout();
    markNeedsPaint();
  }

  TextAlign? get textAlign => _textAlign;
  TextAlign? _textAlign;

  set textAlign(TextAlign? value) {
    if (value == textAlign) {
      return;
    }
    _textAlign = textAlign;
    markNeedsLayout();
    markNeedsPaint();
  }

  TextOverflow? get overflow => _overflow;
  TextOverflow? _overflow;

  set overflow(TextOverflow? value) {
    if (value == overflow) {
      return;
    }
    _overflow = overflow;
    markNeedsLayout();
    markNeedsPaint();
  }

  int? get maxLines => _maxLines;
  int? _maxLines;

  set maxLines(int? value) {
    if (value == maxLines) {
      return;
    }
    _maxLines = maxLines;
    markNeedsLayout();
    markNeedsPaint();
  }

  @override
  void performLayout() {
    final text = this.text;
    final style = this.style;

    if (text == null || text == '' || style == null) {
      size = Size.zero;
      return;
    }

    final data = RositaParagraphUtils.buildParagraphData(
      text: text,
      style: style,
      constraints: constraints,
    );

    size = constraints.constrain(data.size);
  }

  @override
  void rositaPaint() {
    final text = this.text;

    if (text == null) {
      htmlElement.style.display = 'none';
      return;
    }

    htmlElement.style.display = '';

    htmlElement.innerText = text;

    RositaTextUtils.applyTextStyle(
      htmlElement,
      style: style,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}
