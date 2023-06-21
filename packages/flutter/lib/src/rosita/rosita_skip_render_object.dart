// ignore_for_file: public_member_api_docs

import 'package:rosita/rosita_web.dart';
import 'package:web/web.dart' as web;

mixin RositaSkipRenderObjectMixin on RositaRenderMixin {
  @override
  web.HTMLElement? createRositaElement() {
    // Skip create HTML element
    return null;
  }

  @override
  void rositaMarkNeedsLayout() {
    findFirstChildWithHtmlElement()?.rositaMarkNeedsLayout();
  }
}
