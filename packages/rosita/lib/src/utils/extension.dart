// ignore_for_file: public_member_api_docs

import 'dart:ui';

extension RositaColor on Color? {
  String toHexString() => this == null
      ? ''
      : '#'
          '${this!.red.toRadixString(16).padLeft(2, '0')}'
          '${this!.green.toRadixString(16).padLeft(2, '0')}'
          '${this!.blue.toRadixString(16).padLeft(2, '0')}'
          '${this!.alpha.toRadixString(16).padLeft(2, '0')}';
}
