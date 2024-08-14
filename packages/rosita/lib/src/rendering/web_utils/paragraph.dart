part of '../web_rendering.dart';

class RositaParagraphUtils {
  static web.HTMLCanvasElement? _canvas;
  static web.HTMLDivElement? _paragraphsContainer;

  static web.CanvasRenderingContext2D? _canvasContext;

  static web.CanvasRenderingContext2D get canvasContext =>
      _canvasContext ??= (_canvas ??= web.HTMLCanvasElement()).context2D;

  static bool? _isChrome;

  static bool get isChrome => _isChrome ??= web.window.navigator.userAgent.contains('Chrome');

  static double get fixScaleFactor {
    if (isChrome) {
      return 1.0;
    }

    return RendererBinding.instance.renderViews.first.flutterView.devicePixelRatio;
  }

  static web.HTMLDivElement get paragraphsContainer {
    if (_paragraphsContainer != null) {
      return _paragraphsContainer!;
    }

    final paragraphsContainer = web.HTMLDivElement()..id = 'paragraphs-container';

    paragraphsContainer.style
      ..opacity = '0'
      ..userSelect = 'none'
      ..pointerEvents = 'none';

    web.document.body!.append(paragraphsContainer);

    return _paragraphsContainer ??= paragraphsContainer;
  }

  static final Map<String, web.HTMLDivElement> _paragraphsMeasureText = <String, web.HTMLDivElement>{};

  static String? _lastContextFont;

  static String? _defaultFontFamily;

  static String get defaultFontFamily {
    return _defaultFontFamily ??= switch (defaultTargetPlatform) {
      TargetPlatform.iOS => '.SF UI Display',
      TargetPlatform.windows => 'Segoe UI',
      TargetPlatform.macOS => '.AppleSystemUIFont',
      // Default to: android, fuchsia, linux and other forks platforms
      _ => 'Roboto',
    };
  }

  static RositaCanvasFontData buildFontData({required TextStyle style, double fixScaleFactor = 1}) {
    final fontSize = (style.fontSize ?? 10) * fixScaleFactor;
    final height = style.height ?? 1;
    final lineHeight = fontSize * height;
    final fontFamily = style.fontFamily ?? defaultFontFamily;
    final fontStyle = style.fontStyle;
    final fontWeight = style.fontWeight;
    final font = [
      if (fontStyle != null) RositaTextUtils.mapFontStyle(fontStyle),
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
    final fontData = buildFontData(style: style, fixScaleFactor: fixScaleFactor);
    final font = fontData.font;

    if (_lastContextFont != font) {
      _lastContextFont = font;
      canvasContext.font = font;
    }

    final textLength = text.length;

    _paragraphsMeasureText.putIfAbsent(font, () {
      final firstWord =
          text.substring(0, min(2, textLength)); // 2 symbols for layout line height - icons can be more than one symbol
      final div = web.HTMLDivElement()..innerText = firstWord.isEmpty || firstWord == ' ' ? '&nbsp;' : firstWord;

      div.style
        ..font = font
        ..lineHeight = '';

      paragraphsContainer.append(div);

      return div;
    });

    final measureText = _paragraphsMeasureText[font]!;
    final fontLineHeight = measureText.clientHeight.toDouble() / fixScaleFactor;
    final fontBoundingBoxAscent = fontLineHeight;

    double? cacheWidth;

    double totalWidth() => cacheWidth ??= _measureText(text).width.toDouble() / fixScaleFactor;

    final spacesIndex = <int>[];
    int spacesCount = 0;

    if (text.contains(' ')) {
      for (int i = 0; i < textLength; i++) {
        final symbol = text[i];

        if (symbol == ' ') {
          spacesIndex.add(i);
          spacesCount++;
        } else if (i + 1 == textLength) {
          spacesIndex.add(i + 1);
        }
      }
    }

    if (spacesCount == 0) {
      final width = totalWidth();

      return RositaCanvasParagraphData(
        font: font,
        lineHeight: fontLineHeight,
        wordList: [width],
        boundingBoxAscent: fontBoundingBoxAscent,
        minIntrinsicWidth: width,
        maxIntrinsicWidth: width,
      );
    }

    if (rositaTryMeasureTextInOnePass) {
      final width = totalWidth();
      final wordList = <double>[];
      final spacerMeasure = _measureText(' ');
      final spacerWidth = spacerMeasure.width.toDouble() / fixScaleFactor;
      final widthWithoutSpaces = width - spacesCount * spacerWidth;
      final symbolWidth = widthWithoutSpaces / (textLength - spacesCount);

      int previousSpaceIndex = -1;

      for (int i = 0; i < spacesIndex.length; i++) {
        if (i > 0) {
          wordList.add(spacerWidth);
        }

        final spaceIndex = spacesIndex[i];
        final wordLength = spaceIndex - previousSpaceIndex - 1;

        if (wordLength > 0) {
          wordList.add(wordLength * symbolWidth);
        }

        previousSpaceIndex = spaceIndex;
      }

      return RositaCanvasParagraphData(
        font: font,
        lineHeight: fontLineHeight,
        wordList: wordList,
        boundingBoxAscent: fontBoundingBoxAscent,
        minIntrinsicWidth: wordList.fold(0.0, (double max, double value) => value > max ? value : max),
        maxIntrinsicWidth: width,
      );
    }

    final list = text.split(' ');
    final spacerMeasure = _measureText(' ');
    final spacerWidth = spacerMeasure.width.toDouble() / fixScaleFactor;

    final wordList = <double>[];

    for (int i = 0; i < list.length; i++) {
      if (i > 0) {
        wordList.add(spacerWidth);
      }

      final measure = _measureText(list[i]);
      final width = measure.width.toDouble() / fixScaleFactor;

      wordList.add(width);
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

  static web.TextMetrics _measureText(String string) => canvasContext.measureText(string);
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

  RositaCanvasParagraphData({
    required super.font,
    required super.lineHeight,
    required this.wordList,
    required this.boundingBoxAscent,
    required this.minIntrinsicWidth,
    required this.maxIntrinsicWidth,
  });

  Size? _size;

  Size get size => _size!;

  int? _lines;

  int get lines => _lines!;

  bool _wordBreak = false;

  bool get wordBreak => _wordBreak;

  void layout({double minWidth = 0.0, double maxWidth = double.infinity, required TextScaler textScaler}) {
    _wordBreak = false;

    int lines = 1;
    double maxLineWidth = 0;
    double lineWidth = 0;

    if (maxWidth == 0) {
      _size = Size(0, textScaler.scale(lineHeight));
      _lines = 1;
      _wordBreak = false;
      return;
    }

    for (int i = 0; i < wordList.length; i++) {
      double width = textScaler.scale(wordList[i]);

      if (width > maxWidth) {
        _wordBreak = true;
        lines += width ~/ maxWidth;
        width = width % maxWidth;
      }

      if (lineWidth + width > maxWidth) {
        lines++;
        lineWidth = 0;
      }

      lineWidth += width;

      if (lineWidth > maxLineWidth) {
        maxLineWidth = lineWidth;
      }
    }

    _size = Size(
      lines > 1 && maxWidth.isFinite ? maxWidth : maxLineWidth,
      lines * textScaler.scale(lineHeight),
    );

    _lines = lines;
  }

  ({double words, int lines}) takeWordsCount(Size size, int? maxLines, TextScaler textScaler) {
    final maxWidth = size.width;
    final maxHeight = size.height;

    double worldCount = 0;

    int lines = 1;
    double maxLineWidth = 0;
    double lineWidth = 0;

    for (int i = 0; i < wordList.length; i++) {
      final width = textScaler.scale(wordList[i]);

      if (lineWidth + width > maxWidth) {
        lines++;

        if (maxLines != null && lines > maxLines || lines * textScaler.scale(lineHeight) > maxHeight) {
          worldCount = worldCount + (maxWidth - lineWidth - width) / width;

          if (worldCount < .0) {
            return (words: worldCount + 1, lines: maxLines ?? lines - 1);
          }

          return (words: worldCount, lines: lines - 1);
        }

        lineWidth = 0;
      }

      lineWidth += width;

      if (lineWidth > maxLineWidth) {
        maxLineWidth = lineWidth;
      }
      worldCount += 1.0;
    }

    return (words: worldCount, lines: lines);
  }
}
