// ignore_for_file: always_specify_types

part of '../rosita_canvas.dart';

mixin _ParagraphMixin on _CanvasMixin {
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

    context.font = data.font;

    context.fillStyle = '${style.color?.toHexString()}';

    if (string != null) {
      context.fillText(string, offset.dx, offset.dy + data.lineHeight);
    }

    if (text.children != null) {
      for (final child in text.children!) {
        if (child is TextSpan) {
          _drawTextSpan(child, data, offset);
        }
      }
    }

    if (parentData != null) {
      context.font = parentData.font;
    }
  }
}
