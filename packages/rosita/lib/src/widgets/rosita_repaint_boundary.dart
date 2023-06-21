import 'package:flutter/widgets.dart';
import 'package:rosita/rosita.dart';

// ignore: non_constant_identifier_names
Widget RositaRepaintBoundary({
  Key? key,
  Widget? child,
}) {
  if (rositaEnableUpdateCompositingBits || key != null) {
    return RepaintBoundary(key: key, child: child);
  }

  return child ?? const SizedBox.shrink();
}