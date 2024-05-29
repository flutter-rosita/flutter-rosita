import 'package:flutter/rendering.dart';
import 'package:rosita/rosita.dart';

const String _kEllipsis = '\u2026';

class RositaRenderParagraph extends RositaRenderBox with RelayoutWhenSystemFontsChangeMixin {
  RositaRenderParagraph({
    String? text,
    TextStyle? style,
    TextScaler? textScaler,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    bool softWrap = true,
  })  : _text = text,
        _style = style,
        _textScaler = textScaler,
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

  TextScaler get textScaler => _textScaler ?? TextScaler.noScaling;
  TextScaler? _textScaler;

  set textScaler(TextScaler? value) {
    if (value == textScaler) {
      return;
    }
    _textScaler = textScaler;

    setLayout();
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
    _textSize = null;
    _isInitialSetText = true;
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

  bool _textDidExceedMaxLines = false;
  bool _didOverflowHeight = false;
  bool _didOverflowWidth = false;

  Size? _textSize;

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    final int? maxLines = this.maxLines;
    Size textSize = _layoutText(minWidth: constraints.minWidth, maxWidth: constraints.maxWidth);

    final constrainSize = constraints.constrain(textSize);

    switch (overflow) {
      case TextOverflow.visible:
        _textDidExceedMaxLines = false;
        _didOverflowHeight = false;
        _didOverflowWidth = false;
      default:
        _textDidExceedMaxLines = maxLines != null && _paragraphData!.lines > maxLines;
        _didOverflowHeight = constrainSize.height < textSize.height;
        _didOverflowWidth = constrainSize.width < textSize.width;
    }

    final bool hasVisualOverflow = _textDidExceedMaxLines || _didOverflowHeight || _didOverflowWidth;

    if (hasVisualOverflow) {
      final wordsCount = _paragraphData!.takeWordsCount(constrainSize, maxLines, textScaler);
      final linesCount = wordsCount.lines;
      textSize = Size(constrainSize.width, linesCount * _paragraphData!.lineHeight);
    }

    size = constraints.constrain(textSize);

    if (_textSize == null) {
      _textSize = textSize;
    } else if (_textSize != textSize) {
      _textSize = textSize;
      _isInitialSetText = true;
      markNeedsPaint();
    }
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

    _paragraphData!.layout(
      minWidth: minWidth,
      maxWidth: widthMatters ? maxWidth : double.infinity,
      textScaler: textScaler,
    );

    return _paragraphData!.size;
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
    setLayout();
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

    final paragraphData = _paragraphData!;

    style.display = '';

    RositaTextUtils.applyTextStyle(
      style,
      textStyle: textStyle,
      textAlign: textAlign,
    );

    if (!_isInitialSetText) return;

    _isInitialSetText = false;

    final bool hasVisualOverflow = _textDidExceedMaxLines || _didOverflowHeight || _didOverflowWidth;

    assert(() {
      if (hasVisualOverflow) {
        htmlElement.setAttribute('rosita-debug-overflow', 'true');
      } else {
        htmlElement.removeAttribute('rosita-debug-overflow');
      }
      return true;
    }());

    if (hasVisualOverflow == false) {
      htmlElement.innerText = text;

      style.wordBreak = paragraphData.wordBreak ? 'break-word' : '';
      return;
    }

    final List<String> wordList = text.split(' ');
    final buffer = StringBuffer();
    final wordsCount = paragraphData.takeWordsCount(size, maxLines, textScaler).words;

    for (int i = 0; i < wordsCount; i++) {
      if (i == 0 && wordsCount < 1) {
        final word = wordList[0];

        buffer.write(word.substring(0, (wordsCount * word.length).floor()));
        break;
      }

      if (i % 2 == 0) {
        final word = wordList[i ~/ 2];

        buffer.write(word);
      } else {
        buffer.write(' ');
      }

      final delta = wordsCount - i;

      if (delta < 1 && delta > 0 && (i + 1) % 2 == 0) {
        final word = wordList[(i + 1) ~/ 2];

        buffer.write(word.substring(0, ((wordsCount - i) * word.length).floor()));
      }
    }

    final string = buffer.toString();

    switch (overflow) {
      case TextOverflow.ellipsis:
        if (string.length > 3) {
          htmlElement.innerText = '${string.substring(0, string.length - 3)}$_kEllipsis';

          return;
        }
      default:
    }

    htmlElement.innerText = string;
  }
}
