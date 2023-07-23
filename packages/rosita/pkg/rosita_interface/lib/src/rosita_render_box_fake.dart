import 'dart:html' as html;

import 'package:flutter/rendering.dart';

abstract class RositaRenderBox extends RenderBox {
  html.HtmlElement get htmlElement => throw UnimplementedError();

  void rositaPaint() => throw UnimplementedError();
}