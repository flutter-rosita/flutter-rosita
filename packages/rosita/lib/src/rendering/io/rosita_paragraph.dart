part of '../io_rendering.dart';

class RositaRenderParagraph extends RositaRenderBox with RelayoutWhenSystemFontsChangeMixin {
  RositaRenderParagraph({
    this.text,
    this.style,
    this.textScaler,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.softWrap = true,
  });

  String? text;

  TextStyle? style;

  TextScaler? textScaler;

  TextAlign? textAlign;

  bool softWrap;

  TextOverflow? overflow;

  int? maxLines;
}
