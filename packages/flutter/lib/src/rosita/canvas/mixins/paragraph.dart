// ignore_for_file: always_specify_types

part of '../rosita_canvas.dart';

mixin _ParagraphMixin on _CanvasMixin {
  String? _lastContextFont;

  void drawRositaParagraph(TextPainter textPainter, Offset offset) {
    final text = textPainter.text;

    if (text is TextSpan) {
      _setDirty();
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

    if (_lastContextFont != data.font) {
      _lastContextFont = data.font;
      context.font = data.font;
    }

    context.fillStyle = style.color.toStyleString();

    if (string != null) {
      final measure = context.measureText(string);

      double alignX = 0;
      final double alignY = measure.fontBoundingBoxAscent?.toDouble() ?? data.lineHeight;

      if (offset == Offset.zero && textAlign == TextAlign.center) {
        alignX = (_size?.width ?? 0) / 2 - (measure.width ?? 0) / 2;
      }

      context.fillText(string, offset.dx + this.offset + alignX, offset.dy + this.offset + alignY);
    }

    if (text.children != null) {
      for (final child in text.children!) {
        if (child is TextSpan) {
          _drawTextSpan(child, data, offset, textAlign);
        }
      }
    }

    if (parentData != null && _lastContextFont != parentData.font) {
      _lastContextFont = parentData.font;
      context.font = parentData.font;
    }
  }
}
