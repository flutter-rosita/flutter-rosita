// ignore_for_file: public_member_api_docs

import 'dart:html' as html;

import 'package:flutter/rendering.dart';

abstract class RositaRenderBox extends RenderBox {
  html.HtmlElement get htmlElement;

  void rositaPaint();
}