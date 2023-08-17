import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:rosita/rosita.dart';
import 'package:universal_html/html.dart' as html;

class RositaParagraphUtils {
  static html.CanvasElement? _canvas;

  static html.CanvasRenderingContext2D? _canvasContext;

  static html.CanvasRenderingContext2D get canvasContext =>
      _canvasContext ??= (_canvas ??= html.CanvasElement()).context2D;

  static String? _lastContextFont;

  static RositaCanvasFontData buildFontData({required TextStyle style}) {
    final fontSize = style.fontSize ?? 10;
    final height = style.height ?? 1;
    final lineHeight = fontSize * height;
    final fontFamily = style.fontFamily;
    final fontStyle = style.fontStyle;
    final fontWeight = style.fontWeight;

    final font = [
      if (fontStyle != null) RositaTextUtils.maFontStyle(fontStyle),
      if (fontWeight != null) RositaTextUtils.mapFontWeight(fontWeight),
      '${fontSize}px',
      if (fontFamily != null) "'$fontFamily'",
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
    final lineHeight = fontData.lineHeight;

    if (_lastContextFont != font) {
      _lastContextFont = font;
      canvasContext.font = font;
    }

    final list = text.split(' ');
    final spacerWidth = _measureText(' ');
    final wordList = <double>[];

    for (int i = 0; i < list.length; i++) {
      if (i > 0) {
        wordList.add(spacerWidth);
      }

      final width = _measureText(list[i]);

      wordList.add(width);
    }

    return RositaCanvasParagraphData(
      font: font,
      lineHeight: lineHeight,
      wordList: wordList,
    );
  }

  static double _measureText(String string) => canvasContext.measureText(string).width?.toDouble() ?? 0;
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

  const RositaCanvasParagraphData({
    required super.font,
    required super.lineHeight,
    required this.wordList,
  });

  Size buildSize(BoxConstraints constraints) {
    final biggestSize = constraints.biggest;

    int lines = 1;
    double maxLineWidth = 0;
    double lineWidth = 0;

    for (int i = 0; i < wordList.length; i++) {
      final width = wordList[i];

      if (lineWidth + width >= biggestSize.width) {
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
