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
    required BoxConstraints constraints,
  }) {
    final fontData = buildFontData(style: style);
    final font = fontData.font;
    final lineHeight = fontData.lineHeight;

    if (_lastContextFont != font) {
      _lastContextFont = font;
      canvasContext.font = font;
    }

    final lineWidth = _measureText(text);
    final biggestSize = constraints.biggest;
    final Size lineSize;

    if (lineWidth <= biggestSize.width) {
      lineSize = Size(lineWidth, lineHeight);
    } else {
      final list = text.split(' ');
      final spacerWidth = _measureText(' ');

      int lines = 1;
      double maxLineWidth = 0;
      double lineWidth = 0;

      for (int i = 0; i < list.length; i++) {
        if (i > 0) {
          lineWidth += spacerWidth;
        }

        final width = _measureText(list[i]);

        if (lineWidth + width >= biggestSize.width) {
          lines++;
          lineWidth = 0;
        }

        lineWidth += width;

        if (lineWidth > maxLineWidth) {
          maxLineWidth = lineWidth;
        }
      }

      lineSize = Size(
        maxLineWidth,
        lines * lineHeight,
      );
    }

    return RositaCanvasParagraphData(
      font: font,
      lineHeight: lineHeight,
      size: lineSize,
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
  final Size size;

  const RositaCanvasParagraphData({
    required super.font,
    required super.lineHeight,
    required this.size,
  });
}
