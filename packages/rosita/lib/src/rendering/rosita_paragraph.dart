import 'package:flutter/rendering.dart';
import 'package:rosita/rosita.dart';

class RositaRenderParagraph extends RositaRenderBox with RelayoutWhenSystemFontsChangeMixin {
  RositaRenderParagraph({
    String? text,
    TextStyle? style,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    bool softWrap = true,
  })  : _text = text,
        _style = style,
        _textAlign = textAlign,
        _overflow = overflow,
        _maxLines = maxLines,
        _softWrap = softWrap;

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

  bool get softWrap => _softWrap;
  bool _softWrap;

  set softWrap(bool value) {
    if (_softWrap == value) {
      return;
    }
    _softWrap = value;
    setLayout();
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
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.constrain(
      _layoutText(
        minWidth: constraints.minWidth,
        maxWidth: constraints.maxWidth,
      ),
    );
  }

  @override
  void performLayout() {
    size = constraints.constrain(_layoutText(minWidth: 0, maxWidth: constraints.maxWidth));
  }

  Size _layoutText({double minWidth = 0.0, double maxWidth = double.infinity}) {
    final text = this.text;
    final style = this.style;

    if (text == null || style == null) {
      return Size.zero;
    }

    _paragraphData ??= RositaParagraphUtils.buildParagraphData(
      text: text,
      style: style,
    );

    final bool widthMatters = softWrap || overflow == TextOverflow.ellipsis;

    return _paragraphData!.buildSize(
      minWidth: minWidth,
      maxWidth: widthMatters ? maxWidth : double.infinity,
    );
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    _layoutText();
    return _paragraphData!.minIntrinsicWidth;
  }


  @override
  double computeMaxIntrinsicWidth(double height) {
    _layoutText();
    return _paragraphData!.maxIntrinsicWidth;
  }

  double _computeIntrinsicHeight(double width) {
    return _layoutText(minWidth: width, maxWidth: width).height;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return _computeIntrinsicHeight(width);
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return _computeIntrinsicHeight(width);
  }

  @override
  void systemFontsDidChange() {
    super.systemFontsDidChange();
    _paragraphData = null;
  }

  bool _isInitialSetText = true;

  @override
  void rositaPaint() {
    final style = htmlElement.style;
    final textStyle = this.style;
    final text = this.text;

    if (text == null) {
      style.display = 'none';
      return;
    }

    style.display = '';

    if (_isInitialSetText) {
      htmlElement.innerText = text;
      _isInitialSetText = false;
    }

    RositaTextUtils.applyTextStyle(
      style,
      textStyle: textStyle,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}
