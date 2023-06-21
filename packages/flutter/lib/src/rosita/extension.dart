// ignore_for_file: public_member_api_docs

import 'dart:ui';

extension RositaColor on Color {
  String toHexString() => '#'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}'
      '${alpha.toRadixString(16).padLeft(2, '0')}';
}
