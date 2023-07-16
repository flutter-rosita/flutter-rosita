// ignore_for_file: always_specify_types

part of '../rosita_canvas.dart';

mixin _ParagraphMixin on _CanvasMixin {
  void drawRositaParagraph(TextPainter textPainter, Offset offset) {
    final text = textPainter.text;

    if (text is TextSpan) {
      _setDirty();
      _drawTextSpan(text, '', offset);
    } else {
      assert(() {
        // ignore: avoid_print
        print('RositaCanvas not handled text: ${text.runtimeType}, $text');
        return true;
      }());
    }
  }

  void _drawTextSpan(TextSpan text, String font, Offset offset) {
    final string = text.text;

    final style = text.style;

    if (style == null) {
      return;
    }

    final fontSize = style.fontSize;
    final height = style.height ?? 1;

    if (fontSize == null) {
      throw Exception('Invalid font size');
    }

    final lineHeight = fontSize * height;

    final newFont = [
      '${fontSize}px',
      if (style.fontFamily != null) "'${style.fontFamily}'"
    ].join(' ').trim();

    context.font = newFont;

    context.fillStyle = '${style.color?.toHexString()}';

    if (string != null) {
      context.fillText(string, offset.dx, offset.dy + lineHeight);
    }

    if (text.children != null) {
      for (final child in text.children!) {
        if (child is TextSpan) {
          _drawTextSpan(child, newFont, offset);
        }
      }
    }

    context.font = font;
  }
}
