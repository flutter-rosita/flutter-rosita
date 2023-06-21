// ignore_for_file: public_member_api_docs, always_specify_types
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderColoredBoxMixin on RositaRenderMixin {
  Color get color;

  @override
  void rositaPaint() {
    (htmlElement.style as JSObject).setProperty('backgroundColor' as JSAny, color.toStyleJSAny());
  }
}
