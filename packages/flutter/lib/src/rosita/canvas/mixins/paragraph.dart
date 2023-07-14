// ignore_for_file: always_specify_types

part of '../rosita_canvas.dart';

mixin _ParagraphMixin on _CanvasMixin {
  void drawRositaParagraph(TextPainter textPainter, Paragraph paragraph, Offset offset) {
    final text = textPainter.text;

    if (text is TextSpan) {
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

    final newFont = [
      if (style.fontSize != null) '${style.fontSize}px',
      if (style.fontFamily != null) "'${style.fontFamily}'"
    ].join(' ').trim();

    if (newFont.isNotEmpty) {
      context.font = newFont;
    }

    if (string == null) {
      context.fillText(string!, offset.dx, offset.dy);
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
