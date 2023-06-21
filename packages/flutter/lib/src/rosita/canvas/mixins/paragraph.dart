// ignore_for_file: always_specify_types

part of '../rosita_canvas.dart';

mixin _ParagraphMixin on _CanvasMixin {
  String? _lastContextFont;

  void drawRositaParagraph(TextPainter textPainter, Offset offset) {
    final text = textPainter.text;

    if (text is TextSpan) {
      final rect = offset & textPainter.size;

      _setDirty(rect, 1);
      _drawTextSpan(text, null, offset, textPainter.textAlign);
    } else {
      assert(() {
        // ignore: avoid_print
        print('RositaCanvas not handled text: ${text.runtimeType}, $text');
        return true;
      }());
    }
  }

  void _drawTextSpan(TextSpan text, RositaCanvasFontData? parentData, Offset offset, TextAlign textAlign) {
    final string = text.text;

    final style = text.style;

    if (style == null) {
      return;
    }

    final data = RositaParagraphUtils.buildFontData(style: style);
    final font = data.font;

    if (string != null) {
      if (parentData == null || _lastContextFont != font) {
        _lastContextFont = font;
        context.font = font;
      }

      context.fillStyle = style.color.toStyleString();

      final measure = context.measureText(string);

      double alignX = 0;
      final double alignY = measure.fontBoundingBoxAscent?.toDouble() ?? data.lineHeight;

      if (offset == Offset.zero && textAlign == TextAlign.center) {
        alignX = (_size?.width ?? 0) / 2 - (measure.width ?? 0) / 2;
      }

      context.fillText(string, offset.dx + this.offset.dx + alignX, offset.dy + this.offset.dy + alignY);
    }

    if (text.children != null) {
      for (final child in text.children!) {
        if (child is TextSpan) {
          _drawTextSpan(child, data, offset, textAlign);
        }
      }
    }
  }
}
