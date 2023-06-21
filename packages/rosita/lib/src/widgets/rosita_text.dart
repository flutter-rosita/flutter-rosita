import 'package:flutter/widgets.dart';
import 'package:rosita/rosita.dart';

class RositaText extends StatelessWidget {
  const RositaText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
  });

  final String? text;

  final TextStyle? style;

  final TextAlign? textAlign;

  final TextOverflow? overflow;

  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);

    TextStyle? effectiveTextStyle = style;

    if (style == null || style!.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(style);
    }

    return RositaRichText(
      text,
      style: effectiveTextStyle,
      textAlign: textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start,
      overflow: overflow ?? effectiveTextStyle?.overflow ?? defaultTextStyle.overflow,
      maxLines: maxLines ?? defaultTextStyle.maxLines,
    );
  }
}
