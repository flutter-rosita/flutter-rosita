// ignore_for_file: public_member_api_docs

import 'dart:ui';

import 'package:flutter/rosita.dart';

void rositaSkipCallback(VoidCallback skipCallback, [VoidCallback? callback]) {
  if (kIsRosita) {
    // Skip call function
    callback?.call();
  } else {
    skipCallback.call();
  }
}
