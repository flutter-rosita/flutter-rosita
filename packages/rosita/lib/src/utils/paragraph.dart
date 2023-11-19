import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:rosita/rosita.dart';
import 'package:universal_html/html.dart' as html;

class RositaParagraphUtils {
  static html.CanvasElement? _canvas;
  static html.DivElement? _paragraphsContainer;

  static html.CanvasRenderingContext2D? _canvasContext;

  static html.CanvasRenderingContext2D get canvasContext =>
      _canvasContext ??= (_canvas ??= html.CanvasElement()).context2D;

  static html.DivElement get paragraphsContainer {
    if (_paragraphsContainer != null) {
      return _paragraphsContainer!;
    }

    final paragraphsContainer = html.DivElement()..id = 'paragraphs-container';

    paragraphsContainer.style
      ..opacity = '0'
      ..userSelect = 'none'
      ..pointerEvents = 'none';

    html.document.body!.append(paragraphsContainer);

    return _paragraphsContainer ??= paragraphsContainer;
  }

  static final Map<String, html.DivElement> _paragraphsMeasureText = <String, html.DivElement>{};

  static String? _lastContextFont;

  static String? _defaultFontFamily;

  static String get defaultFontFamily {
    return _defaultFontFamily ??= switch (defaultTargetPlatform) {
      TargetPlatform.iOS => '.SF UI Display',
      TargetPlatform.android || TargetPlatform.fuchsia || TargetPlatform.linux => 'Roboto',
      TargetPlatform.windows => 'Segoe UI',
      TargetPlatform.macOS => '.AppleSystemUIFont',
    };
  }

  static RositaCanvasFontData buildFontData({required TextStyle style}) {
    final fontSize = style.fontSize ?? 10;
    final height = style.height ?? 1;
    final lineHeight = fontSize * height;
    final fontFamily = style.fontFamily ?? defaultFontFamily;
    final fontStyle = style.fontStyle;
    final fontWeight = style.fontWeight;
    final font = [
      if (fontStyle != null) RositaTextUtils.maFontStyle(fontStyle),
      if (fontWeight != null) RositaTextUtils.mapFontWeight(fontWeight),
      '${fontSize}px/$height',
      '"$fontFamily"',
    ].join(' ');

    return RositaCanvasFontData(
      font: font,
      lineHeight: lineHeight,
    );
  }

  static RositaCanvasParagraphData buildParagraphData({
    required String text,
    required TextStyle style,
  }) {
    final fontData = buildFontData(style: style);
    final font = fontData.font;

    if (_lastContextFont != font) {
      _lastContextFont = font;
      canvasContext.font = font;
    }

    final list = text.split(' ');
    final spacerMeasure = _measureText(' ');
    final spacerWidth = spacerMeasure.width?.toDouble() ?? 0;

    double fontLineHeight = 0.0;
    double fontBoundingBoxAscent = 0.0;

    final wordList = <double>[];

    for (int i = 0; i < list.length; i++) {
      if (i > 0) {
        wordList.add(spacerWidth);
      }

      final measure = _measureText(list[i]);
      final width = measure.width?.toDouble() ?? 0;

      wordList.add(width);

      if (i == 0) {
        _paragraphsMeasureText.putIfAbsent(font, () {
          final firstWord = list[i];
          final div = html.DivElement()..innerText = firstWord.isEmpty || firstWord == ' ' ? '&nbsp;' : firstWord;

          div.style
            ..font = font
            ..lineHeight = '';

          paragraphsContainer.append(div);

          return div;
        });

        final measureText = _paragraphsMeasureText[font]!;

        fontLineHeight = measureText.clientHeight.toDouble();
        fontBoundingBoxAscent = fontLineHeight;
      }
    }

    return RositaCanvasParagraphData(
      font: font,
      lineHeight: fontLineHeight,
      wordList: wordList,
      boundingBoxAscent: fontBoundingBoxAscent,
      minIntrinsicWidth: wordList.fold(0.0, (double max, double value) => value > max ? value : max),
      maxIntrinsicWidth: wordList.fold(0.0, (double sum, double value) => sum + value),
    );
  }

  static html.TextMetrics _measureText(String string) => canvasContext.measureText(string);
}

class RositaCanvasFontData {
  final String font;
  final double lineHeight;

  const RositaCanvasFontData({
    required this.font,
    required this.lineHeight,
  });
}

class RositaCanvasParagraphData extends RositaCanvasFontData {
  final List<double> wordList;
  final double boundingBoxAscent;
  final double minIntrinsicWidth;
  final double maxIntrinsicWidth;

  const RositaCanvasParagraphData({
    required super.font,
    required super.lineHeight,
    required this.wordList,
    required this.boundingBoxAscent,
    required this.minIntrinsicWidth,
    required this.maxIntrinsicWidth,
  });

  Size buildSize({double minWidth = 0.0, double maxWidth = double.infinity}) {
    int lines = 1;
    double maxLineWidth = 0;
    double lineWidth = 0;

    for (int i = 0; i < wordList.length; i++) {
      final width = wordList[i];

      if (lineWidth + width >= maxWidth) {
        lines++;
        lineWidth = 0;
      }

      lineWidth += width;

      if (lineWidth > maxLineWidth) {
        maxLineWidth = lineWidth;
      }
    }

    return Size(
      maxLineWidth,
      lines * lineHeight,
    );
  }
}
