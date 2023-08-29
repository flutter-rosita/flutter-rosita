// ignore_for_file: public_member_api_docs

import 'dart:ui';

import 'package:rosita/rosita.dart';
import 'package:universal_html/html.dart' as html;

mixin RositaSkipRenderObjectMixin on RositaRenderMixin {
  @override
  html.HtmlElement? createRositaElement() {
    // Skip create HTML element
    return null;
  }
}
