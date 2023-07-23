// ignore_for_file: public_member_api_docs

import 'dart:html' as html;

import 'package:rosita/rosita.dart';

mixin RositaSkipRenderObjectMixin on RositaRenderMixin {
  @override
  html.HtmlElement? createRositaElement() {
    // Skip create HTML element
    return null;
  }
}
