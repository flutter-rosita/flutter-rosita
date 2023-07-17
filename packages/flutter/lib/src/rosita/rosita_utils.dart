// ignore_for_file: public_member_api_docs

import 'dart:ui';

void rositaSkipCallback(VoidCallback skipCallback, [VoidCallback? callback]) {
  // Skip call function
  callback?.call();
}
