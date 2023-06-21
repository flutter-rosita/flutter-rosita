// ignore_for_file: public_member_api_docs

import 'dart:ui';

extension RositaColorExtension on Color? {
  String toStyleString() {
    final color = this;

    if (color == null) {
      return '';
    }

    return 'rgba(${(color.r * 255).toInt()},${(color.g * 255).toInt()},${(color.b * 255).toInt()},${color.a})';
  }
}
