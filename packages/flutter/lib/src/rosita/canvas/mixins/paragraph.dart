// ignore_for_file: always_specify_types

part of '../rosita_canvas.dart';

mixin _ParagraphMixin on _CanvasMixin {
  String? _lastContextFont;

  void drawRositaParagraph(TextPainter textPainter, Offset offset) {
    final text = textPainter.text;

    if (text is TextSpan) {
      _setDirty();
      _drawTextSpan(text, null, offset);
    } else {
      assert(() {
        // ignore: avoid_print
        print('RositaCanvas not handled text: ${text.runtimeType}, $text');
        return true;
      }());
    }
  }

  void _drawTextSpan(TextSpan text, RositaCanvasFontData? parentData, Offset offset) {
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

    context.fillStyle = style.color.toHexString();

    if (string != null) {
      context.fillText(string, offset.dx + this.offset, offset.dy + this.offset + data.lineHeight);
    }

    if (text.children != null) {
      for (final child in text.children!) {
        if (child is TextSpan) {
          _drawTextSpan(child, data, offset);
        }
      }
    }

    if (parentData != null && _lastContextFont != parentData.font) {
      _lastContextFont = parentData.font;
      context.font = parentData.font;
    }
  }
}
