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
    _isInitialSetText = true;
    setLayout();
  }

  TextStyle? get style => _style;
  TextStyle? _style;

  set style(TextStyle? value) {
    if (identical(_style, value)) {
      return;
    } else if (_style?.fontFamily != value?.fontFamily ||
        _style?.fontSize != value?.fontSize ||
        _style?.height != value?.height ||
        _style?.fontWeight != value?.fontWeight ||
        _style?.fontStyle != value?.fontStyle) {
      _style = value;
      setLayout();
    } else if (_style?.color != value?.color) {
      _style = value;
      markNeedsPaint();
    }
  }

  TextAlign? get textAlign => _textAlign;
  TextAlign? _textAlign;

  set textAlign(TextAlign? value) {
    if (value == textAlign) {
      return;
    }
    _textAlign = textAlign;
    markNeedsPaint();
  }

  TextOverflow? get overflow => _overflow;
  TextOverflow? _overflow;

  set overflow(TextOverflow? value) {
    if (value == overflow) {
      return;
    }
    _overflow = overflow;
    setLayout();
  }

  int? get maxLines => _maxLines;
  int? _maxLines;

  set maxLines(int? value) {
    if (value == maxLines) {
      return;
    }
    _maxLines = maxLines;
    setLayout();
  }

  void setLayout() {
    _paragraphData = null;
    markNeedsLayout();
    markNeedsPaint();
  }

  RositaCanvasParagraphData? _paragraphData;

  @override
  void performLayout() {
    final text = this.text;
    final style = this.style;

    if (text == null || text == '' || style == null) {
      size = Size.zero;
      return;
    }

    final data = _paragraphData ??= RositaParagraphUtils.buildParagraphData(
      text: text,
      style: style,
    );

    size = constraints.constrain(data.buildSize(constraints));
  }

  bool _isInitialSetText = true;

  @override
  void rositaPaint() {
    final text = this.text;

    if (text == null) {
      htmlElement.style.display = 'none';
      return;
    }

    htmlElement.style.display = '';

    if (_isInitialSetText) {
      htmlElement.innerText = text;
      _isInitialSetText = false;
    }

    RositaTextUtils.applyTextStyle(
      htmlElement,
      style: style,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}
