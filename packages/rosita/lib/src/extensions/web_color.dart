// ignore_for_file: public_member_api_docs

import 'dart:js_interop';
import 'dart:ui';

extension RositaColorExtensionJSAny on Color? {
  JSAny toStyleJSAny() {
    final color = this;

    if (color == null) {
      return ''.toJS;
    }

    return ('rgba('.toJS)
        .add((color.r * 255).toInt().toJS)
        .add(','.toJS)
        .add((color.g * 255).toJS)
        .add(','.toJS)
        .add((color.b * 255).toJS)
        .add(','.toJS)
        .add(color.a.toJS)
        .add(')'.toJS);
  }
}
