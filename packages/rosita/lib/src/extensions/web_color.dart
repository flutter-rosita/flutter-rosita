// ignore_for_file: public_member_api_docs

import 'dart:js_interop';
import 'dart:ui';

extension RositaColorExtensionJSAny on Color? {
  JSAny toStyleJSAny() {
    final color = this;

    if (color == null) {
      return '' as JSAny;
    }

    return ('rgba(' as JSAny)
        .add(color.red as JSAny)
        .add(',' as JSAny)
        .add(color.green as JSAny)
        .add(',' as JSAny)
        .add(color.blue as JSAny)
        .add(',' as JSAny)
        .add(color.alpha / 255 as JSAny)
        .add(')' as JSAny);
  }
}
