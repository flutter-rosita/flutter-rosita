// ignore_for_file: public_member_api_docs

import 'dart:ui';

extension RositaColorExtension on Color? {
  String toStyleString() {
    final color = this;

    if (color == null) {
      return '';
    }

    return 'rgba(${color.red},${color.green},${color.blue},${color.alpha / 255})';
  }
}
